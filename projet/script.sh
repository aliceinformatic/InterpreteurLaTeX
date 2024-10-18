#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Erreur syntaxe : $0 <nom_algorithme.tex>"
    exit 1
fi

ALGO_TEX="tex/$1"

make clean

clear

make

chmod +x asipro 

chmod +x sipro 

if [ $? -eq 0 ]; then
    
    ./projet < $ALGO_TEX > projet.asm
    
    if [ $? -eq 0 ]; then
        ./asipro projet.asm projet

        if [ $? -eq 0 ]; then
            ./sipro projet
        else
            echo "Erreur lors de l'assemblage du fichier ASM."
        fi
    else
        echo "Erreur lors de la génération du fichier ASM."
    fi
else
    echo "Erreur lors de la compilation du projet."
fi
