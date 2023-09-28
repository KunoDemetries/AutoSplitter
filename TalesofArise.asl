state("Tales of Arise", "Steam 1.1.0.0")
{
    byte LoadingScreen : 0x42792FA;  //160 not / 32 loading
    string150 CurCutscene : 0x047C4220, 0x68, 0x20, 0x1F8;
}

state("Tales of Arise", "Steam 1.3.0.0")
{
    byte LoadingScreen : 0x3DC9E4A;  //160 not / 32 loading
    string150 CurCutscene : 0x042C8DF0, 0x68, 0x20, 0x1F8;
}

state("Tales of Arise", "Steam 1.4.0.0")
{
    byte LoadingScreen : 0x3DC9E4A;  //160 not / 32 loading
    string150 CurCutscene : 0x042C8DF0, 0x68, 0x20, 0x1F8;
}

init
{
    switch (modules.First().ModuleMemorySize) 
    {
        case 85544960: 
            version = "Steam 1.1.0.0";
        break;
        case 77914112: 
            version = "Steam 1.3.0.0";
        break;
        case 77918208:
            version = "Steam 1.4.0.0";
        break;
    }
}

start
{
    return ((current.CurCutscene != old.CurCutscene) && (old.CurCutscene == @"\Arise\Content\Binaries\Movie\Composite\MV_MEP_010_00000.usm") && (current.CurCutscene == null) && (current.LoadingScreen == 160));
}

isLoading
{
    return (current.LoadingScreen == 32);
}
