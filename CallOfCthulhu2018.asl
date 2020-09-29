state("CallOfCthulhu")
{
	byte loading1 : 0x033BDCE0, 0x1A0, 0xE8, 0x148, 0x440, 0x40, 0x900, 0x95C;
}

isLoading
{
	return (current.loading1 != 150) && (current.loading1 != 0); 
}
