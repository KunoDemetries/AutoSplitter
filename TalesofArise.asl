state("Tales of Arise", "Steam 1.1.0.0")
{
    byte LoadingScreen : 0x42792FA;  //160 not / 132 loading
    string150 CurCutscene : 0x047C4220, 0x68, 0x20, 0x1F8;
}

init
{
    vars.DoLoad = false;

    switch (modules.First().ModuleMemorySize) 
    {
        case 85544960: 
            version = "Steam 1.1.0.0";
        break;
    }
}

startup
{
    //settings.Add("DL", false, "Do cutscene loading?");
}

start
{
    return ((current.CurCutscene != old.CurCutscene) && (old.CurCutscene == @"\Arise\Content\Binaries\Movie\Composite\MV_MEP_010_00000.usm") && (current.CurCutscene == null) && (current.LoadingScreen == 160));
}

update
{
    print(current.LoadingScreen.ToString());
}

isLoading
{
    return (current.LoadingScreen == 32);
}