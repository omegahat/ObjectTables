newRFunctionTable <-
function(db)
{
  val <- .Call("newRFunctionTable", db, PACKAGE = "RObjectTables")

  val
}
