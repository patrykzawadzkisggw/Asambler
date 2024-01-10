#include <stdio.h>

extern double _pierwiastek(double a);

double pierwiastek(double a);


int main()
{
	 double zmienna=0;
     int precyzja=0;

    while (1)
	{
		lz:
		printf("Podaj liczbe zmiennoprzecinkowa: ");
		if(scanf("%lf", &zmienna)!=1){
			fflush(stdin);
			b1:
			printf("naucz sie pisac cyferki.\n");
			goto lz;
		}
    	if(zmienna <0) goto b1;
		fflush(stdin);
		lm:
		printf("Podaj liczbe miejsc po przecinku[0-10]: ");
		if(scanf("%d", &precyzja)!=1){
			fflush(stdin);
			b2:
			printf("naucz sie pisac cyferki.\n");
			goto lm;
		}
		if(precyzja <0 || precyzja>10) goto b2;

    	printf("wynik: %.*lf\n", precyzja, pierwiastek(zmienna));
	}
	

	return 0;
}