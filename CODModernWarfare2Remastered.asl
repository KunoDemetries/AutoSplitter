// help from Klooger on some of the addresses
state("MW2CR")
{
	string6 decide: 0xA9809F;
    string50 map : 0x41758D1;
	int loading1 : 0x4B894F0;
}

state("MW2CR", "Default")
{
	string50 map : 0x42187F6;
	byte loading1 : 0x6509784;
	string6 decide: 0xA9809F;
}

state("MW2CR", "1.1.12")
{
	string50 map : 0x41758D1;
	int loading1 : 0x4B894F0;
	string6 decide: 0x11BAC56C;
}

state("MW2CR", "1.1.13")
{
	string50 map : 0x41767F6;
	byte loading1 : 0x4B8A4F0;
}


init
{
    // I have to leave this in as I don't own 1.1.12 or the orignal 1.0 version
	if (current.decide == "1.1.12") 
	{
    	version = "1.1.12";
  	}
	else 
	{
    version = "Default";
  	}
      
    if ( modules.First().ModuleMemorySize == 300334080)
    {
        version = "1.1.13";
    }

	vars.doneMaps = new List<string>(); // Just in case intel% is added in the future (been talks) just adding a doneMaps just in case
}

startup 
{
    settings.Add("acta", true, "All Acts");    
    settings.Add("act1", true, "Act 1", "acta");
    settings.Add("act2", true, "Act 2", "acta");
    settings.Add("act3", true, "Act 3", "acta");

    vars.missions2 = new Dictionary<string,string> 
		{ 
			//{"trainier", "S.S.D.D."}, 
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

      	vars.onStart = (EventHandler)((s, e) => // (taken from Gelly) using this just in case someone has autostart/reset off
        {
    		vars.doneMaps.Clear();
			vars.doneMaps.Add(current.map);
        });

    timer.OnStart += vars.onStart; 

   vars.onReset = (LiveSplit.Model.Input.EventHandlerT<LiveSplit.Model.TimerPhase>)((s, e) => 
        {
            vars.doneMaps.Clear(); // Needed because checkpoints bad in game 
        });
    timer.OnReset += vars.onReset; 

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
	if ((current.map == "trainer") && (current.loading1 != 0)) 
    {
    	vars.doneMaps.Clear();
		vars.doneMaps.Add(current.map);
    	return true;
    }
}

isLoading
{
    return (current.map == "ui") || (current.loading1 == 0);
}
 
reset
{
    return ((current.map == "ui") && (old.map != "ui"));
}

split
{
	if ((current.map != old.map) && (settings[current.map]) && (!vars.doneMaps.Contains(current.map))) 
	{
		vars.doneMaps.Add(current.map);
		return true;	
	}	
}
