state("s2_sp64_ship")
{
	string15 map : 0x6A122B4;
    int loading1 : 0x2AB9B44;
}

startup 
{
	settings.Add("missions", true, "Missions");

	vars.missions = new Dictionary<string,string> 
		{  
			{"cobra", "Operation Cobra"}, 
			{"marigny", "Stronghold"},
			{"train", "S.O.E."},
			{"paris", "Liberation"},
			{"aachen", "Collateral Damage"},
			{"hurtgen", "Death Factory"},
			{"hill", "Hill 493"},
			{"bulge", "Battle of The Bulge"},
			{"taken", "Ambush"},
			{"taken_tent", "The Rhine"},
        	{"labor_camp", "Epilogue"},
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
            "LiveSplit | Call of Duty: WW2",
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
	vars.doneMaps = new List<string>(); // Because you get kicked to the main menu after each level gotta use a doneMaps just in case
}

start
{
	if ((current.map == "normandy") && (current.map != "transport_ship"))
	{
		vars.doneMaps.Clear();
		return true;
	}
}

split
{
	if ((current.map != old.map) && (settings[current.map]) && (!vars.doneMaps.Contains(current.map))) 
	{
		vars.doneMaps.Add(old.map);
		return true;	
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
