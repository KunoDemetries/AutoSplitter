state("CallOfCthulhu")
{
	int loading1 : 0x0313B1D0, 0x8;
}

isLoading
{
	return (current.loading1 == 2); 
}
