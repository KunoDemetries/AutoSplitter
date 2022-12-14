state("Obscure-Win64-Shipping")
{

}

init
{
    vars.CurEggCount = 0;
    vars.CurColorCount = 10;
    vars.CurWeaponCount = 30;
    vars.doneMaps = new List<string>(); 
    vars.SaveFiles = new String[188]; 
    vars.logPath = Environment.GetEnvironmentVariable("LocalAppData")+"\\Obscure\\Saved\\SaveGames\\";

    // Entire section down (of just init) credits to go Micrologist

    if(!vars.scanCooldown.IsRunning)
    {
        vars.scanCooldown.Start(); 
    }

    vars.GetStaticPointerFromSig = (Func<string, int, IntPtr>) ( (signature, instructionOffset) => {
        var scanner = new SignatureScanner(game, modules.First().BaseAddress, (int)modules.First().ModuleMemorySize);
        var pattern = new SigScanTarget(signature);
        var location = scanner.Scan(pattern);
        if (location == IntPtr.Zero) return IntPtr.Zero;
        int offset = game.ReadValue<int>((IntPtr)location + instructionOffset);
        return (IntPtr)location + offset + instructionOffset + 0x4;
    });

    vars.Loading = vars.GetStaticPointerFromSig("48 8d 0d ?? ?? ?? ?? e8 ?? ?? ?? ?? 48 8b 05 ?? ?? ?? ?? ff 05", 0x3);
    vars.GameEngine = vars.GetStaticPointerFromSig("48 89 05 ?? ?? ?? ?? 48 85 c9 74 ?? e8 ?? ?? ?? ?? 48 8d 4d", 0x3);
    vars.pBase = vars.GetStaticPointerFromSig("48 8b 1d ?? ?? ?? ?? 48 85 db 74 ?? 41 b0", 0x3);

    print(vars.Loading.ToString("X"));
    print(vars.GameEngine.ToString("X"));
    print(vars.pBase.ToString("X"));
    if (vars.Loading == IntPtr.Zero || vars.GameEngine == IntPtr.Zero || vars.pBase == IntPtr.Zero)
    {
        throw new Exception("Loading/GameEngine/pBase/ not initialized - trying again");
    }

    vars.watchers = new MemoryWatcherList
    {
        new StringWatcher(new DeepPointer(vars.GameEngine, 0x8B0, 0x0), 100) { Name = "CurMap"},
        new MemoryWatcher<byte>(new DeepPointer(vars.Loading - 0x2)) { Name = "Loader"},
        new MemoryWatcher<byte>(new DeepPointer(vars.pBase, 0x30, 0xE8, 0x3A0, 0x200, 0x30, 0x20, 0x798)) {Name = "BossMode"}, // based on pos2
        new MemoryWatcher<byte>(new DeepPointer(vars.pBase, 0x30, 0xE8, 0x2B8, 0x200, 0x30, 0x20, 0x758)) {Name = "PlayerMovement"}, // based on pos2
        new MemoryWatcher<byte>(new DeepPointer(vars.pBase, 0x30, 0xE8, 0x3A0, 0x200, 0x30, 0x20, 0x870)) {Name = "CharlieDead"}, // baed on something2
    };
}

startup
{
    settings.Add("SOD", true, "Split On Charlie Death?"); 
    settings.Add("egg", true, "Split On Picking Up Eggs?");
    settings.Add("TC", true, "Split on Every Train Color Pickup? (No Specific Order!)");
    settings.Add("WO", true, "Split on Every Weapon Obtained? (No Specific Order!)");

    vars.missions2 = new Dictionary<string,string> 
	{ 	
        {"2","Red Egg"},
        {"4","Green Egg"},
        {"6","Blue Egg"},
    };
 	foreach (var Tag in vars.missions2)
	{
		settings.Add(Tag.Key, true, Tag.Value, "egg");
    };

    vars.scanCooldown = new Stopwatch();

		if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        	var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Choo-Choo Charlie",
               MessageBoxButtons.YesNo,MessageBoxIcon.Question
            );
        
            if (timingMessage == DialogResult.Yes)
            {
                timer.CurrentTimingMethod = TimingMethod.GameTime;
            }
        }	
}

update
{
    vars.watchers.UpdateAll(game);
    current.CurMap = vars.watchers["CurMap"].Current;
    current.loading = vars.watchers["Loader"].Current;
    current.BossMode = vars.watchers["BossMode"].Current;
    current.CharlieDead = vars.watchers["CharlieDead"].Current;
    current.PlayerMovement = vars.watchers["PlayerMovement"].Current;
   // print(current.PlayerMovement.ToString());

    if  (vars.scanCooldown.Elapsed.TotalMilliseconds >= 500 && (current.PlayerMovement == 1) && (current.CurMap.Contains("Maps"))) 
    {
        vars.SaveFiles = Directory.GetFiles(vars.logPath);

        foreach (string FileName in vars.SaveFiles)
        {
            if (FileName.Contains("Egg") && !vars.doneMaps.Contains(FileName))
            {
                vars.doneMaps.Add(FileName);
                vars.CurEggCount++;
                print(FileName);
            }

            if (FileName.Contains("TrainColor") && (!vars.doneMaps.Contains(FileName)))
            {
                vars.doneMaps.Add(FileName);
                vars.CurColorCount++;
                print(FileName);
            }

            if (FileName.Contains("Unlocked") && (!vars.doneMaps.Contains(FileName)))
            {
                vars.doneMaps.Add(FileName);
                vars.CurWeaponCount++;
                print(FileName);
            }
        }
        vars.scanCooldown.Reset();
        vars.scanCooldown.Start(); 
    }
}

start
{
    return ((current.CurMap.Contains("Maps")) && (current.loading == 1) && (old.loading == 0));
}

onStart
{
    vars.scanCooldown.Reset();
}

split
{
    String CurEggCountToString = vars.CurEggCount.ToString();
    String CurColorCountToString = vars.CurColorCount.ToString();
    String CurWeaponCountToString = vars.CurWeaponCount.ToString();

    if (!vars.doneMaps.Contains(current.CurMap) && (!current.CurMap.Contains("MainMenu")) && (current.CurMap != old.CurMap) && (current.loading == 1))
    {
        vars.doneMaps.Add(current.CurMap);
        return true;
    }

    //Splitting on gaining a new egg
    if (settings[CurEggCountToString] && (!vars.doneMaps.Contains(CurEggCountToString)))
    {
        vars.doneMaps.Add(CurEggCountToString);
        print("Split on Egg Count Of : " + CurEggCountToString);
        return true;
    }

    // Splitting on gaining a new paint bucket
    if (settings["TC"] && (!vars.doneMaps.Contains(CurColorCountToString)) && (vars.CurColorCount != 10))
    {
        vars.doneMaps.Add(CurColorCountToString);
        print("Split on Paint Count Of : " + (vars.CurColorCount -10).ToString());
        return true;
    }

    // Splitting on gaining a new weapon
    if (settings["WO"] && (!vars.doneMaps.Contains(CurWeaponCountToString)) && (vars.CurWeaponCount != 30))
    {
        vars.doneMaps.Add(CurWeaponCountToString);
        print("Split on Weapon Count Of : " + (vars.CurWeaponCount - 30).ToString());
        return true;
    }

    // Splitting on killing Charles
    if ((current.BossMode == 1) && (current.CharlieDead == 1) && (settings["SOD"]) && (!vars.doneMaps.Contains("EndSplitted")))
    {
        print("Killed Charles");
        vars.doneMaps.Add("EndSplitted");
        return true;
    }
}

isLoading
{
    return (current.loading == 0);
}

reset
{
    return (current.CurMap.Contains("MainMenu"));
}

onReset
{
    vars.doneMaps.Clear();
    vars.CurEggCount = 0;
    vars.CurColorCount = 10;
    vars.CurWeaponCount = 30;
    Array.Clear(vars.SaveFiles, 0, vars.SaveFiles.Length);
}
