#ifndef TYPES_H
#define TYPES_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define MAX_NAME_LENGTH 256

// Définitions des types pour l'analyse syntaxique
typedef enum {NUM_T, BOOL_T, UKN_T} type_synth;

typedef struct {
    char name[MAX_NAME_LENGTH];
    int type;
} Symbol;

#endif /* TYPES_H */
