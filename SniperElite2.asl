state("SniperEliteV2", "1.13")
{
	byte Load : 0x67FC38;
	byte Splash : 0x653B40;
	byte Start : 0x689FE2;
	string38 CurMap : 0x685F31;
	byte Objective : 0x656F3C;
	byte BulletCam : 0x65B917; //Experimental
}

state("SEV2_Remastered", "Remastered")
{
	byte Load : 0x751D0D;
	byte Splash : 0x74C670;
	byte Start : 0x799A77;
	string38 CurMap : 0x7CFC7D;
	byte Objective : 0x7CF568;
	byte BulletCam : 0x76DD17; //Experimental
}

init
{
    //print(modules.First().ModuleMemorySize.ToString());
	switch(modules.First().ModuleMemorySize)
    {
	case 8146944 :
        	version = "1.13";
        	break;
	case 18169856 :
	        version = "Remastered";
			break;
    }
	vars.doneMaps = new List<string>();
}

startup
{
	settings.Add("missions", true, "Missions");
	settings.SetToolTip("missions", "Enable splits for Full Game. \n");
	vars.missions = new Dictionary<string,string> 
		{
            {"Tutorial\\M01_Tutorial.pc", "Prologue"},		
			{"Street\\M02_Street.pc", "Schonberg Streets"}, 
			{"Facility\\M03_Facility.pc", "Mittelwerk Facility"},
			{"BodeMuseum\\M05_BodeMuseum.pc", "Kasier Friedrich Museum"},
			{"Bebelplatz\\M06_Bebelplatz.pc", "Opernplatz"},
			{"Church\\M07_Church.pc", "St. Olibartus Church"},
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

    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {        
    	var timingMessage = MessageBox.Show
		(
        	"This game uses Time without Loads (Game Time) as the main timing method.\n"+
        	"LiveSplit is currently set to show Real Time (RTA).\n"+
        	"Would you like to set the timing method to Game Time? This will make verification easier",
        	"LiveSplit | Sniper Elite V2",
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
	return current.Start == 1;
}

onStart
{
	vars.doneMaps.Add(current.CurMap);
}

split
{
    if (current.CurMap != old.CurMap && old.CurMap != "nu\\Options.gui" && settings[current.CurMap] && !vars.doneMaps.Contains(current.CurMap) || current.CurMap == "BrandenburgGate\\M11_BrandenburgGate.pc" && current.Objective == 3 && current.BulletCam == 1)
	{
		vars.doneMaps.Add(current.CurMap);
		return true;		
	}
}

onReset
{		
	vars.doneMaps.Clear();
}

isLoading
{
	return current.Load == 0 || current.Splash == 0;
}