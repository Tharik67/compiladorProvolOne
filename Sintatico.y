%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "y.tab.h"
  #include "lista.h"

  extern FILE * yyin;
  FILE * file_out;
  int tab = 0;
  int lines = 0;
  Lista * entradas;
  Lista * saidas;

  int yylex();

  void yyerror(const char * s) {
    fprintf(stderr, "%s\n", s);
  };

  void insere_entradas(char * var){
    //printf("%s\n",var);
    lst_insFin(entradas,var);
    //exibeLista(entradas);
  }

  void insere_saidas(char * var){
    lst_insFin(saidas,var);
  }

  void tabula(){
    int i;
    for (i=0; i<tab; i++)
      fprintf(file_out,"\t");
  }

  void escreve_tab(char * str){
    tabula();
    fprintf(file_out,"%s",str);
    lines++;
  }

  void escreve(char * str){
    fprintf(file_out,"%s",str);
    lines++;
  }

  void escreve2_tab(char * str, char * str2){
    tabula();
    fprintf(file_out,"%s",str);
    fprintf(file_out,"%s",str2);
    lines++;
  }

  void escreve2(char * str, char * str2){
    fprintf(file_out,"%s",str);
    fprintf(file_out,"%s",str2);
    lines++;
  }

  void abre_enquanto(char * var) {
    tabula();
    fprintf(file_out,"while (%s) {\n",var);
    tab++;
    lines++;
  }

  void fecha_enquanto(){
    //tab--; tabula(); fprintf(file_out,"}\n"); lines++;
    tab--;
    tabula();
    fprintf(file_out,"}\n");
    lines++;
  }

  void write_init_program(){
    tab++;
    lines++;
    fprintf(file_out,"int main(void){\n");
    tabula();
    fprintf(file_out,"int ");
  }

  void write_end_program(){
    tabula();
    fprintf(file_out,"return(0);\n}\n");
    //printf("Lines: %d\n", lines);
  }
%}

%start program
%token ENTRADA
%token SAIDA
%token FIM
%token id
%token ENQUANTO
%token FACA
%token INC
%token ZERA

%union { char * word; }
%type <word> varlist_in
%type <word> varlist_out
%type <word> id
%type <word> cmd

%%
program: ENTRADA { write_init_program(); } varlist_in { exibeLista(entradas); } SAIDA varlist_out cmds FIM { write_end_program(); return(0); }

varlist_in: id',' { insere_entradas($1); escreve($1); } varlist_in
         | id';' { insere_entradas($1); escreve2($1,"\n"); lines++;}

varlist_out: varlist_out id';' { lines++; } 
        | id',' { }

cmds: cmd cmds | cmd

cmd: ENQUANTO id { abre_enquanto($2); } FACA cmds FIM { fecha_enquanto();}

cmd: id '=' id { tabula(); fprintf(file_out,"%s;\n",$$); } 
     | INC id { escreve2_tab($2,"++;\n"); }
     | ZERA id { escreve2_tab($2," = 0;\n");}
%%

int main(int argc, char * argv[]) {
  FILE * file_in = fopen(argv[1],"r");
  file_out = fopen("saida.txt","w");
  entradas = lst_cria();

  if(!file_in){
    printf("Erro na leitura do arquivo!\n");
    exit(1);
  }

  yyin = file_in;
  yyparse();

  fclose(file_in);
  fclose(file_out);
  return(0);
}