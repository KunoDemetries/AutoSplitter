state("GoW", "Epic 1.0.1") // Stating the game's .exe name, and the launcher and version number
{
    string100 CurrentObjective : 0x2232080; // Found by doing a string scan of the current objective playing (IS STATIC) Search any value in the startup than move the value backwards to add the realm name (super important it has to be done like this or the string will not read correctly in longer string names)
    int Loader : 0x2255648; // 257 during loads, 256 during cutscene loads, 0 during everything else (This value is somewhat hard if you don't have a NG+ save)
}

state("GoW", "Epic 1.0.2")
{
    string100 CurrentObjective : 0x2233080; 
    int Loader : 0x2256648;
}

state("GoW", "Epic 1.0.3")
{
    string100 CurrentObjective : 0x2234100;
    int Loader : 0x22576C8;
}

state("GoW", "Epic 1.0.4") // Also works for 1.0.5 on epic
{
    string100 CurrentObjective : 0x2236380;
    int Loader : 0x2259948;
}

state("GoW", "Epic 1.0.11") 
{
    string100 CurrentObjective : 0x22BB870;
    int Loader : 0x22DEE48;
}

state("GoW", "Epic 1.0.12")
{
    string100 CurrentObjective : 0x22C3C00;
    int Loader : 0x22E71D0;
}

state("GoW", "Steam 1.0.2")
{
    string100 CurrentObjective : 0x2235CE0;
    int Loader : 0x22592A8; 
}

state("GoW", "Steam 1.0.6.1")
{
    string100 CurrentObjective : 0x2238FE0;
    int Loader : 0x225C5B0; 
}

state("GoW", "Steam 1.0.8")
{
    string100 CurrentObjective : 0x2238060;
    int Loader : 0x225B630; 
}

state("GoW", "Steam 1.0.11")
{
    string100 CurrentObjective : 0x22BE460;
    int Loader : 0x22E1A28; 
}

state("GoW", "Steam 1.0.12")
{
    string100 CurrentObjective : 0x22C67E0;
    string40 COJ : 0x015B7070, 0x10, 0x1A8, 0x160, 0x160, 0x10;
    int Loader : 0x22E9DB0; 
}

init 

{
	vars.doneMaps = new List<string>(); //Used for not splitting twice just in cause the game crashes

    switch (modules.First().ModuleMemorySize) 
    {
        case    83886080: version = "Epic 1.0.1";
            break;
        case    84807680: version = "Epic 1.0.2"; 
            break;
        case    84811776: version = "Epic 1.0.3";
            break;
        case    84819968: version = "Epic 1.0.4";
            break;
        case    85364736: version = "Epic 1.0.11";
            break;
        case    85610496: version = "Epic 1.0.12";
            break;
        case    85020672: version = "Steam v1.0.2"; 
            break;
        case    85032960: version = "Steam 1.0.6.1";
            break;
        case    85028864: version = "Steam 1.0.8";
            break;
        case    85581824: version = "Steam 1.0.11";
            break;
        case    85839872: version = "Steam 1.0.12";
            break;
        default:        version = ""; 
            break;
    } 
    /* This will check the current module size for a game, generally they are different per update.
    you can find this by doing "print(modules.First().ModuleMemorySize.ToString());" inside of update through livesplit
    and use DebugViewer to see the value printed
    */

    vars.CurrentObjectiveParsed = "";
    vars.Parser = "";
    vars.Parser2 = "";
    vars.Splitter = false;
}

startup
{
    settings.Add("SES", false, "Split for non-English version?");
    settings.Add("SOC", false, "Split on completion of task?"); // Adding this as sometimes people like more customization of split location (superbly important for longer games)
    settings.Add("GoW", true, "God of War"); // used as the entire function head of the split settings
    settings.Add("TMT", true, "The Marked Trees", "GoW"); //Used to wrap all of the objectives to marked tree than to the GoW function
    settings.Add("PTTM", true, "Path to the Mountain", "GoW");
    settings.Add("ARB", true, "A Realm Beyond", "GoW");
    settings.Add("TLOA", true, "The Light of Alfheim", "GoW");
    settings.Add("ITM", true, "Inside the Mountain", "GoW");
    settings.Add("AND", true, "A New Destination", "GoW");
    settings.Add("TMC", true, "The Magic Chisel", "GoW");
    settings.Add("BTL", true, "Behind the Lock", "GoW");
    settings.Add("TS", true, "The Sickness", "GoW");
    settings.Add("TBlR", true, "The Black Rune", "GoW");
    settings.Add("RTTS", true, "Return to the Summit", "GoW");
    settings.Add("EFH", true, "Escape from Helheim", "GoW");
    settings.Add("APTJ", true, "A Path to Jotunheim", "GoW");
    settings.Add("BTR", true, "Between the Realms", "GoW");
    settings.Add("JIR", true, "Jotunheim in Reach", "GoW");
    settings.Add("MA", true, "Mother's Ashes", "GoW");
    settings.Add("TJH", true, "The Journey Home", "GoW");

    var tB = (Func<string, string, string, Tuple<string, string, string>>) ((elmt1, elmt2, elmt3) => { return Tuple.Create(elmt1, elmt2, elmt3); });
    var sB = new List<Tuple<string, string, string>>
    {
        tB("TMT", "1", "Hunt with Atreus"),
        tB("TMT", "2", "Defeat Dauði Kaupmaðr"),
        tB("TMT", "3", "Return to the house"),
        tB("TMT", "4", "Defeat the Stranger"),
        tB("PTTM", "5", "Journey to the Mountain"),
        tB("PTTM", "6", "Continue towards the mountain"),
        tB("PTTM", "7", "Escape the ruins"),
        tB("PTTM", "8", "Fight off the Reavers"),
        tB("PTTM", "9", "Throw your axe at the trees"),
        tB("PTTM", "10", "Proceed through the gate to the mountain"),
        tB("PTTM", "11", "Hunt with Atreus (again)"),
        tB("PTTM", "12", "Follow the Witch"),
        tB("PTTM", "13", "Collect the white-petaled flower"),
        tB("PTTM", "14", "Get to the boat"),
        tB("PTTM", "15", "Boat towards daylight"),
        tB("PTTM", "16", "Dock at the bridge"),
        tB("PTTM", "17", "Investigate the temple and bridge"),
        tB("PTTM", "18", "Make your way to the Tower"),
        tB("PTTM", "20", "Pass through the tower and caves"),
        tB("PTTM", "21", "Continue towards the mountain (Foothills)"),
        tB("ARB", "22", "Follow the Witch (Foothills)"),
        tB("TLOA", "23", "Find a way to the Light"),
        tB("TLOA", "24", "Get to the Ringed Temple"),
        tB("TLOA", "25", "Find a way into the temple"),
        tB("TLOA", "26", "Reactivate the Ringed Temple bridge"),
        tB("TLOA", "27", "Go back up to the Ringed Temple bridge"),
        tB("TLOA", "28", "Find another way into the temple"),
        tB("TLOA", "29", "Find a way into the hive"),
        tB("TLOA", "30", "Investigate the hive"),
        tB("TLOA", "31", "Destroy the hive and claim the Light"),
        tB("TLOA", "32", "Find a way out of the temple"),
        tB("TLOA", "33", "Return to the boat"),
        tB("TLOA", "34", "Use the sand bowl lift"),
        tB("TLOA", "35", "Return to Týr’s Temple"),
        tB("TLOA", "36", "Realm travel back to Midgard"),
        tB("TLOA", "37", "Return to the Mountain"),
        tB("TLOA", "38", "Go back through the tower"),
        tB("ITM", "40", "Ascend the mountain"),//
        tB("ITM", "41", "Traverse the dark caves"),
        tB("ITM", "42", "Ascend the Cave Shaft"),
        tB("ITM", "43", "Free the chain"),
        tB("ITM", "44", "Find a way to ascend"),
        tB("ITM", "45", "Reach the summit"),
        tB("AND", "46", "Take Mimir’s head to the Witch"),
        tB("AND", "47", "Return to the Witch’s Cave"),
        tB("AND", "48", "Talk to the Witch in her house"),
        tB("AND", "49", "Return to the boat"),
        tB("AND", "50", "Go to the Serpent’s horn"),
        tB("TMC", "51", "Follow Mimir’s instructions to the chisel"),
        tB("TMC", "52", "Investigate the dead Giant"),
        tB("TMC", "53", "Retrieve a piece of the chisel"),
        tB("TMC", "54", "Find a way to break the ice"),
        tB("TMC", "55", "Talk to Sindri"),
        tB("TMC", "56", "Find a way to the hammer"),
        tB("TMC", "57", "Make your way up the hammer"),
        tB("TMC", "58", "Release the strap"),
        tB("TMC", "59", "Find a way to the hammer’s head"), // where I was last
        tB("TMC", "60", "Make your way to the chisel"),
        tB("BTL", "61", "Return to the boat"),
        tB("BTL", "62", "Return to the Lake of Nine"),
        tB("BTL", "63", "Go to Týr’s Vault"),
        tB("BTL", "64", "Ask Freya for help"),
        tB("TS", "65", "Use Freya’s boat to return home"),
        tB("TS", "66", "Return to the Realm Travel Room"),
        tB("TS", "67", "Realm travel to Helheim"),
        tB("TS", "68", "Reach the Bridge Keeper"),
        tB("TS", "70", "Defeat the Bridge Keeper"),
        tB("TS", "71", "Return to the Realm Travel Room"),
        tB("TS", "72", "Deliver the heart to Freya"),
        tB("TBlR", "73", "Enter the boat"),
        tB("TBlR", "74", "Return to Týr’s Vault"),
        tB("TBlR", "75", "Retrieve the Black Rune"),
        tB("TBlR", "76", "Deactivate the Vault’s defenses"),
        tB("TBlR", "77", "Escape the trap"),
        tB("TBlR", "78", "Exit Týr’s Vault"),
        tB("RTTS", "79", "Journey back to the mountain"),
        tB("RTTS", "80", "Find a new path up to the summit"),
        tB("RTTS", "81", "Continue towards the summit"),
        tB("RTTS", "83", "Open the bridge to Jötunheim"),
        tB("RTTS", "84", "Catch Baldur"),
        tB("EFH", "85", "Find a way out of Helheim"),
        tB("EFH", "86", "Use the ship"),
        tB("EFH", "87", "Escape Helheim"),
        tB("APTJ", "88", "Realm travel back to Midgard"),
        tB("APTJ", "89", "Show Týr’s key plans to Brok"),
        tB("APTJ", "90", "Locate Týr’s mysterious door"),
        tB("APTJ", "91", "Explore Týr’s hidden chamber"),
        tB("APTJ", "92", "Break the chains"),
        tB("APTJ", "93", "Go back up and flip the temple"),
        tB("BTR", "94", "Explore the Realm Between Realms"),
        tB("BTR", "95", "Take the Unity Stone to the precipice"),
        tB("BTR", "96", "Investigate the Jötunheim tower"),
        tB("BTR", "97", "Survive the gauntlet of realms"),
        tB("JIR", "98", "Talk to Brok and Sindri"),
        tB("JIR", "99", "Return to the Serpent’s horn in Midgard"),
        tB("JIR", "100", "Boat into the Serpent’s mouth"),
        tB("JIR", "101", "Find Mimir’s eye"),
        tB("JIR", "102", "Defeat Baldur"),
        tB("MA", "103", "Return to the Realm Travel Room"),
        tB("MA", "104", "Find Jötunheim’s highest peak"),
        tB("MA", "105", "Scatter her ashes"),
    };
    foreach (var s in sB) settings.Add(s.Item2, true, s.Item3, s.Item1);   

    vars.Splits = new Dictionary <string, string>
    {
        {"Midgard - Wildwoods - Hunt with Atreus", "1"},
        {"Midgard - Wildwoods - Defeat Dauði Kaupmaðr", "2"},
        {"Midgard - Wildwoods - Return to the house", "3"},
        {"Midgard - Wildwoods - Defeat the Stranger", "4"},
        {"Midgard - Wildwoods - Journey to the Mountain", "5"},
        {"Midgard - The River Pass - Continue towards the mountain", "6"},
        {"Midgard - The River Pass - Escape the ruins", "7"},
        {"Midgard - The River Pass - Fight off the Reavers", "8"},
        {"Midgard - The River Pass - Throw your axe at the trees", "9"},
        {"Midgard - The River Pass - Proceed through the gate to the mountain", "10"},
        {"Midgard - The River Pass - Hunt with Atreus", "11"},
        {"Midgard - Sanctuary Grove - Follow the Witch", "12"},
        {"Midgard - The River Pass - Collect the white-petaled flower", "13"},
        {"Midgard - The River Pass - Get to the boat", "14"},
        {"Midgard - Shores of Nine - Boat towards daylight", "15"},
        {"Midgard - Shores of Nine - Dock at the bridge", "16"},
        {"Midgard - Shores of Nine - Investigate the temple and bridge", "17"},
        {"Midgard - Brok’s Shop - Make your way to the Tower", "18"},
        {"Midgard - Shores of Nine - Pass through the tower and caves", "20"},
        {"Midgard - Foothills - Continue towards the mountain", "21"},
        {"Midgard - Foothills - Follow the Witch", "22"},
        {"Alfheim - Týr’s Bridge - Find a way to the Light", "23"},
        {"Alfheim - Lake of Light - Get to the Ringed Temple", "24"},
        {"Alfheim - Lake of Light - Find a way into the temple", "25"},
        {"Alfheim - Lake of Light - Reactivate the Ringed Temple bridge", "26"},
        {"Alfheim - Lake of Light - Go back up to the Ringed Temple bridge", "27"},
        {"Alfheim - Lake of Light - Find another way into the temple", "28"},
        {"Alfheim - Lake of Light - Find a way into the hive", "29"},
        {"Alfheim - The Dusk Veil - Investigate the hive", "30"},
        {"Alfheim - The Dusk Veil - Destroy the hive and claim the Light", "31"},
        {"Alfheim - Lake of Light - Find a way out of the temple", "32"},
        {"Alfheim - Lake of Light - Return to the boat", "33"},
        {"Alfheim - Lake of Light - Use the sand bowl lift", "34"},
        {"Alfheim - Lake of Light - Return to Týr’s Temple", "35"},
        {"Alfheim - Lake of Light - Realm travel back to Midgard", "36"},
        {"Midgard - Realm Travel Room - Return to the Mountain", "37"},
        {"Midgard - Shores of Nine - Go back through the tower", "38"},
        {"Midgard - Foothills - Ascend the mountain", "40"},
        {"Midgard - The Mountain - Traverse the dark caves", "41"},
        {"Midgard - The Mountain - Ascend the Cave Shaft", "42"},
        {"Midgard - The Mountain - Free the chain", "43"},
        {"Midgard - The Mountain - Find a way to ascend", "44"},
        {"Midgard - The Mountain - Reach the summit", "45"},
        {"Midgard - The Summit - Take Mimir’s head to the Witch", "46"},
        {"Midgard - Shores of Nine - Return to the Witch’s Cave", "47"},
        {"Midgard - The River Pass - Talk to the Witch in her house", "48"},
        {"Midgard - The River Pass - Return to the boat", "49"},
        {"Midgard - The River Pass - Go to the Serpent’s horn", "50"},
        {"Midgard - Shores of Nine - Follow Mimir’s instructions to the chisel", "51"},
        {"Midgard - Northern Dock - Investigate the dead Giant", "52"},
        {"Midgard - Thamur’s Corpse - Retrieve a piece of the chisel", "53"},
        {"Midgard - Thamur’s Corpse - Find a way to break the ice", "54"},
        {"Midgard - Thamur’s Corpse - Talk to Sindri", "55"},
        {"Midgard - Thamur’s Corpse - Find a way to the hammer", "56"},
        {"Midgard - Thamur’s Corpse - Make your way up the hammer", "57"},
        {"Midgard - Thamur’s Corpse - Release the strap", "58"},
        {"Midgard - The Hammer Head - Find a way to the hammer’s head", "59"},
        {"Midgard - Thamur’s Corpse - Make your way to the chisel", "60"},
        {"Midgard - The Giant’s Chisel - Return to the boat", "61"},
        {"Midgard - Northern Dock - Return to the Lake of Nine", "62"},
        {"Midgard - Shores of Nine - Go to Týr’s Vault", "63"},
        {"Midgard - Týr’s Vault - Ask Freya for help", "64"},
        {"Midgard - The River Pass - Use Freya’s boat to return home", "65"},
        {"Midgard - Wildwoods - Return to the Realm Travel Room", "66"},
        {"Midgard - Brok’s Shop - Realm travel to Helheim", "67"},
        {"Helheim - Realm Travel Room - Reach the Bridge Keeper", "68"},//
        {"Helheim - Bridge Of The Damned - Defeat the Bridge Keeper", "70"},
        {"Helheim - Bridge Of The Damned - Return to the Realm Travel Room", "71"},
        {"Midgard - Realm Travel Room - Deliver the heart to Freya", "72"},
        {"Midgard - The River Pass - Enter the boat", "73"},
        {"Midgard - Shores of Nine - Return to Týr’s Vault", "74"},
        {"Midgard - Týr’s Vault - Retrieve the Black Rune", "75"},
        {"Midgard - Týr’s Vault - Deactivate the Vault’s defenses", "76"},
        {"Midgard - Týr’s Vault - Escape the trap", "77"},
        {"Midgard - Týr’s Vault - Exit Týr’s Vault", "78"},
        {"Midgard - Shores of Nine - Journey back to the mountain", "79"},
        {"Midgard - The Mountain - Find a new path up to the summit", "80"},
        {"Midgard - The Mountain - Continue towards the summit", "81"},
        {"Midgard - The Summit - Open the bridge to Jötunheim", "83"},
        {"Midgard - The Summit - Catch Baldur", "84"},
        {"Helheim - Helheim Landing - Find a way out of Helheim", "85"},
        {"Helheim - Helheim Landing - Use the ship", "86"},
        {"Helheim - Helheim Landing - Escape Helheim", "87"},
        {"Helheim - Secret Chamber of Odin - Realm travel back to Midgard", "88"},
        {"Midgard - Realm Travel Room - Show Týr’s key plans to Brok", "89"},
        {"Midgard - Brok’s Shop - Locate Týr’s mysterious door", "90"},
        {"Midgard - The Hall of Týr - Explore Týr’s hidden chamber", "91"},//
        {"Midgard - The Hall of Týr - Break the chains", "92"},
        {"Midgard - The Hall of Týr - Go back up and flip the temple", "93"},
        {"Midgard - Realm Travel Room - Explore the Realm Between Realms", "94"},
        {"Midgard - Realm Travel Room - Take the Unity Stone to the precipice", "95"},
        {"Midgard - Jötunheim Tower - Investigate the Jötunheim tower", "96"},
        {"Midgard - Jötunheim Tower - Survive the gauntlet of realms", "97"},
        {"Midgard - Realm Travel Room - Talk to Brok and Sindri", "98"},
        {"Midgard - Shores of Nine - Return to the Serpent’s horn in Midgard", "99"},
        {"Midgard - Shores of Nine - Boat into the Serpent’s mouth", "100"},
        {"Midgard - Belly of the Beast - Find Mimir’s eye", "101"},
        {"Midgard - Thamur’s Corpse - Defeat Baldur", "102"},
        {"Midgard - Thamur’s Corpse - Return to the Realm Travel Room", "103"},
        {"Jötunheim - Find Jötunheim’s highest peak", "104"},
        {"Jötunheim - Scatter her ashes", "105"},
        {"Midgard - Bosque Selvagem - Cace com Atreus","1"},
        {"Midgard - Bosque Selvagem - Derrote o Troll","2"},
        {"Midgard - Bosque Selvagem - Volte para casa","3"},
        {"Midgard - Bosque Selvagem - Derrote o Estranho","4"},
        {"Midgard - Bosque Selvagem - Jornada até a Montanha","5"},
        {"Midgard - Vale do Rio - Continue em direção à montanha","6"},
        {"Midgard - Vale do Rio - Fuja das ruínas","7"},
        {"Midgard - Vale do Rio - Enfrente os Salteadores","8"},
        {"Midgard - Vale do Rio - Jogue seu machado nas árvores","9"},
        {"Midgard - Vale do Rio - Prossiga até a montanha","10"},
        {"Midgard - Vale do Rio - Cace com Atreus","11"},
        {"Midgard - Bosque do Santuário - Siga a Bruxa","12"},
        {"Midgard - Vale do Rio - Colha a flor de pétalas brancas","13"},
        {"Midgard - Vale do Rio - Entre no barco","14"},
        {"Midgard - Costa dos Nove - Siga em direção à luz do dia","15"},
        {"Midgard - Costa dos Nove - Atraque na ponte","16"},
        {"Midgard - Costa dos Nove - Investigue o templo e a ponte","17"},
        {"Midgard - Loja do Brok - Vá até a Torre","18"},
        {"Midgard - Costa dos Nove - Passe pela torre e pelas cavernas","20"},
        {"Midgard - Contrafortes - Continue em direção à montanha","21"},
        {"Midgard - Contrafortes - Siga a Bruxa","22"},
        {"Alfheim - Ponte de Týr - Encontre um caminho até a Luz","23"},
        {"Alfheim - Lago da Luz - Chegue ao Templo Anelado","24"},
        {"Alfheim - Lago da Luz - Encontre um jeito de entrar no templo","25"},
        {"Alfheim - Lago da Luz - Reative a ponte do Templo Anelado","26"},
        {"Alfheim - Lago da Luz - Volte para a ponte do Templo Anelado","27"},
        {"Alfheim - Lago da Luz - Encontre outro meio de entrar no Templo","28"},
        {"Alfheim - Lago da Luz - Encontre um meio de entrar na colmeia","29"},
        {"Alfheim - O Véu do Crepúsculo - Investigue a colmeia","30"},
        {"Alfheim - O Véu do Crepúsculo - Destrua a colmeia e obtenha a luz","31"},
        {"Alfheim - Lago da Luz - Encontre um meio de sair do templo","32"},
        {"Alfheim - Lago da Luz - Volte para o barco","33"},
        {"Alfheim - Lago da Luz - Use o elevador do vaso de areia","34"},
        {"Alfheim - Lago da Luz - Volte para o Templo de Týr","35"},
        {"Alfheim - Lago da Luz - Volte para o Reino de Midgard","36"},
        {"Midgard - Sala de Viagem entre Reinos - Volte para a Montanha","37"},
        {"Midgard - Loja do Brok - Volte pela torre","38"},
        {"Midgard - Contrafortes - Suba a montanha","40"},
        {"Midgard - A Montanha - Atravesse as cavernas escuras","41"},
        {"Midgard - A Montanha - Suba a Caverna Vertical","42"},
        {"Midgard - A Montanha - Solte a corrente","43"},
        {"Midgard - A Montanha - Encontre um jeito de subir","44"},
        {"Midgard - A Montanha - Chegue até o cume","45"},
        {"Midgard - O Cume - Leve a cabeça de Mimir para a Bruxa","46"},
        {"Midgard - Costa dos Nove - Volte para a caverna da bruxa","47"},
        {"Midgard - Vale do Rio - Fale com a bruxa na casa dela","48"},
        {"Midgard - Vale do Rio - Volte para o barco","49"},
        {"Midgard - Vale do Rio - Vá até a trompa da Serpente","50"},
        {"Midgard - Costa dos Nove - Siga as instruções de Mimir até o cinzel","51"},
        {"Midgard - Doca do Norte - Examine o Gigante morto","52"},
        {"Midgard - Corpo de Thamur - Obtenha um pedaço do cinzel","53"},
        {"Midgard - Corpo de Thamur - Encontre uma forma de destruir o gelo","54"},
        {"Midgard - Corpo de Thamur - Fale com Sindri","55"},
        {"Midgard - Corpo de Thamur - Dê um jeito de chegar até o martelo","56"},
        {"Midgard - Corpo de Thamur - Tente subir pelo martelo","57"},
        {"Midgard - Corpo de Thamur - Solte a alça","58"},
        {"Midgard - A Cabeça do Martelo - Dê um jeito de chegar à cabeça do martelo","59"},
        {"Midgard - Corpo de Thamur - Vá até o cinzel","60"},
        {"Midgard - O Cinzel do Gigante - Volte para o barco","61"},
        {"Midgard - O Reino Entre os Reinos - Volte para o Lago dos Nove","62"},
        {"Midgard - Loja do Brok - Vá até o Cofre de Týr","63"},
        {"Midgard - Cofre de Týr - Peça ajuda a Freya","64"},
        {"Midgard - Vale do Rio - Use o barco de Freya para voltar para casa","65"},
        {"Midgard - Bosque Selvagem - Volte para a Sala de Viagem de Týr","66"},
        {"Midgard - Loja do Brok - Viaje para o Reino de Helheim","67"},
        {"Helheim - Sala de Viagem entre Reinos - Encontre o Guardião da Ponte","68"},
        {"Helheim - Ponte dos Condenados - Derrote o Guardião da Ponte","70"},
        {"Helheim - Ponte dos Condenados - Volte para a Sala de Viagem de Týr","71"},
        {"Midgard - Sala de Viagem entre Reinos - Entregue o coração para Freya","71"},
        {"Midgard - Costa dos Nove - Volte para o Cofre de Týr","74"},
        {"Midgard - Cofre de Týr - Obtenha a Runa Negra","75"},
        {"Midgard - Cofre de Týr - Desative as defesas do Cofre","76"},
        {"Midgard - Cofre de Týr - Fuja da armadilha","77"},
        {"Midgard - Cofre de Týr - Saia do Cofre de Týr","78"},
        {"Midgard - A Montanha - Volte para a montanha","79"},
        {"Midgard - A Montanha - Encontre um novo caminho até o cume","80"},
        {"Midgard - A Montanha - Continue em direção ao cume","81"},
        {"Midgard - O Cume - Abra a ponte para Jötunheim","83"},
        {"Midgard - O Cume - Capture Baldur","84"},
        {"Helheim - Atracagem de Helheim - Encontre um meio de sair de Helheim","85"},
        {"Helheim - Atracagem de Helheim - Use o barco","86"},
        {"Helheim - Atracagem de Helheim - Fuja de Helheim","87"},
        {"Helheim - Câmara Secreta de Odin - Volte para o Reino de Midgard","88"},
        {"Midgard - Sala de Viagem entre Reinos - Mostre o projeto da chave para Brok","89"},
        {"Midgard - Loja do Brok - Encontre a porta misteriosa de Týr","90"},
        {"Midgard - O Salão de Týr - Explore a câmara oculta de Týr","91"},
        {"Midgard - O Salão de Týr - Destrua as correntes","92"},
        {"Midgard - O Salão de Týr - Volte e vire o templo","93"},
        {"Midgard - Sala de Viagem entre Reinos - Explore o Reino entre os Reinos","94"},
        {"Midgard - Sala de Viagem entre Reinos - Leve a Pedra da Unidade ao precipício","95"},
        {"Midgard - Torre de Jötunheim - Investigue a torre de Jötunheim","96"},
        {"Midgard - Torre de Jötunheim - Sobreviva ao suplício dos reinos","97"},
        {"Midgard - Sala de Viagem entre Reinos - Fale com Brok e Sindri","98"},
        {"Midgard - Costa dos Nove - Volte para a trompa da Serpente em Midgard","99"},
        {"Midgard - Costa dos Nove - Entre de barco na boca da Serpente","100"},
        {"Midgard - Barriga da Fera - Encontre o olho de Mimir","101"},
        {"Midgard - Corpo de Thamur - Derrote Baldur","102"},
        {"Midgard - Corpo de Thamur - Volte para a Sala de Viagem de Týr","103"},
        {"Jötunheim - Sala de Viagem entre Reinos - Encontre o pico mais alto de Jötunheim","104"},
        {"Jötunheim - Espalhe as cinzas dela","105"},
    };


    if (timer.CurrentTimingMethod == TimingMethod.RealTime) // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
    {        
    var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time? This will make verification easier.\n"+
            "ASL coded by KunoDemetries, if you need to get in contact with reach out to me on my twitter @kunoDemetries",
            "LiveSplit | God of War (2018)",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
}

split
{
    if (settings[vars.Splits[current.CurrentObjective]] && (!vars.doneMaps.Contains(current.CurrentObjective)))
    {
        vars.doneMaps.Add(current.CurrentObjective);
        return true;
    }
}

isLoading
{
    return (current.Loader != 0);
}

onReset
{
    vars.doneMaps.Clear();
}
