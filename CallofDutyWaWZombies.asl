state("CoDWaW")
{
    byte Paused: 0x49C945C; // 1 paused, 0 unpaused, pretty easy to find
    int Round : 0x2D03898; 
    /* So this is the total zombies spawned that I'm using as the identifier if the round has ended as there is no possibility of hitting 0 
    before the end of the round as zombies will spawn instantly after a nuke. To find this it was pretty simple of getting the zombies down to 3-4
    doing a scan and decrease the value after killing each zombie    
    */
    bool Loader : 0x3172284; // Taken from main-game ASL
    string50 CurrentLevelName : 0x5592B8; // Taken from main-game ASL
    bool RoundEnd: 0x14E73D0; // Just a generic bool check on if the round end screen is shown and or the death screen
}

startup
{
    settings.Add("SPR", false, "Split Every Round?"); 
    settings.Add("SSR", true, "Split Specific Rounds"); 

    vars.missions2 = new Dictionary<string,string> 
	{ 	
        {"5","Round 5"},
        {"10","Round 10"},
        {"15","Round 15"},
        {"20","Round 20"},
        {"25","Round 25"},
        {"30","Round 30"},
        {"35","Round 35"},
        {"40","Round 40"},
        {"45","Round 45"},
        {"50","Round 50"},
        {"75","Round 75"},
        {"100","Round 100"},
    };
 	foreach (var Tag in vars.missions2)
	{
		settings.Add(Tag.Key, true, Tag.Value, "SSR");
    };
}

init
{    
    vars.doneMaps = new List <string>();
    vars.currentCount = 1;
}

update
{
    if ((current.Round == 0) && (old.Round != 0) && (old.Round == 1) && (current.Paused != 1))
    {
        vars.currentCount++;
    }
}

start
{
    return ((current.Loader) && (current.Round == 1) && (vars.currentCount == 1));
}

split
{
    if (!settings["SPR"] && (settings["SSR"]) && (settings[vars.currentCount.ToString()]) && (!vars.doneMaps.Contains(vars.currentCount.ToString())))
    {
        vars.doneMaps.Add(vars.currentCount.ToString());
        return true;
    }
}

isLoading
{
    return (current.Paused == 1 || current.RoundEnd);
}

reset 
{
	return (current.CurrentLevelName == "ui");
}

onReset
{
    vars.doneMaps.Clear();
    vars.currentCount = 1;
}