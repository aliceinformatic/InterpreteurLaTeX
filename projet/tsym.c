#include <stdio.h>
#include <string.h>
#include "tsym.h"

tsym *tsym_empty(const char *algo) {
  tsym *ts = malloc(sizeof *ts);
  if (ts == NULL) {
    return NULL;
  }

  ts->phead = NULL;
  ts->ptail = NULL;
  ts->lhead = NULL;
  ts->ltail = NULL;

  ts->np = 0;
  ts->nvl = 0;
  ts->valretour = 0;
  ts->algo = malloc(strlen(algo) + 1);
  strcpy(ts->algo, algo);
  return ts;
}

int tsym_add(tsym *ts, const char *nom, int genre, int type) {
  if (tsym_search(ts, nom) != NULL) {
    return 1;
  }

  ctsym *ct = malloc(sizeof *ct);
  if (ct == NULL) {
    return -1;
  }
  ct->genre = genre;
  ct->type = type;
  ct->nom = malloc(strlen(nom) + 1);
  strcpy(ct->nom, nom);
  ct->next = NULL;

  if (genre == 0) {
    if (ts->phead == NULL) {
      ts->phead = ct;
      ts->ptail = ct;
      ct->prev = NULL;
    } else {
      ts->ptail->next = ct;
      ct->prev = ts->ptail;
      ts->ptail = ct;
    }
    ts->np += 1;
    ct->ind = ts->np;
  } else if (genre == 1) {
      if (ts->lhead == NULL) {
        ts->lhead = ct;
        ts->ltail = ct;
        ct->prev = NULL;
      } else {
        ts->ltail->next = ct;
        ct->prev = ts->ltail;
        ts->ltail = ct;
      }
    ts->nvl += 1;
    ct->ind = ts->nvl;
  }
  return 0;
}

void tsym_ind_update(ctsym *c) {
  while (c != NULL) {
    c->ind -= 1;
    c = c->next;
  }
}

int tsym_remove(tsym *ts, const char *nom) {
    if (ts == NULL || nom == NULL) {
        return -1;
    }

    ctsym *p = tsym_search(ts, nom);
    if (p == NULL) {
        return 1;
    }

    if (p->prev != NULL) {
        p->prev->next = p->next;
    } else {
        if (p->genre == 0) {
            ts->phead = p->next;
        } else {
            ts->lhead = p->next;
        }
    }

    if (p->next != NULL) {
        p->next->prev = p->prev;
    } else {
        if (p->genre == 0) {
            ts->ptail = p->prev;
        } else {
            ts->ltail = p->prev;
        }
    }
    tsym_ind_update(p->next);

    if (p->genre == 0) {
        ts->np -= 1;
    } else {
        ts->nvl -= 1;
    }
    free(p->nom);
    free(p);
    return 0;
}


ctsym *tsym_search(tsym *ts, const char *nom) {
  if ((ts->np + ts->nvl != 0) && nom != NULL && ts != NULL) {
    int c = 0;
    ctsym *p = ts->phead;
    while (c < 2) {
      if (p == NULL) {
        p = ts->lhead;
        c += 1;
      } else {
        if (strcmp(p->nom, nom) == 0) {
          return p;
        }
        p = p->next;
      }
    }
  }
  return NULL;
}

void tsym_print(tsym *ts) {
  if (ts == NULL) {
    return;
  }

  ctsym *p = ts->phead; // Parcours de la liste des paramètres à partir de la tête
  ctsym *q = ts->lhead; // Parcours de la liste des variables locales à partir de la tête
  printf("\n\n;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
  printf(";\tTable des symboles\n");
  printf("\n\n;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
  printf(";algo : \t%s\n", ts->algo);
  printf(";np : \t\t%d\n;ntsoc : \t%d\n", ts->np, ts->nvl);
  printf(";valretour : \t%d -> %s\n;;;;;;;\n", ts->valretour, (ts->valretour == 0 ? "int" : "boolean"));
  while (p != NULL) {
    printf(";para %d %s\t%s\n", p->ind, p->nom, (p->type == 0 ? "int" : "boolean"));
    p = p->prev;
  }
  printf("\n");
  while (q != NULL) {
    printf(";tsoc %d %s\t%s\n", q->ind, q->nom, (q->type == 0 ? "int" : "boolean"));
    q = q->next;
  }
  printf(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n");
}


int tsym_free(tsym *ts) {
  if (ts == NULL) {
    return -1;
  }
  
  free(ts->algo);
  ctsym *p = ts->phead;

  while (p != NULL) {
    free(p->nom);
    ctsym *q1 = p;
    p = p->next;
    free(q1);
  }
  p = ts->lhead;

  while (p != NULL) {
    free(p->nom);
    ctsym *q2 = p;
    p = p->next;
    free(q2);
  }
  free(ts);
  ts = NULL;
  return 0;
}

void tsym_return_update(tsym *ts, int nom) {
  if (ts == NULL || nom > 1 || nom < 0) {
    fprintf(stderr, "Erreur : Problème de nom ou de structure\n");
  }

  ts->valretour = nom;
}

