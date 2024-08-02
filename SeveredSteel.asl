// autosplitter and layout by nyutie
// first time doin any of this :3_:

state("ThankYouVeryCool-Win64-Shipping", "oldleaderboards steam") {
    // float levelTimer: 0x5B0F540, 0x118, 0xB54;
    float fullTimer: 0x5B0F540, 0x118, 0xB58;
    bool isOnMainMenu: 0x59C7EE0, 0x8D0, 0x0, 0x16B0, 0xD8;
}

state("ThankYouVeryCool-Win64-Shipping", "oldleaderboards epic") {
    // float levelTimer: 0x5DC0380, 0x118, 0xB54;
    float fullTimer: 0x5DC0380, 0x118, 0xB58;
    bool isOnMainMenu: 0x5D52E90, 0x30, 0x60, 0x560, 0x320;
}

state("ThankYouVeryCool-Win64-Shipping", "firefight2 steam patch 1") {
    // float levelTimer: 0x5B19140, 0x118, 0xB64;
    float fullTimer: 0x5B19140, 0x118, 0xB68;
    bool isOnMainMenu: 0x59D1AE0, 0x2190, 0x0, 0xEA0, 0x27C;
}

startup
{
    if(timer.CurrentTimingMethod == TimingMethod.RealTime) // copied this from somewhere lmao
    {
        var timingMessage = MessageBox.Show
        (
            "This game uses Game Time (time without loads) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (time INCLUDING loads).\n"+
            "Would you like the timing method to be set to Game Time for you?",
            vars.aslName+" | LiveSplit",
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Question
        );
        if (timingMessage == DialogResult.Yes) timer.CurrentTimingMethod = TimingMethod.GameTime;
	}

    vars.MapReferences = new List<string>()
    {
        "/Game/Campaign/Trash/CDA_Trash.CDA_Trash_C",
        "/Game/Campaign/TrashDiveTut/CDA_TrashDive.CDA_TrashDive_C",
        "/Game/Campaign/AboveTrash/CDA_AboveTrash.CDA_AboveTrash_C",
        "/Game/Campaign/Trash_turrets/CDA_Turrets.CDA_Turrets_C",
        "/Game/Campaign/trash_combat/CDA_TrashCombat.CDA_TrashCombat_C",
        "/Game/Campaign/TrashControlRoom/CDA_WasteManagement.CDA_WasteManagement_C",
        "/Game/Campaign/MeatPlant/CDA_RedHouse.CDA_RedHouse_C",
        "/Game/Campaign/MeatProc/CDA_RedProc.CDA_RedProc_C",
        "/Game/Campaign/HospitlCafe/CDA_Cafeteria.CDA_Cafeteria_C",
        "/Game/Campaign/Labs/CDA_Labs.CDA_Labs_C",
        "/Game/Campaign/LabBasement/CDA_LabBasement.CDA_LabBasement_C",
        "/Game/Campaign/HospitalCare/CDA_CyberHospital.CDA_CyberHospital_C",
        "/Game/Campaign/Corridor/CDA_Corridor.CDA_Corridor_C",
        "/Game/Campaign/Vents1/CDA_Vents1.CDA_Vents1_C",
        "/Game/Campaign/Vents_two/CDA_Vents2.CDA_Vents2_C",
        "/Game/Campaign/Oxygenate/CDA_Oxygenate.CDA_Oxygenate_C",
        "/Game/Campaign/TrainStation/CDA_SubwayStation.CDA_SubwayStation_C",
        "/Game/Campaign/Train0/CDA_Train0.CDA_Train0_C",
        "/Game/Campaign/TrainOne/CDA_TrainOne.CDA_TrainOne_C",
        "/Game/Campaign/Checkpoint/CDA_Checkoint.CDA_Checkoint_C",
        "/Game/Campaign/Intelligence/CDA_Intel.CDA_Intel_C",
        "/Game/Campaign/DataPrism/CDA_DataPrism.CDA_DataPrism_C",
        "/Game/Campaign/ServerRoom/CDA_Serveroom.CDA_Serveroom_C",
        "/Game/Campaign/Armory/CDA_Armory.CDA_Armory_C",
        "/Game/Campaign/Prison/CDA_Prison.CDA_Prison_C",
        "/Game/Campaign/Vents3/CDA_Vents3.CDA_Vents3_C",
        "/Game/Campaign/Anxiety/CDA_Anxiety.CDA_Anxiety_C",
        "/Game/Campaign/Reception/CDA_Reception.CDA_Reception_C",
        "/Game/Campaign/LowerAdmin/CDA_LowerAdmin.CDA_LowerAdmin_C",
        "/Game/Campaign/MiddleAdmin/CDA_MiddleAdmin2.CDA_MiddleAdmin2_C",
        "/Game/Campaign/UpperAdmin/CDA_UpperAdmin.CDA_UpperAdmin_C",
        "/Game/Campaign/TeleportingLab/CDA_Teleporter.CDA_Teleporter_C",
        "/Game/Campaign/Barraks/CDA_Barracks.CDA_Barracks_C",
        "/Game/Campaign/Apartments/CDA_Apartments.CDA_Apartments_C",
        "/Game/Campaign/Mall/CDA_Mall.CDA_Mall_C",
        "/Game/Campaign/Asention/CDA_Asention.CDA_Asention_C",
        "/Game/Campaign/GlassMoon/CDA_GlassMoon.CDA_GlassMoon_C",
        "/Game/Campaign/Nightclub/CDA_Nightclub.CDA_Nightclub_C",
        "/Game/Campaign/ceooffice/CDA_ceooffice.CDA_ceooffice_C",
        "/Game/Campaign/Penthouse/CDA_Penthouse.CDA_Penthouse_C",
        "/Game/Campaign/Museum1/CDA_Gallery.CDA_Gallery_C",
        "/Game/Campaign/Museum/CDA_Museum.CDA_Museum_C",
        "/Game/Campaign/Garden/CDA_Garden.CDA_Garden_C",
        "/Game/Campaign/Mansion/CDA_Mansion.CDA_Mansion_C",
        "/Game/Campaign/TheWall/CDA_TheWall.CDA_TheWall_C",
        "/Game/Campaign/Cage/CDA_Cage.CDA_Cage_C",
        "/Game/Campaign/Escapism/CDA_Escapism.CDA_Escapism_C"
    };
}

init
{
    switch ((long)modules.First().ModuleMemorySize) {
        case 0x605D000:
            version = "oldleaderboards steam";
            vars.SaveOffsetPath = new DeepPointer(0x5B0B178, 0x130, 0x38, 0x70, 0x459);
            break;
        case 0x6380000:
            version = "oldleaderboards epic";
            vars.SaveOffsetPath = new DeepPointer(0x5DBBFB8, 0x130, 0x38, 0x70, 0x459);
            break;
        case 0x60B0000:
            version = "firefight2 steam patch 1";
            vars.SaveOffsetPath = new DeepPointer(0x5B14D78, 0x130, 0x38, 0x70, 0x459);
            break;
        default:
            MessageBox.Show
            (
                "Unsupported version of the game! If you're on GOG, sorry, I don't have it.\n" +
                "If you're on Steam/Epic, I'm probably already working on the update!\n\n" +
                "If you have any questions you can find me on the official Greylock Discord server, or the official SS/EPN speedrun Discord server.\n\n" +
                "modules.First().BaseAddress: 0x" + modules.First().BaseAddress.ToString("X") + "\n" + 
                "modules.first().ModuleMemorySize: 0x" + modules.First().ModuleMemorySize.ToString("X") + "\n",
                "SS-autosplitter", // caption
                MessageBoxButtons.OK,
                MessageBoxIcon.Warning
            );
            return;
    }

    timer.IsGameTimePaused = false;
    vars.CurrentMapIndex = -2;
}

update
{
    if (version == "") {
        return false; // stops update
    }

    IntPtr resolvedSavePath = IntPtr.Zero;
    vars.SaveOffsetPath.DerefOffsets(game, out resolvedSavePath);
    vars.SaveOffset = resolvedSavePath;

    IntPtr saveOffset = vars.SaveOffset;
    int campaignLevelReferenceStringLength = game.ReadValue<int>(saveOffset + 0x82);
    vars.CampaignLevelReferenceString = game.ReadString(saveOffset + 0x82 + 0x4, campaignLevelReferenceStringLength);
}

start
{
    if (!current.isOnMainMenu && vars.CampaignLevelReferenceString == vars.MapReferences[0] && current.fullTimer > 0f && old.fullTimer == 0f)
    {
        vars.CurrentMapIndex = 0;
        return true;
    }
}

split
{
    int nowCurrentMapIndex = vars.MapReferences.IndexOf(vars.CampaignLevelReferenceString);
    if (nowCurrentMapIndex == vars.CurrentMapIndex + 1)
    {
        vars.CurrentMapIndex = nowCurrentMapIndex;
        return true;
    }
    else if (nowCurrentMapIndex == vars.MapReferences.Count - 1 && current.fullTimer == 0f) // last map
    {
        return true;
    }
}

reset
{
    if (current.isOnMainMenu)
    {
        return true;
    }
}

isLoading
{
    if (!current.isOnMainMenu && current.fullTimer == old.fullTimer)
    {
        return true;
    }
    return false;
}

gameTime
{
    return TimeSpan.FromSeconds(current.fullTimer != 0f ? current.fullTimer : old.fullTimer);
}

onReset
{
    vars.CurrentMapIndex = -2;
}

exit
{
    timer.IsGameTimePaused = true;
}
