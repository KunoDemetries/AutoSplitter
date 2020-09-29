state("SniperElite4_DX11") 
{
    string100 map : 0xEB0BEB;
    float loading1 : 0xCFCAF0;
    float islandload : 0xC15A90; 
}

state("SniperElite4_DX12") 
{
	string100 map :  0xE5A2AB;
	float loading1 : 0xE55958;
	float islandload : 0xB683E0; 
}

startup
{
	settings.Add("missions", true, "Missions");

	vars.missions = new Dictionary<string,string> 
	{ 
    	{"Marina", "Bianti Village"},
        {"Viaduct", "Regilino Viaduct"},
        {"Dockyard", "Lorino Dockyard"},
        {"Monte_Cassino", "Abrunza Monastery"},
        {"Coastal_Facility", "Magazzeno Facility"},
        {"Forest", "Giovi Fiorini Mansion"},
        {"Fortress", "allagra Fortress"},
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
	if ((current.map == "Island") && (current.loading1 != 0))
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

reset
{
	return ((current.map == "Island") && (old.map != "Island"));
}

isLoading
{
	return ((current.loading1 == 0)) ||
  	((current.islandload == 0));
}
