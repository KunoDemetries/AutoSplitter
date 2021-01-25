state("MW2CR")
{
	string6 decide: 0xA9809F;
    string50 map1 : 0x41758D1;
	int loading1 : 0x4B894F0;
}

state("MW2CR", "Default")
{
	string50 map1 : 0x42187F6;
	byte loading1 : 0x6509784;
	string6 decide: 0xA9809F;
}

state("MW2CR", "1.1.12")
{
	string50 map1 : 0x41758D1;
	int loading1 : 0x4B894F0;
	string6 decide: 0x11BAC56C;
}

init
{
	if (current.decide == "1.1.12") 
	{
    	version = "1.1.12";
  	}
	else 
	{
    version = "Default";
  	}
      
	vars.doneMaps = new List<string>(); 
}


startup 
{
    settings.Add("acta", true, "All Acts");    
    settings.Add("act1", true, "Act 1", "acta");
    settings.Add("act2", true, "Act 2", "acta");
    settings.Add("act3", true, "Act 3", "acta");

    vars.missions2 = new Dictionary<string,string> 
	{ 
		{"trainier", "S.S.D.D."}, 
		{"roadkill", "Team Player"},
		{"cliffhanger", "Cliffhanger"},
		{"airport", "No Russian"},
		{"favela", "Takedown"},
    };

 	foreach (var Tag in vars.missions2)
	{
		settings.Add(Tag.Key, true, Tag.Value, "act1");
    };

    vars.missions3 = new Dictionary<string,string> 
	{ 
		{"invasion", "Wolverines"},
		{"favela_escape", "The Hornets Nest"},
		{"arcadia", "Exodus"},
		{"oilrig", "The Only Easy Day Was Yesterday"},
		{"gulag", "The Gulag"},
		{"dcburning", "Of Their Own Accord"},
    };
 	
	 foreach (var Tag in vars.missions3)
	{
		settings.Add(Tag.Key, true, Tag.Value, "act2");
    };
        
    vars.missions4 = new Dictionary<string,string> 
	{ 
		{"contingency", "Contingency"},
		{"dcemp", "Second Sun"}, 
		{"dc_whitehouse", "Whiskey Hotel"},
		{"estate", "Loose Ends"},
		{"boneyard", "The Enemy of My Enemy"},
		{"af_caves", "Just Like Old Times"},
		{"af_chase", "Endgame"},
		{"ending", "End"},
    };
        
 	foreach (var Tag in vars.missions4)
	{
		settings.Add(Tag.Key, true, Tag.Value, "act3");
    };

      	vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
        {
            vars.starter = 0;
            vars.endsplit = 0;
            vars.FuckFinalSplit = 0;
            vars.doneMaps.Clear();
            vars.doneMaps.Add(current.map.ToString());
        });

    timer.OnStart += vars.onStart; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Call of Duty: Modern Warfare 2 Remastered",
               MessageBoxButtons.YesNo,MessageBoxIcon.Question
            );
        
            if (timingMessage == DialogResult.Yes)
            {
                timer.CurrentTimingMethod = TimingMethod.GameTime;
            }
        }	
}

start
{
	if ((current.map1 == "trainer") && (current.loading1 != 0)) 
    {
    	vars.doneMaps.Clear();
		vars.doneMaps.Add(current.map1);
    	return true;
    }
}

 isLoading
{
	return ((current.loading1 == 0) && (version == "1.1.12"));
	return ((current.loading1 == 0) && (version == "Default"));
    return (current.map1 == "ui");
}
 
 reset
{
    return ((current.map1 == "ui") && (old.map1 != "ui"));
}

split
{
	if (current.map1 != old.map1) 
	{
		if (settings[current.map1]) 
		{
			vars.doneMaps.Add(old.map1);
			return true;	
		}	
	}
}

// help from klooger
