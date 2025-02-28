state("BlazblueEntropyEffect") { }

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "Blazblue";
    vars.Helper.AlertLoadless();

    settings.Add("boss-kills", true, "Split on boss kills");

    vars.ActionFlags_AsyncLoading = 1 << 0;
}

onSplit
{
    vars.HighestSeenHp = 0;
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var gim = mono["GameInputManager", 1];
        vars.Helper["ActionFlags"] = gim.Make<int>("s_instance", "m_uiActionFlag");

        var bb = mono["BattleBase"];
        var ab = mono["ActorBase"];
        var atm = mono["ActorTargetMgr"];
        var po = mono["PlayerObj"];
        vars.Helper["LastHitHp"] = bb.Make<int>("Cur", "PlayerSelf", ab["TargetMgr"], atm["m_lastHit"], po["m_LastUpdateHP"] + sizeof(int));

        return true;
    });

    vars.HighestSeenHp = 0;
}

update
{
    if (current.LastHitHp > vars.HighestSeenHp)
    {
        vars.HighestSeenHp = current.LastHitHp;
    }

    print(current.LastHitHp.ToString());
}

split
{
    return settings["boss-kills"] && old.LastHitHp > 0 && current.LastHitHp <= 350 && vars.HighestSeenHp > 17000;
}

isLoading
{
    return (current.ActionFlags & vars.ActionFlags_AsyncLoading) != 0;
}
