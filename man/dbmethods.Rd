\name{dbmethods}
\alias{dbread}
\alias{dbwrite}
\alias{dbexists}
\alias{dbattach}
\alias{dbdetach}
\alias{dbobjects}
\alias{dbremove}
\alias{dbcanCache}
\alias{dbread.default}
\alias{dbwrite.default}
\alias{dbexists.default}
\alias{dbattach.default}
\alias{dbdetach.default}
\alias{dbobjects.default}
\alias{dbremove.default}
\alias{dbcanCache.default}
\title{Methods for user-defined tables}
\description{
  These are generic functions that are extended
  by different classes of user-level tables that can
  be attached to the search path.
  They are called when the corresponding user-level
  functions are called for that `database'.
  A classes implementations of these methods
  must be globally accessible so that they can be called when needed.
  This differs from closure tables which pass functions,
  (rather than function names) to the C-level interface that implements
  the table's connection to the R engine.
}
\usage{
dbobjects(database)
dbexists(database, name)
dbread(database, name, na=1)
dbwrite(database, name, object)
dbremove(database, name)
dbattach(database)
dbdetach(database)
dbcanCache(database, name)

dbobjects.default(database)
dbexists.default(database, name)
dbread.default(database, name, na=1)
dbremove.default(database, name)
dbwrite.default(database, name, object)
dbattach.default(database)
dbdetach.default(database)
dbcanCache.default(database, name)
}
\arguments{
  \item{database}{the database object which manages the name-value pairs.}
  \item{name}{the name of the symbol in the database.}
  \item{object}{an R object that is to be assigned to the specified
    symbol in the database.}
  \item{na}{a specific object that can be returned to indicate
   that the database does not contain an object of that name.
   This is similar to an "NA" while still allowing any value
   bound to a variable to be returned.
   This uses the uniqueness of the objects internal address.
   Its value is irrelevant, but the \code{dbread} method should 
   not mdofy it in anyway.}
}
\value{
  \code{dbexists} returns a logical value
  indicating whether the database has a variable by that name.

  \code{dbread} is equivalent to \code{\link[base:get]{get}}
  and returns the value in the database assigned to the specified name.

  \code{dbwrite} is equivalent to \code{\link[base:assign]{assign}}
  and returns the value being assigned, i.e. \code{object}.
  This allows one to do chained assigments of the form
  \code{x <- y <- 10}.

  \code{dbremove} is equivalent to \code{\link[base:remove]{remove}}
  and removes the binding for the specified name in the
  database, discarding the value.

  \code{dbobjects} is equivalent to \code{\link[base:objects]{objects}}
  and returns a character vector containing the names
  of all the name-value bindings in the database.

  \code{dbcanCache} returns a logical value indicating whether the
  value of the specified variable (given by \code{name}) cannot be
  changed except for in R (\code{TRUE}) or whether it might be
  changed externally (\code{FALSE}).  This is used by the R engine to
  determine if it is entitle to cache the value associated with
  \code{name}. It does this to avoid searching through the list
  of elements in the search path each time it wants the value of a
  variable that it has already seen. This is useful when the
  data source can be modified externally by other applications
  such as another thread in a Java application, the CORBA naming
  service, etc.

  \code{\link{dbattach}} and \code{\link{dbdetach}}
  have no (useful) return values and are invoked each time
  the user-level table is added and removed from the search
  path, respectively. These can be used to perform initialization
  and cleanup of values that the database uses to implement the other
  methods. For example, it might create a directory for caching
  values when it is attached and remove it on detach.
  Alternatively, it might open a connection to a database
  and close it when it is no longer needed.

}  
\details{
  These methods are the S4-compatible accessors for user-level
  tables that can be attached to the search path.
  They correspond to the
  \code{\link[base:exists]{exists}},
  \code{\link[base:get]{get}},
  \code{\link[base:remove]{remove}},
  \code{\link[base:assign]{assign}}
  and \code{\link[base:objects]{objects}} that are used
  to access and operate on variables within
  elements of the search path.
  These are not typically called directly but by the 
  R engine when accessing user-level tables that
  are implemented by particular methods for these generic
  functions.

  These functions are compatible with the equivalent S4 functions.
}  
\seealso{
  \code{\link{newRFunctionTable}}
  \code{\link{newRClosureTable}}
  \code{\link[base:attach]{attach}}
  \code{\link[base:detach]{detach}}
  \url{http://developer.r-project.org/RObjectTables.pdf}
}  
\note{
  This is experimental. Make certain that important data
  is backed up before using this user-level table interface.
}
\example{
  fixedTable <- list(x=1, y = "abc",
                     z = list(a= rnorm(3), b = c(TRUE, FALSE, TRUE)),
                     cube = function(x) x^3)

		     dbread.FixedTable <- function(database, name) {
		       database[[name]]
 	             }
		     dbremove.FixedTable <- function(database, name) {
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

  search()
  objects(2)
  objects("my fixed list")  
  
  exists("x", where = 2)
  find(x)
  x
  get("x")
  get("x", pos = 2)
  get("x", pos = "my fixed list")


  try(assign("myVar", 10, pos = 2))
  try(remove("x", pos = "my fixed list"))
  try(rm(x, pos = "my fixed list"))
  try(rm(x, inherits = TRUE))    

  detach("my fixed list")

  # now the table has gone from the search list.
  # It is still available as `fixedTable'
  search()
}
\keyword{data}
