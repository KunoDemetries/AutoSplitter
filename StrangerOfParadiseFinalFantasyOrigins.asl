//Thanks to Clara the Classy for finding the CurrentMapName's so I don't have to finish the game myself

state("SOPFFO", "1.02 Epic")
{
    int Loader : 0x4234128; // not loading 1065353216
    int Loader1 : 0x3918FE4; // just testing out a better value
    string250 CurrentMapName : 0x04239E90, 0x20; //REG STRING
    string250 CurrentCutsceneName: 0x04276B58, 0x30, 0x50;  //UNICODE
}

init
{
    vars.doneMaps = new List<string>(); 

    switch (modules.First().ModuleMemorySize) 
    {
        case 75980800:
            version = "1.02 Epic";
        break;
        default:        
            version = "";
        break;
    }
}

startup
{
    settings.Add("SOPFFO", true, "Stranger of Paradise Final Fantasy Origins"); 

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
}

start
{
    return (settings[current.CurrentMapName] && (current.Loader != 0) && (old.Loader == 0));
}

onStart
{

}

split
{
    if ((settings[current.CurrentMapName]) && (current.CurrentMapName != old.CurrentMapName) && (!vars.doneMaps.Contains(current.CurrentMapName)) || (current.CurrentCutsceneName == "movie/EV04_32.mp4"))
    {
        vars.doneMaps.Add(current.CurrentMapName);
        return true;
    }
}

isLoading
{
    return (current.Loader1 == 1);
}

onReset
{
    vars.doneMaps.Clear();
}