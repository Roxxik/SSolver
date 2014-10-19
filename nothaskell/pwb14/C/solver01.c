#include <stdio.h>

int main(void) {
	int k;
	int i = 0;
	char input;
	for (k = 0;;k++) {
		switch (i) {
			case 0: printf("N");
					break;
			case 1: printf("W");
					break;
			case 2: printf("S");
					break;
			case 3: printf("E");
					break;
		}
		i = 0;
		input = fgetc(stdin);
		if (input == '0') {
			i = 1;
		} else {
			i = 2;
		}
	}
}
