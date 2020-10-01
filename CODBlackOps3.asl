state("blackops3") 
{
	int loading1 : 0x19E00000;
	string111 map : 0x156E5086;
}

startup
{
	settings.Add("missions", true, "Missions");	
	
	vars.missions = new Dictionary<string,string> 
	{  
	    {"newworld", "New World"},
        {"ackstation", "In Darkness"},
        {"odomes", "Provocation"},
        {"en", "Hypercenter"},
        {"ngeance", "Vengeance"},
        {"amses", "Rise and Fall"},
        {"nfection", "Demon Within"},
        {"quifer", "Sand Castle"},
        {"otus", "Lotus Towers"},
        {"coalescence", "Life"},
	};

 	foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
    };
}
 
init
{
	vars.doneMaps = new List<string>(); 
}

start
{
	if ((current.map1 == "logue") && (current.loading1 != 0))
	{
		vars.doneMaps.Clear();
		return true;	
	}
}

split
{
	if (current.map != old.map) 
	{
		if (settings[current.map]) 
		{
			vars.doneMaps.Add(old.map);
			return true;	
		}	
	}
}

isLoading
{
	return (current.loading1 == 0);
}
