state("ScarletNexus-Win64-Shipping")
{
    byte Loader : 0x4A8C954; // Originally a byte
    int Chapter : 0x04FC56C0, 0x30, 0x2C0, 0x58, 0x410, 0x60, 0x398, 0x2BC;
    int Level : 0x04FC56C0, 0x30, 0x2C0, 0x58, 0x410, 0x60, 0x398, 0x2A0;
    int Section : 0x04FC56C0, 0x30, 0x2C0, 0x58, 0x410, 0x60, 0x398, 0x29C;
    byte Character : 0x04FC56C0, 0x30, 0x260, 0x9D8; // Used to see if we're playing Yuito or Kasane
}

init
{
    vars.FinalValueFemale = 0;
    vars.FinalValueMale = 0;
    vars.Name = "duck"; // IK this could not have anything in it, but I also like ducks so lol. I have to set the var to a string or it won't work because it can't convert a null to a string
    vars.doneMaps = new List<string>();
}

startup
{
    settings.Add("SN", true, "Scarlet Nexus");
    settings.Add("P0", true, "Phase 0 Prologue: Reuinion/Encounter", "SN");
    
    settings.Add("YR", true, "Yuito Route", "SN");
        settings.Add("MP1", true, "Phase 1 Prologue: Trusting the Future", "YR");
        settings.Add("MP2", true, "Phase 2 Prologue: Days of Disquieting Stagnation", "YR");
        settings.Add("MP3", true, "Phase 3 Prologue: Inside Upside Down Reality", "YR");
        settings.Add("MP4", true, "Phase 4 Prologue: Fate Split in Two", "YR");
        settings.Add("MP5", true, "Phase 5 Prologue: A Changed World and Creeping Unease", "YR");
        settings.Add("MP6", true, "Phase 6 Prologue: Choice to Face It, Eyes Open", "YR");
        settings.Add("MP7", true, "Phase 7 Prologue: Where Lost Memories Lead", "YR");
        settings.Add("MP8", true, "Phase 8 Prologue: Collecting Pieces of Unkown History", "YR");
        settings.Add("MP9", true, "Phase 9 Prologue: Eternal Vow, Eternal Bond", "YR");
        settings.Add("MP10", true, "Phase 10 Prologue: Conclusion and Accidental Meeting", "YR");
        settings.Add("MP11", true, "Phase 11 Prologue: Feeling Unraveled Time Together", "YR");
        settings.Add("MP12", true, "Phase 12 Prologue: Path to the Future and Freedom", "YR");

    settings.Add("KR", true, "Kasane Route", "SN");
        settings.Add("FP1", true, "Phase 1 Prologue: Searching for Freedom", "KR");
        settings.Add("FP2", true, "Phase 2 Prologue: Days of Disquieting Stagnation", "KR");
        settings.Add("FP3", true, "Phase 3 Prologue: Fated to Move Upon Awakening", "KR");
        settings.Add("FP4", true, "Phase 4 Prologue: What Waits at the End", "KR");
        settings.Add("FP5", true, "Phase 5 Prologue: The Point of No Return", "KR");
        settings.Add("FP6", true, "Phase 6 Prologue: Intertwining Thoughts and Confusion", "KR");
        settings.Add("FP7", true, "Phase 7 Prologue: Where Lost Memories Lead", "KR");
        settings.Add("FP8", true, "Phase 8 Prologue: They Speak of a Hidden Past", "KR");
        settings.Add("FP9", true, "Phase 9 Prologue: Protecting Lives and Protected Lives", "KR");
        settings.Add("FP10", true, "Phase 10 Prologue: Conclusion and Accidental Meeting", "KR");
        settings.Add("FP11", true, "Phase 11 Prologue: Feeling Unraveled Time Together", "KR");
        settings.Add("FP12", true, "Phase 12 Prologue: Path to the Future and Freedom", "KR");

    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    	var sB = new List<Tuple<string, string, string>> 
    {
        //tB("P0","102","Starting the Tutorial"),
        tB("P0","601","Finsihed tutorial and entiering Suoh City"), // Will only split once!
        tB("MP1","100601","Start of Phase 1"),
        tB("MP1","100702","Entering into Kikuchiba"),
        tB("MP1","100703","Upper level construction"),
        tB("MP1","100901","Entering into Mizuhagwa District"),
        tB("MP2","200602","Start of Phase 2"),
        tB("MP2","200101","OFS Training Course"),
        tB("MP2","200702","Ending of Training Course"),
        tB("MP2","200801","Entering Abandoned Subway: Suoh Line 9"),
        tB("MP2","200802","Entering Abandoned Line"),
        tB("MP2","200803","Entering Osukuni Station"),
        tB("MP3","300601","Start of Phase 3"),
        tB("MP3","301002","Start of Junction"),
        tB("MP3","301003","Start of Parking Lot"),
        tB("MP4","400601","Start of Phase 4"),
        tB("MP5","501401","Start of Phase 5"),
        tB("MP5","501301","Start of Old Ward"),
        tB("MP5","500702","Entering into Mid-Level Shopping district"),
        tB("MP6","600901","Start of Phase 6"),
        tB("MP6","601701","Entrance of Museum Ruins"),
        tB("MP6","601703","Entrance of Level 0 Experimental Devision"),
        tB("MP7","700601","Start of Phase 7"),
        tB("MP8","801901","Start of Phase 8"),
        tB("MP8","802001","Entrance of Church Entrance"),
        tB("MP9","900601","Start of Phase 9"),
        tB("MP9","900201","Entrance of Suoh OSF Chief's Office"),
        tB("MP9","901201","Entrance of Bridge of Beauty"),
        tB("MP9","901202","Entrance of Hallowed Ground"),
        tB("MP9","901203","Entrance of Worship Hall"),
        tB("MP10","1000703","Start of Phase 10"),
        tB("MP10","1001901","Entrance of Trailhead"),
        tB("MP10","1002101","Entrance of Babe Entrance"),
        tB("MP10","1002102","Entrance of Babe - Floor of Reason"),
        tB("MP10","1002103","Entrance of Babe - Floor of Emotion"),
        tB("MP10","1002104","Entrance of Babe - Floor of Instinct"),
        tB("MP10","1001003","Entrance of Parking Area"),
        tB("MP11","1101003","Start of Phase 11"),
        tB("MP12","1202201","Start of Phase 12"),
        tB("MP12","1202204","Entrance of Memories of Fighting"),
        tB("MP12","1202205","Entrance of Memories of Lodging"),
        tB("MP12","1202206","Entrance of The Forgotten Stage"),
        tB("MP12","1202207","Entrance of Memories of Pursuit"),
        tB("MP12","1202208","Entrance of Memories of Rebeillion"),
        tB("MP12","1202209","Entrance of Memories of Nightmare"),
        tB("MP12","1202211","Entrance of Memories of Impasse"),
        tB("MP12","1202202","Entrance of Millennium Hall"),
        tB("MP12","1202210","Entrance of Final Fight"),
        tB("FP1","1000601","Start of Phase 1"),
        tB("FP1","1000701","Entrance of Sub-Level Underground Facility"),
        tB("FP1","1000702","Entrance of Mid-Level Shopping Distric"),
        //tB("FP1","1000703","Entrance of Upper-Level Construction Site"),
        tB("FP2","2000601","Start of Phase 2"),
        tB("FP2","2000702","Entrance of Mid-Level Shopping Distric"),
        tB("FP2","2000801","Entrance of Hirasaka Station Entrance/Exit"),
        tB("FP2","2000802","Entrance of Inside Abandoned Line"),
        tB("FP2","2000803","Entrance of Osukuni Station"),
        tB("FP3","3000601","Start of Phase 3"),
        tB("FP3","3001001","Entrance of Suoh Exit"),
        tB("FP3","3001002","Entrance of Junction"),
        tB("FP3","3001003","Entrance of Parking Area"),
        tB("FP4","4005601","Start of Phase 4"),
        tB("FP5","5000601","Start of Phase 5"),
        tB("FP6","6001003","Start of Phase 6"),
        tB("FP6","6007003","Entrance of Level 0 Experimental Devision"),
        tB("FP6","6001501","Entrance of Town Center"),
        tB("FP6","6000702","Entering into Mid-Level Shopping district"),
        tB("FP7","7000902","Start of Phase 7"),
        tB("FP7","7001701","Entrance of Museum Ruins"),
        tB("FP7","7001703","Entrance of Level 0 Experimental Devision"),
        tB("FP8","8001901","Start of Phase 8"),
        tB("FP8","8002001","Entrance of Church Headquarters"),
        tB("FP9","9000902","Start of Phase 9"),
        tB("FP9","9001201","Entrance of Bridge of Beauty"),
        tB("FP9","9001202","Entrance of Hollowed Ground"),
        tB("FP9","9001203","Entrance of Worship Hall"),
        tB("FP10","10000703","Start of Phase 10"),
        tB("FP10","10001901","Entrance of Trailhead"), 
        tB("FP10","10002101","Entrance of Church Entrance"), 
        tB("FP10","10002102","Entrance of Floor of Reason"), 
        tB("FP10","10002103","Entrance of Floor of Emotion"), 
        tB("FP10","10002104","Entrance of Floor of Instinct"), 
        tB("FP10","10001003","Entrance of Parking Area"), 
        tB("FP10","10001304","Entrance of Old OSF Hospital (11 Years Ago)"), 
        tB("FP11","11001003","Start of Phase 11"), 
        tB("FP12","12002201","Start of Phase 12"), 
        tB("FP12","12002204","Entrance of Memories of Fighting"),
        tB("FP12","12002205","Entrance of Memories of Lodging"),
        tB("FP12","12002206","Entrance of The Forgotten Stage"),
        tB("FP12","12002207","Entrance of Memories of Pursuit"),
        tB("FP12","12002208","Entrance of Memories of Rebeillion"),
        tB("FP12","12002209","Entrance of Memories of Nightmare"),
        tB("FP12","12002211","Entrance of Memories of Impasse"),
        tB("FP12","12002202","Entrance of Millennium Hall"),
        tB("FP12","12002210","Entrance of Final Fight"), 
    };
    	foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);

    vars.onStart = (EventHandler)((s, e) => 
        {
            vars.doneMaps.Clear(); // Needed because checkpoints bad in game 
            vars.doneMaps.Add(vars.FinalValueMale.ToString());
        if (current.Character == 5)
        {
            vars.Name = "Yuito";
        }
        else
        {
            vars.Name = "Kasane";
        }
        });
    timer.OnStart += vars.onStart; 

        vars.onReset = (LiveSplit.Model.Input.EventHandlerT<LiveSplit.Model.TimerPhase>)((s, e) => 
        {
            vars.doneMaps.Clear(); // Needed because checkpoints bad in game 
        });
    timer.OnReset += vars.onReset; 
}

//[11828] Cannot implicitly convert type 'System.EventHandler' to 'LiveSplit.Model.Input.EventHandlerT<LiveSplit.Model.TimerPhase>'


update
{
    vars.FinalValueMale = ((current.Chapter*100000 + (current.Level*100) + current.Section));
    vars.FinalValueFemale = ((current.Chapter*1000000 + (current.Level*100) + current.Section));
    print(vars.FinalValueMale.ToString());
}

start
{
    if ((vars.FinalValueMale == 102) && (current.Loader == 5))
    {
        if (current.Character == 5)
        {
            vars.Name = "Yuito";
        }
        else
        {
            vars.Name = "Kasane";
        }
        return true;
    }
}

split
{
    if(vars.Name == "Yuito")
    {
        if((settings[vars.FinalValueMale.ToString()]) && (current.Loader != 20) && (!vars.doneMaps.Contains(vars.FinalValueMale.ToString())))
        {
            vars.doneMaps.Add(vars.FinalValueMale.ToString());
            return true;
        }
    }
    else
    {
        if((settings[vars.FinalValueFemale.ToString()]) && (current.Loader != 20) && (!vars.doneMaps.Contains(vars.FinalValueFemale.ToString())))
        {
            vars.doneMaps.Add(vars.FinalValueFemale.ToString());
            return true;
        }        
    }
}

isLoading
{
    return (current.Loader == 20);
}
