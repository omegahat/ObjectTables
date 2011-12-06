#include "Rinternals.h"

#ifndef USE_LOCAL_HEADER
#include "R_ext/RObjectTables.h"
#else
#include "RObjectTables.h"
#endif



static const char *Names[] = {"i", "num", "logi"};

SEXP
SimpleTable_objects(R_ObjectTable *tb)
{
    int n = sizeof(Names)/sizeof(Names[0]), i;
    SEXP ans;

    PROTECT(ans = NEW_CHARACTER(n));
    for(i = 0; i < n; i++)
	SET_STRING_ELT(ans, i, COPY_TO_USER_STRING(Names[i]));
    UNPROTECT(1);

    return(ans);
}

SEXP
SimpleTable_get(const char *name, Rboolean *canCache, R_ObjectTable *tb)
{
    SEXP ans = R_UnboundValue;
    fprintf(stderr, "[SimpleTable_get] Looking for %s\n",name);fflush(stderr);
    if(strcmp(name, "i") == 0) { 
	PROTECT(ans = NEW_INTEGER(3));
    } else if(strcmp(name, "num") == 0) {
	PROTECT(ans = NEW_NUMERIC(2));
    } else if(strcmp(name, "logi") == 0) {
	PROTECT(ans = NEW_LOGICAL(5));
    } else
	return(R_NilValue);

    if(canCache)
	*canCache = FALSE;
    UNPROTECT(1);
    return(ans);
}

Rboolean
SimpleTable_exists(const char *name, Rboolean *canCache, R_ObjectTable *tb)
{
    int n = sizeof(Names)/sizeof(Names[0]), i;

    for(i = 0 ; i < n; i++)
	if(strcmp(name, Names[i]) == 0) {
            if(canCache)
		*canCache = FALSE;
	    return(TRUE);
	}

    return(FALSE);
}

void
SimpleTable_attach(R_ObjectTable *tb)
{
    fprintf(stderr, "attaching a simple table instance\n");fflush(stderr);
}

void
SimpleTable_detach(R_ObjectTable *tb)
{
    fprintf(stderr, "detaching a simple table instance\n");fflush(stderr);
}

SEXP
newSimpleTable()
{
 R_ObjectTable *tb;

  tb = (R_ObjectTable *) malloc(sizeof(R_ObjectTable));
  tb->type = 23;
  tb->cachedNames = NULL;
  tb->privateData = NULL;

  tb->exists = SimpleTable_exists;
  tb->get = SimpleTable_get;
  tb->remove = NULL;
  tb->assign = NULL;
  tb->objects = SimpleTable_objects;
  tb->canCache = NULL;

  tb->onAttach = SimpleTable_attach;
  tb->onDetach = SimpleTable_detach;

  return(R_MakeExternalPtr(tb, Rf_install("SimpleTable"), R_NilValue));
}

SEXP
R_SimpleTable_exists(SEXP name, SEXP db)
{
 R_ObjectTable *tb = R_ExternalPtrAddr(db);
 SEXP ans;

 ans = NEW_LOGICAL(1);
 LOGICAL_DATA(ans)[0] = tb->exists(CHAR(STRING_ELT(name, 0)), NULL, tb);

 return(ans);
}

SEXP
R_SimpleTable_get(SEXP name, SEXP db)
{
 R_ObjectTable *tb = R_ExternalPtrAddr(db);
 SEXP ans;

 ans = tb->get(CHAR(STRING_ELT(name, 0)), NULL, tb);

 return(ans);
}

SEXP
R_SimpleTable_objects(SEXP db)
{
 R_ObjectTable *tb = R_ExternalPtrAddr(db);
 SEXP ans;

 ans = tb->objects(tb);

 return(ans);
}
