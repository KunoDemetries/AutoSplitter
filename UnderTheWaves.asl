state("UnderTheWaves-Win64-Shipping")
{
    string100 CurSubtitles : "EOSSDK-Win64-Shipping.dll", 0x01552468, 0x68, 0x68, 0x100, 0x0, 0x108, 0x28, 0xE;
}

init
{
    vars.doneMaps = new List<string>(); 
    vars.CanStart = false;
    vars.EndList = new List<string>
    (){
        
        "... what...? [Gasp] ... Pearl? Pearl?",
        "Qu’est-ce que... ? [Cri étouffé] Pearl ?... Pearl ?",
        "Was ...? [Flüster] Pearl ...? Pearl? Pearl?",
        "Cosa...? [Sussulta] Pearl?... Pearl?",
        "¿Qué...? Ah... ¿Pearl...? ¿Pearl?",
        "什么……？[喘气]珀尔？……珀尔？",
        "怎麼……？［喘氣］珀爾？……珀爾？",
        "뭐...? [헉 하는 소리] 펄?... 펄?",
        "え…？[息をのむ]パール？… パールなのか？",
        "ما...؟ [لهاث] \"بيرل\"؟... \"بيرل\"؟",
        "Wat...? [hapt naar adem] Pearl...? Pearl?",
        "Co...? [Dyszy] Pearl? ... Pearl?",
        "O quê? [Arfada] Pearl? ... Pearl?",
        "Что...? [тяжело дышит] Перл?... Перл?",
        "¿Qué...? [Jadea] ¿Pearl?... ¿Pearl?",
        "Τι...; [Πνιχτά] Περλ;... Περλ;",
        "Mi...? [zihálás] Pearl?... Pearl?",
        "O que...? [Ofegante] Pearl?... Pearl?",
        "Co...? [Zalapání] Pearl...? Pearl?",
        "อะไรน่ะ...? [หอบ] เพิร์ล?... เพิร์ล?",
        "Ne... [Yutkunma] Pearl?.. Pearl?"
    };


    // Code stipet written by just_ero, derived from Micrologist's original codework on UE4 sigscanning
    Func<int, string, IntPtr> scan = (offset, pattern) => {
    var scn = new SignatureScanner(game, game.MainModule.BaseAddress, game.MainModule.ModuleMemorySize);
    var pttern = new SigScanTarget(offset, pattern);
    var ptr = scn.Scan(pttern);
    return ptr + 0x4 + game.ReadValue<int>(ptr);
    };

   // GameEngine and Loading are both generic scans found by Micrologist 

    vars.GameEngine = scan(0x3, "48 89 05 ?? ?? ?? ?? 48 85 c9 74 ?? e8 ?? ?? ?? ?? 48 8d 4d");
    vars.Loading = scan(0x5, "89 43 60 8B 05 ?? ?? ?? ??");
    vars.InteractionList = scan( 0x3, "48 8d 0d ?? ?? ?? ?? e8 ?? ?? ?? ?? 48 8b 05 ?? ?? ?? ?? 4c 89 24 d8 49 8b 8c 24");
    vars.Day = scan(0x3, "48 8d 0d ?? ?? ?? ?? e8 ?? ?? ?? ?? 83 fb ?? 72 ?? d1 eb 83 c3 ?? 8b c3 48 03 c0 49 0b c4");
    print(vars.GameEngine.ToString("X"));
    print(vars.Day.ToString("X"));

    vars.watchers = new MemoryWatcherList
    {
        //vars.engine
        new StringWatcher(new DeepPointer(vars.GameEngine, 0x8B0, 0x0), 150) { Name = "CurMap"},
        //vars.loading
        new MemoryWatcher<int>(new DeepPointer(vars.Loading)) {Name = "Loading"},
        //vars.interactivelist
        new MemoryWatcher<bool>(new DeepPointer(vars.InteractionList, 0x178, 0x4B8, 0x692)) {Name = "bCinematicHideHud"},

        //vars.day
        new MemoryWatcher<int>(new DeepPointer(vars.Day, 0x150, 0x30, 0x0, 0x20, 0x20, 0x20, 0x290)) {Name = "CurDay"},
    };
}

startup
{
    settings.Add("UTW", true, "Under The Waves");
    settings.Add("End", true, "End split?");

	vars.missions = new Dictionary<string,string> 
		{ 
			{"2", "Day 2"},
			{"3", "Day 3"},
			{"14", "Day 14"},
			{"15", "Day 15"},
			{"16", "Day 16"},
			{"17", "Day 17"},
		}; 
 		foreach (var Tag in vars.missions)
		{
			settings.Add(Tag.Key, true, Tag.Value, "UTW");
    	};
}

update
{
    vars.watchers.UpdateAll(game);
    //vars.gamengine
    current.CurMap = vars.watchers["CurMap"].Current;
    //print(vars.watchers["CurMap"].Current.ToString());
    old.CurMap = vars.watchers["CurMap"].Old;
    //vars.loading
    current.isLoading = vars.watchers["Loading"].Current;
    //vars.interactivelist
    current.bCinematicHideHud = vars.watchers["bCinematicHideHud"].Current;

    //vars.day
    current.CurDay = vars.watchers["CurDay"].Current.ToString();
    print(current.CurMap);
    if (old.CurMap.Contains("MainMenu"))
    {
        vars.CanStart = true;
       // print("True");
    }
}

start
{
    return ((vars.CanStart) && (!current.bCinematicHideHud) && (current.CurDay == "1"));
}

onStart
{
    vars.doneMaps.Add(current.CurDay);
    vars.CanStart = false;
}

split
{
    if (settings[current.CurDay] && (!vars.doneMaps.Contains(current.CurDay)) && (current.bCinematicHideHud) && (!current.CurMap.Contains("MainMenu")))
    {
        vars.doneMaps.Add(current.CurDay);
        return true;
    }

    if ((settings["End"]) && (current.CurMap.Contains("Boat_End") | (current.CurMap.Contains("Beach_End"))))
    {
        return true;
    }
}

isLoading
{
    return ((current.isLoading != 0));
}

reset
{

}

onReset
{
    vars.CanStart = false;
    vars.doneMaps.Clear();
}