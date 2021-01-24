// Splits once loading is done because can't do a logical check for which load screen is which without entering the level first sadly
// Easiest fix compared to trying to sort through hours of finding a code for the current map as it's usually locked cause UE4 bad
state("CallOfCthulhu")
{
	int loading1 : 0x0313B1D0, 0x8;
}

isLoading
{
	return (current.loading1 == 2); 
}

startup
{
	settings.Add("missions", true, "Missions");

	vars.missions = new Dictionary<string,string> 
    {  
		{"1","Chapter 2: Dark Water"},
		{"2","Chapter 3: Garden of the Hawkins mansion"},
		{"3","Chapter 4: Tunnels Under the Hawkins mansion"},
		{"4","Chapter 5: Riverside Institute"},
		{"5","Chapter 6: Hawkins mansion"},				
		{"6","Chapter 7: The Nameless Bookstore"},
		{"7","Chapter 8: Riverside Institute"},
		{"8","Chapter 9: Riverside Institute"},
		{"9","Chapter 10: Darkwater police station"},
		{"10","Chapter 11: Darkwater police station"},
		{"11","Chapter 12: Darkwater Port"},
		{"12","Chapter 13: Abandoned whaling station"},
		{"13","Chapter 14: Coastal Cave Alabaster Point"},
	};

	foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
    };
}

init
{
	vars.counter = 0;
	vars.oldcomparision = 0;
	vars.doneMaps = new List<string>();
}

update
{
	if ((current.loading1 != 2) && (old.loading1 == 2) && (vars.oldcomparision != current.loading1))
	{
		vars.counter++;
	}

}

start
{
	if ((current.loading1 != 2) && (old.loading1 == 2))
	{
		vars.doneMaps.Clear();
		vars.counter = 0;
		return true;			
	}
}

split
{
    string currentMap = (vars.counter.ToString());

	if ((settings[currentMap]) && (old.loading1 != current.loading1) && (!vars.doneMaps.Contains(currentMap)))
	{
		vars.oldcomparision = current.loading1;
		vars.doneMaps.Add(currentMap);				
		return true;		
	}
}
