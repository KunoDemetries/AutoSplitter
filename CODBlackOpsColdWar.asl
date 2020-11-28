state("BlackOpsColdWar")
{
    int loading1 : 0xE5DFA28;
    string50 map : 0x15981F24;
}

startup
{
	settings.Add("missions", true, "Missions");
    settings.Add("split", false, "Briefings");
    settings.SetToolTip("split", "Will Split on ever briefing (Includes interrogation)");

	vars.missions = new Dictionary<string,string> 
    {    
        {"r_hub","CIA Safehouse E9"},
        {"m_armada","Fractured Jaw"},
        {"r_stakeout","Brick in the Wall"},
        {"s_amerika","Redlight, Greenlight"},
        {"s_yamantau","Echoes of a Cold War"},
        {"s_kgb","Desperate Measures"},
        {"c_revolucion","End of the Line"},
        {"m_prisoner","Break on Through"},
        {"r_hub8","Identity Crisis"},
        {"s_siege","The Final Countdown (Good Ending)"},
        {"s_duga","Ashes to Ashes (Bad Ending)"},
        }; 

 	    foreach (var Tag in vars.missions)
	    {
		    settings.Add(Tag.Key, true, Tag.Value, "missions");
    };

}

init
{
    vars.debreifsplit = 0;
    vars.doneMaps = new List<string>(); 
    vars.splitter = 0;
}

update
{
    if ((current.map == "r_hub") && (old.map != "takedown") &&  (current.map != old.map) && (settings["split"]))
    {
        vars.debreifsplit = 1;
    }
    else
    {
        vars.debreifsplit = 0;
    }

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

start
{
    if ((current.map == "takedown") && (current.loading1 != 0))
    {
		vars.doneMaps.Clear();
		return true;		
	}
}

split
{
    return ((vars.debreifsplit == 1) ||
            (vars.splitter == 1));
}

reset
{
    if (current.map == "frontend")
    {
        
		vars.doneMaps.Clear();
		return true;		
	
    }
 }


isLoading
{
    return (current.loading1 == 0);
}
