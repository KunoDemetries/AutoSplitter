// Thanks Kuno for the help much <3
state("sniper5_dx12", "Steam 1.3")
{
	//string110 CurCutscene : 0x026FDE68, 0x20, 0x248, 0x0, 0x0;
	string110 CurCutscene : 0x02670900, 0x8, 0x248, 0x0, 0x0;
	string14 CurMap : 0x303C74E;
	int start : 0xE88080;	// main menu 6, in game 13, loading 3, second cutscene is 8, first 5. E8C3EC
}

state("sniper5_dx12", "Steam 1.2")
{
	string110 CurCutscene : 0x02663370, 0x38, 0x248, 0x0, 0x0;
	string14 CurMap : 0x302E3FE;
	int start : 0xE7E2FC;	// main menu 6, in game 13, loading 3, second cutscene is 8, first 5
}

state("sniper5_dx12", "Steam 1.1")
{
	string110 CurCutscene : 0x02637348, 0x8, 0x248, 0x0, 0x0;
	string14 CurMap : 0x2FFFB1E;
	int start : 0xE642FC;  // main menu 6, in game 12, loading 3, second cutscene is 8
}

state("sniper5_dx12", "Xbox Game Pass 1.0.0")
{
	string15 CurMap : 0x30866BE;
	int start : 0xEF9E9C; 
}

state("sniper5_dx12", "Xbox Game Pass 1.1")
{
	string110 CurCutscene : 0x026E7570, 0x8, 0x248, 0x0, 0x0;
	string15 CurMap : 0x30AAF8E;
	int start : 0xF0AC00; 
}

init
{
	switch(modules.First().ModuleMemorySize)
    {
	case 376324096 :
        	version = "Xbox Game Pass 1.0.0";
        	break;
	case 379846656 : 
		version = "Xbox Game Pass 1.1";
		break;
	case 414150656 :
        	version = "Steam 1.0.0";
        	break;
	case 416047104 :
        	version = "Steam 1.1";
        	break;
	case 417222656 :
		version = "Steam 1.2";
		break;
	case 406196224 :
		version = "Steam 1.3";
		break;
    }
	vars.doneMaps = new List<string>(); // You get kicked to the main menu, so adding this just in case
	timer.Run.Offset = TimeSpan.FromMilliseconds(-480);
}

startup
{
	var result = MessageBox.Show(timer.Form, // EAC Warning made by xZeKo :O
        "Please make sure Easy Anti-Cheat is disabled.\n"
        + "If you run the autosplit with Easy Anti-Cheat on, there is a possibility you could be banned.\n"
        + "\n \n Click Yes if Easy Anti-Cheat is disabled."
        + "\n \n Click No to find out how to disable Easy Anti-Cheat.",
        "Sniper Elite 5",
        MessageBoxButtons.YesNo,
        MessageBoxIcon.Information);
    if (result == DialogResult.No)
    {
        Process.Start("https://github.com/xZeko-SRC/SE5disableEAC/blob/main/README.md");
    }

		
	settings.Add("ils", true, "Individual Levels");
	settings.SetToolTip("ils", "Enable splits for ILs. Please uncheck Missions.");
	settings.Add("survival", false, "Survival");
	settings.SetToolTip("ils", "Enable splits for Survival. Please uncheck Missions and ILs.");
	settings.Add("missions", false, "Missions");
	settings.SetToolTip("missions", "Enable splits for Full Game. Please uncheck Individual Levels. \n Uncheck The Atlantic Wall or it will double split for Occupied Residence");

	vars.missions = new Dictionary<string,string> 
		{ 
		//Coast.asr level 1
			{"Coast.asr", "The Atlantic Wall"},
    	    {"Chateau.asr", "Occupied Residence"},
    	    {"Island.asr", "Spy Academy"},
    	    {"Factory.asr", "War Factory"},
    		{"Guernsey.asr", "Festung Guernesey"},
    	    {"Villages.asr", "Libération"},
    	    {"ResearchBase.a", "Secret Weapons"},
			{"StNazaire.asr", "Rubble And Ruin"},
			{"Chateau_Epilog", "Loose Ends"},
			{"DLC_KillHitler", "Wolf Mountain: DLC"},
			{"DLC01_Dragoon.", "Landing Force"},
		};
		foreach (var Tag in vars.missions)
		{
			settings.Add(Tag.Key, true, Tag.Value, "missions");
    	};

		vars.cutscenes = new List<string>
	{
		@"sounds\cutscenes\m01_coast\cs_m01_exfiltrate_sfx.wav",
		@"sounds\cutscenes\m02_chateau\cs_m02_exfiltrate_sfx.wav",
		@"sounds\cutscenes\m03_island\cs_m03_exfiltrate_sfx.wav",
		@"sounds\cutscenes\m03_island\cs_m03_exfiltrate_sfx.wav",
		@"sounds\cutscenes\m04_factory\cs_m04_exfiltrate_sfx.wav",
		@"sounds\cutscenes\m05_guernsey\cs_m05_exfiltrate_sfx.wav",
		@"sounds\cutscenes\m06_villages\cs_m06_exfiltrate_sfx.wav",
		@"sounds\cutscenes\m07_research_base\cs_m07_exfiltrate_sfx.wav",
		@"sounds\cutscenes\m08_st_nazaire\cs_m08_sub_pen_explosion_sfx.wav",
		@"sounds\cutscenes\m09_epilogue\cs_m09_mollerdead_sfx.wav",
		@"sounds\cutscenes\m10_killhitler\cs_m10_exf_sfx.wav",
		@"sounds\cutscenes\intros_outros\cs_dlc01_outro_sfx.wav"
	};

    if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
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
	return ((current.start == 13) && (settings[current.CurMap]) || (settings["ils"] && (current.start == 13)) || (settings["survival"] && (current.start == 13)));
}

onStart
{
	vars.doneMaps.Add(current.CurMap);
}

split
{
	if ((current.CurMap != old.CurMap) && (settings[current.CurMap]) && (!vars.doneMaps.Contains(current.CurMap)) || (vars.cutscenes.Contains(current.CurCutscene) && (old.CurCutscene == null) && (settings["ils"])) ||  (settings["survival"]) && (old.start == 13) && (current.start == 8))
	{
		vars.doneMaps.Add(current.CurMap);
		return true;		
	}
}

reset
{
	return (settings["ils"] && (current.start == 3));
}

onReset
{		
	vars.doneMaps.Clear();
}

isLoading
{
	return (settings["missions"] && current.start == 3);
}
