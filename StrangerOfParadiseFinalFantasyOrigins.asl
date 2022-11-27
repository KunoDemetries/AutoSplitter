//Thanks to Clara the Classy for finding the CurrentMapName's so I don't have to finish the game myself

state("SOPFFO", "1.02 Epic")//75980800
{
    int Loader1 : 0x3918FE4; // just testing out a better value  1 loading, 0 not
    string250 CurrentMapName : 0x04239E90, 0x20; //REG STRING
    string250 CurrentCutsceneName : 0x04276B58, 0x30, 0x50;  //UNICODE movie/
}

state("SOPFFO", "1.03 Epic")// 61,440
{
    int Loader1 : 0x3926FE4; //E000
    string250 CurrentMapName : 0x042483F0, 0x20; // E560
    string250 CurrentCutsceneName : 0x042850D8, 0x30, 0x50;  //E580, 3CCE8
}

state("SOPFFO", "1.04 Epic")//20,480
{
    int Loader1 : 0x392BFE4; //5000
    string250 CurrentMapName : 0x0424D460, 0x20; //135D0
    string250 CurrentCutsceneName : 0x0428A158, 0x30, 0x50;  //13600, 3CCF8
}
// I didn't forget to update the game, I'm just bad at telling what update we are on.
state("SOPFFO", "1.11 Epic")
{
    int Loader1 : 0x3AC0604; //194620
    string250 CurrentMapName : 0x04431C10, 0x20; // 1E47B0
    string250 CurrentCutsceneName : 0x0446FF28, 0x30, 0x50; // 1E5DD0. 1620
}

state("SOPFFO", "1.12 Epic")
{
    int Loader1 : 0x3AD9604; // 19000
    string250 CurrentMapName : 0x0444AF70, 0x20; //19360
    string250 CurrentCutsceneName : 0x04489288, 0x30, 0x50;  
}

state("SOPFFO", "1.23 Epic")
{
    int Loader1 : 0x3DCB064; // 2F1A60
    string250 CurrentMapName : 0x0474ECD0, 0x20; //19360
    string250 CurrentCutsceneName : 0x04791DC8, 0x30, 0x50;  
}

state("SOPFFO", "1.24 Epic")
{
    int Loader1 : 0x3DCC064; // 2F1A60
    string250 CurrentMapName : 0x0474FD00, 0x20; //19360
    string250 CurrentCutsceneName : 0x04792F18, 0x30, 0x50; 
}

init
{
    vars.doneMaps = new List<string>(); 

    switch (modules.First().ModuleMemorySize) 
    {
        case 75980800:
            version = "1.02 Epic";
        break;
        case 76042240:
            version = "1.03 Epic";
        break;
        case 76062720:
            version = "1.04 Epic";
        break;
        case 78143488: 
            version = "1.11 Epic";
        break;
        case 78368768:
            version = "1.12 Epic";
        break;
        case 81690624:
            version = "1.23 Epic";
        break;
        case 81694720: 
            version = "1.24 Epic";
        break;
        default:        
            version = "";
        break;
    }
}

startup
{
    settings.Add("SOPFFO", true, "Stranger of Paradise: Final Fantasy Origins"); 

    vars.missions2 = new Dictionary<string,string> 
	{ 	
        {"mission/CH01_MAIN01_BABIL/CH01_MAIN01_BABIL.bmud","A Desperate Struggle"},
        {"mission/CH01_MAIN01_STP/CH01_MAIN01_STP.bmud","Dawn"},
        {"mission/CH01_MAIN02_CHAOS/CH01_MAIN02_CHAOS.bmud","Illusion at Journey's End"},
        {"mission/CH01_MAIN03_CITY/CH01_MAIN03_CITY.bmud","In Memories"},
        {"mission/CH01_MAIN03_NORTH/CH01_MAIN03_NORTH.bmud","Dawn of a New Journey"},
        //{"mission/CH01_MAIN03_PURABOKA/CH01_MAIN03_PURABOKA.bmud",""},
        {"mission/CH01_MAIN03_SASTA/CH01_MAIN03_SASTA.bmud","The Journey Begins"},
        {"mission/CH02_MAIN01_PALAM/CH02_MAIN01_PALAM.bmud","Audience with the Dark Elf"},
        {"mission/CH02_MAIN01_SUN/CH02_MAIN01_SUN.bmud","Natrual Distortion"},
        {"mission/CH02_MAIN02_CLYST/CH02_MAIN02_CLYST.bmud","A Familiar Place"},
        {"mission/CH02_MAIN02_BABIL/CH02_MAIN02_BABIL.bmud","Memories of Wind"},
        {"mission/CH03_MAIN01_EVIL/CH03_MAIN01_EVIL.bmud","Memories of Poison"},
        {"mission/CH03_MAIN01_FIRE/CH03_MAIN01_FIRE.bmud","Memories of Fire"},
        {"mission/CH03_MAIN02_GAGA/CH03_MAIN02_GAGA.bmud","Phantoms of the Past"},
        {"mission/CH03_MAIN02_RAITH/CH03_MAIN02_RAITH.bmud","Memories of Earth"},
        {"mission/CH03_MAIN03_RONKA/CH03_MAIN03_RONKA.bmud","To Remember"},
        {"mission/CH03_MAIN03_MAKOU/CH03_MAIN03_MAKOU.bmud","Memories of Water"},
        {"mission/CH04_MAIN01_CITY/CH04_MAIN01_CITY.bmud","The False Warriors"},
        {"mission/CH04_MAIN02_DELK/CH04_MAIN02_DELK.bmud","Schemes of the Past"},
        {"mission/CH04_MAIN03_CITA/CH04_MAIN03_CITA.bmud","Remembering Home"},
        {"mission/CH04_MAIN04_FLOAT/CH04_MAIN04_FLOAT.bmud","The Suffering of Fools"},
        {"mission/CH04_MAIN05_CITY/CH04_MAIN05_CITY.bmud","Strangers of Paradise"},
        {"mission/CH04_MAIN06_CHAOS01/CH04_MAIN06_CHAOS01.bmud","Warriors of Calamity"},
    };
 	foreach (var Tag in vars.missions2)
	{
		settings.Add(Tag.Key, true, Tag.Value, "SOPFFO");
    };

	if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
    {        
    	var timingMessage = MessageBox.Show 
        (
           "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier",
            "LiveSplit | Stranger of Paradise: Final Fantasy Origins",
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
    return (settings[current.CurrentMapName] && (current.Loader1 != 1) && (old.Loader1 == 1));
}

split
{
    if ((settings[current.CurrentMapName]) && (current.CurrentMapName != old.CurrentMapName) && (!vars.doneMaps.Contains(current.CurrentMapName)) || (current.CurrentCutsceneName == "movie/EV04_33-EN.mp4"))
    {
        vars.doneMaps.Add(current.CurrentMapName);
        return true;
    }
}

isLoading
{
    return ((current.Loader1 == 1) || (current.CurrentCutsceneName != null));
}

onReset
{
    vars.doneMaps.Clear();
}
