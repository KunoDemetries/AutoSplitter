state("s2_sp64_ship")
{
	string15 CurrentLevelName : 0x6A122B4;
    int Loader : 0x2AB9B44;
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
	return ((current.CurrentLevelName == "normandy") && (current.CurrentLevelName != "transport_ship"));
}

onStart
{
	vars.doneMaps.Clear();
}

split
{
	if ((current.CurrentLevelName != old.CurrentLevelName) && (settings[current.CurrentLevelName]) && (!vars.doneMaps.Contains(current.CurrentLevelName))) 
	{
		vars.doneMaps.Add(old.CurrentLevelName);
		return true;	
	}
}

isLoading
{
	return (current.Loader == 0);	
}
