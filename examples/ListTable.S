createListHandlers <-
function(...)
{
  .contents <- list(...)
  objects <- function() {
    names(.contents)
  }
 
  Exists <- function(what) {
    if(length(.contents) == 0)
      return(FALSE)
# get("print",4)(get("match",4)(what, get("names",4)(.contents)))
#    print(match(what, names(.contents)))
    !is.na(match(what, names(.contents)))
  }

  Get <- function(what) {
    if(Exists(what))
      .contents[[what]]
    else
      .Call("R_getUnboundValue", PACKAGE = "RObjectTables")
  }

  remove <- function(what) {
    idx <- match(what, names(.contents))
    if(is.na(idx)) 
      return(FALSE)

    .contents <<- .contents[-idx]
    TRUE
  }

  assign <- function(what, val) {
    .contents[[what]] <<- val
    val
  }

  cache <- function(what) {
#TRUE
    FALSE
  }

   # order is currently important.
  return(list(assign=assign, 
              objects=objects,
              get=Get, 
              remove=remove, 
              exists=Exists, 
              cache=cache))
}
