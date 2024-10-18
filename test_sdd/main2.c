#include <stdio.h>
#include <stdlib.h>
#include "../tsym.h"


//chmod +x tsym.sh 
//./tsym.sh

int main() {

    tsym *table_symboles = tsym_empty("Exemple");

    tsym_add(table_symboles, "variable1", 0, 0);
    tsym_add(table_symboles, "variable2", 1, 1);

    tsym_print(table_symboles);

    tsym_remove(table_symboles, "variable1");

    tsym_print(table_symboles);

    tsym_return_update(table_symboles, 1);

    tsym_print(table_symboles);

    tsym_free(table_symboles);

    return 0;
}
