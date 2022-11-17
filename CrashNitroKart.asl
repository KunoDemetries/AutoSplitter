state("Dolphin")
{
    //string50 CurMap : 0x0133A248, 0xDA8;
    //int Load : 0x196BFC8;
}

init
{
    vars.doneMaps = new List<string>(); 

    //Thank you to Jujstme for pretty much teaching me all of this. 
    vars.watchers = new MemoryWatcherList();
    IntPtr ptr = IntPtr.Zero;

    var scanner = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize);

    ptr = game.MemoryPages(true).FirstOrDefault(p => p.Type == MemPageType.MEM_MAPPED && p.State == MemPageState.MEM_COMMIT && (int)p.RegionSize == 0x2000000).BaseAddress;
                print("  => MEM2 address found at 0x" + ptr.ToString("X"));
    if (ptr == IntPtr.Zero) throw new Exception("Sigscan failed!");
    //checkptr();

    vars.watchers.Add(new StringWatcher(ptr + 0x2000DA8, 40) { Name = "MapName" });    
    vars.watchers.Add(new StringWatcher(ptr + 0x20A34DA, 50) { Name = "CurCutscene"});
    vars.watchers.Add(new MemoryWatcher<int> (ptr + 0x200B024) { Name = "Load"});
}

update
{   
    vars.watchers.UpdateAll(game);
   // print(vars.watchers["MapName"].Current);
    print(vars.watchers["Load"].Current.ToString());
}

split
{
    if ((!vars.watchers["MapName"].Current.Contains("hub")) && (vars.watchers["MapName"].Current.Contains("tracks")) && (!vars.doneMaps.Contains(vars.watchers["MapName"].Current)) && (vars.watchers["MapName"].Current != ""|| vars.watchers["MapName"].Current != null))
    {
        vars.doneMaps.Add(vars.watchers["MapName"].Current);
        return true;
    }
}

onReset
{
    vars.doneMaps.Clear();
}

isLoading
{
    return ((vars.watchers["Load"].Current == 1) && (vars.watchers["CurCutscene"].Current == null || vars.watchers["CurCutscene"].Current == ""));
}