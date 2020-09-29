state("BlackOps")
{
	string70 map : 0x21033E8;
	long loading1: 0x1656804;	
}

startup 
{
	vars.missions = new Dictionary<string,string> { 
	  {"vorkuta", "Vorkuta"},
		{"pentagon", "USDD"},
		{"flashpoint", "Executive Order"},
		{"khe_sanh", "SOG"},
		{"hue_city", "The Defector"},
		{"kowloon", "Numbers"},
		{"fullahead", "Project Nova"},
		{"creek_1", "Victor Charlie"},
		{"river", "Crash Site"},
		{"wmd_sr71", "WMD"},
		{"pow", "Payback"}, 
		{"rebirth", "Rebirth"},
		{"int_escape", "Revelations"},
		{"underwaterbase", "Redemption"},
		{"outro", "Menu Screen"},
		}; 
    foreach (var Tag in vars.missions) {
    settings.Add(Tag.Key, true, Tag.Value);
    }
}

init 
{
	vars.doneMaps = new List<string>(); 
}

start
{
    if ((current.map == "cuba") && (current.loading1 != 0)) {
        vars.doneMaps.Clear();
        return true;
    }
}

isLoading
{
	return (current.loading1 == 0);
}


reset
{
	return (current.map == "frontend");
}

split
{
    if ((current.map != old.map) && (vars.doneMaps != old.maps))
    {
	    if (settings[current.map]) 
      {
	      vars.doneMaps.Add(old.map);
				return true;
			}
    }			
}
