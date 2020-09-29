state("OpenSeason")
{
    int loading1 : 0x6880F0;
    string110 map : 0x6880EC;
}


startup {
	
	settings.Add("missions", true, "Missions");

	vars.missions = new Dictionary<string,string> 
	{  
		{"OS_TimberlineRide", "Timberline"}, 
		{"OS_TimberlinePuni", "Puni Mart Picnic"},
		{"OS_TheLedge", "Wake In The Wild"}, 
		{"OS_ForestSkunks", "Meet The Skunks"},
		{"OS_ElliotRosie", "Hoof It!"}, 
		{"OS_ForestLoggers", "Scare Bear"},
		{"OS_Mine", "Mine Shafted"}, 
		{"OS_Journey", "Hunted!"},
		{"OS_SnowballRide", "Snow Blitz"}, 
		{"OS_Marsh", "Crazy Quackers"},
		{"OS_ElliotDuckCall", "Fowl Duty"}, 
		{"OS_ElliotTurret1", "Duck And Cover"},
		{"OS_BeaverDam", "Beaver Damage"}, 
		{"OS_OuthouseRide", "Rocky River"},
		{"OS_ShawsCabin", "Shaw's Shack"}, 
		{"OS_DawnBattleTheLedge", "Start The Battle"},
		{"OS_ElliotTurretClanTree", "Protect The Clan's Tree"}, 
		{"OS_ElliotPropaneTank", "Tanks A Lot"},
		{"OS_DawnBattleTheMarsh", "Clear The Ducks"}, 
		{"OS_DawnBattleForest", "The Trouble With Trappers"}, 
		{"OS_ElliotTurretBeaver", "Toothy Torpedoes"}, 
		{"OS_ElliotChainsaw", "Chainsaw Cha Cha"}, 
		{"OS_DawnBattleBeaverDam", "Reilly's Rampage"}, 
		{"OS_FinalBattle", "Shaw Showdown"},
	}; 
 	foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
    };
 }

init
{
	vars.doneMaps = new List<string>(); 
}

start
{
    if ((current.map != "menu") && (current.map == "OS_Daisyfield"))
	{
		vars.doneMaps.Clear();
		return true;
	}
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
}

isLoading
{
	return ((current.loading1 == 0));
}

reset
{
    return ((current.map == "menu") && (old.map != current.map));
}
