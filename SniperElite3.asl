state("SniperElite3", "Old")
{
	int loading1 : 0x00628040, 0x0;	
	string40 map : 0xA37ECD;
}

state("SniperElite3", "Current Version")
{
    int loading1 : 0x846AEC;
    string40 map : 0x792655;
}

init
{
    switch (modules.First().ModuleMemorySize)
	{
		case (9441280):
			version = "Current Version";
			break;
	}
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

    	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
        {        
        var timingMessage = MessageBox.Show (
               "This game uses Time without Loads (Game Time) as the main timing method.\n"+
                "LiveSplit is currently set to show Real Time (RTA).\n"+
                "Would you like to set the timing method to Game Time? This will make verification easier",
                "LiveSplit | Sniper Elite 3",
               MessageBoxButtons.YesNo,MessageBoxIcon.Question
            );
        
            if (timingMessage == DialogResult.Yes)
            {
                timer.CurrentTimingMethod = TimingMethod.GameTime;
            }
        }
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
