typedef struct no No;
typedef struct lista Lista;

Lista *lst_cria(void);
int lst_vazia(Lista* ls);
void lst_insIni(Lista* ls, void* elem);
void lst_insFin(Lista* ls, void* elem);
void *lst_retIni(Lista* ls);
void *lst_retFin(Lista* ls);
void lst_posIni(Lista* ls);
void lst_posFin(Lista* ls);
void *lst_prox(Lista* ls);
void *lst_ant(Lista* ls);
void lst_libera(Lista* ls);
void exibeLista(Lista * ls);
