state("iw7_ship") // Base Address : 0x7FF6EBF60000
{
    int CurrentRound : 0x1FAB484; 
    byte Loader : 0x5D65B77;
    string100 CurrentLevelName : 0x21E5F3C;
}
// iw7_ship.exe+5D168E4, extra just in case
init
{
    vars.doneMaps = new List<string>(); 
    vars.CurRoundToString = "";
    vars.DoSplit = 0;
}

startup
{
    settings.Add("RS", true, "Split Every Round?");
    settings.Add("SS", true, "Call of Duty WW2 Zombies");

	vars.missions = new Dictionary<string,string> 
	{
        {"5", "5"},
        {"10", "10"},
        {"15", "15"},
        {"20", "20"},
        {"25", "25"},
        {"30", "30"},
        {"35", "35"},
        {"40", "40"},
        {"45", "45"},
        {"50", "50"},
        {"55", "55"},
        {"60", "60"},
        {"65", "65"},
        {"70", "70"},
        {"75", "75"},
        {"80", "80"},
        {"85", "85"},
        {"90", "90"},
        {"95", "95"},
        {"100", "100"},
    };
	foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "SS");
    };
}

update
{
    vars.CurRoundToString = current.CurrentRound.ToString();

    if (settings["RS"])
    {
        if ((current.CurrentRound != old.CurrentRound) && (!vars.doneMaps.Contains(vars.CurRoundToString)))
        {
            vars.doneMaps.Add(vars.CurRoundToString);
            vars.DoSplit = 1;
        }
    }
    else
    {
        if (settings[vars.CurRoundToString] && (!vars.doneMaps.Contains(vars.CurRoundToString)))
        {
            vars.doneMaps.Add(vars.CurRoundToString);
            vars.DoSplit = 1;
        }
    }
}

start
{
    return (current.Loader != 0 && current.CurrentLevelName != "cp_frontend");
}

onStart
{
    vars.doneMaps.Add(vars.CurRoundToString);
}

split
{
    if (vars.DoSplit == 1)
    {
        vars.DoSplit = 0;
        return true;
    }
}

reset
{
    return (current.CurrentLevelName == "cp_frontend");
}

onReset
{
    vars.doneMaps.Clear();
}