typedef struct no No;
typedef struct lista Lista;

Lista *lst_cria(void);
int lst_vazia(Lista* ls);
void lst_insFin(Lista* ls, char* elem);
void lst_libera(Lista* ls);
void exibeLista(Lista * ls);
