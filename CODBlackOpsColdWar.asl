// Created by KunoDemetries#6969 
// For vers 1.7.6
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

}

init // making throwaway vars for comparison and tracking
{
    vars.debreifsplit = 0;
    vars.doneMaps = new List<string>(); 
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
    if (((settings[current.map]) && (old.map != current.map) && (!vars.doneMaps.Contains(current.map))))
	{
		vars.doneMaps.Add(old.map);				
		vars.splitter = 1;	
    }
    else
    {
        vars.splitter = 0;
    }
}

start // a generic start 
{
    if ((current.map == "takedown") && (current.loading1 != 0))
    {
		vars.doneMaps.Clear(); // Always good to clear doneMaps in start and reset. Would recommend to also do it in 
		return true;		    // update if you're back in e_frontend but most of the time it's not neccesary
	}
}

split // Basically if the "update" function's checks turned true to split
{
    return ((vars.debreifsplit == 1) ||
            (vars.splitter == 1));
}

reset // e_frontend is the main menu screen
{
    if (current.map == "e_frontend")
    {
        
		vars.doneMaps.Clear(); // Always good to clear doneMaps in start and reset
		return true;		
	
    }
 }


isLoading
{
    return (current.loading1 == 0);
}
