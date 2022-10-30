state("APlagueTaleRequiem_x64", "SteamRelease")
{
    byte Cutscene: 0x237CD48, 0x1080;
    short isLoading: 0x285A1D8, 0x4F0;
    byte Paused: 0x237CD80, 0x70;
    string128 Chapter: 0x02366E88, 0x708, 0x2E8, 0x750, 0x0;
    string128 Menu: 0x235348A;
}

state("APT2_WinStore.x64.Submission", "Xbox Game Pass 1.2.0")
{
    byte Cutscene: 0x23A6388, 0x1080;
    short isLoading: 0x02883978, 0x4F0;
    byte Paused: 0x23A63C0, 0x70;
    string128 Chapter: 0x23904C8, 0x708, 0x2E8, 0x750, 0x0;
    string128 Menu: 0x237CACA; // 29640
}

init
{
    switch (modules.First().ModuleMemorySize)
	{
		case (44359680):
			version = "SteamRelease";
			break;
        case (44335104):
            version = "Xbox Game Pass 1.2.0";
            break;
    }
}

update
{
    // Uncomment debug information in the event of an update.
    //print(modules.First().ModuleMemorySize.ToString());
}

start
{
    return current.Menu != "MENU" && current.Cutscene == 0 && current.isLoading == 256;
}

split
{
    return current.Chapter != old.Chapter;
}

isLoading
{
    return current.Paused == 1 || current.Cutscene == 1 || current.Menu == "MENU" || current.isLoading == 128;
}