%{
  #include "types.h"
  #include "tsym.h"
  #include "stack_algo.h"
  #include "vglob.h"
  #include "projet.tab.h"
  #include <stdlib.h>
  #include <stdio.h>
  #include <stdbool.h>
  #include <string.h>

  int yylex();
  void yyerror(const char *str);
  void debut();
  void body(tsym *ts);
  void fin();

  //--------------------------VARIABLES-------------------------

  int whileNb = 0;
  int ifNb = 0;
  int forNb = 0;
  int condNb = 0;
  int callNb = 0;
  int currentWhile = 0;
  int currentIf = 0;
  int currentFor = 0;
  int imbWhile = 0;
  int imbIf = 0;
  int imbFor = 0;
  int closeWhile = 0;
  int closeIf = 0;
  int closeFor = 0;

//--------------------------OUTILS-------------------------


//  calc_etq_while : permet de calculer la bonne étiquette pour chaque WHILE,  
//    DOFORI et OD rencontrés dans la lecture de l'algo. Met également à jour
//    les variables permettant de gérer ces étiquettes.


int calc_etq_while() {
  int etq = whileNb;
  if (currentWhile == 1) {
    etq += 1;
  } else {
    etq += imbWhile;
    if (currentWhile != imbWhile && !closeWhile) {
      etq -= (imbWhile - currentWhile);
    }
  }
  currentWhile -= 1;
  if (currentWhile == 0) {
    whileNb += imbWhile;
    imbWhile = 0;
    closeWhile = 0;
  }
  return etq;
}

//  calc_etq_if : permet de calculer la bonne étiquette pour chaque IF et FI 
//    rencontrés dans la lecture de l'algo. Met également à jour les variables
//    permettant de gérer ces étiquettes.


int calc_etq_if() {
  int etq = ifNb;
  if (currentIf == 1) {
    etq += 1;
  } else {
    etq += imbIf;
    if (currentIf != imbIf && !closeIf) {
      etq -= (imbIf - currentIf);
    }
  }
  currentIf -= 1;
  if (currentIf == 0) {
    ifNb += imbIf;
    imbIf = 0;
    closeIf = 0;
  }
  return etq;
}

//  calc_etq_for : permet de calculer la bonne étiquette pour chaque DOFORI
//    rencontrés dans la lecture de l'algo. Met également à jour les variables
//    permettant de gérer ces étiquettes.


int calc_etq_for() {
  int etq = forNb;
  if (currentFor == 1) {
    etq += 1;
  } else {
    etq += imbFor;
    if (currentFor != imbFor && !closeFor) {
      etq -= (imbFor - currentFor);
    }
  }
  currentFor -= 1;
  if (currentFor == 0) {
    forNb += imbFor;
    imbFor = 0;
    closeFor = 0;
  }
  return etq;
}

%}

%union {
  int entier;
  char* id;
  type_synth t_synth;
}

%type <entier> LINT
%type <t_synth> EXPR
%type <t_synth> APPEL

%token OR
%token AND
%token EQ
%token DIFF
%token NOT
%token SUPP_EQ
%token INF_EQ
%token SUPP_STR
%token INF_STR

%token BEG
%token END
%token SET                           
%token IF                             
%token FI                           
%token ELSE                            
%token DOWHILE                       
%token DOFORI                      
%token OD                           
%token CALL                           
%token RETURN

%token <id> ID
%token <entier> NUM
%token <entier> BOOLEAN


%left OR
%left AND
%left EQ DIFF
%left SUPP_EQ INF_EQ SUPP_STR INF_STR
%left '+''-'
%left '*''/'
%left NOT
%start MAIN

%%

LPARAM :
  LPARAM ',' ID {
    tsym_add(ts, $3, 0, 0);
  }
  | ID {
    tsym_add(ts, $1, 0, 0);
  }
  | {}
;

LINT :
  LINT ',' EXPR {
    $$ = $1 + 1;
  } 
  | EXPR {
    $$ = 1;
  }
  | {
    $$ = 0;
  }

EXPR :
  EXPR '+' EXPR {
    if ($1 == NUM_T && $3 == NUM_T) {
      printf("\tpop ax\n");
      printf("\tpop bx\n");
      printf("\tadd ax,bx\n");
      printf("\tpush ax\n");
    } else {
        exit_error(ts, "ADD : Erreur de typage"); 
    }
  }

| EXPR '-' EXPR {
    if ($1 == NUM_T && $3 == NUM_T) {
      printf("\tpop ax\n");
      printf("\tpop bx\n");
      printf("\tsub bx,ax\n");
      printf("\tpush bx\n");
    } else {
        exit_error(ts, "SUB : Erreur de typage"); 
    }
  }

| EXPR '*' EXPR {
    if ($1 == UKN_T) {
        $1 = NUM_T;
    }
    if ($3 == UKN_T) {
        $3 = NUM_T;
    }
  if ($1 == NUM_T && $3 == NUM_T) {
      printf("\tpop ax\n");
      printf("\tpop bx\n");
      printf("\tmul ax,bx\n");
      printf("\tpush ax\n");
  } else {
      exit_error(ts, "MUL : Erreur de typage"); 
  }
}


| EXPR '/' EXPR {
    if ($1 == NUM_T && $3 == NUM_T) {
      printf("\tpop ax\n");
      printf("\tpop bx\n");
      printf("\tconst cx,erreur_div\n");
      printf("\tdiv bx,ax\n");
      printf("\tjmpe cx\n");
      printf("\tpush bx\n");
    } else {
        exit_error(ts, "DIV : Erreur de typage"); 
    }
  }

| '(' EXPR ')'  {}

| EXPR AND EXPR {
  if ($1 == BOOL_T && $3 == BOOL_T) {
    printf("\tpop ax\n");
    printf("\tpop bx\n");
    printf("\tand ax,bx\n");
    printf("\tpush ax\n");
  } else {
      exit_error(ts, "AND : Erreur de typage"); 
  }
}

| EXPR OR EXPR {
  if ($1 == BOOL_T && $3 == BOOL_T) {
    printf("\tpop ax\n");
    printf("\tpop bx\n");
    printf("\tor ax,bx\n");
    printf("\tpush ax\n");
  } else {
      exit_error(ts, "OR : Erreur de typage"); 
  }
}

| EXPR EQ EXPR {
  if (($1 == NUM_T && $3 == NUM_T) || ($1 == BOOL_T && $3 == BOOL_T)) {
    printf("\tconst cx,cond%d\n", condNb);
    printf("\tpop ax\n");
    printf("\tpop bx\n");
    printf("\tcmp ax,bx\n");
    printf("\tjmpc cx\n");
    printf("\tconst ax,0\n");
    printf("\tpush ax\n");
    printf("\tconst cx,fin_cond%d\n", condNb);
    printf("\tjmp cx\n");
    printf(":cond%d\n", condNb);
    printf("\tconst ax,1\n");
    printf("\tpush ax\n");
    printf(":fin_cond%d\n", condNb);
    condNb += 1;
  } else {
      exit_error(ts, "EQUAL : Erreur de typage"); 
  }
}

| EXPR DIFF EXPR {
  if (($1 == NUM_T && $3 == NUM_T) || ($1 == BOOL_T && $3 == BOOL_T)) {
    printf("\tconst cx,cond%d\n", condNb);
    printf("\tpop ax\n");
    printf("\tpop bx\n");
    printf("\tcmp ax,bx\n");
    printf("\tjmpc cx\n");
    printf("\tconst ax,1\n");
    printf("\tpush ax\n");
    printf("\tconst cx,fin_cond%d\n", condNb);
    printf("\tjmp cx\n");
    printf(":cond%d\n", condNb);
    printf("\tconst ax,0\n");
    printf("\tpush ax\n");
    printf(":fin_cond%d\n", condNb);
    condNb += 1;
  } else {
      exit_error(ts, "DIFF : Erreur de typage"); 
  }
}

| NOT EXPR {
  if ($2 == BOOL_T) {
    printf("\tconst cx,cond%d\n", condNb);
    printf("\tconst bx,0\n");
    printf("\tpop ax\n");
    printf("\tcmp ax,bx\n");
    printf("\tjmpc cx\n");
    printf("\tconst ax,0\n");
    printf("\tpush ax\n");
    printf("\tconst cx,fin_cond%d\n", condNb);
    printf("\tjmp cx\n");
    printf(":cond%d\n", condNb);
    printf("\tconst ax,1\n");
    printf("\tpush ax\n");
    printf(":fin_cond%d\n", condNb);
    condNb += 1;
  } else {
      exit_error(ts, "NOT : Erreur de typage"); 
  }
}

| EXPR SUPP_EQ EXPR {
  if ($1 == NUM_T && $3 == NUM_T) {
    printf("\tconst cx,cond%d\n", condNb);
    printf("\tpop ax\n");
    printf("\tpop bx\n");
    printf("\tsless bx,ax\n");
    printf("\tjmpc cx\n");
    printf("\tconst ax,1\n");
    printf("\tpush ax\n");
    printf("\tconst ax,fin_cond%d\n", condNb);
    printf("\tjmp ax\n");
    printf(":cond%d\n", condNb);
    printf("\tconst ax,0\n");
    printf("\tpush ax\n");
    printf(":fin_cond%d\n", condNb);
    condNb += 1;
  } else {
      exit_error(ts, "SUPP_EQ : Erreur de typage"); 
  }
}

| EXPR SUPP_STR EXPR {
  if ($1 == NUM_T && $3 == NUM_T) {
    printf("\tconst cx,cond%d\n", condNb);
    printf("\tpop ax\n");
    printf("\tpop bx\n");
    printf("\tsless ax,bx\n");
    printf("\tjmpc cx\n");
    printf("\tconst ax,0\n");
    printf("\tpush ax\n");
    printf("\tconst ax,fin_cond%d\n", condNb);
    printf("\tjmp ax\n");
    printf(":cond%d\n", condNb);
    printf("\tconst ax,1\n");
    printf("\tpush ax\n");
    printf(":fin_cond%d\n", condNb);
    condNb += 1;
  } else {
    exit_error(ts, "SUPP_STR : Erreur de typage"); 
  }
}

| EXPR INF_EQ EXPR {
  if ($1 == NUM_T && $3 == NUM_T) {
    printf("\tconst cx,cond%d\n", condNb);
    printf("\tpop ax\n");
    printf("\tpop bx\n");
    printf("\tsless ax,bx\n");
    printf("\tjmpc cx\n");
    printf("\tconst ax,1\n");
    printf("\tpush ax\n");
    printf("\tconst cx,fin_cond%d\n", condNb);
    printf("\tjmp cx\n");
    printf(":cond%d\n", condNb);
    printf("\tconst ax,0\n");
    printf("\tpush ax\n");
    printf(":fin_cond%d\n", condNb);
    condNb += 1;
  } else {
      exit_error(ts, "INF_EQ : Erreur de typage"); 
  }
}

| EXPR INF_STR EXPR {
  if ($1 == NUM_T && $3 == NUM_T) {
    printf("\tconst cx,cond%d\n", condNb);
    printf("\tpop ax\n");
    printf("\tpop bx\n");
    printf("\tsless bx,ax\n");
    printf("\tjmpc cx\n");
    printf("\tconst ax,0\n");
    printf("\tpush ax\n");
    printf("\tconst cx,fin_cond%d\n", condNb);
    printf("\tjmp cx\n");
    printf(":cond%d\n", condNb);
    printf("\tconst ax,1\n");
    printf("\tpush ax\n");
    printf(":fin_cond%d\n", condNb);
    condNb += 1;
  } else {
      exit_error(ts, "INF_STR : Erreur de typage"); 
  }
}

| NUM {
    printf("\tconst ax,%d\n", $1);
    printf("\tpush ax\n");
    $$ = NUM_T;
}

| BOOLEAN { 
		printf("\tconst ax,%d\n", $1);
		printf("\tpush ax\n"); 
		$$ = BOOL_T; 
}

| ID {
    ctsym *p = tsym_search(ts, $1);
    if (p == NULL) {
      exit_error(ts, "ID : Erreur variable");
    } else {
        if (p->type == 0) {
        $$ = NUM_T;
      } else {
        $$ = BOOL_T;
      }
      int n = (p->genre == 0 ? (4 + 2*(ts->np) - 2*(p->ind))   //Calcul pour trouver la variable dans
                             : (2 + 2*(ts->np) + 2*(p->ind))); //la pile des algorithmes
      printf("\tcp ax,bp\n");
      printf("\tconst bx,%d\n", n);
      printf("\tsub ax,bx\n");
      printf("\tloadw bx,ax\n");
      printf("\tpush bx\n");
    }
  }

| APPEL {}
;

MAIN:
    MAIN ALGO
  | ALGO
;

ALGO : 
  BEG '{' ID '}' { 
    nb_algo += 1;
    new_algo($3);
    init_algo(ts);
  }
  '{' LPARAM '}' BLOC END {}
;

BLOC:
    BLOC INSTR
  | INSTR
;

INSTR :
//--------------------------SET-------------------------

  SET '{' ID '}' '{' EXPR '}' {
    tsym_add(ts, $3, 1, $6);
    ctsym *p = tsym_search(ts, $3);
    int n = (p->genre == 0 ? (4 + 2*(ts->np) - 2*(p->ind))
                           : (2 + 2*(ts->np) + 2*(p->ind)));
    printf("\tcp ax,bp\n");
    printf("\tconst bx,%d\n", n);
    printf("\tsub ax,bx\n");
    printf("\tpop bx\n");
    printf("\tstorew bx,ax\n");
  }

//--------------------------IF-------------------------

|IF {
  currentIf += 1; 
  imbIf += 1;
  if (currentIf != imbIf) {
    closeIf = 1;
  }
} 
  '{' EXPR '}' {
  printf("\tpop ax\n");
  printf("\tconst cx,fin_if%d\n", ifNb + imbIf);
  printf("\tconst bx,0\n");
  printf("\tcmp ax,bx\n");
  printf("\tjmpc cx\n");
  printf(":if%d\n", ifNb + imbIf);
  } BLOC SSI

//--------------------------WHILE-------------------------

|DOWHILE {
  currentWhile += 1;
  imbWhile += 1;
  if (currentWhile != imbWhile) {
    closeWhile = 1;
  }
  printf(":while%d\n", whileNb + imbWhile);
  printf("\tconst ax,1\n");
  printf("\tpush ax\n");
}   

'{' EXPR '}' {
  printf("\tpop ax\n");
  printf("\tpop bx\n");
  printf("\tconst cx,corps_while%d\n", whileNb + imbWhile);
  printf("\tcmp ax,bx\n");
  printf("\tjmpc cx\n");
  printf("\tconst cx,fin_while%d\n", whileNb + imbWhile);
  printf("\tjmp cx\n");
  printf(":corps_while%d\n", whileNb + imbWhile);
} BLOC {
    printf("\tconst cx,while%d\n", whileNb + imbWhile);
    printf("\tjmp cx\n");
  }

  OD {
    printf(":fin_while%d\n\n", calc_etq_while());
  }

//--------------------------FOR-------------------------

|DOFORI '{' ID '}' {
  currentFor += 1; 
  imbFor += 1;
  if (currentFor != imbFor) {
    closeFor = 1;
    }
  }
  '{' EXPR '}' {
    tsym_add(ts, $3, 1, 0);
    ctsym *p = tsym_search(ts, $3);
    int n = (p->genre == 0 ? (4 + 2*(ts->np) - 2*(p->ind)) 
                           : (2 + 2*(ts->np) + 2*(p->ind)));
    printf("\tcp ax,bp\n");
    printf("\tconst bx,%d\n", n);
    printf("\tsub ax,bx\n");
    printf("\tpop bx\n");
    printf("\tstorew bx,ax\n");
    printf(":for%d\n", forNb + imbFor);
  }
  '{' EXPR '}' {
    if ($11 != NUM_T) {
      exit_error(ts,"\\DOFORI : Erreur variable");
    }
    ctsym *p = tsym_search(ts, $3);
    int n = (2 + 2*(ts->np) + 2*(p->ind));
    printf("\tcp ax,bp\n");
    printf("\tconst bx,%d\n", n);
    printf("\tsub ax,bx\n");
    printf("\tloadw bx,ax\n");
    printf("\tpush bx\n");
    printf("\tpop ax\n");
    printf("\tpop bx\n");
    printf("\tconst cx,1\n");
    printf("\tadd bx,cx\n");
    printf("\tconst cx,corps_for%d\n", forNb + imbFor);
    printf("\tsless ax,bx\n");
    printf("\tjmpc cx\n");
    printf("\tconst cx,fin_for%d\n", forNb + imbFor); 
    printf("\tjmp cx\n");
    printf(":corps_for%d\n", forNb + imbFor);
  }
  BLOC {
    ctsym *p = tsym_search(ts, $3);
    int n = (2 + 2*(ts->np) + 2*(p->ind));
    printf("\tcp ax,bp\n");
    printf("\tconst bx,%d\n", n);
    printf("\tsub ax,bx\n");
    printf("\tloadw bx,ax\n");
    printf("\tpush bx\n");
    printf("\tpop ax\n");
    printf("\tconst bx,1\n");
    printf("\tadd ax,bx\n");
    printf("\tpush ax\n");
    printf("\tcp ax,bp\n");
    printf("\tconst bx,%d\n", n);
    printf("\tsub ax,bx\n");
    printf("\tpop bx\n");
    printf("\tstorew bx,ax\n");
    printf("\tconst cx,for%d\n", forNb + imbFor);
    printf("\tjmp cx\n");
  }
  OD {
    printf(":fin_for%d\n\n", calc_etq_for());
  }
  
//--------------------------RETURN-------------------------

|RETURN '{' EXPR '}' {
  int n = 4 + 2*(ts->np) + 2*(ts->nvl);
  printf("\tcp ax,bp\n");
  printf("\tconst bx,%d\n", n);
  printf("\tsub ax,bx\n");
  printf("\tpop bx\n");
  printf("\tstorew bx,ax\n");
  end_algo();
}

//--------------------------CALL-------------------------

|APPEL {
  printf("\tconst ax,rec\n");
  printf("\tcallprintfs ax\n");
  printf("\tconst ax,space\n");
  printf("\tcallprintfs ax\n");
  printf("\tcp ax,sp\n");
  printf("\tcallprintfd ax\n");
  printf("\tconst ax,nl\n");
  printf("\tcallprintfs ax\n");
  printf("\tpop ax\n");
}
;

APPEL :
  CALL '{' ID '}' {
    for (int i = 0; i < nb_algo; i++) {
      if (strcmp(tds[i]->algo, $3) == 0) {
        i += nb_algo;
      }
      if (i == nb_algo - 1) {
        exit_error(ts, "\\CALL : Erreur nom algo");
      }
    }
    callNb += 1;
    //tsym_print(ts);
    tsym *p = tsym_find(*tds, $3);
    tsym_print(p);
    printf(";Début CALL\n");
    printf("\tconst ax,0\n");
    for (int i = 0; i <= p->nvl; i++) {
      printf("\tpush ax\n");
    }
  }

  '{' LINT '}' {
    tsym *p = tsym_find(*tds, $3);
    if ($7 != p->np) {
      exit_error(ts, "\\CALL : Erreur nombre de paramètres");
    }

    stack_algo_put(stack, p);
    ts = stack->head->ts;

    printf("\tconst ax,%s\n", ts->algo);
    printf("\tcall ax\n");
    printf(":fin_rec%d\n", callNb);

    for (int i = 0; i < (ts->np + ts->nvl); i++) {
      printf("\tpop ax\n");
    }
    printf(";Fin CALL\n");
    stack_algo_remove(stack);
    ts = stack->head->ts;
    $$ = UKN_T;
  }
;

//--------------------------ELSE/FI-------------------------


SSI :
  ELSE {
    printf("\tconst cx,fin_else%d\n", ifNb + imbIf);
    printf("\tjmp cx\n");
    printf(":fin_if%d\n", ifNb + imbIf);
  }

  BLOC FI {
    printf(":fin_else%d\n", calc_etq_if());
  }

| FI {
    printf(":fin_if%d\n", calc_etq_if());
  }
;
//-----------------------------------------------------------
%%
void yywrap() {
  //ne fait rien
}

void debut() {
  printf("\n\n:val\n@int 0\n");
  if (ts->np > 1) {
    printf("\n:phrase1\n");
    printf("@string \"\\nEntrez %d valeurs :\\n\"", ts->np);
  } else if (ts->np == 1) {
    printf("\n:phrase1.5\n");
    printf("@string \"\\nEntrez une valeur :\\n\"");
  }
  printf("\n:debug\n");
  printf("@string \"DEBUG\\n\"");
  printf("\n:s_res\n");
  printf("@string \"\\nLe résultat est :\\n\"");
  printf("\n:erreur_div\n");
  printf("@string \"Erreur division par 0 interdite\\n\"");
  printf("\n:rec\n");
  printf("@string \"Résultat n°%d :\"", callNb);
  printf("\n\n:errdiv\n");
  printf("\tconst ax,erreur_div\n");
  printf("\tcallprintfs ax\n");
  printf("\tend\n");
  printf("\n\n:main\n");
  printf("\tconst bp,pile\n");
  printf("\tconst sp,pile\n");
  printf("\tconst cx,2\n");
  printf("\tsub sp,cx\n\n");
}

void body(tsym *ts) {
  printf("\tconst ax,0\n");
  for (int i = 0; i <= ts->nvl; i++) {
    printf("\tpush ax\n");
  }
  if (ts->np == 1) {
    printf("\tconst ax,phrase1.5\n");
    printf("\tcallprintfs ax\n");
  } else if (ts->np > 1) {
    printf("\tconst ax,phrase1\n");
    printf("\tcallprintfs ax\n");
  }
  for (int i = 0; i < ts->np; i++) {
    printf("\tconst ax,val\n");
    printf("\tcallscanfd ax\n");
    printf("\tloadw bx,ax\n");
    printf("\tpush bx\n");
  }
  printf("\tconst ax,%s\n", ts->algo);
  printf("\tcall ax\n");
  for (int i = 0; i < (ts->np + ts->nvl); i++) {
    printf("\tpop ax\n");
  }
}

void fin() {
  printf("\n\tconst ax,s_res\n");
  printf("\tcallprintfs ax\n");
  printf("\tcp ax,sp\n");
  printf("\tcallprintfd ax\n");
  printf("\tpop ax\n");
  printf("\tconst ax,nl\n");
  printf("\tcallprintfs ax\n");
  printf("\tend\n");
  printf(":pile\n");
  printf("@int 0\n");
}

void yyerror(const char *str) {
	fprintf(stderr, "%s\n", str);
}

int main(void) {
  stack = stack_algo_empty();
  if (stack == NULL) {
      fprintf(stderr, "Erreur lors de la création de la liste d'algorithmes\n");
      return EXIT_FAILURE;
  }
  
  printf("\tconst ax,main\n");
  printf("\tjmp ax\n");
  printf("\n\n:nl\n");
  printf("@string \"\\n\"");
  printf("\n:space\n");
  printf("@string \" \"");
  printf("\n\n");

  yyparse();
  debut();
  body(ts);
  fin();

  tsym_free(ts);
  return EXIT_SUCCESS;
}