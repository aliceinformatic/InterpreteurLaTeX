#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "stack_algo.h"

stack_algo *stack_algo_empty() {
  stack_algo *stack = malloc(sizeof *stack);
  if (stack == NULL) {
    return NULL;
  }

  stack->head = NULL;
  stack->nb = 0;
  return stack;
}

int stack_algo_put(stack_algo *stack, tsym *p) {
  cstack_algo *ca = malloc(sizeof *ca);
  if (ca == NULL || stack == NULL) {
    return -1;
  }

  ca->ts = p;
  ca->next = stack->head;
  stack->head = ca;
  stack->nb += 1;
  return 0;
}

int stack_algo_remove(stack_algo *stack) {
  if (stack == NULL || stack->head == NULL) {
    return -1;
  }

  cstack_algo *ca = stack->head;
  stack->head = stack->head->next;
  ca->next = NULL;
  stack->nb -= 1;
  return 0;
}

void stack_algo_print(stack_algo *stack) {
  if (stack == NULL) {
    return;
  }

  cstack_algo *p = stack->head;
  while(p != NULL) {
    printf(";>%s\n", p->ts->algo);
    p = p->next;
  }
}

void stack_algo_free(stack_algo *stack) {
  if (stack == NULL) {
      return;
  }

  cstack_algo *current = stack->head;
  cstack_algo *next;
  while (current != NULL) {
    next = current->next;
    free(current->ts);
    free(current);
    current = next;
  }

  free(stack);
}


tsym *tsym_find(tsym *tab, const char *s) {
  for (int i = 0; i < nb_algo; i++) {
    if (strcmp(tab[i].algo, s) == 0) {
      tsym *p = &tab[i];
      return p;
    }
  }
  return NULL;
} 

void new_algo(const char *s) {
  tsym *p = tsym_empty(s);
  tds[nb_algo - 1] = p;
  ts = p;
  stack_algo_remove(stack);
  stack_algo_put(stack, ts);
}

void init_algo(tsym *ts) {
  printf("\n\n; Algorithme %s\n", ts->algo);
  printf(":%s\n", ts->algo);
  printf("\tpush bp\n");
  printf("\tcp bp,sp\n");
  printf("\n");
}

void end_algo() {
  printf("\n\tpop bp\n");
  printf("\tret\n");
}

void exit_error(tsym *ts, const char *s) {
  fprintf(stderr,"Erreur %s\n", s);
  tsym_free(ts);
  exit(EXIT_FAILURE);
}
