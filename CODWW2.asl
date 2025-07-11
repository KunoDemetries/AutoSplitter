state("s2_sp64_ship")
{
	string15 CurrentLevelName : 0x6A122B4;
    int Loader : 0x2AB9B44;
}

startup 
{
	settings.Add("Cutscene Time Fix", true, "Adds 62.8s to Hill 493, 2:58.6 to Ambush, & 48.7 to Epilogue");
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

update
{
	//massive shoutout to Ero for the help here. This is basically *removing* time from LiveSplits "loading times" which is then adding to RTA to display the time as LRT
	// this is probably a really backwards way of doing it, there must be a simpler way but im unsure - Meta
	if (settings["Cutscene Time Fix"] && old.CurrentLevelName == "hill" && current.CurrentLevelName == "mission_select")
	{print("Hill CTF Executed Successfully"); const double HillOffset = 62.8; timer.LoadingTimes -= TimeSpan.FromSeconds(HillOffset);}

	if (settings["Cutscene Time Fix"] && old.CurrentLevelName == "taken" && current.CurrentLevelName == "mission_select")
	{print("Taken CTF Executed Successfully"); const double TakenOffset = 178.6; timer.LoadingTimes -= TimeSpan.FromSeconds(TakenOffset);}

	if (settings["Cutscene Time Fix"] && old.CurrentLevelName == "remagen" && current.CurrentLevelName == "labor_camp")
	{print("Labor CTF Executed Successfully"); const double LaborOffset = 48.7; timer.LoadingTimes -= TimeSpan.FromSeconds(LaborOffset);}
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
