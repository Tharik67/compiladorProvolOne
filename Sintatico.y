%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  //#include "y.tab.h"
  #include "lista.h"

  extern FILE * yyin;
  FILE * file_out;
  int tab = 0;
  int lines = 1;
  char *command;
  Lista * entradas;
  Lista * saidas;
  char varEsq[100];
  
  int yylex();

  void yyerror(const char *s){
    // Sem o parametro s ele reclama
    fprintf(stderr, "Treta na linha %d: cade o comando \"%s\" hein? Ta achando que aqui eh brincadeira?\n", lines,command);
    exit(1);
  };

  void insere_entradas(char * var){
    if (buscaInfo(entradas,var)) {
      printf("Cuidado na linha %d: redeclarando a variavel %s\n!", lines, var);
      return;
    }
    lst_insFin(entradas,var);
  }

  void insere_saidas(char * var){
    if (buscaInfo(entradas,var)) {
      lst_insFin(saidas,var);
    } else {
      printf("Cuidado na linha %d: variavel %s nao existe. Impossivel imprimir!\n", lines, var);
      exit(1);
    }
  }

  void inicializa_variavel(char * var) {
    inicializa(entradas,var);
  }

  void atribui_variavel(char * var1, char * var2) {
    //printf("VAR1: %s\nVAR2: %s\n", var1, var2);

    if (!buscaInfo(entradas, var1)) {
      printf("Linha %d: variavel %s nao pode receber valor pois nao existe!\n", lines, var1);
      exit(1);
    } else {
      No * n = pegaNo(entradas, var2);
      if (n == NULL) {
        printf("Linha %d: variavel %s nao existe!\n", lines, var2);
        exit(1);
      } else if (!n->inicializada) {
        printf("Linha %d: variavel %s nao inicializada!\n", lines, var2);
        exit(1);
      }
      inicializa_variavel(var1);
    }
  }

  void tabula(){
    for (int i=0; i<tab; i++)
      fprintf(file_out,"\t");
  }

  void escreve(char * str){
    fprintf(file_out,"%s",str);
  }

  void escreve_tab(char * str){
    tabula();
    fprintf(file_out,"%s",str);
  }

  void escreve_var(char * str){
    str[strlen(str)-1] = 0;
    fprintf(file_out,"%s",str);
  }

  void escreve_var_tab(char * str){
    str[strlen(str)-1] = 0;
    tabula();
    fprintf(file_out,"%s",str);
  }

  void escreve2(char * str, char * str2){
    fprintf(file_out,"%s",str);
    fprintf(file_out,"%s",str2);
  }

  void escreve2_tab(char * str, char * str2){
    tabula();
    escreve2(str,str2);
  }

  void abre_enquanto(char * var) {
    if (!buscaInfo(entradas,var)) {
      printf("Deu ruim no ENQUANTO (linha %d): variavel inexistente %s!\n", lines, var);
      exit(1);
    }
    tabula();
    fprintf(file_out,"while (%s) {\n",var);
    tab++;
  }

  void fecha_enquanto(){
    tab--;
    tabula();
    fprintf(file_out,"}\n");
  }

  void printa_saidas(){
    No * n = saidas->ini;

    while(n) {
      tabula();
      fprintf(file_out,"printf(\"%%s\",%s);\n",n->info);
      n = n->prox;
    }
  }

  void write_init_program(){
    tab++;
    fprintf(file_out,"int main(void){\n");
    tabula();
    fprintf(file_out,"int ");
  }

  void write_end_program(){
    printa_saidas();
    tabula();
    fprintf(file_out,"return(0);\n}\n");
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

%union {char * word;}
%type <word> varlist_in
%type <word> varlist_out
%type <word> id
%type <word> cmd
%%

program:{command="ENTRADA";} ENTRADA 
        {write_init_program(); command="VarList_in";} varlist_in
        {command="SAIDA";} SAIDA
        {command="VarList_out";} varlist_out { escreve("\n"); }
        {command="cmds";} cmds 
        {command="FIM";} FIM { write_end_program(); return(0); }

varlist_in: id',' { $1[strlen($1)-1] = 0; insere_entradas($1); escreve2($1,", "); } varlist_in
          | id';' { $1[strlen($1)-1] = 0; insere_entradas($1); escreve2($1,";\n"); lines++; }

varlist_out: id',' { $1[strlen($1)-1] = 0; insere_saidas($1); } varlist_out  
          | id';' { $1[strlen($1)-1] = 0; insere_saidas($1); lines++; }

cmds: cmd {lines++;} cmds | cmd {lines++;}

cmd: ENQUANTO
     {command="id";} id { abre_enquanto($3); }
     {command="FACA";} FACA { lines++; }
     {command="cmds";} cmds
     {command="FIM";} FIM { fecha_enquanto(); }

cmd: id {strcpy(varEsq, $1);} '=' id { atribui_variavel(varEsq,$4); tabula(); fprintf(file_out,"%s;\n",$$); } 
     | INC id { inicializa_variavel($2); escreve2_tab($2,"++;\n"); }
     | ZERA id { inicializa_variavel($2); escreve2_tab($2," = 0;\n");}
%%

int main(int argc, char * argv[]) {
  FILE * file_in = fopen(argv[1],"r");
  file_out = fopen("saida.txt","w");
  entradas = lst_cria();
  saidas = lst_cria();

  if(!file_in){
    printf("Erro na leitura do arquivo!\n");
    exit(1);
  }

  yyin = file_in;
  yyparse();

  fclose(file_in);
  fclose(file_out);
  lst_libera(entradas);
  lst_libera(saidas);
  return(0);
}