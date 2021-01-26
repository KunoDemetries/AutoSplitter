state("BlackOps") {
    string14 map : 0x21033E8;
    long loading : 0x1656804;
}

startup {
    var missions = new Dictionary<string,string> {
        {"vorkuta", "Vorkuta"},
        {"pentagon", "USDD"},
        {"flashpoint", "Executive Order"},
        {"khe_sanh", "SOG"},
        {"hue_city", "The Defector"},
        {"kowloon", "Numbers"},
        {"fullahead", "Project Nova"},
        {"creek_1", "Victor Charlie"},
        {"river", "Crash Site"},
        {"wmd_sr71", "WMD"},
        {"pow", "Payback"},
        {"rebirth", "Rebirth"},
        {"int_escape", "Revelations"},
        {"underwaterbase", "Redemption"},
        {"outro", "Menu Screen"}
    };

    foreach (var mission in missions)
        settings.Add(mission.Key, true, mission.Value);

    timer.CurrentTimingMethod = TimingMethod.GameTime;
}

start {
    return current.map == "cuba" && current.loading != 0 && old.loading == 0;
}

split {
    return current.map != old.map && settings[current.map];
}

reset {
    return current.map == "frontend";
}

isLoading {
    return current.loading == 0;
}
