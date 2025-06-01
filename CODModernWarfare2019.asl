state("ModernWarfare")
{
}

init
{
    vars.doneMaps = new List<string>(); // You can accidently enter a previous level so adding this just in case someone gets kicked to the menu
    var pattern = new SigScanTarget(0x7, "4c 8d 3d ?? ?? ?? ?? 66 66 0f 1f 84 00 ?? ?? ?? ?? 4b 8d 04 c0");
    vars.watchers = new MemoryWatcherList();

    vars.gameOffset = IntPtr.Zero;
    int scanAttempts = 10;
    while (scanAttempts-- > 0)
    {
        foreach (var page in game.MemoryPages(true).Reverse())
        {
        var scanner = new SignatureScanner(game, page.BaseAddress, (int)page.RegionSize);
        vars.GetStaticPointerFromSig = (Func<string, int, IntPtr>) ( (signature, instructionOffset) => {

        var pattern1 = new SigScanTarget(signature);
        var location = scanner.Scan(pattern1);
        if (location == IntPtr.Zero) return IntPtr.Zero;
        int offset = game.ReadValue<int>((IntPtr)location + instructionOffset);
        return (IntPtr)location + offset + instructionOffset + 0x4;
    });
            if ((vars.gameOffset = scanner.Scan(pattern)) != IntPtr.Zero)
            {
                print("Found static Game members at 0x" + vars.gameOffset.ToString("X8"));
                scanAttempts = 0;
                break;
            }
        }
        if (scanAttempts == 0) break;
        print("Could not find pattern, retrying " + scanAttempts + " more times.");
        Thread.Sleep(1000);
    }

    vars.mapname = vars.GetStaticPointerFromSig("4c 8d 3d ?? ?? ?? ?? 66 66 0f 1f 84 00 ?? ?? ?? ?? 4b 8d 04 c0", 0x3);
    vars.loading = vars.GetStaticPointerFromSig("80 3d ?? ?? ?? ?? ?? 74 ?? 48 8b 0d ?? ?? ?? ?? e8", 0x2);
    print( vars.loading.ToString("X8"));
    vars.watchers.Add(new StringWatcher(vars.mapname, 40) { Name = "MapName" }); 
    vars.watchers.Add(new MemoryWatcher<int>(new DeepPointer(vars.loading + 0x1)) { Name = "loading"});
}

startup 
{
    settings.Add("act0", true, "all Acts");	
    settings.Add("act1", true, "Act 1", "act0");
    settings.Add("act2", true, "Act 2", "act0");
    settings.Add("act3", true, "Act 3", "act0");

    vars.missions = new Dictionary<string,string> 
		{ 
    		{"piccadilly","Piccadilly"},
    		{"safehouse","embedded"},
    		{"safehouse_finale","Proxy War"},
    		{"townhoused","Clean House"},
    		{"marines","Hunting Party"},
    		{"embassy","Embassy"},
    	};
		foreach (var Tag in vars.missions)
		{
			settings.Add(Tag.Key, true, Tag.Value, "act1");
		};

    vars.missions2 = new Dictionary<string,string> 
		{ 
			{"highway","Highway of Death"},
    		{"hometown","Hometown"},
     		{"tunnels","The Wolf's Den"},
     		{"captive","Captive"},
    	};
		foreach (var Tag in vars.missions2)	
		{
			settings.Add(Tag.Key, true, Tag.Value, "act2");
		};
        
    vars.missions3 = new Dictionary<string,string> 
		{ 
        	{"stpetersburg","Old Comrads"},
        	{"estate","Going Dark"},
        	{"lab","Into the Furnace"},
        };
		foreach (var Tag in vars.missions3)
		{
			settings.Add(Tag.Key, true, Tag.Value, "act3");
    	};

    vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
    {
		vars.doneMaps.Clear();
    });

    timer.OnStart += vars.onStart; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Call of Duty: Modern Warfare 2019",
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
   // print(vars.watchers["MapName"].Current.ToString());
    current.loading = vars.watchers["loading"].Current;
    current.map = old.map = vars.watchers["MapName"].Current;
    print(vars.watchers["loading"].Current.ToString());
}

isLoading
{
    return (current.loading == 1);
}

split
{
	if ((settings[(current.map)]) && (!vars.doneMaps.Contains(current.map)))
	{
		vars.doneMaps.Add(current.map);	
		return true;
	}
}
   

start
{
	if ((current.map == "proxywar") && (current.loading == 0) && ((old.loading != 1)))
    {
		vars.doneMaps.Clear();
    	return true;
    }
}

onStart
{
    vars.doneMaps.Add(current.map);
}

exit 
{
    timer.OnStart -= vars.onStart;
}

onReset
{
    vars.doneMaps.Clear();
}
