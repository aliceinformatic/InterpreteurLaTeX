#!/bin/bash

# Compilation de main.c
gcc -std=c99 -Wall -Wextra -o main main.c ../stack_algo.c ../tsym.c

# Vérification si la compilation de main.c a réussi
if [ $? -eq 0 ]; then
    echo "Compilation de main.c réussie."
else
    echo "Erreur lors de la compilation de main.c."
    exit 1
fi

./main