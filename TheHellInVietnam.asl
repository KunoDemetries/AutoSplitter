state("thiv")
{
	string10 map : "ChromeEngine2.dll", 0x4AF96C;
	int loading3 : "ChromeEngine2.dll", 0x42963C;
	int scene : "ChromeEngine2.dll", 0x2FD614;
}

startup
{
	settings.Add("missions", true, "Missions");

	vars.missions = new Dictionary<string,string> 
    {  
        {"Mission_02","A Day in the Country"},
        {"Mission_04","Highway Patrol"},
        {"Mission_03","Down by the River"},
        {"Mission_05","The Battle of Hue"},
        {"Mission_06","Buddah's Smile"},
        {"Mission_07","Field of Destruction"},
        {"Mission_08","The Journey Home"},
    };

 	foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
    };
}


start
{
    return ((current.map == "Mission_01") && (current.loading3 != old.loading3));
}

isLoading
{
    return (current.loading3 == 4);
}

split
{
	return ((current.map != old.map) && (settings[current.map]));
}

reset
{
	return ((old.scene == 5046310) && (current.scene == 4456486));
}
