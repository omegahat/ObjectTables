unbound <-
function()
{
  .Call("R_getUnboundValue", PACKAGE="RObjectTables")
}

.First.lib <-
function(libname, pkgname)
{
 library.dynam("RObjectTables", pkgname, libname)
}


setMethod("cacheMetaData", "UserDefinedDatabase", function(where, attach = TRUE) {cat("In method\n"); character(0)})

