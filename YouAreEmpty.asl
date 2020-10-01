state("you_are_empty")
{
    bool isNotLoading : "ds2kernel.dll", 0xC00EC;
    string50 maps : "ds2kernel.dll", 0xBDC94;
}

startup
{
    settings.Add("l1", true, "Levels");

    vars.missions5 = new Dictionary<string,string> 
    { 
        {"med2", "Hospital 2"}, 
        {"kolhoz", "Kolhoz 1"}, 
        {"kolhoz_part2", "Kolhoz 2"}, 
        {"meat", "Plant 1"}, 
        {"meat_part2", "Plant 2"}, 
        {"wall", "Old Town"}, 
        {"gor", "Totalitarianism 1"}, 
        {"gor_part_2", "Totalitarianism 2"}, 
        {"grsvt", "City Council"}, 
        {"gorkonec", "Tram"}, 
        {"poh", "Yards"}, 
        {"kinostreet", "Cinema 1"}, 
        {"kinostreet 2", "Cinema 2"}, 
        {"metro", "Metro 1"},
        {"met6", "Metro 2"}, 
        {"theatre","Opera"},
        {"krovli","Roofs"},
        {"parall","Depot 1"},
        {"parall_part2","Depot 2"},
        {"parall_part3","Depot 3"},
        {"lastlevel","Utopia"},
        {"futur","Reactor"},
        {"lastzlo","Finale"},
    };

 	foreach (var Tag in vars.missions5)
	{
		settings.Add(Tag.Key, true, Tag.Value, "l1");
    };
}

init
{
    vars.doneMaps = new List<string>(); 
}

start
{
   if ((current.maps == "med1") && (!current.isNotLoading)) {
        vars.doneMaps.Clear();
		vars.doneMaps.Add(current.maps);
        return true;
    }
}


isLoading
{
    return !current.isNotLoading;
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
