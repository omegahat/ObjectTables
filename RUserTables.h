#ifndef R_USER_TABLES
#define R_USER_TABLES

#include "Rdefines.h"
#include "R_ext/Callbacks.h"

typedef enum {R_DB_ASSIGN, 
              R_DB_GET, 
              R_DB_EXISTS, 
              R_DB_REMOVE, 
              R_DB_OBJECTS, 
              R_DB_CACHE, 
              R_DB_ATTACH, 
              R_DB_DETACH, 
              R_DB_UNKNOWN_DB_ACTION} R_ObjectTableAction;

 extern void R_PreserveObject(SEXP);
#endif
