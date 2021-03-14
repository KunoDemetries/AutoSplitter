// Start was done by xZeko as I got busy with another ASL
state("Zoo_no_sse") // Two .exe's pogu, which work with the same addresses
{
    byte splitter : 0x470770; // Such a powerful address, not only does it have a value for loading, main menu, and split, it also only took 5 minutes to find
    int start : 0x46EAA0; // 0 main menu
	int start2 : 0x478064; // 3 main menu
	int start3 : 0x474840; // 0 main menu
}

state("Zoo_SSE")
{
    byte splitter : 0x470770;
    int start : 0x46EAA0; // 0 main menu
	int start2 : 0x478064; // 3 main menu
	int start3 : 0x474840; // 0 main menu
}

startup
{
	settings.Add("missions", true, "All Levels");

    vars.missions = new Dictionary<string,string> // Ik you can do int,string but it always reads errors for me so ICBA to struggle with it
    {
        {"170","Mines"},
        {"130","Volcano"},
        {"139","Warehouse"},
        {"43","Ice House"},
        {"78","Diamond-o-Matic"},
    };
	foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
    };
}

start
{
	return ((current.start == 16777472) && (current.start2 == 4) && (old.start3 == 1) || (current.start == 256) && (current.start2 == 4) && (old.start3 == 1));
}

split
{
    return (settings[current.splitter.ToString()] && (current.splitter != old.splitter));
}

isLoading
{
    return (current.splitter == 0) ||
    (current.splitter == 12);
}
