// Created by KunoDemetries#6969 
// For vers 1.8
state("BlackOpsColdWar")
{
    int loading1 : 0xE179120; // It seems static addresses for things like loads and
    string50 map : 0xECF9EF3; // Level names are consistent to the 0xEA - 0xEF area
}

startup
{
	settings.Add("missions", true, "Missions"); // Making a setting for base levels
    settings.Add("split", false, "Briefings"); // Making a setting for All the briefings
    settings.SetToolTip("split", "Will Split on ever briefing (Includes interrogation)");  // making a note to explain the briefing setting

	vars.missions = new Dictionary<string,string> // creating a dictionary just to not have to make 1.5k settings
    	{    
        	{"ger_hub","CIA Safehouse E9"}, // first "" is the in-game name, and the second "" is the actual name
        	{"nam_armada","Fractured Jaw"},
        	{"ger_stakeout","Brick in the Wall"},
        	{"rus_amerika","Redlight, Greenlight"},
        	{"rus_yamantau","Echoes of a Cold War"},
        	{"rus_kgb","Desperate Measures"},
        	{"nic_revolucion","End of the Line"},
        	{"nam_prisoner","Break on Through"},
        	{"ger_hub8","Identity Crisis"},
        	{"rus_siege","The Final Countdown (Good Ending)"},
        	{"rus_duga","Ashes to Ashes (Bad Ending)"},
    	}; 
        // operation cirus demission_tundra
 	    foreach (var Tag in vars.missions) // Saying for every var in var.missions to make it have the key value of missions to then refrence it in the settings for missions
	    {
		    settings.Add(Tag.Key, true, Tag.Value, "missions");
        };


  	vars.onStart = (EventHandler)((s, e) => // thanks gelly for this, it's basically making sure it always clears the vars no matter how livesplit starts
        {
			vars.doneMaps.Clear();
			vars.debreifsplit = 0;
    		vars.splitter = 0;
        });

        timer.OnStart += vars.onStart; 

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Call of Duty: Black Ops Cold War",
               MessageBoxButtons.YesNo,MessageBoxIcon.Question
            );
        
            if (timingMessage == DialogResult.Yes)
            {
                timer.CurrentTimingMethod = TimingMethod.GameTime;
            }
        }	

}

init // making throwaway vars for comparison and tracking
{
    vars.debreifsplit = 0;
    vars.doneMaps = new List<string>(); // Because of how menuing works you can accidently enter into a previous level, so doneMaps needed
    vars.splitter = 0;
}

update
{
    // This first one is basically keeping track of everytime we enter a debrief as they're the same map name
    if ((current.map == "ger_hub") && (old.map != "takedown") &&  (current.map != old.map) && (settings["split"]))
    {
        vars.debreifsplit = 1;
    }
    else
    {
        vars.debreifsplit = 0;
    }

    // A basic check to see if were in a level we weren't in previously and if that level's setting is true
    if ((settings[current.map]) && (old.map != current.map) && (!vars.doneMaps.Contains(current.map)))
	{
		vars.doneMaps.Add(old.map);				
		vars.splitter = 1;	
    }
    else
    {
        vars.splitter = 0;
    }
}

start 
{
    if ((current.map == "takedown") && (current.loading1 != 0))
    {
		vars.doneMaps.Clear(); // Always good to clear doneMaps in start and reset. Would recommend to also do it in 
		vars.debreifsplit = 0; // update if you're back in e_frontend but most of the time it's not neccesary
    	vars.splitter = 0; 
		return true;		    
	}
}

split // Basically if the "update" function's checks turned true to split
{
    return ((vars.debreifsplit == 1) ||
            (vars.splitter == 1));
}

reset // e_frontend is the main menu screen (like most 3arc games)
{
    return (current.map == "e_frontend");
 }


isLoading
{
    return (current.loading1 == 0);
}

exit 
{
    timer.OnStart -= vars.onStart;
}
