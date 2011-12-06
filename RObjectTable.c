/*
 This file provides the generic C-level implementation of
 an R-based implementation of an R_ObjectTable. It assumes the
 methods for the table are R functions supplied as a list
 and here we provide the C routines to call these.
 Typically the functions will share a common environment so that
 they can modify their shared variables which hold the contents of
 the table.
 */

#include "RUserTables.h"

SEXP
R_getUnboundValue()
{
    return(R_UnboundValue);
}

SEXP RClosureTable_callWithName(R_ObjectTableAction handlerType, const char * const name, R_ObjectTable *tb);
SEXP RClosureTable_getFunction(SEXP obj, R_ObjectTableAction handlerType);

Rboolean 
RClosureTable_exists(const char * const name, Rboolean *canCache, R_ObjectTable *tb)
{
 SEXP val;
 if(tb->active == FALSE)
    return((Rboolean) FALSE);

 tb->active = (Rboolean) FALSE;
 val = RClosureTable_callWithName(R_DB_EXISTS, name, tb);
 tb->active = (Rboolean) TRUE;

 return((Rboolean) LOGICAL(val)[0]);
}

SEXP
RClosureTable_get(const char * const name, Rboolean *canCache, R_ObjectTable *tb)
{
 SEXP val;
 if(tb->active == FALSE)
    return(R_UnboundValue);

 tb->active = (Rboolean) FALSE;
 val = RClosureTable_callWithName(R_DB_GET, name, tb);
 tb->active = (Rboolean) TRUE;
 return(val);
}

int
RClosureTable_remove(const char * const name,  R_ObjectTable *tb)
{
 SEXP val;
 val = RClosureTable_callWithName(R_DB_REMOVE, name, tb);
 return(LOGICAL(val)[0]);
}

Rboolean
RClosureTable_canCache(const char * const name, R_ObjectTable *tb)
{
 SEXP val;
 val = RClosureTable_callWithName(R_DB_CACHE, name, tb);
 return( (Rboolean) LOGICAL(val)[0]);
}

SEXP
RClosureTable_assign(const char * const name, SEXP value, R_ObjectTable *tb)
{
    SEXP obj, fun, val, e;
    obj = (SEXP) tb->privateData;
    fun = RClosureTable_getFunction(obj, R_DB_ASSIGN);
    if(!fun) {
	error("can't assign to this type of database");
    }

    PROTECT(e = allocVector(LANGSXP,3));
    SETCAR(e, fun);
    SETCAR(CDR(e), val = NEW_CHARACTER(1));
    SET_STRING_ELT(val, 0, COPY_TO_USER_STRING(name));
    SETCAR(CDR(CDR(e)), value);
    val = eval(e, R_GlobalEnv);
    UNPROTECT(1);
    return(val);
}


SEXP
RClosureTable_objects(R_ObjectTable *tb)
{
    SEXP obj, fun, val, e;
    obj = (SEXP) tb->privateData;
    fun = RClosureTable_getFunction(obj, R_DB_OBJECTS);

    PROTECT(e = allocVector(LANGSXP,1));
    SETCAR(e, fun);
    val = eval(e, R_GlobalEnv);
    UNPROTECT(1);
    return(val);
}

SEXP
RClosureTable_callWithName(R_ObjectTableAction handlerType, const char * const name, R_ObjectTable *tb)
{
    SEXP obj, fun, val, e;
    int errorOccurred = FALSE;

    obj = (SEXP) tb->privateData;
    fun = RClosureTable_getFunction(obj, handlerType);
    if(!fun || fun == R_NilValue) {
        return(NEW_LOGICAL(1));
    }

    PROTECT(e = allocVector(LANGSXP,2));
    SETCAR(e, fun);
    SETCAR(CDR(e), val = NEW_CHARACTER(1));
    SET_STRING_ELT(val, 0, COPY_TO_USER_STRING(name));
#ifndef TRY_EVAL
    val = eval(e, R_GlobalEnv);
#else
    val = R_tryEval(e, NULL, &errorOccurred);
#endif
    if(errorOccurred) {
	return(NEW_LOGICAL(1));
    }
    UNPROTECT(1);
    return(val);
}

SEXP
RClosureTable_getFunction(SEXP obj, R_ObjectTableAction handlerType)
{
    /* Simple version now */
    return(VECTOR_ELT(obj, (int) handlerType));
}

SEXP 
newRClosureTable(SEXP handlers)
{
 R_ObjectTable *tb;
 SEXP val, klass;

  tb = (R_ObjectTable *) malloc(sizeof(R_ObjectTable));
  if(!tb)
      error("cannot allocate space for an internal R object table");

  tb->type = 15;
  tb->cachedNames = NULL;
  tb->active = (Rboolean) TRUE;

  R_PreserveObject(handlers);
  tb->privateData = handlers;

  tb->exists = RClosureTable_exists;
  tb->get = RClosureTable_get;
  tb->remove = RClosureTable_remove;
  tb->assign = RClosureTable_assign;
  tb->objects = RClosureTable_objects;
  tb->canCache = RClosureTable_canCache;

  tb->onAttach = NULL;
  tb->onDetach = NULL;

  PROTECT(val = R_MakeExternalPtr(tb, Rf_install("UserDefinedDatabase"), R_NilValue));
  PROTECT(klass = NEW_CHARACTER(1));
   SET_STRING_ELT(klass, 0, COPY_TO_USER_STRING("UserDefinedDatabase"));
   SET_CLASS(val, klass);
  UNPROTECT(2);

  return(val);
}
