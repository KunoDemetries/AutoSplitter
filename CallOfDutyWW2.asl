state("s2_sp64_ship")
{
	string200 map: 0x6A122B4;
    int loading1:  0x2AB9B44;
}

startup 
{
	settings.Add("missions", true, "Missions");

	vars.missions = new Dictionary<string,string> {  
		{"cobra", "Operation Cobra"}, 
		{"marigny", "Stronghold"},
		{"train", "S.O.E."},
		{"paris", "Liberation"},
		{"aachen", "Collateral Damage"},
		{"hurtgen", "Death Factory"},
		{"hill", "Hill 493"},
		{"bulge", "Battle of The Bulge"},
		{"taken", "Ambush"},
		{"taken_tent", "The Rhine"},
        {"labor_camp", "Epilogue"},
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
	if ((current.map == "normandy") && (current.map != "transport_ship"))
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