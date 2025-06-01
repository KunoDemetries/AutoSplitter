state("CoDWaW", "steam")
{
    string50 CurrentLevelName : 0x5592B8; 
    bool Loader : 0x3172284; // Originally an int
    int HasControlLevelMak : 0x14ED874; //Used to start the timer at the beginning of Mak once you gain control
	//float fov : 0x1DC4F98; Current fov value, declared @ Ln 118, Col 57
}

state("CoDWaW", "V1.1")
{
	string50 CurrentLevelName : 0x955598;
	bool Loader : 0x130CFC8;
	int HasControlLevelMak : 0x14BE05C;
}

startup 
{
    settings.Add("Cutscene Time Fix", true, "Substract 62.55s from the timer after finishing TLTB");
	settings.Add("WAW", true, "All Missions");
	settings.Add("fov", false, "Set fov to value specified in asl (default is 90)");
		
	vars.missions = new Dictionary<string,string> 
		{ 
        	{"pel1", "Little Resistance"}, 
       		{"pel2", "Hard Landing"},
       		{"sniper", "Vendetta"},
       		{"see1", "Their Land, Their Blood"},
		{"pel1a", "Burn 'em Out"},
       		{"pel1b", "Relentless"},
       		{"see2", "Blood and Iron"},
       		{"ber1", "Ring of Steel"},
        	{"ber2", "Eviction"},
       		{"pby_fly", "Black Cats"},
       		{"oki2", "Blowtorch & Corkscrew"},
       		{"oki3","Breaking Point"},
       		{"ber3","Heart of the Reich"},
       		{"ber3b","Downfall"},
		};
    	foreach (var Tag in vars.missions) 
		{
   			settings.Add(Tag.Key, true, Tag.Value, "WAW");
  		}

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
    {        
    	var timingMessage = MessageBox.Show 
		(
    	    "This game uses Time without Loads (Game Time) as the main timing method.\n"+
    	    "LiveSplit is currently set to show Real Time (RTA).\n"+
    	    "Would you like to set the timing method to Game Time? This will make verification easier",
    	    "LiveSplit | Call of Duty: World at War",
    	   MessageBoxButtons.YesNo,MessageBoxIcon.Question
    	);
        
    	if (timingMessage == DialogResult.Yes)
    	{
    	    timer.CurrentTimingMethod = TimingMethod.GameTime;
    	}
    }	
}

init
{
	switch (modules.First().ModuleMemorySize) 
    {
        case 78712832: 
            version = "steam";
            break;
        case 77728728 : 
            version = "V1.1";
            break;
    default:
        print("Unknown version detected");
        return false;
    }
	vars.doneMaps = new List<string>(); // Coop runners can enter the wrong level by accident, so doneMaps needed
}

start
{
    if ((current.CurrentLevelName == "mak") && (current.HasControlLevelMak == 16384)) 
	{
        vars.doneMaps.Clear(); 
        return true;
    }
}

onStart
{
	vars.doneMaps.Clear();
}

isLoading
{
    return (!current.Loader);
}

update
{
	//massive shoutout to Ero for the help here. This is basically *adding* time to LiveSplits "loading times" which is then subtracting from RTA to display the time as LRT
	//the string used originally does not exist in v1.1 - hek
	if (settings["Cutscene Time Fix"] && 
    	((version == "steam" && current.CurrentLevelName == "pel1a_load") || 
     	(version == "V1.1" && current.CurrentLevelName == "pel1a")) && 
    	old.CurrentLevelName == "see1")
	{
		print("CTF Executed Successfully");
		const double Offset = 62.55;
		timer.LoadingTimes += TimeSpan.FromSeconds(Offset);
	}


	//Write float value of FOV into game memory
	if (settings["fov"])
	{
		bool bSuccess;
		IntPtr hProcess = game.Handle;
		IntPtr lpPtrPath = IntPtr.Add(modules.First().BaseAddress, 0x1DC4F98);
		byte[] lpBuffer = BitConverter.GetBytes((float)90);// < FOV value goes here
		UIntPtr nSize = (UIntPtr)lpBuffer.Length;
		UIntPtr lpNumberOfBytesWritten = UIntPtr.Zero;
		
		UIntPtr nReadSize = (UIntPtr)4;
		byte[] lpReadBuf = new byte[4];
		UIntPtr lpNumberOfBytesRead = UIntPtr.Zero;
		
		bSuccess = WinAPI.WriteProcessMemory(hProcess, lpPtrPath, lpBuffer, nSize, out lpNumberOfBytesWritten);
		bSuccess = WinAPI.ReadProcessMemory(hProcess, lpPtrPath, lpReadBuf, nReadSize, out lpNumberOfBytesRead);
		float fov = BitConverter.ToSingle(lpReadBuf, 0);
	}
}

split
{
    if ((current.CurrentLevelName != old.CurrentLevelName) && (settings[current.CurrentLevelName]) && (!vars.doneMaps.Contains(current.CurrentLevelName)))
	{
        vars.doneMaps.Add(current.CurrentLevelName);
		return true;
	}			
}

reset 
{
	return (current.CurrentLevelName == "ui");
}

onReset
{
	vars.doneMaps.Clear();
}
