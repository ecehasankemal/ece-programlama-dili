#include <stdio.h>

int main(void)
{
	int	sayaç;

	sayaç = 31;
	if (sayaç >= 10)
	{
		if (sayaç == 20)
		{
			printf("Evet sayaç 20\n");
		}
		else if (sayaç == 15)
		{
			printf("Hmm sayaç 15 imiş\n");
		}
		else
		{
			printf("Merhaba Dünya\n");
		}
		sayaç--;
	}
	return (0);
}
