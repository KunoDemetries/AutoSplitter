state("sniperelite", "Steam")
{
	byte Load : 0x357040;
	byte Start : 0x35DAD4;
	string8 CurMap : 0x418EED; //4049D9, 404995
	byte State : 0x3AD3FC;
	string12 WarRecord : 0x418AB0;
	int Reset : 0x3B84A0;
	int Cuts : 0x3ADB24;
	int MC : 0x3AE2E0;
}

state("sniperelite", "GOG / Retail")
{
	byte Load : 0x329B07;
	byte Start : 0x2DB89C;
	byte State : 0x32A18C;
	string12 WarRecord : 0x394D30;
	string8 CurMap : 0x380CE5; //380D29, 39514D
	int Reset : 0x3350A0;
	int Cuts : 0x35EC4C; //35EC4C, 32A8A8
	int MC : 0x32B040; // 256 completed 1 failed
}

init
{
	switch(modules.First().ModuleMemorySize)
    {
	case 4341760 :
        	version = "Steam";
        	break;
	case 3805184 : 
			version = "GOG / Retail";
			break;
   }

	vars.doneMaps = new List<string>(); // You get kicked to the main menu, so adding this just in case
}

startup
{	
	settings.Add("ils", true, "Individual Levels");
	settings.SetToolTip("ils", "Enable splits for ILs. Please uncheck Missions.");
	settings.Add("missions", false, "Missions");
	settings.SetToolTip("missions", "Enable splits for Full Game. Please uncheck Individual Levels. \n");

	vars.missions = new Dictionary<string,string> 
		{ 
    	    {"level01a", "(Karlshorst) Meet the Informant"},
			{"level02b", "Assassinate Bormann -- Supply Raid"},
			{"level02d", "The Reichstag"},
			{"level02e", "Brandenburg Gate"},
			{"level03a", "Extract the Agent -- Missing Contact"},
			{"level03b", "Meet the Courier"},
			{"level03c", "Infiltrate the Square"},
			{"level03d", "The French Cathedral"},
			{"level03e", "Exfiltrate the Square -- (Extract the Agent)"},
			{"level01b", "Karlshorst Reprise -- Destroy Fuel Dump"},
			{"level04a", "The Scientists -- Secure U-Bahn Station"},
			{"level04b", "Prevent Reinforcement"},
			{"level04c", "Anhalter Station"},
			{"level05a", "Raid on Nordsig -- Via the U-Bahn"},
			{"level05b", "Approach to Nordsig"},
			{"level05c", "Eliminate Guardpost"},
			{"level05d", "Nordsig HW Plant"},
			{"level05e", "Assist OSS Team"},
			{"level05f", "Exfiltrate Nordsig"},
			{"level06a", "Recover the V2 tech -- Cut Communications"},
			{"level06b", "Destroy Ammo Dump"},
			{"level06c", "Disable Katyushas"},
			{"level06d", "Holzmarkt Train Yard"},
			{"level06e", "The Schloss"},
			{"level08a", "Escape from Berlin -- Extract the Pilot"},
			{"level08b", "Journey to Tempelhof"},
			{"level08d", "Tempelhof Airport"},
			{"level02a", "The Safehouse - 100%"},

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
        	"LiveSplit | Sniper Elite 5",
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
	return (current.Start == 5 && (current.Cuts == 0) && old.Start == 2) || (current.CurMap == "level02a") && (current.Start == 5 && old.Start ==255);
}

onStart
{
	vars.doneMaps.Add(current.CurMap);
}

split
{
if ((current.CurMap != old.CurMap) && (settings[current.CurMap]) && (!vars.doneMaps.Contains(current.CurMap)) || (settings["ils"] && (current.Start == 5 && current.MC == 256)) || (current.CurMap == "level08d") && (current.Start == 5 && current.MC == 256) || (current.CurMap == "level02a") && (current.Start == 5 && current.MC == 256))
	{
		vars.doneMaps.Add(current.CurMap);
		return true;		
	}
}

reset
{
	return (settings["ils"] && (current.Reset == 0) && old.Reset == 1);
}

onReset
{		
	vars.doneMaps.Clear();
}

isLoading
{
	return current.Load == 0 || current.State == 8 && current.WarRecord != "oldmenu1.dds";
}
