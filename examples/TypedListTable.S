createTypedListHandlers <-
function(...)
{  
  h <- createListHandlers(...)

  e <- environment(h$assign)

  assign("super.assign", h$assign,env = e)
  assign("types", list(), env = e)
  
  h$assign <- function(name, object) {
    if(!is.na(match(name, names(types)))) {
      if(types[[name]] != typeof(object) && !inherits(object, types[[name]]))
        stop(paste("Incorrect type for ",name,". Should have been ",types[[name]], sep=""))
    }
    super.assign(name, object)
  }
  

  h$setType <- function(name, type) {
    types[[name]] <<- type
    type
  }

  h$getType <- function(name) types[[name]]
  h$types <- function() types

  environment(h$assign) <- e  
  environment(h$setType) <- e  
  environment(h$getType) <- e  
  environment(h$types) <- e
  
  h  
}  
