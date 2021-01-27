state("SniperElite3")
{
	int loading1: 0x00628040, 0x0;	
	string40 map: 0xA37ECD;
}

startup 
{

	settings.Add("missions", true, "Missions");

	vars.missions = new Dictionary<string,string> 
		{ 
			{"Oasis\\M02_Oasis.pc", "Gaberoun"},
			{"Halfaya_Pass\\M03_Halfaya_Pass.pc", "Halfaya Pass"},
			{"Fort\\M04_Fort.pc", "Fort Rifugio"},
			{"Siwa\\M05_Siwa.pc", "Siwa Oasis"},
			{"Kasserine_Pass\\M06_Kasserine_Pass.pc", "Kasserine Pass"},
			{"Airfield\\M07_Airfield.pc", "Pont Du Fahs Airfield"},
			{"Ratte_Factory\\M08_Ratte_Factory.pc", "Ratte Factory"},
		}; 
 		foreach (var Tag in vars.missions)
		{
			settings.Add(Tag.Key, true, Tag.Value, "missions");
    	};
}
 
 start
{
	return ((current.map == "Siege_of_Tobruk\\M01_Siege_of_Tobruk.pc") && (current.loading1 == 1));
}

split 
{
    return ((settings[(current.map)]) && (current.map != old.map));
}

 
isLoading
{
	return (current.loading1 == 0);
}
