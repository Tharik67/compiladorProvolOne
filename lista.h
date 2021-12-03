typedef struct no {
  char info[100];
  int inicializada;
  struct no *prox;
} No; 

typedef struct lista {
  int tam;
  struct no *ini;
  struct no *fim;
} Lista;

// typedef struct no No;
// typedef struct lista Lista;

Lista *lst_cria(void);
int lst_vazia(Lista* ls);
void lst_insFin(Lista* ls, char* elem);
void lst_libera(Lista* ls);
void exibeLista(Lista* ls);
int buscaInfo(Lista * ls, char* elem);
No * pegaNo(Lista * ls, char * elem);
void inicializa(Lista * ls, char * elem);