%{
  #include "types.h"
  #include "projet.tab.h"
  #include <stdlib.h>
  #include <stdio.h>
  #include <string.h>
  int strtoEntier(const char *);
  char *strdup2(const char *str);
//.                                 {fprintf(stderr,"Caractère inconnu : %c\n", yytext[0]);}
%}

%option noyywrap

%%
"\\begin\{algo\}"                   {return BEG;}
"\\end\{algo\}"                     {return END;}

"true"                              {yylval.entier = 1; return BOOLEAN;}
"false"                             {yylval.entier = 0; return BOOLEAN;}

[1-9][0-9]*|[0]                     {yylval.entier = strtoEntier(yytext); return NUM;}
[a-zA-Z][a-zA-Z0-9_]*               {yylval.id = strdup2(yytext); return ID;}

"\\SET"                             {return SET;}
"\\IF"                              {return IF;}
"\\FI"                              {return FI;}
"\\ELSE"                            {return ELSE;}
"\\DOWHILE"                         {return DOWHILE;}
"\\DOFORI"                          {return DOFORI;}
"\\OD"                              {return OD;}
"\\CALL"                            {return CALL;}
"\\RETURN"                          {return RETURN;}

"!"                                 {return NOT;}
"&&"                                {return AND;}
"||"                                {return OR;}
">="                                {return SUPP_EQ;}
">"                                 {return SUPP_STR;}
"<="                                {return INF_EQ;}
"<"                                 {return INF_STR;}
"=="                                {return EQ;}
"!="                                {return DIFF;}

"+"|"-"|"*"|"/"|"("|")"|"{"|"}"|"," {return yytext[0];}

.|\n                                {}
%%

int strtoEntier(const char *s) {
  return strtol(s, NULL, 10);
}

char *strdup2(const char *str) {
  if (str == NULL) {
    return NULL;
  }
  char *n_str = (char *)malloc(strlen(str) +1);
  if (n_str == NULL) {
    return NULL;
  }
  strcpy(n_str, str);
  return n_str;
}