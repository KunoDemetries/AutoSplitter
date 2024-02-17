state("BlazblueEntropyEffect")
{
    byte Loading : "GameAssembly.dll", 0x046D98B0, 0xB8, 0x0, 0x58;
}

isLoading
{
    return (current.Loading == 1);
}
