%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define PALOS 3
#define DIM 27 //DIMENSION DE LA MATRIZ DE ADYACENCIA
#define BUFF 4000

//declarar la variable listaTr de tipo ListaTransiciones
//Almacena las transiciones de un solo nodo (nodoOrig) 
//a varios nodos (nodosFin y sus correspondientes etiquetas)
struct ListaTransiciones {
	char* nodoOrig;
	char* nodosFin[DIM];
	char* etiquetas[DIM]; 
	int total;
} listaTr;

//tabla de adyacencia
char* tablaTr[DIM][DIM];
char* fila;

//inicializa una tabla cuadrada DIM x DIM con la cadena vacia
void iniTabla(char* tabla[DIM][DIM]) {
	for (int i = 0; i < DIM; i++) {
		for (int j = 0; j < DIM; j++) {
			tabla[i][j] = "";
		}
	}
}

/*
 * Calcula la multiplicacion simbolica de matrices 
 * cuadradas DIM x DIM: res = t1*t2
 *
 * CUIDADO: res DEBE SER UNA TABLA DISTINTA A t1 y t2
 * Por ejemplo, NO SE DEBE USAR en la forma:
 *           multiplicar(pot, t, pot); //mal
 */
void multiplicar(char* t1[DIM][DIM], char* t2[DIM][DIM], char* res[DIM][DIM]) {
	for (int i = 0; i < DIM; i++) {
		for (int j = 0; j < DIM; j++) {
			res[i][j] = (char*) calloc(BUFF, sizeof(char));
			for (int k = 0; k < DIM; k++) {
				if (strcmp(t1[i][k],"")!=0 && strcmp(t2[k][j],"") != 0) {
					strcat(strcat(res[i][j],t1[i][k]),"-");
					strcat(res[i][j],t2[k][j]);
				}
			}
		}
	}
}


/* 
 *Copia la tabla orig en la tabla copia
*/
void copiar(char* orig[DIM][DIM], char* copia[DIM][DIM]) {
	for (int i = 0; i < DIM; i++) {
		for (int j = 0; j < DIM; j++) {
			copia[i][j] = strdup(orig[i][j]);
		}
	}
}
// Devuelve el numero num en base 10
int funcion(int num);


%}

  //nuevo tipo de dato para yylval
%union{
	char* nombre;
}

%token OB CB OP CP PYC FL C EOL STRING //PONER TODOS LOS TOKENS DE LA GRAMATICA, POR EJEMPLO, ID
%start	grafo		//variable inicial 

%token<nombre> NUMBER

%%

grafo:	
		|grafo linea  
		|STRING STRING EOL OB EOL grafo CB 
		;	

linea:	orig FL lista PYC EOL
		;

lista: transiciones 
		|  lista C transiciones
		;

transiciones:	NUMBER OP NUMBER CP { int i; i=atoi(fila); int j; j=atoi($1);tablaTr[funcion(i)][funcion(j)] = $3;
}
		
		;


orig: NUMBER {fila=$1;
}




%%

int yyerror(char* s) {
	printf("%s\n");
	return -1;
}
void mostrarMatriz(char* tablaTr[DIM][DIM]){
	for(int i=0; i<DIM; i++){
		for(int j=0; j<DIM; j++){
			printf("%s,", tablaTr[i][j]);
			
		}
		printf("\n");
	}
	printf("-------------------------------------------------\n");
}

int funcion(int num){
	int b=3;
	int res=0;
	int aux=1;
	while(num>0){
		res+=num%10*aux;
		num/=10;
		aux*=b;
	}
	return res;
}

int main() {
	//inicializar lista transiciones
	listaTr.total = 0;

	//inicializar tabla de adyacencia
	iniTabla(tablaTr);

	//nodo inicial
	char* estadoIni = "000";

	//nodo final
	char* estadoFin = "222";
	
	int error = yyparse();

	
	if (error == 0) {
		//matriz para guardar la potencia
		char* pot[DIM][DIM];
		char* aux[DIM][DIM];
		copiar(tablaTr, pot);
		copiar(tablaTr, aux);
		//calcular movimientos de estadoIni a estadoFin
		int i;
		i=funcion(atoi(estadoIni));
		int j;
		j=funcion(atoi(estadoFin));
		//calculando las potencias sucesivas de tablaTr
		while(strcmp(pot[i][j],"") == 0){
			multiplicar(tablaTr, aux, pot);
			copiar(pot, aux);
		}
		

		printf("Nodo inicial  : %s\n", estadoIni);
		//rellenar los ... con los indices adecuados a vuestro codigo
		printf("Movimientos   : %s\n", pot[i][j]);
		printf("Nodo final    : %s\n", estadoFin);
	}

	return error;
}

