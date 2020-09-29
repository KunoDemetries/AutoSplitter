    string100 map : 0xDE83FA1;
    int loading1 :  0xEDD51C4;
    }

startup 
    {
        settings.Add("act1", true, "Act 1");
        settings.Add("act2", true, "Act 2");
        settings.Add("act3", true, "Act 3");

        vars.missions2 = new Dictionary<string,string> { 
        {"piccadilly","Piccadilly"},
        {"safehouse","embedded"},
        {"ouse_finale","Proxy War"},
        {"townhoused","Clean House"},
        {"marines","Hunting Party"},
        {"embassy","Embassy"},
        };

        vars.missions2A = new List<string>();
        foreach (var Tag in vars.missions2) {
        settings.Add(Tag.Key, true, Tag.Value, "act1");
        vars.missions2A.Add(Tag.Key); };

        vars.missions3 = new Dictionary<string,string> { 
		{"highway","Highway of Death"},
        {"hometown","Hometown"},
        {"tunnels","The Wolf's Den"},
        {"captive","Captive"},
        };
        vars.missions3A = new List<string>();
        foreach (var Tag in vars.missions3) {
        settings.Add(Tag.Key, true, Tag.Value, "act2");
        vars.missions3A.Add(Tag.Key); };
        
        vars.missions4 = new Dictionary<string,string> { 
        {"stpetersburg","Old Comrads"},
        {"estate","Going Dark"},
        {"lab","Into the Furnace"},
        };
        
        vars.missions4A = new List<string>();
        foreach (var Tag in vars.missions4) {
        settings.Add(Tag.Key, true, Tag.Value, "act3");
        vars.missions4A.Add(Tag.Key); };
    }

init
    {
    vars.doneMaps = new List<string>(); 
    }

split
    {
    string currentMap = current.map;

    if ((currentMap != old.map)) {
        if (!vars.doneMaps.Contains(current.map)) {
            if (settings[currentMap.Trim()]) {
                if (vars.missions2A.Contains(currentMap) ||
                vars.missions3A.Contains(currentMap) ||
                vars.missions4A.Contains(currentMap)) {
            vars.doneMaps.Add(current.map);
            return true;
            }
            else {
            return false;
            }
        }
        }
    }
    }   

start
    {
	if ((current.map == "proxywar") && (current.loading1 == 1118989) && ((old.loading1 != 1118989)))
    {
    vars.doneMaps.Clear();
	vars.doneMaps.Add(current.map);
    return true;
    }
    }

isLoading
   {
	    return ((current.loading1 == 1118988));
	}
