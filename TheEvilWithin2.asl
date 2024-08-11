state("TEW2") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.GameName = "The Evil Within 2";
    
    settings.Add("chap", true, "All Chapters");
    settings.Add("end", true, "End Split");
    settings.SetToolTip("end", "The end split for when you finish chapter 17. The opposite of start!");

    vars.Chapters = new Dictionary<string,string> 
        {
            {"starter","Chapter 1 - Into the Flame"},
            {"2","Chapter 2 - Something Not Quite Right"},
            {"3","Chapter 3 - Resonances"},
            {"4","Chapter 4 - Behind the Curtain"},
            {"5","Chapter 5 - Lying in Wait"},
            {"6","Chapter 6 - On the Hunt"},
            {"7","Chapter 7 - Lust For Art"},
            {"8","Chapter 8 - Premiere"},
            {"9","Chapter 9 - Another Evil"},
            {"10","Chapter 10 - Hidden From the Start"},
            {"11","Chapter 11 - Reconnecting"},
            {"12","Chapter 12 - Bottomless Pit"},
            {"13","Chapter 13 - Stronghold"},
            {"14","Chapter 14 - Burning the Altar"},
            {"15","Chapter 15 - The End of This World"},
            {"16","Chapter 16 - In Limbo"},
            {"17","Chapter 17 - A Way Out"},
        };

    foreach (var Tag in vars.Chapters)
    {
        settings.Add(Tag.Key, true, Tag.Value, "chap");
    }; 

    settings.SetToolTip("starter", "This is used as the starter setting, disabling this also disables the original start command!");

    vars.doneMaps = new List<string>();

    vars.Helper.AlertLoadless();
}

init 
{
    vars.idSessionLocalScan = vars.Helper.ScanRel(0x3, "48 8b 0d ?? ?? ?? ?? 48 8b 01 ff 50 30 83 F8 07 0F 85 ?? ?? ?? ??");
    // not exactly sure what this is, looks like the parent of UI elements so that's what I'm going with
    vars.uiParentScan = vars.Helper.ScanRel(0x17, "48 8B 93 ?? ?? ?? ?? 48 8D 8D ?? ?? ?? ?? E8 ?? ?? ?? ?? 90 48 8B 0D ?? ?? ?? ??");
    // not sure either, couldn't find evidence of what this actually was but this looked right
    vars.playerPositionBaseScan = vars.Helper.ScanRel(0x1B, "f3 0f 10 98 dc 03 00 00 f3 0f 10 90 d8 03 00 00 f3 0f 10 88 d4 03 00 00 48 8b 0d");
}

update
{
    /**
     * These strings exist in the binary for a debug print.
     * enum GameState {
     *   STATE_PRESS_START = 0,
     *   STATE_USER_SETUP = 1,
     *   STATE_INITIAL_SCREEN = 2, // main menu
     *   STATE_PARTY_LOBBY_HOST = 3,
     *   STATE_PARTY_LOBBY_PEER = 4,
     *   STATE_PARTY_LOBBY_HOST = 5, // happens during load
     *   STATE_PARTY_LOBBY_PEER = 6,
     *   STATE_CREATE_AND_MOVE_TO_PARTY_LOBBY = 7,
     *   STATE_CREATE_AND_MOVE_TO_GAME_LOBBY = 8, // happens during load
     *   STATE_FIND_OR_CREATE_MATCH = 9,
     *   STATE_CONNECT_AND_MOVE_TO_PARTY = 10,
     *   STATE_CONNECT_AND_MOVE_TO_GAME = 11,
     *   STATE_BUSY = 12,
     *   STATE_LOADING = 13, // main load
     *   STATE_INGAME = 14, 
     * }
     */
    current.gameState = vars.Helper.Read<int>(vars.idSessionLocalScan, 0x8);
    // 0 in main menu, then in the save it's 1-17 based on the chapter you're in
    current.chapterId = vars.Helper.Read<int>(vars.idSessionLocalScan, 0x3D28, 0x5C);
    
    // player position!
    // BD0 comes from (vars.Helper.Read<int>(vars.playerPositionBaseScan, 0x14B80, 0xA7A0) + 0x7) * 0x10
    // but I don't think this value changes so hardcoding it here
    current.x = vars.Helper.Read<float>(vars.playerPositionBaseScan, 0xBD0 + 0x0);
    current.y = vars.Helper.Read<float>(vars.playerPositionBaseScan, 0xBD0 + 0x4);
    
    // z at 0x8
    // I constructed this by stepping through the assembly and working my way up
    // this is *not* randomly scanned
    current.isPaused = vars.Helper.Read<bool>(vars.uiParentScan, 0x28, 0x0, 0x80, 0x1C8, 0x18, 0x8, 0x8, 0xC);
    // this is nulled out on initial de-load, helps with transitions from a menu to a load screen
    current.isPausedParent = vars.Helper.Read<long>(vars.uiParentScan, 0x28);

    // This is the spinner on screen for saving, loading, etc.
    // There's a sibling value at 0x14 (a string) which describes what state the loader is in.
    // For the loading spinner, the percentage it's at is at 0x30
    current.spinnerType = vars.Helper.Read<int>(vars.uiParentScan, 0x30, 0xA28, 0x0, 0x2C);
    current.spinnerTypeString = vars.Helper.ReadString(256, ReadStringType.UTF8,vars.uiParentScan, 0x30, 0xA28, 0x0, 0x14);

    if (!((IDictionary<string, object>)(old)).ContainsKey("gameState"))
    {
        vars.Log("Loaded values:");
        vars.Log("  gameState: " + current.gameState + " [at " + (vars.Helper.Read<long>(vars.idSessionLocalScan) + 0x8).ToString("X") + "]");
        vars.Log("  chapterId: " + current.chapterId);
        vars.Log("  x / y: " + current.x + " / " + current.y);
        vars.Log("  isPaused: " + current.isPaused);
        vars.Log("  isPausedParent: " + current.isPausedParent.ToString("X"));
        vars.Log("  spinner type: '" + current.spinnerTypeString + "' [" + current.spinnerType + "]");
        return;
    }

    if (old.gameState != current.gameState)
    {
        vars.Log("gameState: " + old.gameState + " -> " + current.gameState);
    }

    if (old.chapterId != current.chapterId)
    {
        vars.Log("chapterId: " + old.chapterId + " -> " + current.chapterId);
    }

    if (old.isPaused != current.isPaused)
    {
        vars.Log("isPaused: " + old.isPaused + " -> " + current.isPaused);
    }

    if (old.isPausedParent != current.isPausedParent)
    {
        vars.Log("isPausedParent: " + old.isPausedParent.ToString("X") + " -> " + current.isPausedParent);
    }

    if (old.spinnerTypeString != current.spinnerTypeString || old.spinnerType != current.spinnerType)
    {
        vars.Log("spinner type: '" + old.spinnerTypeString + "' [" + old.spinnerType + "], '"  + current.spinnerTypeString + "' [" + current.spinnerType + "]");
    }
}

start
{
    return (
        settings["starter"] &&
        old.chapterId != current.chapterId &&
        current.chapterId == 1 &&
        !vars.doneMaps.Contains(current.chapterId.ToString())
    );
}

onStart
{
    vars.doneMaps.Clear();
    vars.doneMaps.Add(current.chapterId.ToString());
}

split
{
    var chapterKey = current.chapterId.ToString();
    if (
        old.chapterId != current.chapterId &&
        settings.ContainsKey(chapterKey) &&
        settings[chapterKey] &&
        !vars.doneMaps.Contains(chapterKey)
    ) {
        vars.doneMaps.Add(chapterKey);
        return true;
    }

    if (
        settings["end"] &&
        current.chapterId == 17 &&
        current.x > 42099.80858 &&
        current.x < 42099.8086 &&
        current.y > -28778.58009 &&
        current.y < -28778.58007
    ) {
        return true;
    }
}

isLoading
{
    return current.spinnerType == 3    // spinner is loading_area (monitor / computer warps)
        || current.isPaused            // self-explanatory!
        // user is entering a load screen, since it is deleted when the level unloads
        // (which causes isPaused to be 0 due to ZeroOrNull)
        // i think this also comes up elsewhere
        || current.isPausedParent == 0 
        || current.gameState == 13     // STATE_LOADING
        || current.gameState == 5      // STATE_PARTY_LOBBY_HOST
        || current.gameState == 8;     // STATE_CREATE_AND_MOVE_TO_GAME_LOBBY
}

reset
{
    return old.chapterId != current.chapterId && current.chapterId == 0;
}