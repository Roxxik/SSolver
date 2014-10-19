#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define arraySize(x) (sizeof(x) / sizeof(x[0]))
typedef unsigned long int TTileVal;
typedef unsigned char TCoordinate;
typedef enum {North, West, South, East} TStep;
typedef signed char TOffset;
typedef TTileVal **TField;

void setTile (TField Field, TCoordinate i, TCoordinate j, TTileVal Value) {
	Field[i][j] = Value;
}

TTileVal tileValue (TField Field, TCoordinate i, TCoordinate j) {
	return Field[i][j];
}

void getOffset(TStep Step, TOffset *x, TOffset *y) {
	switch (Step) {
		case North: *x = 0;
					*y =-1;
					break;
		case West:	*x =-1;
					*y = 0;
					break;
		case South:	*x = 0;
					*y = 1;
					break;
		case East:	*x = 1;
					*y = 0;
					break;
	}
}

TTileVal neighbour (TField Field, TCoordinate i, TCoordinate j, TStep Step) {
	TOffset x, y;
	getOffset(Step,&x,&y);
	return tileValue(Field,i+x,j+y);
}

bool isNumber (char c) {
	char m = '0';
	bool b = false;
	int i;
	for (i=0;i<=9;i++) {
		if (c == m++) {
			b = true;
		}
	}
	return b;
}

void nextTile (TCoordinate c, TCoordinate *i, TCoordinate *j) {
	if (*j == c) {
		if (*i == c) {
			*i = 0;
		} else {
			*j += 1;
		}
		*i = 0;
	} else {
		*i += 1;
	}
}

void printField (TField Field,TCoordinate c) {
	printf("hi");
	TCoordinate i = 0;
	TCoordinate j = 0;
	int k;
	printf("%d",i);
	for (k = 1;k<=c*c;k++) {
		printf("%d",k);
		printf("%lu, ", tileValue(Field,i,j));
		if (j == c)
			printf("\n");
		nextTile(c,&i,&j);
	}
		
}

int main(void) {
	printf("start\n");
	TField matrix;
	TCoordinate i;
	TCoordinate j;
	TCoordinate c = 4;
	printf("allocating\n");
	matrix = malloc(c*sizeof(TTileVal));
	for(i = 0; i < c; i++) {
		matrix[i] = malloc(c * sizeof(int));
	}
	printf("initializing\n");
	for (i = 0; i < c; i++)
		for (j = 0; j < c; j++)
			matrix[i][j] = i + j+3;
	printf("printing\n");
	printField(matrix,c);

	/*
	printf("free\n");
	for(i = 0; i < c; i++)
		free(matrix[i]);
	printf("zeilen frei\n");
	free(matrix);*/
	return 0;
}
