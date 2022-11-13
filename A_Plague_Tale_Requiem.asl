state("APlagueTaleRequiem_x64", "SteamRelease")
{
    byte Cutscene: 0x237CD48, 0x1080;
    short isLoading: 0x285A1D8, 0x4F0;
    byte Paused: 0x237CD80, 0x70;
    string128 Chapter: 0x02366E88, 0x708, 0x2E8, 0x750, 0x0;
    string128 Menu: 0x235348A;
}

state("APlagueTaleRequiem_x64", "Steam 1.3")
{
	bool Paused		: 0x23932B0, 0x70;				// 0 when unpaused, 1 when paused
	byte Cutscene		: 0x237DD90, 0x288;				// 128 cutscene, 160 no cutscene
	short isLoading		: 0x2871118, 0x4F0;				// 128 when loading, 256 in game
	float X			: 0x23932A8, 0x378, 0xA190;			// -8 base address of Paused
	float Y			: 0x23932A8, 0x378, 0xA194;			// ''
	float Z			: 0x23932A8, 0x378, 0xA198;			// ''
	string128 Chapter	: 0x237D2D8, 0x708, 0x2E8, 0x750, 0x0;		// Go to the end of chapter 3, type in III - A Burden of Blood, correct address is top one of 2 that will change to IV - Protector's Duty, normal string
	string128 Menu		: 0x236980A;					// Type in all caps MENU as a string then go into a level, one that changes is correct
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
		case (44457984):
			version = "Steam 1.3";
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
