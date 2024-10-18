#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../stack_algo.h"
#include "../tsym.h"
#include "../vglob.h"

//chmod +x stack_algo.sh 
//./stack_algo.sh

int main() {
    stack_algo *liste_algo = stack_algo_empty();

    tsym *algo1 = tsym_empty("Algorithme1");
    tsym *algo2 = tsym_empty("Algorithme2");
    tsym *algo3 = tsym_empty("Algorithme3");

    stack_algo_put(liste_algo, algo1);
    stack_algo_put(liste_algo, algo2);
    stack_algo_put(liste_algo, algo3);

    printf("Liste des algorithmes :\n");
    stack_algo_print(liste_algo);

    stack_algo_remove(liste_algo);

    printf("\nListe des algorithmes après suppression du premier :\n");
    stack_algo_print(liste_algo);

    free(algo1);
    free(algo2);
    free(algo3);
    free(liste_algo);

    return 0;
}

