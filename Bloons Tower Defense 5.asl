/*
state("BTD5-Win", "Version 1.1")
{
    int Round :  "BTD5-Win.exe", 0x0080D4AC, 0x78, 0x14;
	int Menu : "BTD5-Win.exe", 0x80D290;
}
*/

state("BTD5-Win", "Version 3.35")
{
    int Round : 0x00A30A10, 0x7C, 0x14;
    string40 CurrentLevelName : 0x00A30A04, 0x0, 0x0, 0x28, 0x3C, 0x1C;
}

init
{
    vars.TimerStart = false;
    vars.DoSplit = false;
    vars.doneMaps = new List<string>(); 

    switch (modules.First().ModuleMemorySize) 
    {
        case    12582912: version = "Version 3.35"; 
            break;
        default:        version = "Version 1.1"; 
            break;
    }
}

startup
{
    settings.Add("SPR", true, "Split Per Round?");
    settings.Add("SPL", false, "Split per level?");
    settings.Add("SODC", false, "Split on map difficulty change?");

    vars.DifficutlyChangeList = new List<string>()
    {
        "/autumn_leaves/", // Intermediate, autumn leaves
        "/day_of_the_undead/", // Advanced, Day of the undead
        "/double_double_crossover/", // Expert, Double Double Cross
        "/toxic_waste/", // Extreme, Toxic Waste
    };
}

update
{
    if (vars.TimerStart)
    {
        if ((settings["SPR"]) && (current.Round != old.Round) && (current.Round != 0))
        {
            vars.DoSplit = true;
        }

        if ((settings["SPL"]) && (current.CurrentLevelName != old.CurrentLevelName) && (!vars.doneMaps.Contains(current.CurrentLevelName)))
        {
            vars.doneMaps.Add(current.CurrentLevelName);
            vars.DoSplit = true;
        }

        if ((settings["SODC"]) && (vars.DifficutlyChangeList.Contains(current.CurrentLevelName) && (!vars.doneMaps.Contains(current.CurrentLevelName))))
        {
            vars.doneMaps.Add(current.CurrentLevelName);
            vars.DoSplit = true;
        }
    }
}

start
{
	return (current.Round == 1 && old.Round == 0);
}

onStart
{
    vars.TimerStart = true;
}

onReset
{
    vars.doneMaps.Clear();
    vars.TimerStart = false;
}

split
{ 
    if (vars.DoSplit)
    {
        vars.DoSplit = false;
        return true;
    }
}