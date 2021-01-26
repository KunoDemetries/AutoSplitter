state("ModernWarfare")
{
    string100 map : 0xDE83FA1;
    int loading1 :  0xEDD51C4;
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
    		{"ouse_finale","Proxy War"},
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

split
{
	if ((current.map != old.map) && (settings[(current.map)]))
	{
		return true;
	}
}
   

start
{
	if ((current.map == "proxywar") && (current.loading1 == 1118989) && ((old.loading1 != 1118989)))
    {
    	return true;
    }
}

isLoading
{
    return ((current.loading1 == 1118988));
}
