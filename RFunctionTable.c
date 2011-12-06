/*
 This file provides the generic C-level implementation of
 an R-based implementation of an R_ObjectTable. It assumes the
 methods for the table are available as regular R methods, either
 S4 or S3.
 */

#include "RUserTables.h"

const char * const R_ObjectTable_FunNames[] = {
    "dbwrite", 
    "dbread",
    "dbexists",
    "dbremove",
    "dbobjects",
    "dbcanCache",
    "dbattach",
    "dbdetach"
};


SEXP RFunctionTable_callWithName(R_ObjectTableAction handlerType, const char * const name, R_ObjectTable *tb);
SEXP RFunctionTable_callNoArgs(R_ObjectTable *tb, R_ObjectTableAction action);

Rboolean 
RFunctionTable_exists(const char * const name, Rboolean *canCache, R_ObjectTable *tb)
{
 SEXP val;
 if(tb->active == FALSE)
   return((Rboolean) FALSE);
 val = RFunctionTable_callWithName(R_DB_EXISTS, name, tb);
 return((Rboolean) LOGICAL(val)[0]);
}

SEXP
RFunctionTable_get(const char * const name, Rboolean *canCache, R_ObjectTable *tb)
{
 SEXP val;
 if(tb->active == FALSE)
     return(R_UnboundValue) ;
 val = RFunctionTable_callWithName(R_DB_GET, name, tb);
 return(val);
}

int
RFunctionTable_remove(const char * const name,  R_ObjectTable *tb)
{
 SEXP val;
 val = RFunctionTable_callWithName(R_DB_REMOVE, name, tb);
 return(LOGICAL(val)[0]);
}

Rboolean
RFunctionTable_canCache(const char * const name, R_ObjectTable *tb)
{
 SEXP val;
 val = RFunctionTable_callWithName(R_DB_CACHE, name, tb);
 return((Rboolean) LOGICAL(val)[0]);
}

SEXP
RFunctionTable_assign(const char * const name, SEXP value, R_ObjectTable *tb)
{
    SEXP obj,  val, e;
    int errorOccurred = FALSE;
    obj = (SEXP) tb->privateData;

    /* dbassign(db, name, value) */
    PROTECT(e = allocVector(LANGSXP,4));
    SETCAR(e, Rf_install(R_ObjectTable_FunNames[R_DB_ASSIGN]));
    SETCAR(CDR(e), obj);

    SETCAR(CDR(CDR(e)), val = NEW_CHARACTER(1));

    SET_STRING_ELT(val, 0, COPY_TO_USER_STRING(name));
    SETCAR(CDR(CDR(CDR(e))), value);
#ifndef TRY_EVAL
    val = eval(e, R_GlobalEnv);
#else
    val = R_tryEval(e, NULL, &errorOccurred);
    if(errorOccurred) {
	tb->active = TRUE;
	val = R_NilValue;
    }

#endif
    UNPROTECT(1);
    return(val);
}


SEXP
RFunctionTable_objects(R_ObjectTable *tb)
{
    return(RFunctionTable_callNoArgs(tb, R_DB_OBJECTS));
}

void
RFunctionTable_attach(R_ObjectTable *tb)
{
    RFunctionTable_callNoArgs(tb, R_DB_ATTACH);
}

void
RFunctionTable_detach(R_ObjectTable *tb)
{
    RFunctionTable_callNoArgs(tb, R_DB_DETACH);
}

SEXP
RFunctionTable_callNoArgs(R_ObjectTable *tb, R_ObjectTableAction action)
{
    SEXP obj, fun, val, e;
    int errorOccurred = FALSE;
    Rboolean old;
    obj = (SEXP) tb->privateData;

    /* dbobjects(db) */
    PROTECT(e = allocVector(LANGSXP,2));
    SETCAR(e, Rf_install(R_ObjectTable_FunNames[action]));
    SETCAR(CDR(e), obj);

    old = tb->active;
    tb->active = (Rboolean) FALSE;

#ifndef TRY_EVAL
    val = eval(e, R_GlobalEnv);
#else
    val = R_tryEval(e, NULL, &errorOccurred);
    if(errorOccurred) {
	tb->active = TRUE;
	val = R_NilValue;
    }
    else
	tb->active = old;
#endif
    UNPROTECT(1);
    return(val);
}

SEXP
RFunctionTable_callWithName(R_ObjectTableAction handlerType, const char * const name, R_ObjectTable *tb)
{
    SEXP obj, val, e;
    SEXP missingValue;
    Rboolean old;
    int errorOccurred = FALSE;
    obj = (SEXP) tb->privateData;

    old = tb->active;
    tb->active = (Rboolean) FALSE;

    /* fun(db, name) */
    PROTECT(e = allocVector(LANGSXP,3 + (handlerType == R_DB_GET ? 1 : 0)));

    SETCAR(e, Rf_install(R_ObjectTable_FunNames[handlerType]));

    SETCAR(CDR(e), obj);

    SETCAR(CDR(CDR(e)), val = NEW_CHARACTER(1));
    SET_STRING_ELT(val, 0, COPY_TO_USER_STRING(name));
    if(handlerType == R_DB_GET)
	SETCAR(CDR(CDR(CDR(e))), missingValue = NEW_LOGICAL(1));

#ifndef TRY_EVAL
    val = eval(e, R_GlobalEnv);
#else
    val = R_tryEval(e, NULL, &errorOccurred);
    if(errorOccurred || val == missingValue) {
	val = R_NilValue;
/*
	tb->active = TRUE;
        PROBLEM "error in database function"
        ERROR;
*/
    }

#endif
    tb->active = old;

    UNPROTECT(1);
    return(val);
}

SEXP 
newRFunctionTable(SEXP handlers)
{
 R_ObjectTable *tb;
 SEXP klass, val;

  tb = (R_ObjectTable *) malloc(sizeof(R_ObjectTable));
  tb->type = 15;
  tb->active = (Rboolean) TRUE;
  tb->cachedNames = NULL;
 
  R_PreserveObject(handlers);
  tb->privateData = handlers;

  tb->exists = RFunctionTable_exists;
  tb->get = RFunctionTable_get;
  tb->remove = RFunctionTable_remove;
  tb->assign = RFunctionTable_assign;
  tb->objects = RFunctionTable_objects;
  tb->canCache = RFunctionTable_canCache;
  tb->onAttach = RFunctionTable_attach;
  tb->onDetach = RFunctionTable_detach;

  PROTECT(val = R_MakeExternalPtr(tb, Rf_install("UserDefinedDatabase"), R_NilValue));
  PROTECT(klass = NEW_CHARACTER(1));
   SET_STRING_ELT(klass, 0, COPY_TO_USER_STRING("UserDefinedDatabase"));
   SET_CLASS(val, klass);
  UNPROTECT(2);
  return(val);
}
