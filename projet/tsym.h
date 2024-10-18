#ifndef TSYM_H
#define TSYM_H

#include <stdlib.h>
#include <stdio.h>

typedef struct tsym tsym; 
typedef struct ctsym ctsym;


// Structure d'une table des symboles


struct tsym {
  char *algo;     
  int np;         // Nombre de paramètres
  int nvl;        // Nombre de variables locales
  ctsym *phead;   
  ctsym *ptail;   
  ctsym *lhead;   
  ctsym *ltail;   
  int valretour;  // Type de valeur de retour : 0 => int, 1 => booléen
};

struct ctsym {
  char *nom; 
  int type; 
  int genre; 
  int ind;
  ctsym *next;
  ctsym *prev;
};

// Crée une table des symboles initialement vide
extern tsym *tsym_empty(const char *algo);

// Ajoute une variable dans la table des symboles associée
extern int tsym_add(tsym *ts, const char *nom, int genre, int type);

// Retire une variable de la table des symboles
extern int tsym_remove(tsym *ts, const char *nom);

// Met à jour les indices des cellules à partir de la cellule donnée
extern void tsym_id_update(ctsym *c);

// Met à jour la valeur de retour de la table des symboles associée
extern void tsym_return_update(tsym *ts, int val);

// Recherche une variable dans la table des symboles associée
extern ctsym *tsym_search(tsym *ts, const char *nom);

// Affiche les informations de la table des symboles associée
extern void tsym_print(tsym *ts);

// Libère les ressources allouées pour la table des symboles
extern int tsym_free(tsym *ts);


#endif /* TSYM_H */