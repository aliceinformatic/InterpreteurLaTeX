# Compilation de main2.c
gcc -std=c99 -Wall -Wextra -o main2 main2.c ../tsym.c

# Vérification si la compilation de main2.c a réussi
if [ $? -eq 0 ]; then
    echo "Compilation de main2.c réussie."
else
    echo "Erreur lors de la compilation de main2.c."
    exit 1
fi

./main2