#ifndef MEM_H
#define MEM_H

#include <string.h>

char variable_names[100][100] = {{0}};
int variable_set[100];
int variable_counter = 0; 

double variable_values[100];


int add_variable(char* var_name)
{
	int x; 
	
	
	for (x = 0; x<variable_counter; x++) {
		if (strcmp(var_name, variable_names[x]) == 0) {
				return x;
		}
	}

	variable_counter++;
	strcpy(variable_names[x], var_name);
	return x;
}

int set_variable(int index, double val)
{
	variable_values[index] = val;
	variable_set[index] = 1;
	
	return val;
}

#endif