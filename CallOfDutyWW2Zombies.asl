state("s2_mp64_ship", "Current Steam Version") // Base Address : 0x7FF6EBF60000
{
    int CurrentRound : 0xA768DFC; 
    byte Paused : 0x275075C; 
}
/*
7FF6FC200420
7FF6FC2811DC
7FF6EE6B011D
7FF6EE6B075D
7FF6EE77F400
7FF6EE77F470
7FF6EE77F460
7FF6F92681AD
7FF6F94A3891
7FF6F94AC7D0
7FF6FC2811E0
7FF6F926808D
7FF6F94A3A79
7FF6F4D38DD3
7FF6EE77F410
7FF6EE6B08ED
7FF6FC20041C
7FF6EE6B075C
7FF6EE5B349A

*/
init
{
    vars.doneMaps = new List<string>(); 
    vars.CurRoundToString = "";
    vars.DoSplit = 0;

    switch (modules.First().ModuleMemorySize) 
    {
        case  317335552: version = "Current Steam Version";
            break;
    }
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
    return ((current.CurrentRound == 1) && (old.CurrentRound == 0));
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

isLoading
{
    return (current.Paused == 1);
}

onReset
{
    vars.doneMaps.Clear();
}