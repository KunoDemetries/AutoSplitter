state("jericho")
{
    string50 map : 0x3C4E8A;
    int loading1 : 0x3C1AFC;
}

startup
{
    settings.Add("l1",true,"Al-Khali");
    settings.Add("l2",true,"World War 2");
    settings.Add("l3",true,"The Crusades");
    settings.Add("l4",true,"Roman Provinces");
    settings.Add("l5",true,"Sumeria");

    vars.missions1 = new Dictionary<string,string> 
		{
    		{"alk_tomb.dds","The Tomb"},
    	   {"alk_bunker_00.dds","Operation Vigil"},
    	   {"alk_city.dds","Al Khali"},
    	   {"alk_bunker_01.dds","Green"},
    	   {"alk_final.dds","Man Down!"},
   		};  
    	foreach (var Tag in vars.missions1)
		{
			settings.Add(Tag.Key, true, Tag.Value, "l1");
    	};

    vars.missions2 = new Dictionary<string,string> 
		{
    	    {"wwii_pillboxes.dds","The Path of Souls"},
    	    {"wwii_mosque.dds","Blackwatch"},
    	    {"wwii_mosque_inside.dds","Ambush"},
    	    {"wwii_vigil.dds","The Flames of Anger"},
    	    {"wwii_vigil_inside.dds","Exorcism"},
    	    {"wwii_bradenburg.dds","Bradenburg Gate"},
    	};
 		foreach (var Tag in vars.missions2)
		{
			settings.Add(Tag.Key, true, Tag.Value, "l2");
    	};

    vars.missions3 = new Dictionary<string,string> 
		{
        	{"cru_labyrinh.dds","Motley Crew"},
        	{"cru_sewers.dds","Sewers"},
        	{"cru_keep.dds","Out of the Frying Pan..."},
        	{"cru_catacomb.dds","Tortured Souls"},
        	{"cru_chapel.dds","Black Rose"},
    	};
 		foreach (var Tag in vars.missions3)
		{
			settings.Add(Tag.Key, true, Tag.Value, "l3");
    	}; 

    vars.missions4 = new Dictionary<string,string> 
		{
    	    {"rom_caldrium.dds","The Low road"},
    	    {"rom_tepidarium.dds","Decadence"},
    	    {"rom_palace_01.dds","Temple of Pain"},
    	    {"rom_palace_02.dds","Gardens of Hell"},
    	    {"rom_coloseum.dds","Morituri te Salutant"},
    		{"rom_chamber.dds","Guts"},
    	};
 		foreach (var Tag in vars.missions4)
		{
			settings.Add(Tag.Key, true, Tag.Value, "l4");
    	};   

    vars.missions5 = new Dictionary<string,string> 
		{
        	{"sum_ziggurat_02.dds","spiritual Guide"},
        	{"sum_ziggurat_03.dds","Skin"},
        	{"sum_ziggurat_04.dds","Flesh"},
        	{"sum_ziggurat_meat.dds","Blood"},
        	{"sum_ziggurat_05.dds","Sacrifice"},
        	{"sum_end.dds","Pyxis Prima"},
    	};
 		foreach (var Tag in vars.missions5)
		{
			settings.Add(Tag.Key, true, Tag.Value, "l5");
    	};  
}

start
{
    if ((current.loading1 == 0) && (current.map != old.map)) 
	{
    	if ((current.map == "alk_desert.dds") ||
        	(current.map == "wwii_biggates.dds") ||
        	(current.map == "cru_river.dds") ||
        	(current.map == "rom_outskirts.dds") ||
        	(current.map == "sum_ziggurat_01.dds"))
        {
            return true;
        }
    }
}

split
{
	return ((current.map.ToLowerInvariant() != old.map.ToLowerInvariant()) && (settings[current.map.ToLowerInvariant()]));
}

isLoading
{
    return (current.loading1 == 0);
}

reset
{
    return (current.map == "Default.dds");
}
