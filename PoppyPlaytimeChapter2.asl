// Poppy Playtime Ch3 Autosplitter and Load Remover
// Supports Load Remover IGT
// Original script by: Kuno Demetries
// Discord: Kuno Demetries#6969
// Linktree: https://linktr.ee/KunoDemetries
// Updated script by TheDementedSalad


state("Playtime_Prototype4-Win64-Shipping"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Helper.Settings.CreateFromXml("Components/PPCH2.Settings.xml");
	
	vars.splitstoComplete = new HashSet<string>();
}

init
{
	switch (modules.First().ModuleMemorySize)
	{
		case (85676032):
			version = "Steam 7/5/22";
			break;
		case (85671936):
			version = "Steam 25/5/22";
			break;
		case (86134784):
			version = "Steam 31/10/24";
			break;
	}
	
	vars.completedSplits = new List<byte>();

	IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 05 ???????? 48 3B C? 48 0F 44 C? 48 89 05 ???????? E8");
	IntPtr gEngine = vars.Helper.ScanRel(3, "48 89 05 ???????? 48 85 c9 74 ?? e8 ???????? 48 8d 4d");
	IntPtr fNames = vars.Helper.ScanRel(3, "48 8d 05 ???????? eb ?? 48 8d 0d ???????? e8 ???????? c6 05");
	IntPtr Train = vars.Helper.ScanRel(3, "48 8d 0d ???????? e8 ???????? e8 ???????? 84 c0 75");
	IntPtr gSyncLoad = vars.Helper.ScanRel(21, "33 C0 0F 57 C0 F2 0F 11 05");
	
	if (gWorld == IntPtr.Zero || gEngine == IntPtr.Zero)
	{
		const string Msg = "Not all required addresses could be found by scanning.";
		throw new Exception(Msg);
	}
	
	vars.Helper["isLoading"] = vars.Helper.Make<bool>(gSyncLoad);
	
	vars.Helper["TransitionType"] = vars.Helper.Make<bool>(gEngine, 0x8A8);
	
	vars.Helper["AuthorityGameMode"] = vars.Helper.Make<ulong>(gEngine, 0x780, 0x78, 0x118, 0x18);
	
	vars.Helper["CheckpointID"] = vars.Helper.Make<byte>(gEngine, 0x780, 0x78, 0x118, 0x2E4);
	
	vars.Helper["isGameLoaded"] = vars.Helper.Make<byte>(gEngine, 0x780, 0x78, 0x118, 0x2F8);
	
	vars.Helper["localPlayer"] = vars.Helper.Make<ulong>(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x18);
	vars.Helper["localPlayer"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
	
	vars.Helper["AcknowledgedPawn"] = vars.Helper.Make<ulong>(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x2A0, 0x18);
	
	vars.Helper["CantMove"] = vars.Helper.Make<byte>(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x2A0, 0x76C);
	
	vars.Helper["X"] = vars.Helper.Make<double>(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x290, 0x11C);
	
	if(version == "Steam 31/10/24"){
		vars.Helper["TrainStopped"] = vars.Helper.Make<float>(Train, 0x270, 0x5F0, 0x5D8, 0x2A0);
	}
	
	else{
		vars.Helper["TrainStopped"] = vars.Helper.Make<float>(Train, 0x170, 0x5F0, 0x600, 0x2A0);
	}
		
		
	
	vars.FNameToString = (Func<ulong, string>)(fName =>
	{
		var nameIdx  = (fName & 0x000000000000FFFF) >> 0x00;
		var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
		var number   = (fName & 0xFFFFFFFF00000000) >> 0x20;

		IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
		IntPtr entry = chunk + (int)nameIdx * sizeof(short);

		int length = vars.Helper.Read<short>(entry) >> 6;
		string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

		return number == 0 ? name : name + "_" + number;
	});
	
	vars.FNameToShortString = (Func<ulong, string>)(fName =>
	{
		string name = vars.FNameToString(fName);

		int dot = name.LastIndexOf('.');
		int slash = name.LastIndexOf('/');

		return name.Substring(Math.Max(dot, slash) + 1);
	});
	
	vars.FNameToShortString2 = (Func<ulong, string>)(fName =>
	{
		string name = vars.FNameToString(fName);

		int under = name.LastIndexOf('_');

		return name.Substring(0, under + 1);
	});	
}

update
{
	//Uncomment debug information in the event of an update.
	//print(modules.First().ModuleMemorySize.ToString());
	
	vars.Helper.Update();
	vars.Helper.MapPointers();
	
	if(timer.CurrentPhase == TimerPhase.NotRunning)
	{
		vars.completedSplits.Clear();
	}

	//print(current.Items2.ToString());
	
	//print(vars.FNameToShortString2(current.AuthorityGameMode));
}

start
{
	return current.CheckpointID == 0 && current.isGameLoaded == 1 && current.X != old.X;
}

split
{
	string setting = "";
	
	if(vars.FNameToShortString2(current.AuthorityGameMode) == "MainMenu_Gamemode_C_"){
		if(current.CheckpointID != old.CheckpointID){
			setting = current.CheckpointID;
		}
	}
	
	// Debug. Comment out before release.
	if (!string.IsNullOrEmpty(setting))
	vars.Log(setting);
	
	if (settings.ContainsKey(setting) && settings[setting] && vars.completedSplits.Add(setting)){
		return true;
	}
	
}

isLoading
{
	return current.TransitionType || current.isLoading || current.isGameLoaded == 0 || 
			vars.FNameToShortString2(current.AuthorityGameMode) == "MainMenu_Gamemode_C_" || vars.FNameToShortString2(current.localPlayer) != "PlayerController_";
}

reset
{
}

