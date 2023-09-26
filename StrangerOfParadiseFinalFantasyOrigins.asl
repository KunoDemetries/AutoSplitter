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

state("SOPFFO", "1.25 Epic")
{
    int Loader1 : 0x3F0F9E4; // 2F1A60
    string250 CurrentMapName : 0x048AD7B0, 0x20; //19360
    string250 CurrentCutsceneName : 0x048F1B28, 0x30, 0x50; 
}

state("SOPFFO", "1.26 Epic")
{
    int Loader1 : 0x3F139E4; // 2F1A60
    string250 CurrentMapName : 0x048B17D0, 0x20; //19360
    string250 CurrentCutsceneName : 0x048F5B48, 0x30, 0x50; 
}

state("SOPFFO", "1.32 Epic")
{
    int Loader1 : 0x3F149E4; // 2F1A60
    string250 CurrentMapName : 0x048B27B0, 0x20; //19360
    string250 CurrentCutsceneName : 0x048F6B28, 0x30, 0x50; //FE0
}

state("SOPFFO", "1.32 Steam")
{
    int Loader1 : 0x3F36974; // 21F90
    string650 CurrentMapName : 0x48D47B0, 0x20; //19360
    string250 CurrentCutsceneName : 0x04918B28, 0x30, 0x50; // steam dif is 22000
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
        case 83181568 :
            version = "1.25 Epic";
        break;
        case 83202048 :
            version = "1.32 Epic";
        break;
        case 83525632 : 
            version = "1.32 Steam";
        break; 
        default:        
            version = "";
        break;
    }

    //10 98 ? ? ? ? 00 00 d0 3e curmapname
    //40 2d ? ? ? ? 00 00 02 00 cutscenename
    //00 50 ? b2 ? f6 7f ? 00 f0 48 a3 loading
}

startup
{
    settings.Add("SOPFFO", true, "Stranger of Paradise: Final Fantasy Origins"); 

     var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    var sB = new List<Tuple<string, string, string>>
    {
        tB("SOPFFO", "1", "A Desperate Struggle"),
        tB("SOPFFO", "2", "Dawn"),
        tB("SOPFFO", "3", "Illusion at Journey's End"),
        tB("SOPFFO", "4", "In Memories"),
        tB("SOPFFO", "5", "Dawn of a New Journey"),
        tB("SOPFFO", "6", "The Journey Begins"),
        tB("SOPFFO", "7", "Audience with the Dark Elf"),
        tB("SOPFFO", "8", "Natrual Distortion"),
        tB("SOPFFO", "9", "A Familiar Place"),
        tB("SOPFFO", "10", "Memories of Wind"),
        tB("SOPFFO", "11", "Memories of Poison"),
        tB("SOPFFO", "12", "Memories of Fire"),
        tB("SOPFFO", "13", "Phantoms of the Past"),
        tB("SOPFFO", "14", "Memories of Earth"),
        tB("SOPFFO", "15", "To Remember"),
        tB("SOPFFO", "16", "Memories of Water"),
        tB("SOPFFO", "17", "The False Warriors"),
        tB("SOPFFO", "18", "Schemes of the Past"),
        tB("SOPFFO", "19", "Remembering Home"),
        tB("SOPFFO", "20", "The Suffering of Fools"),
        tB("SOPFFO", "21", "Strangers of Paradise"),
        tB("SOPFFO", "22", "Warriors of Calamity"),
    };
    foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);   


    vars.Splits = new Dictionary <string, string>
	    { 	
        //egs
        {"mission/CH01_MAIN01_BABIL/CH01_MAIN01_BABIL.bmud","1"},
        {"mission/CH01_MAIN01_STP/CH01_MAIN01_STP.bmud","2"},
        {"mission/CH01_MAIN02_CHAOS/CH01_MAIN02_CHAOS.bmud","3"},
        {"mission/CH01_MAIN03_CITY/CH01_MAIN03_CITY.bmud","4"},
        {"mission/CH01_MAIN03_NORTH/CH01_MAIN03_NORTH.bmud","5"},
        //{"mission/CH01_MAIN03_PURABOKA/CH01_MAIN03_PURABOKA.bmud",""},
        {"mission/CH01_MAIN03_SASTA/CH01_MAIN03_SASTA.bmud","6"},
        {"mission/CH02_MAIN01_PALAM/CH02_MAIN01_PALAM.bmud","7"},
        {"mission/CH02_MAIN01_SUN/CH02_MAIN01_SUN.bmud","8"},
        {"mission/CH02_MAIN02_CLYST/CH02_MAIN02_CLYST.bmud","9"},
        {"mission/CH02_MAIN02_BABIL/CH02_MAIN02_BABIL.bmud","10"},
        {"mission/CH03_MAIN01_EVIL/CH03_MAIN01_EVIL.bmud","11"},
        {"mission/CH03_MAIN01_FIRE/CH03_MAIN01_FIRE.bmud","12"},
        {"mission/CH03_MAIN02_GAGA/CH03_MAIN02_GAGA.bmud","13"},
        {"mission/CH03_MAIN02_RAITH/CH03_MAIN02_RAITH.bmud","14"},
        {"mission/CH03_MAIN03_RONKA/CH03_MAIN03_RONKA.bmud","15"},
        {"mission/CH03_MAIN03_MAKOU/CH03_MAIN03_MAKOU.bmud","16"},
        {"mission/CH04_MAIN01_CITY/CH04_MAIN01_CITY.bmud","17"},
        {"mission/CH04_MAIN02_DELK/CH04_MAIN02_DELK.bmud","18"},
        {"mission/CH04_MAIN03_CITA/CH04_MAIN03_CITA.bmud","19"},
        {"mission/CH04_MAIN04_FLOAT/CH04_MAIN04_FLOAT.bmud","20"},
        {"mission/CH04_MAIN05_CITY/CH04_MAIN05_CITY.bmud","21"},
        {"mission/CH04_MAIN06_CHAOS01/CH04_MAIN06_CHAOS01.bmud","22"},
        //steam
        {"FDC8F89403E781B0C6A6C41A1533BBC78182ED4E65CE436668F1C6D65DA95719", "1"},
        {"41068306BED1015EC127A1614BFA129E6E2C235B84C5A10D983CE954B6A6D814", "2"},
        {"682A162B48DF1FA94AFDEF3B71CE73CB5BF1DECDA6F70EC7C3A5BCAF350A9DC8", "3"},
        {"7A00A089F627165F7BB71A830E85A866AD02F4C3DDDABA820AFC0C949C3FB8C4", "4"},
        {"FCA50872522BF75ACAA621CEE606FC26A91967470C847529578364A340D98E62", "5"},
        {"19B4AFB88946668192A1DAE9AB14BF734182B36EFACADF81DE0221494CAD4094", "6"},
        {"E32550207AF1FDFF5F3AA44BD97D73249331752A7E2778DBCA83E58515B52D2A", "7"},
        {"AFDD36AEED76B1C5BC69B118DF919E7040C9FE3BF4D8A0D3C800033334233563", "8"},
        {"72855EFF2472FE3AD19ECEE02754C07E6D8D6B2ECC0DA11EB44B102D7198A873", "9"},
        {"B29967B0F8E6FC8DC37E6EE709887CCF94C3B7B8B169F8AF38AE1E6701F589B8", "10"},
        {"1A5D3E88CA45A2BF3647F5254B50EACC85A1DA7EE14DC43C59535A290288EEAA", "11"},
        {"01E3806C388305CC4EA8B684B0DC7361AA72910F0793135C3AB652712871101E", "12"},
        {"DBDD9FB6BBF61F7C8449BF697B936F2249619DEEE8F02B1DFC2DD375699A013E", "13"},
        {"439A1D2B7A7D1F4B07193A0B0454D4A7B154651DB8C1AA9B75D9618A42AAF03C", "14"},
        {"1B696D773862AA56E6CBB5D64F0DA53179BAF995FF91AF7B7E3957F35BAC2D3F", "15"},
        {"AFAD79AF1F32A0E898AE550CD6FAFBC149291F76EB46509A43C06EC5BA11D9D1", "16"},
        {"B0F4E7077DA089B5B343E72BF4C208F7E94FD6EC57E28954F5732A937841EAC1", "17"},
        {"016645D64DA88AA109FCA70D12956A443A2C2AA96566BE4D5FD81E09372B4E4F", "18"},
        {"E0CD3385873DBAC7BCCCB406349F40625B7537EE5251C94C64C4FB17AF24A49B", "19"},
        {"BC1B055AA99872B3DBC61291F5693AE23090ECB029C14E3BA2D9B7A533817031", "20"},
        {"DFD28D94810127F4012327D58B2818B24B885F79B85D4302EAA0DA144E2F2D67", "21"},
        {"31B1A9D12EDF302785641AD66D1CF9E14D7B3FED51B9DEAFD288E84FF470EA5B", "22"},
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

update
{
    print(current.CurrentMapName);
}

start
{
    return (settings[vars.Splits[current.CurrentMapName]] && (current.Loader1 != 1) && (old.Loader1 == 1));
}

split
{
    if (settings[vars.Splits[current.CurrentMapName]] && (current.CurrentMapName != old.CurrentMapName) && (!vars.doneMaps.Contains(current.CurrentMapName)) || (current.CurrentCutsceneName == "movie/EV04_33-EN.mp4"))
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
