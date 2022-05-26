/*  Originally made by Meta: https://twitter.com/ItsCamNotCan
    Redone by Kuno Demetries: https://t.co/D8xyyuVeak
*/

state("ThankYouVeryCool-Win64-Shipping", "4.1.0")
{
    //int loading   : 0x521BBE4; // if this gets re-added in, make sure to also add it to init
    //int level     : 0x5219EA0;
    int menuState : 0x4F54688;
    float IGT     : 0x0543C7F0, 0x118, 0xA18;
}

state("ThankYouVeryCool-Win64-Shipping", "4.27.2")
{
    //int loading   : 0x5639D84; // 2 is loading, 0 isn't
    //int level     : 0x5219EA0; 
    int menuState : 0x5375080;
    float IGT     : 0x05893910, 0x118, 0xAAC;
    string110 CurLevel : 0x0588F548, 0x130, 0x38, 0x70, 0x4F3;
}

init
{
    vars.menuState = false;
    vars.totalGameTime = 0;
    vars.loading = 0;
    vars.doneMaps = new List<string>();

    switch (modules.First().ModuleMemorySize) 
    {
        case 98951168: 
            version = "4.27.2";
            break;
        default:        version = "4.1.0"; 
            break;
    }
}

startup
{
    settings.Add("Levels", true, "All Levels");

    vars.missions2 = new Dictionary<string,string> 
	{ 	
        {"/Game/Campaign/Trash/CDA_Trash.CDA_Trash_C", "Trash Compactor"},
        {"/Game/Campaign/TrashDiveTut/CDA_TrashDive.CDA_TrashDive_C", "Compact Controls"},
        {"/Game/Campaign/AboveTrash/CDA_AboveTrash.CDA_AboveTrash_C", "Maintenance"},
        {"/Game/Campaign/Trash_turrets/CDA_Turrets.CDA_Turrets_C", "Security Hut"}, 
        {"/Game/Campaign/trash_combat/CDA_TrashCombat.CDA_TrashCombat_C", "Security Hut 2"},
        {"/Game/Campaign/TrashControlRoom/CDA_WasteManagement.CDA_WasteManagement_C", "Waste Management"},
        {"/Game/Campaign/MeatPlant/CDA_RedHouse.CDA_RedHouse_C", "Red House"},
        {"/Game/Campaign/MeatProc/CDA_RedProc.CDA_RedProc_C", "Red Processing"},
        {"/Game/Campaign/HospitlCafe/CDA_Cafeteria.CDA_Cafeteria_C", "Cafeteria"},
        {"/Game/Campaign/Labs/CDA_Labs.CDA_Labs_C", "R&B Lab"},
        {"/Game/Campaign/LabBasement/CDA_LabBasement.CDA_LabBasement_C", "Production Lab"},
        {"/Game/Campaign/HospitalCare/CDA_CyberHospital.CDA_CyberHospital_C", "Cybermedicine"},
        {"/Game/Campaign/Corridor/CDA_Corridor.CDA_Corridor_C", "Corridor"},
        {"/Game/Campaign/Vents1/CDA_Vents1.CDA_Vents1_C", "Service Vents (Hospital Vents)"},
        {"/Game/Campaign/Vents_two/CDA_Vents2.CDA_Vents2_C", "Subway Vents"},
        {"/Game/Campaign/Oxygenate/CDA_Oxygenate.CDA_Oxygenate_C", "Cleave"},
        {"/Game/Campaign/TrainStation/CDA_SubwayStation.CDA_SubwayStation_C", "Train Station"},
        {"/Game/Campaign/Train0/CDA_Train0.CDA_Train0_C", "Train Zero"},
        {"/Game/Campaign/TrainOne/CDA_TrainOne.CDA_TrainOne_C", "Train"},
        {"/Game/Campaign/Checkpoint/CDA_Checkoint.CDA_Checkoint_C", "Checkpoint"},
        {"/Game/Campaign/Intelligence/CDA_Intel.CDA_Intel_C", "Intelligence"},
        {"/Game/Campaign/DataPrism/CDA_DataPrism.CDA_DataPrism_C", "Data Prism"},
        {"/Game/Campaign/ServerRoom/CDA_Serveroom.CDA_Serveroom_C", "Server Room"},
        {"/Game/Campaign/Armory/CDA_Armory.CDA_Armory_C", "Armory"},
        {"/Game/Campaign/Prison/CDA_Prison.CDA_Prison_C", "Prison"},
        {"/Game/Campaign/Vents3/CDA_Vents3.CDA_Vents3_C", "Admin Vents (Vent 3)"},
        {"/Game/Campaign/Anxiety/CDA_Anxiety.CDA_Anxiety_C", "Forest"},
        {"/Game/Campaign/Reception/CDA_Reception.CDA_Reception_C", "Reception"},
        {"/Game/Campaign/LowerAdmin/CDA_LowerAdmin.CDA_LowerAdmin_C", "Lower Administration"},
        {"/Game/Campaign/MiddleAdmin/CDA_MiddleAdmin2.CDA_MiddleAdmin2_C", "Middle Admin"},
        {"/Game/Campaign/UpperAdmin/CDA_UpperAdmin.CDA_UpperAdmin_C", "Upper Admin"},
        {"/Game/Campaign/TeleportingLab/CDA_Teleporter.CDA_Teleporter_C", "Portal Lab"},
        {"/Game/Campaign/Barraks/CDA_Barracks.CDA_Barracks_C", "Barracks"},
        {"/Game/Campaign/Apartments/CDA_Apartments.CDA_Apartments_C", "Apartments"},
        {"/Game/Campaign/Mall/CDA_Mall.CDA_Mall_C", "Greens"},
        {"/Game/Campaign/Asention/CDA_Asention.CDA_Asention_C", "Towers"},
        {"/Game/Campaign/GlassMoon/CDA_GlassMoon.CDA_GlassMoon_C", "City"},
        {"/Game/Campaign/Nightclub/CDA_Nightclub.CDA_Nightclub_C", "Party Mansion"},
        {"/Game/Campaign/ceooffice/CDA_ceooffice.CDA_ceooffice_C", "CEO Office"},
        {"/Game/Campaign/Penthouse/CDA_Penthouse.CDA_Penthouse_C", "Penthouse"},
        {"/Game/Campaign/Museum1/CDA_Gallery.CDA_Gallery_C", "Art Gallery"},
        {"/Game/Campaign/Museum/CDA_Museum.CDA_Museum_C", "Museum"},
        {"/Game/Campaign/Garden/CDA_Garden.CDA_Garden_C", "Garden"},
        {"/Game/Campaign/Mansion/CDA_Mansion.CDA_Mansion_C", "Estate"},
        {"/Game/Campaign/TheWall/CDA_TheWall.CDA_TheWall_C", "The Wall"},
        {"/Game/Campaign/Cage/CDA_Cage.CDA_Cage_C", "Conscience"},
        {"/Game/Campaign/Escapism/CDA_Escapism.CDA_Escapism_C", "Escapism"},
    };
	foreach (var Tag in vars.missions2)
	{
		settings.Add(Tag.Key, true, Tag.Value, "Levels");
    };

    vars.stopwatch = new Stopwatch();
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
	{        
		var timingMessage = MessageBox.Show (
			"This game uses Time without Loads (Game Time) as the main timing method.\n"+
			"LiveSplit is currently set to show Real Time (RTA).\n"+
			"Would you like to set the timing method to Game Time?",
			"LiveSplit | Severed Steel",
			MessageBoxButtons.YesNo,MessageBoxIcon.Question
		);
		
		if (timingMessage == DialogResult.Yes)
		{
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}
}

start
{
    if (current.menuState == 7)
    {
        vars.doneMaps.Add(current.CurLevel);
        return true;
    }
}

split
{
    if ((current.CurLevel != old.CurLevel) && (!vars.doneMaps.Contains(current.CurLevel)))
    {
        vars.doneMaps.Add(current.CurLevel);
        return true;
    }
}

onReset
{
    vars.doneMaps.Clear();
}

gameTime 
{
    return TimeSpan.FromSeconds(vars.totalGameTime + current.IGT);
}

isLoading
{
    return true;
}

exit
{
    timer.IsGameTimePaused = true;
}