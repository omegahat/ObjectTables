  fixedTable <- list(x=1, y = "abc",
                     z = list(a = rnorm(3), b = c(TRUE, FALSE, TRUE)),
                     cube = function(x) x^3)

		     dbread.FixedTable <- function(database, name) {
		       database[[name]]
 	             }
		     dbremove.FixedTable <- function(database, name) {
		       stop("This is a read-only table")  
		     }
dbwrite.FixedTable <- function(database, name, object)
{
    		       stop("This is a read-only table")  
}
		     dbexists.FixedTable <- function(database, name) {
		       any(name == names(database))
                     }

		     dbobjects.FixedTable <- function(database) {
                       names(database)
 	             }
		     
  class(fixedTable) <- c("FixedTable")
  attach(newRFunctionTable(fixedTable), name = "my fixed list")
