state("blackops3") 
{
	int loading1 : 0x19E00000;
	string111 map : 0x156E5086;
}

startup
{
	settings.Add("missions", true, "Missions");	
	
	vars.missions = new Dictionary<string,string> 
	{  
	    {"newworld", "New World"},
        {"ackstation", "In Darkness"},
        {"odomes", "Provocation"},
        {"en", "Hypercenter"},
        {"ngeance", "Vengeance"},
        {"amses", "Rise and Fall"},
        {"nfection", "Demon Within"},
        {"quifer", "Sand Castle"},
        {"otus", "Lotus Towers"},
        {"coalescence", "Life"},
	};

 	foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
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
                "LiveSplit | Call of Duty: Black Ops 3",
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
	vars.doneMaps = new List<string>(); 
}

start
{
	if ((current.map1 == "logue") && (current.loading1 != 0))
	{
		vars.doneMaps.Clear();
		return true;	
	}
}

split
{
	if (current.map != old.map) 
	{
		if (settings[current.map]) 
		{
			vars.doneMaps.Add(old.map);
			return true;	
		}	
	}
}

isLoading
{
	return (current.loading1 == 0);
}

exit 
{
    timer.OnStart -= vars.onStart;
}
