// A Plague Tale: Requiem Load Remover & Autosplitter Version 1.0.6 19/11/2023
// Supports Load Remover IGT
// Supports full chapter splits for full game & IL's
// Splits for campaigns can be obtained from 
// Script & Steam Pointers by TheDementedSalad
// Xbox Pointers by KunoDemetries
// GoG Pointers by Kanemzi

state("APlagueTaleRequiem_x64", "Steam 1.0")
{
	bool Paused		: 0x237CD80, 0x70;				// 0 when unpaused, 1 when paused
	bool Crafting		: 0x285A1D8, 0x638, 0x1B8, 0xE8, 0x30;		// 128 cutscene, 160 no cutscene
	byte Cutscene		: 0x2367940, 0x288;				// 1 in crafting tabs/codex 0 elsewhere
	short isLoading		: 0x285A1D8, 0x4F0;				// 128 when loading, 256 in game
	float X			: 0x237CD78, 0x378, 0xA190;			// -8 base address of Paused
	float Y			: 0x237CD78, 0x378, 0xA194;			// ''
	float Z			: 0x237CD78, 0x378, 0xA198;			// ''
	string128 Chapter	: 0x2366E88, 0x708, 0x2E8, 0x750, 0x0;		// Go to the end of chapter 3, type in III - A Burden of Blood, correct address is top one of 2 that will change to IV - Protector's Duty, normal string
	string128 Menu		: 0x235348A;					// Type in all caps MENU as a string then go into a level, one that changes is correct
}

state("APlagueTaleRequiem_x64", "Steam 1.3")
{
	bool Paused		: 0x23932B0, 0x70;
	bool Crafting		: 0x2871118, 0x638, 0x1B8, 0xE8, 0x30;
	byte Cutscene		: 0x237DD90, 0x288;
	short isLoading		: 0x2871118, 0x4F0;
	float X			: 0x23932A8, 0x378, 0xA190;
	float Y			: 0x23932A8, 0x378, 0xA194;
	float Z			: 0x23932A8, 0x378, 0xA198;
	string128 Chapter	: 0x237D2D8, 0x708, 0x2E8, 0x750, 0x0;
	string128 Menu		: 0x236980A;
}

state("APlagueTaleRequiem_x64", "Steam 1.4")
{
	bool Paused		: 0x2393BF0, 0x70;
	bool Crafting		: 0x2871B18, 0x638, 0x1B8, 0xE8, 0x30;
	byte Cutscene		: 0x237E620, 0x288;
	short isLoading		: 0x2871B18, 0x4F0;
	float X			: 0x2393BE8, 0x378, 0xA170;
	float Y			: 0x2393BE8, 0x378, 0xA174;
	float Z			: 0x2393BE8, 0x378, 0xA178;
	string128 Chapter	: 0x237DB68, 0x708, 0x2E8, 0x750, 0x0;
	string128 Menu		: 0x236A08A;
}

state("APT2_WinStore.x64.Submission", "Xbox 1.0")
{
	bool Paused		: 0x23A63C0, 0x70;
	bool Crafting		: 0x2883978, 0x638, 0x1B8, 0xE8, 0x30;
	byte Cutscene		: 0x23A6388, 0x1080;
	short isLoading		: 0x2883978, 0x4F0;
	float X			: 0x23A63B8, 0x378, 0xA190;
	float Y			: 0x23A63B8, 0x378, 0xA194;
	float Z			: 0x23A63B8, 0x378, 0xA198;
	string128 Chapter	: 0x23904C8, 0x708, 0x2E8, 0x750, 0x0;
	string128 Menu		: 0x237CACA;
}

state("APT2_WinStore.x64.Submission", "Xbox 1.3")
{
	bool Paused			: 0x23BC8F0, 0x70;							// fixed
	bool Crafting		: 0x289A8B8, 0x638, 0x1B8, 0xE8, 0x30;
	byte Cutscene		: 0x23A73D0, 0x288;							// 128 cutscene, 160 no cutscene
	short isLoading		: 0x289A8B8, 0x4F0;							// 297A0
	float X				: 0x23BC8E8, 0x378, 0xA190;					//fixed 
	float Y				: 0x23BC8E8, 0x378, 0xA194;					// fixed
	float Z				: 0x23BC8E8, 0x378, 0xA198;					// Fixed
	string128 Chapter	: 0x23A6918, 0x708, 0x2E8, 0x750, 0x0;		//fixed
	string128 Menu		: 0x2392E4A;								//29640
}

state("APlagueTaleRequiem_x64", "GoG 1.0")
{
	bool Paused			: 0x2368560, 0x70;
	bool Crafting		: 0x28454F8, 0x638, 0x1B8, 0xE8, 0x30;
	byte Cutscene		: 0x2353120, 0x288;
	short isLoading		: 0x28454F8, 0x4F0;
	float X				: 0x2368558, 0x378, 0xA190;
	float Y				: 0x2368558, 0x378, 0xA194;
	float Z				: 0x2368558, 0x378, 0xA198;
	string128 Chapter	: 0x2352688, 0x708, 0x2E8, 0x750, 0x0;
	string128 Menu		: 0x233EC6A;
}

state("APlagueTaleRequiem_x64", "GoG 1.3")
{
	bool Paused			: 0x237DAB0, 0x70;
	byte Cutscene		: 0x2368590, 0x288;
	bool Crafting		: 0x285B488, 0x638, 0x1B8, 0xE8, 0x30;
	short isLoading		: 0x285B488, 0x4F0;
	float X				: 0x237DAA8, 0x378, 0xA190;
	float Y				: 0x237DAA8, 0x378, 0xA194;
	float Z				: 0x237DAA8, 0x378, 0xA198;
	string128 Chapter	: 0x2367AD8, 0x708, 0x2E8, 0x750, 0x0;
	string128 Menu		: 0x235400A;
}

state("APlagueTaleRequiem_x64", "GoG 1.4")
{
    bool Paused        : 0x237E3F0, 0x70;
    bool Crafting      : 0x285BE88, 0x638, 0x1B8, 0xE8, 0x30;
    byte Cutscene      : 0x2368E20, 0x288;
    short isLoading       : 0x285BE88, 0x4F0;
    float X            : 0x237E3E8, 0x378, 0xA190;
    float Y            : 0x237E3E8, 0x378, 0xA194;
    float Z            : 0x237E3E8, 0x378, 0xA198;
    string128 Chapter  : 0x2368368, 0x708, 0x2E8, 0x750, 0x0;
    string128 Menu     : 0x235488A;
}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	
	if (timer.CurrentTimingMethod == TimingMethod.RealTime){ // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
		var timingMessage = MessageBox.Show (
			"This game uses Time without Loads (Game Time) as the main timing method.\n"+
			"LiveSplit is currently set to show Real Time (RTA).\n"+
			"Would you like to set the timing method to Game Time? This will make verification easier",
			"LiveSplit | A Plague Tale: Requiem",
		MessageBoxButtons.YesNo,MessageBoxIcon.Question);
		
		if (timingMessage == DialogResult.Yes){
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}
}

init
{
	try{
		// Latest Steam updates that share same MemorySize
		switch ((string)vars.Helper.GetMD5Hash()){
			case "1AE94C299EBF70F6BA077489EEE2AE39":
				version = "Steam 1.4";
				break;
			}
	}
	
	catch{
		// Failed to open file for MD5 computation.
		switch ((int)vars.Helper.GetMemorySize()){
			case (44359680):
				version = "Steam 1.0";
				break;
			case (44457984):
				version = "Steam 1.3";
				break;
			case (44335104):
				version = "Xbox 1.0";
				break;
			case (44433408):
				version = "Xbox 1.3";
				break;
			case (44064768):
				version = "GoG 1.0";
				break;
			case (44154880):
				version = "GoG 1.3";
				break;
			case (44158976):
				version = "GoG 1.4";
				break;
			}
		}
	
}

update
{
	// Uncomment debug information in the event of an update.
	//print(modules.First().ModuleMemorySize.ToString());
	
}

start
{
	return current.Menu != "MENU" && current.Cutscene == 160 && current.isLoading == 256;
}

split
{
	if(current.Chapter != old.Chapter && old.Menu != "MENU" || 
		current.X > -259 && current.X < -248f && current.Y > -18f && current.Y < -11f && current.Z > 102f && current.Z < 113f && current.Cutscene == 128 && old.Cutscene == 160){
		return true;
	}
}

isLoading
{
	return current.Paused || current.Cutscene == 128 && !current.Crafting || current.Menu == "MENU" || current.isLoading == 128;
}
