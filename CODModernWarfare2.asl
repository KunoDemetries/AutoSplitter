	string131 map : 0x5DA560;
	int loading1 : 0x171338C;
	int boi : 0xC98A50;
	//int starter : 0xC6F280;
    }


startup 
{
    settings.Add("act1", true, "Act 1");
    settings.Add("act2", true, "Act 2");
    settings.Add("act3", true, "Act 3");

    vars.missions2 = new Dictionary<string,string> 
	{ 
		{"trainier", "S.S.D.D."}, 
		{"roadkill", "Team Player"},
		{"cliffhanger", "Cliffhanger"},
		{"airport", "No Russian"},
		{"favela", "Takedown"},
    };

 	foreach (var Tag in vars.missions2)
	{
		settings.Add(Tag.Key, true, Tag.Value, "act1");
    };

    vars.missions3 = new Dictionary<string,string> 
	{ 
		{"invasion", "Wolverines"},
		{"favela_escape", "The Hornets Nest"},
		{"arcadia", "Exodus"},
		{"oilrig", "The Only Easy Day Was Yesterday"},
		{"gulag", "The Gulag"},
		{"dcburning", "Of Their Own Accord"},
    };
 	
	foreach (var Tag in vars.missions3)
	{
		settings.Add(Tag.Key, true, Tag.Value, "act2");
    };
        
    vars.missions4 = new Dictionary<string,string> 
	{ 
		{"contingency", "Contingency"},
		{"dcemp", "Second Sun"}, 
		{"dc_whitehouse", "Whiskey Hotel"},
		{"estate", "Loose Ends"},
		{"boneyard", "The Enemy of My Enemy"},
		{"af_caves", "Just Like Old Times"},
		{"af_chase", "Endgame"},
		{"ending", "End"},
    };
        
 	foreach (var Tag in vars.missions4)
	{
		settings.Add(Tag.Key, true, Tag.Value, "act3");
    };
}

init
{
    vars.doneMaps = new List<string>(); 
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

    return ((current.boi == 1048576000) && (current.map == "ending"));
}   

start
{
	if ((current.map == "trainer") && (old.map == "ui") && (current.loading != 0)) 
	{
    	vars.doneMaps.Clear();
	vars.doneMaps.Add(current.map);
    	return true;
    }
}

 
 reset
{
    return ((current.map == "ui") && (old.map != "ui"));
}

isLoading
{
	return (current.loading1 == 0);
}
