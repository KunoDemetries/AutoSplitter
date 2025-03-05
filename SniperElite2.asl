state("SniperEliteV2", "1.13")
{
	byte Load : 0x67FC38;
	byte Splash : 0x653B40;
	byte Start : 0x689FE2;
	string38 CurMap : 0x685F31;
	byte Objective : 0x656F3C;
	byte BulletCam : 0x65B917;
	byte MC : 0x689FD2;
	byte isPaused : 0x68A2EA;
}

state("SniperEliteV2", "Skidrow 1.0")
{
	byte Load : 0x5E8C88;
	byte Splash : 0x5F39F8;
	byte Start : 0x629319;
	string38 CurMap : 0x625061;
	byte Objective : 0x624994;
	byte BulletCam : 0x5FB3F7;
	byte MC : 0x0;
	byte isPaused : 0x0;
}

state("SEV2_Remastered", "Remastered")
{
	byte Load : 0x774FE3;
	byte Splash : 0x74C670;
	byte Start : 0x799A77;
	string38 CurMap : 0x7CFC7D;
	byte Objective : 0x7CF568;
	byte BulletCam : 0x76DD17;
	byte MC : 0x799A63;
	byte isPaused : 0x79A038;
}

state("SniperEliteV2_D3D11_UWP_Retail_Submission", "Remastered - UWP")
{
	byte Load : 0xB31147;
	byte Splash : 0xA95184;
	byte Start : 0xB55BE7;
	string38 CurMap : 0xB8368D;
	byte Objective : 0xB82F68;
	byte BulletCam : 0xAB62DF;
	byte MC : 0x0;
	byte isPaused : 0x0;
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
	case 7737344 :
		version = "Skidrow 1.0";
			break;
	case 7733248 :
		version = "1.0 - Not supported";
		break;
	case 21979136 :
		version = "Remastered - UWP";
		break;
	}
	vars.doneMaps = new List<string>();
}

startup
{
	settings.Add("IL", false, "Individual Levels");
	settings.SetToolTip("IL", "Enable split for Individual Level.\n");
	settings.Add("missions", true, "Missions");
	settings.SetToolTip
	(
		"missions",
		"Enable splits for Full Game.\n"+
		"(Disable Individual Levels splitting !)"
	);
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
			"This game allows to use Load Removed Time (Game Time) \n"+
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
	return settings["missions"] && current.Start == 1 && current.Start != old.Start ||
	settings["IL"] && current.Splash == 1 && old.Splash == 0 && current.CurMap != "nu\\Options.gui" && current.isPaused == 0;
}

onStart
{
	vars.doneMaps.Add(current.CurMap);
}

split
{
	return current.CurMap != old.CurMap && old.CurMap != "nu\\Options.gui" && old.CurMap != "3D_FrontEnd\\3D_FrontEnd.ts" && settings[current.CurMap] && !vars.doneMaps.Contains(current.CurMap) ||
	current.CurMap == "BrandenburgGate\\M11_BrandenburgGate.pc" && current.Objective == 3 && current.BulletCam == 1 ||
	settings["IL"] && current.MC == 1;
	vars.doneMaps.Add(current.CurMap);
}

onReset
{
	vars.doneMaps.Clear();
}

isLoading
{
	return current.Load == 0 || current.Splash == 0;
}