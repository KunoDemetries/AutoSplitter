state("cryostasis")
{
	string60 mapName : 0x17B24B3;
	bool isLoading : 0x1B80715;
}

init
{
	vars.doneMaps = new List<string>();
}

startup
{
    settings.Add("Levels", true, "All Levels");

	vars.missions2 = new Dictionary<string,string> 
	{
		{"bios20.map","Dream"}, 
		{"bios31.map","Forest"},
		{"bios32.map","Swamp"},	
		{"bios41","Storm"},
		{"bios41a","Glacier"},
		{"bios42","Ties"},
		{"bios43","Darkness"},
		{"bios51","Heart"},
		{"bios51a","Stress"},
		{"bios52","Cold"},
		{"bios60","Fear"},
		{"bios71","Escape"},
		{"bios72","Beats"},
		{"bios81","Poison"},
		{"bios82","Choice"},
		{"bios83","Heat"},
		{"bios90","Chronos"},
		{"bios91","Light"},
	};
	foreach (var Tag in vars.missions2)
	{
		settings.Add(Tag.Key, true, Tag.Value, "Levels");
	};
}

start
{
	return ((settings[current.mapName]) && (current.isLoading != old.isLoading));
}

onReset
{
	vars.doneMaps.Clear();
}

split
{
    if ((settings[current.mapName])  && (current.mapName != old.mapName) && (!vars.doneMaps.Contains(current.mapName)))
	{
		vars.doneMaps.Add(current.mapName);
		return true;
	}
}

isLoading
{
	return current.isLoading;
}
