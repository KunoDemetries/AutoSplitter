state("MID-Win64-Shipping", "Martha is Dead Demo")
{
    int Loader : 0x04A693D8, 0x4E0;
}

state("MID-Win64-Shipping", "Martha is Dead V4.27")
{
    int Loader : 0x05CD4600, 0x4F8;
}

state("MID-Win64-Shipping", "Martha is Dead V1.0401.01")
{
    int Loader : 0x05CE0A38, 0x4E0; // 1 not / 0 loading
}

update
{
    print(modules.First().ModuleMemorySize.ToString());
} 

init
{
    switch (modules.First().ModuleMemorySize) 
    {
        case 84725760 : version = "Martha is Dead Demo"; 
            break;
        case 104284160 : version = "Martha is Dead V4.27"; 
            break;
        case 104288256 : version = "Martha is Dead V1.0401.01";
            break;
        default:        version = ""; 
            break;
    }

}

isLoading
{
    return (current.Loader == 0);
}
