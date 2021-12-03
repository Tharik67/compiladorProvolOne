%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  //#include "y.tab.h"
  #include "lista.h"

  extern FILE * yyin;
  FILE * file_out;
  int tab = 0;
  int lines = 0;
  char *command;
  Lista * entradas;
  Lista * saidas;
  
  int yylex();

  void yyerror(const char *s){
    // Sem o parametro s ele reclama
    fprintf(stderr, "Treta na linha %d: cade o comando \"%s\" hein? Ta achando que aqui eh brincadeira?\n", lines,command);
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
    for (int i=0; i<tab; i++)
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
  void escreve2(char * str, char * str2){
    fprintf(file_out,"%s",str);
    fprintf(file_out,"%s",str2);
    lines++;
  }

  void escreve2_tab(char * str, char * str2){
    tabula();
    escreve2(str,str2);
  }

  void abre_enquanto(char * var) {
    tabula();
    fprintf(file_out,"while (%s) {\n",var);
    tab++;
    lines++;
  }

  void fecha_enquanto(){
    tab--;
    tabula();
    fprintf(file_out,"}\n");
    lines++;
  }

  void printa_saidas(){
    //lst_posIni(saidas);
    // char * elem = (char*)lst_prox(saidas);

    // while(elem) {
    //   printf("%s\n",elem);
    //   elem = (char*)lst_prox(saidas);
    // }
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
    //printf("%d linhas\n", lines); 
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
        {command="SAIDA";} SAIDA { /*escreve("prinftf(");*/ }
        {command="VarList_out";} varlist_out { escreve("\n"); }
        {command="cmds";} cmds 
        {command="FIM";} FIM { write_end_program(); return(0); }

varlist_in: id',' { insere_entradas($1); escreve($1); } varlist_in
          | id';' { insere_entradas($1); escreve2($1,"\n"); lines++; }

varlist_out: id { /*tabula(); fprintf(file_out,"\"s\"%s ",$1); */} ',' varlist_out  
          | id';' { /*tabula(); fprintf(file_out,"%.*s",(int) strlen($1)-1,$1);*/ lines++;}

cmds: cmd cmds | cmd

cmd: {command="ENQUANTO";} ENQUANTO
     {command="id";} id { abre_enquanto($4); }
     {command="FACA";} FACA
     {command="cmds";} cmds
     {command="FIM";} FIM { fecha_enquanto(); }

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
  lst_libera(entradas);
  //lst_libera(saidas);
  return(0);
}