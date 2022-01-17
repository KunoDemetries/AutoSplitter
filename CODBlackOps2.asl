state("t6sp")
{
	string21 CurrentLevelName : 0xF4E62C; // Regular splitter map
	int Loader :0x3D83614;
	string24 CurrentPlayAreaName : 0xC18138; 
	int EndSplit : 0x2578DF0; 
}

startup
{
	settings.Add("missions", true, "Missions");

    vars.missions = new Dictionary<string,string> 
		{  
			{"monsoon.all.sabs", "Celerium"},
			{"afghanistan.all.sabs", "Old Wounds"},
			{"nicaragua.all.sabs", "Time and Fate"},
			{"pakistan_1.all.sabs", "Fallen Angel"},
			{"karma_1.all.sabs", "Karma"},
			{"panama.all.sabs", "Suffer With Me"},
			{"yemen.all.sabs", "Achilles Veil"},
			{"blackout.all.sabs", "Odysseus"},
			{"la_1.all.sabs", "Cordis Die"},
			{"haiti.all.sabs", "Judgment Day"},
		}; 
		foreach (var Tag in vars.missions)
		{
			settings.Add(Tag.Key, true, Tag.Value, "missions");
    	};
           
    vars.loadings = new Dictionary<string,string> 
		{
        	{"fronted.english.sabs","cutscene1"},
        	{"fronted.all.sabs","cutscene2"},
        	{"ts_afghanistan.all.sabs","cutscene3"},
    	};
        vars.missions1A = new List<string>();
        foreach (var Tag in vars.loadings) 
		{
        	vars.missions1A.Add(Tag.Key);
        }

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
    {        
    	var timingMessage = MessageBox.Show 
		(
           "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier",
            "LiveSplit | Call of Duty: Black Ops 2",
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
    return ((current.CurrentLevelName == "angola.all.sabs") && (current.Loader != 0)); // Starts closer now because of a new loading value
}

isLoading
{
    if (current.CurrentPlayAreaName != "nicaragua_gump_josefina") // No matter what address I used, it always turns true in the middle of joesefina's cutscene mid level
	{
		if ((current.Loader == 0) || 
		((current.CurrentPlayAreaName == "su_rts_mp_dockside")) || // Training course level that map1 doesn't switch to most of the time
		(vars.missions1A.Contains(current.CurrentLevelName))) 
        {
            return true;
        }
		else // IDK why probably because of the double if, but it likes to not unpause without a return false on an else
		{
			return false;
		}
	}	
}

split
{
    return ((current.CurrentLevelName != old.CurrentLevelName) && (settings[current.CurrentLevelName]));

	return ((current.CurrentPlayAreaName == "haiti_gump_endings") && (current.EndSplit != 0)); // Used as end split once decision is made	
}
