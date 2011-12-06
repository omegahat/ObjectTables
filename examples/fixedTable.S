fixedTable <-
function()
{
  values <- list(x = 1:4, y = letters[1:5], cube = function(x) { x^3 } )

  objects <- function() {
    names(values)
  }
  
  get <-  function(name) {
    if(exists(name))
      values[[name]]
    else
      .Call("R_getUnboundValue", PACKAGE="RObjectTables")
  }

  exists <- function(name) {
    return(!is.na(match(name, names(values))))
  }

  return(list(assign=NULL, 
              get = get,
              exists = exists,
              remove = NULL,
              objects = objects
              ))
}
