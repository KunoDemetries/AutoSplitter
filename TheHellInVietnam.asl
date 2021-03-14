state("thiv")
{
    //string10 map : "ChromeEngine2.dll", 0x40A939;
	//int loading3: "ChromeEngine2.dll", 0x2FD61C;
	string10 map: "ChromeEngine2.dll", 0x4AF96C;
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
    if ((current.map == "Mission_01") && (current.loading3 != old.loading3))
    {
		return true;       
    }
}

isLoading
{
    return (current.loading3 == 4);
}

split
{
	if (current.map != old.map) 
	{
		if (settings[current.map]) 
		{			
			return true;	
		}	
	}
}

reset
{
	return ((old.scene == 5046310) && (current.scene == 4456486));
}