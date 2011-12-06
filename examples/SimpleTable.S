newTable <-
function()
{
  db <- .Call("newSimpleTable")
  class(db) <- "UserDefinedDatabase"
  db
}

get.SimpleTable <-
function(x, db)
{
 .Call("R_SimpleTable_get", as.character(x), db)
}

exists.SimpleTable <-
function(x, db)
{
 .Call("R_SimpleTable_exists", as.character(x), db)
}

objects.SimpleTable <-
function(db)
{
 .Call("R_SimpleTable_objects", db)
}
