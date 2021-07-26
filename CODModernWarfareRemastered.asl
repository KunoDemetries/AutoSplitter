state("h1_sp64_ship")
{
	string4 decide: 0x6668D4C;
	string4 decide2: 0x781FAC;
}

state("h1_sp64_ship","default")
{
   int loading1 : 0x1226507C;
	string200 map : 0x443C652;
	string4 decide: 0x6668D4C;
	string4 decide2: 0x781FAC;
}

state("h1_sp64_ship","1.13")
{
	int loading1 : 0x1240049C;
	string200 map : 0x45FF434;
	string4 decide: 0x6668D4C;
	string4 decide2: 0x781FAC;
}

state("h1_sp64_ship","1.15")
{
	int loading1: 0x5005458;
	string200 map : 0x45FF196;
	string4 decide: 0x6668D4C;
	string4 decide2: 0x781FAC;
}

init
{
    if (current.decide == "1.15") 
	{
    version = "1.15";
    }

    if (current.decide2 == "1.13") 
	{
	version = "1.13";
    }

    if ((current.decide != "1.15") && (current.decide2 != "1.13")) 
	{
	version = "1.15";
    }

    vars.doneMaps = new List<string>(); 
	vars.coupOffset = false;
	vars.currentTime = new TimeSpan(0, 0, 0);
}

update 
{
	vars.currentTime = timer.CurrentTime.GameTime;	//keep the variable updated with the current time on the timer
}

startup 
{
    settings.Add("act0", true, "Prologue");
    settings.Add("act1", true, "Act 1");
    settings.Add("act2", true, "Act 2");
    settings.Add("act3", true, "Act 3");

    vars.missions1 = new Dictionary<string,string> 
	{ 
		{"cargoship", "Crew Expendable"}, 
		{"coup", "The Coup"},
    };
 	
	 foreach (var Tag in vars.missions1)
	{
		settings.Add(Tag.Key, true, Tag.Value, "act0");
    };

    vars.missions2 = new Dictionary<string,string> 
	{ 
		{"blackout", "blackout"},
		{"ts_armada", "Charlie Dont Surf"},
		{"ts_bog_a", "The Bog"},
		{"hunted", "Hunted"},
		{"ac130", "Death From Above"},
		{"ts_bog_b", "War Pig"},
		{"airlift", "Shock and Awe"},
		{"aftermath", "Aftermath"},
    };

 	foreach (var Tag in vars.missions2)
	{
		settings.Add(Tag.Key, true, Tag.Value, "act1");
    };

    vars.missions3 = new Dictionary<string,string> 
	{ 
		{"village_assault", "Safe House"},
		{"scoutsniper", "All Ghillied Up"}, 
		{"sniperescape", "One Shot, One Kill"},
		{"village_defend", "Heat"},
		{"ambush", "The Sins of the Father"},
		{"icbm", "Ultimatum"},
    };

 	foreach (var Tag in vars.missions3)
	{
		settings.Add(Tag.Key, true, Tag.Value, "act2");
    };
        
    vars.missions4 = new Dictionary<string,string> 
	{ 
		{"launchfacility_a", "All In"},
		{"launchfacility_b", "No Fighting in The War Room"},
		{"jeepride", "Game Over"},
	};  
        
 	foreach (var Tag in vars.missions4)
	{
		settings.Add(Tag.Key, true, Tag.Value, "act3");
    };
}

start
{
	if ((current.map == "killhouse") && (current.loading1 == 1)) 
	{
    	vars.doneMaps.Clear();
    	return true;
    }
}

split 
{
	if (current.map != old.map) 
	{
		if (current.map == "coup") 
		{
			vars.currentTime = timer.CurrentTime.GameTime;	
			vars.coupOffset = true;
			
			if (settings["coup"]) 
			{				
				vars.doneMaps.Add(old.map);		
				return true;
			}
		}
		else 
		{
			if (settings[current.map]) 
			{	
				vars.doneMaps.Add(old.map);
				return true;
			}
		}
		
	}
}   
 
reset
{
    return ((current.map == "ui") && (old.map != "ui"));
}

 isLoading
{
	return (current.loading1 == 0);

	if ((version == "default") && (current.loading1 == 0))
	{
		return true;
	}
}


gameTime {
	if (vars.coupOffset == true) 
	{					
		vars.coupOffset = false;				
		return vars.currentTime.Add(new TimeSpan (0, 4, 45));	
	}
}
