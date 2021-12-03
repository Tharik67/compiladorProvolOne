#include <stdlib.h>
#include <stdio.h>
#include "lista.h"
#include "string.h"

struct no {
  char info[100];
  struct no *prox;
}; 

struct lista {
  int tam;
  struct no *ini;
  struct no *fim;
};

Lista *lst_cria(void) { 
    Lista *ls = (Lista*) malloc(sizeof(Lista));
    if (ls == NULL) {
        printf("\n\nMemoria insuficiente\n\n");
        exit(1);
    }
    
    ls->tam = 0;
    ls->ini = NULL;
    ls->fim = NULL;
    
    return ls;
}

int lst_vazia(Lista* ls) { 
    // Retorna 1 se a lista estiver vazia ou 0 caso contrario
    int vazia;
    (ls->tam == 0) ? (vazia = 1) : (vazia = 0);
    return vazia;
}

void lst_insFin(Lista* ls, char * elem){
  No * n = (No *) malloc(sizeof(No));
  if (n == NULL){
    printf("\n\nlst_insFin: Memoria insuficiente\n\n");
    exit(1);
  }
  strcpy(n->info, elem);
  //n->info = elem;
  if (lst_vazia(ls)){
    ls->ini = ls->fim = n;
  } else {
    n->prox = NULL;
    ls->fim->prox = n;
    ls->fim = n;
  }
  ls->tam += 1;
  exibeLista(ls);
}

void lst_libera(Lista* ls) {
    while (lst_vazia(ls) == 0) {
        No *aux = ls->ini->prox;
        free(ls->ini);
        ls->ini = aux;
        ls->tam -= 1;
    }
    free(ls);
    return;
}

void exibeLista(Lista * ls) {
  puts("=== Conteudo da Lista ===");
  int idx = 0;
  No * n = ls->ini;

  while(n) {
    printf("Info %d: %s\n",idx,(char*)n->info);
    n = n->prox;
    idx++;
  }
  printf("\n");
}

