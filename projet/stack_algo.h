#ifndef STACK_ALGO_H
#define STACK_ALGO_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tsym.h"

extern tsym *ts;
extern tsym *tds[10];
extern int nb_algo;

typedef struct stack_algo stack_algo;
typedef struct cstack_algo cstack_algo;

// Structure des listes d'algo
struct stack_algo {
  cstack_algo *head;
  int nb;
};

struct cstack_algo {
  tsym *ts;
  cstack_algo *next;
};

extern stack_algo *stack;

// Crée une liste d'algorithmes vide
extern stack_algo *stack_algo_empty();

// Ajoute une liste de variables à la liste d'algorithmes
extern int stack_algo_put(stack_algo *stack, tsym *p);

// Retire une liste de variables de la liste d'algorithmes
extern int stack_algo_remove(stack_algo *stack);

// Affiche les listes d'algorithmes
extern void stack_algo_print(stack_algo *stack);  

// Libère la mémoire allouée pour la liste d'algorithmes
extern void stack_algo_free(stack_algo *stack);

// Recherche un algorithme dans une liste de variables
extern tsym *tsym_find(tsym *tab, const char *s);

// Crée un nouvel algorithme avec le nom donné
extern void new_algo(const char *s);

// Finalise l'algorithme en cours
extern void end_algo();

// Initialise un algorithme avec la liste de symboles donnée
extern void init_algo(tsym *ts);

// Fonction de sortie en cas d'erreur avec le message donné
extern void exit_error(tsym *ts, const char *s);


#endif /* STACK_ALGO_H */
