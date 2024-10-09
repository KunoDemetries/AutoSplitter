state("SniperEliteV2")
{
	//int loading1: 0x6486C4;	
	string65 map: 0x685F31;
}

startup 
{
	settings.Add("missions", true, "Missions");

	vars.missions = new Dictionary<string,string> 
		{ 
			{"Street\\M02_Street.pc", "Schonberg Streets"}, 
			{"Facility\\M03_Facility.pc", "Mittelwerk Facility"},
			{"BodeMuseum\\M05_BodeMuseum.pc", "Kasier Friedrich Museum"},
			{"Bebelplatz\\M06_Bebelplatz.pc", "Opernplatz"},
			{"Church\\M07_Church.pc", "St Olibartus Church"},
			{"Flaktower\\M08_Flaktower.pc", "Tiergarten Flak Tower"},
			{"CommandPost\\M09_CommandPost.pc", "Karlshorst Command Post"},
			{"PotsdamerPlatz\\M10_PotsdamerPlatz.pc", "Kreuzberg HeadQuarters"},
			{"LaunchSite\\M10a_LaunchSite.pc", "Kopenick Launch Site"},
			{"BrandenburgGate\\M11_BrandenburgGate.pc", "Brandenburg Gate"},
		}; 
 		foreach (var Tag in vars.missions)
		{
			settings.Add(Tag.Key, true, Tag.Value, "missions");
    	};
}
 
start
{
	return ((current.map == "Tutorial\\M01_Tutorial.pc") && (old.map == "nu\\Options.gui"));
}

split 
{
    return (settings[(current.map)] && (current.map != old.map));
}

 reset
{
    return ((current.map == "nu\\Options.gui") && (old.map != "nu\\Options.gui"));
}

/*isLoading
{
	return (current.loading1 == 0);
} 
*/ 
