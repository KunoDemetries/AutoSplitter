state("CoDWaW") {
    string50 map : 0x5592B8; 
    int loading1 : 0x3075B14;
    int squares1 : 0x14ED874;
    int Seen : 0x14E742C;
}

startup {
	settings.Add("act0", true, "Missions");
		
	vars.missions = new Dictionary<string,string> { 
        	{"pel1", "Little Resistance"}, 
       		{"pel2", "Hard Landing"},
       		{"sniper", "Vendetta"},
       		{"see1", "Their Land, Their Blood"},
		{"pel1a", "Burn 'em Out"},
       		{"pel1b", "Relentless"},
       		{"see2", "Blood and Iron"},
       		{"ber1", "Ring of Steel"},
        	{"ber2", "Eviction"},
       		{"pby_fly", "Black Cats"},
       		{"oki2", "Blowtorch & Corkscrew"},
       		{"oki3","Breaking Point"},
       		{"ber3","Heart of the Reich"},
       		{"ber3b","Downfall"},
	};
    	foreach (var Tag in vars.missions) {
       	settings.Add(Tag.Key, true, Tag.Value, "act0");
    }
}

init 
{
	vars.doneMaps = new List<string>(); 
}

start
{
    if ((current.map == "mak") && (current.squares1 == 16384)) {
        vars.doneMaps.Clear();
        return true;
    }
}

isLoading
{
    return (current.loading1 == 0) ||
    ((current.map == "see1") && (current.Seen == 0));
}

reset {
	return (old.map != "ui" && current.map == "ui");
}

split
{
    if (current.map != old.map) {
	    if (settings[old.map]) {
	            vars.doneMaps.Add(old.map);
				return true;
				}
        }			
}
