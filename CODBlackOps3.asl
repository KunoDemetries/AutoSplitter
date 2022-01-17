state("blackops3") 
{
	int Loader : 0x19E00000;
	string70 CurrentLevelName : 0x156E5086;
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

start
{
	return ((current.CurrentLevelName == "logue") && (current.Loader != 0));
}

split
{
	return ((current.CurrentLevelName != old.map) && (settings[current.CurrentLevelName]));
}

isLoading
{
	return (current.Loader == 0);
}
