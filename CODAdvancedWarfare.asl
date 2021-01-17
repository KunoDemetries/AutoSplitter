// Asl written by KunoDemetries#6969
// Addresses found by Klooger#1867
state("s1_sp64_ship")
{
	int loading1: 0x922E77C;
	string50 map: 0x30740B6;
}

startup 
{
	settings.Add("missions", true, "Missions");

	vars.missions = new Dictionary<string,string> { 
		{"recovery","Atlas"},
		{"lagos","Traffic"},
		{"fusion","Fission"},
		{"detroit","Aftermath"},
		{"greece","Manhunt"},
		{"betrayal","Utopia"},
		{"irons_estate","Sentinel"},
		{"crash","Crash"},
		{"lab","Bio Lab"},
		{"sanfran","Collapse"},
		{"sanfran_b","Armada"},
		{"df_fly","Throttle"},
		{"captured","Captured"},
		{"finale","Terminus"},
	}; 
	foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
    };
}

start
{
	if ((current.map == "seoul") && (current.loading1 == 0))
	{
		return true;
	}
}

split
{
	if (current.map != old.map) 
	{
		if (settings[(current.map)])
		{
			return true;				
		}
	}
}
 
reset
{
	return (current.map == "ui");
}

isLoading
{
	return (current.loading1 == 1);
}
