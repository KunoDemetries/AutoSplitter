state("sniperelite", "Steam")
{
	byte Load: 0x3A35A9;
	byte Start: 0x35DAD4;
	string8 CurMap: 0x418EED;
	string21 WarRecord: 0x418AA8;
	byte Briefing: 0x3B7299;
	int Cuts: 0x3ADB24;
	int MC: 0x3AE2E0;
	float Framerate: 0x368390;
}

state("sniperelite", "GOG")
{
	byte Load: 0x320D25;
	byte Start: 0x2DB89C;
	string8 CurMap: 0x380CE5;
	string21 WarRecord: 0x394D28;
	byte Briefing: 0x333F91;
	int Cuts: 0x35EC4C;
	int MC: 0x32B040;
	float Framerate: 0x2E60D0;
}

init
{
    //print(modules.First().ModuleMemorySize.ToString());
	switch(modules.First().ModuleMemorySize)
    {
		case 4341760:
			version = "Steam";
			break;
		case 3805184:
			version = "GOG";
			break;
    }
	vars.doneMaps = new List<string>();
}

startup
{
	settings.Add("ils", false, "Individual Levels");
	settings.SetToolTip("ils", "Enables splits for ILs. Please uncheck Any% for asl to work properly.");
	settings.Add("missions", true, "Any%");
	settings.SetToolTip("missions", "Enables splits for Full Game. Please uncheck Individual Levels for asl to work properly.");

	refreshRate = 60;
	
	vars.WarRec = 0;
	vars.missions = new Dictionary<string,string> 
		{ 
    	    {"level01a", "(Karlshorst) Meet the Informant"},
			{"level02b", "(Assassinate Bormann) Supply Raid"},
			{"level02d", "The Reichstag"},
			{"level02e", "Brandenburg Gate"},
			{"level03a", "(Extract the Agent) Missing Contact"},
			{"level03b", "Meet the Courier"},
			{"level03c", "Infiltrate the Square"},
			{"level03d", "The French Cathedral"},
			{"level03e", "Exfiltrate the Square"},
			{"level01b", "(Karlshorst Reprise) Destroy Fuel Dump"},
			{"level04a", "(The Scientists) Secure U-Bahn Station"},
			{"level04b", "Prevent Reinforcement"},
			{"level04c", "Anhalter Station"},
			{"level05a", "(Raid on Nordsig) Via the U-Bahn"},
			{"level05b", "Approach to Nordsig"},
			{"level05c", "Eliminate Guardpost"},
			{"level05d", "Nordsig HW Plant"},
			{"level05e", "Assist OSS Team"},
			{"level05f", "Exfiltrate Nordsig"},
			{"level06a", "(Recover the V2 tech) Cut Communications"},
			{"level06b", "Destroy Ammo Dump"},
			{"level06c", "Disable Katyushas"},
			{"level06d", "Holzmarkt Train Yard"},
			{"level06e", "The Schloss"},
			{"level08a", "(Escape from Berlin) Extract the Pilot"},
			{"level08b", "Journey to Tempelhof"},
			{"level08d", "Tempelhof Airport"},
		};
	foreach (var Tag in vars.missions)
	{
		settings.Add(Tag.Key, true, Tag.Value, "missions");
    };

    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {        
    	var timingMessage = MessageBox.Show
		(
        	"This game uses 'Load Removed Time' (Game Time) as the main timing method.\n"+
        	"LiveSplit is currently set to show 'Real Time Attack' (Real Time).\n"+
			"\n"+
        	"Would you like to set the timing method to LRT ?",
        	"LiveSplit | Sniper Elite",
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
	return current.Start == 5 && current.Cuts == 0 && old.Start == 2 ||
	current.CurMap == "level02a" && current.Start == 5 && old.Start == 255;
}

onStart
{
	vars.doneMaps.Add(current.CurMap);
}

split
{
	return current.CurMap != old.CurMap && settings[current.CurMap] && !vars.doneMaps.Contains(current.CurMap) ||
	settings["ils"] && current.Start == 5 && current.MC == 256 ||
	current.CurMap == "level02a" && current.Start == 5 && current.MC == 256 ||
	current.CurMap == "level08d" && old.Start == 5 && current.Start == 2;

	vars.doneMaps.Add(current.CurMap);
}

onReset
{		
	vars.doneMaps.Clear();
}

isLoading
{
	if(old.WarRecord == "\\frontend\\gamespy.dds" && current.WarRecord == "\\splash\\oldmenu1.dds")
	{
		vars.WarRec = 1;
	}
	else if(current.WarRecord == "\\splash\\loading\\level" && current.WarRecord != old.WarRecord)
	{
		vars.WarRec = 0;
	}

	return current.Load == 0 && current.Briefing != 1 && vars.WarRec != 1 && current.Framerate < 10000 ||
	current.Framerate > 10000;
}
