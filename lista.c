#include <stdlib.h>
#include <stdio.h>
#include "lista.h"

struct no {
  void *info;
  struct no *prox;
  struct no *ant;
}; 

struct lista {
  int tam;
  No *ini;
  No *fim;
  No *corr;
};

Lista *lst_cria(void) { 
    //cria lista vazia (header)
    Lista *ls = (Lista*) malloc(sizeof(Lista));
    if (ls == NULL) {
        printf("\n\nMemoria insuficiente\n\n");
        exit(1);
    }
    
    ls->tam = 0;
    ls->ini = NULL;
    ls->fim = NULL;
    ls->corr = NULL;
    
    return ls;
}

int lst_vazia(Lista* ls) { 
    //retorna 1 se a lista estiver vazia ou 0, caso contrario.
    int vazia;
    (ls->tam == 0) ? (vazia = 1) : (vazia = 0);
    return vazia;
}

void lst_insIni(Lista* ls, void* elem){
  No * n = (No *)malloc(sizeof(No));
  if (n == NULL){
    printf("\n\nlst_insIni: Memoria insuficiente\n\n");
    exit(1);
  }

  n->info = elem;
  if (lst_vazia(ls)){
    n->ant = n->prox = NULL;
    ls->ini = ls->fim = n;
  } else {
    n->ant = NULL;
    n->prox = ls->ini;
    ls->ini->ant = n;
    ls->ini = n;
  }
  ls->tam += 1;
}

void lst_insFin(Lista* ls, void* elem){
  No * n = (No *)malloc(sizeof(No));
  if (n == NULL){
    printf("\n\nlst_insFin: Memoria insuficiente\n\n");
    exit(1);
  }

  n->info = elem;
  //printf("Node info: %s\n",n->info);
  if(lst_vazia(ls)){
    n->ant = n->prox = NULL;
    ls->ini = ls->fim = n;
  } else {
    n->ant = ls->fim;
    n->prox = NULL;
    ls->fim->prox = n;
    ls->fim = n;
  }
  ls->tam += 1;
  //exibeLista(ls);
}

void *lst_retIni(Lista* ls){
  if (lst_vazia(ls)) return NULL;
  void * el = ls->ini->info;
  ls->ini = ls->ini->prox; //ini agora eh o segundo
  if (ls->ini != NULL) {
    ls->ini->ant->prox = NULL; //ini agora nao eh mais o proximo de ninguem
    ls->ini->ant = NULL; //anterior do ini eh o NULL
  }
  ls->tam -= 1;
  return el;
}

void *lst_retFin(Lista* ls){
  if (lst_vazia(ls)) return NULL;
  void * el = ls->fim->info;
  ls->fim = ls->fim->ant;//fim agora eh o penultimo
  if (ls->fim != NULL) {
    ls->fim->prox->ant = NULL; //fim agora nao eh mais o anterior de ninguem
    ls->fim->prox = NULL; //proximo do fim eh o NULL
  }
  ls->tam -= 1;
  return el;
}

void lst_posIni(Lista* ls){
  if (lst_vazia(ls)) {
    puts("Lista Vazia");
    ls->corr = NULL;
  }
  else {
      No * temp = ls->ini;
      ls->corr = ls->ini;
      while(temp->prox != NULL) {
        if (temp->ant==NULL) {
        ls->corr = temp;
      }
      temp=temp->prox;
    }
  }
}

void lst_posFin(Lista* ls){
  if (lst_vazia(ls)) {
    puts("Lista Vazia");
    ls->corr = NULL;
  }
  else {
    No * temp = ls->fim;
    ls->corr = ls->fim;
    while(temp->ant != NULL) {
      if (temp->prox==NULL) {
        ls->corr = temp;
      }
      temp=temp->ant;
    }
  }
}

void *lst_prox(Lista* ls) {
  if (ls->corr == NULL) {
      return NULL;
  }
  else {
      No *aux = ls->ini;
      while (aux->prox != NULL) {
          if (aux == ls->corr) {
              ls->corr = ls->corr->prox;
              return aux->info;
          }
          else {
              aux = aux->prox;
          }
      }
      ls->corr = NULL;
      return aux->info;
  }
}

void *lst_ant(Lista* ls) {
  if (ls->corr == NULL) {
      return NULL;
  }
  else {
      No *aux = ls->fim;
      while (aux->ant != NULL) {
          if (aux == ls->corr) {
              ls->corr = ls->corr->prox;
              return aux->info;
          }
          else {
              aux = aux->ant;
          }
      }
      ls->corr = NULL;
      return aux->info;
  }
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
  char * elem;
  int idx = 0;
  puts("=== Elementos da Lista ===");
  lst_posIni(ls);
  elem = (char*)lst_prox(ls);

  while(elem) {
    printf("Elem %d: %s\n",idx,elem);
    elem = (char*)lst_prox(ls);
    idx++;
  }
}