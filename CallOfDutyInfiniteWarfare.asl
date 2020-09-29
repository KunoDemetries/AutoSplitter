state("iw7_ship")
{
string100 map1 : 0x21E5F3C;
int loading1 : 0xB0596AC;

}

startup
{
	vars.missions = new Dictionary<string,string> 
	{ 
		{"europa", "Rising Threat"},
		{"phparade", "Black Sky: Parade"},
		{"phstreets", "Black Sky: Under Attack"},
		{"phspace", "Black Sky: Take to the Sky"},
		{"shipcrib_moon", "Retribution: Aftermath"},
		{"moon_port", "Operation Port Armor: Civilian Terminal"},
		{"moonjackal", "Operation Port Armor: Shipping Storage"},
		{"sa_moon", "Operation Port Armor: Boarding Party"},
		{"shipcrib_europa", "Retribution: Back in the Fight"},
		{"sa_assassination", "Operation Deep Execute"},
		{"shipcrib_titan", "Retribution: Doing What Needs to be Done"},
		{"titan", "Operation Burn Water: Refinery"},
		{"titanjackal", "Operation Burn Water: Fight or Flight"},
		{"shipcrib_rogue", "Retribution: Rescued"},
		{"rogue", "Operation Dark Quarry"},	
		{"shipcrib_prisoner", "Retribution: Cost of Victory"},
		{"prisoner", "Operation Black Flag: Prisoner Escort"},
		{"heist", "Operation Black Flag: Trap is Sprung"},
		{"heistspace", "Operation Blood Storm: Trojan House"},
		{"marscrash", "Operation Blood Storm: Crash Landing"},
		{"marscrib", "Operation Blood Storm: Regroup"},
		{"marsbase", "Operation Blood Storm: All or Nothing"},
		{"yard", "Operation Blood Storm: Assault the Shipyard"},
	}; 
	  	foreach (var Tag in vars.missions) 
		{
        settings.Add(Tag.Key, true, Tag.Value);
        }
}

init 
{
	vars.doneMaps = new List<string>(); 
}

split
{
  if (current.map1 != old.map1) 
  	{
	    if (settings[current.map1]) 
		{
	        vars.doneMaps.Add(old.map1);
			return true;
		}
	}
}

isLoading
{
	return (current.loading1 == 0);
}


// v-meter iw7_ship.exe+1FDF420
