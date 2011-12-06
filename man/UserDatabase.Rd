\name{UserDatabase}
\alias{newRFunctionTable}
\alias{newRClosureTable}
\title{Create user-defined attach()able table}
\description{

  These functions convert a user-level object
  into an R object that can be attached
  as an element of the R search path.
  The \code{newRFunctionTable} works on objects
  that have methods for the
  \code{\link{dbexists}}, \code{\link{dbread}}, ...
  functions.

  \code{newRClosureTable} works on a collection of
  functions (usually sharing state with a common environment)
  that are called directly by the C-level interface between
  the R engine and the user-level table.
  
}
\usage{
newRFunctionTable(db)
newRClosureTable(db)
}
\arguments{
  \item{db}{a user-defined database object.
    When passed to \code{newRClosureTable},
    this is a list of functions that implement
    the \code{assign}, \code{get},
    \code{exists}, \code{remove},
    \code{objects}, \code{canCache}, \code{attach}
    and \code{detach}.
    When passed to \code{newRFunctionTable},
    this is an object with methods for the
    \code{\link{dbread}}, \code{\link{dbwrite}},
    \code{\link{dbexists}}, \code{\link{dbremove}},
    \code{\link{dbcanCache}}, 
    \code{\link{dbattach}}, \code{\link{dbdetach}} functions.
  }
}
\value{
  An object of class \code{UserDefinedTable}
  that is an external pointer to a C-level
  object that represents the R table.
  This object can then be used in a call
  to \code{\link{attach}}.
}
\details{
}  
\note{This interface is experimental. Please ensure that important data
  is saved before using this.}
\seealso{
  \code{\link{attach}}
  \url{http://developer.r-project.org/RTableObjects.pdf}
}
\example{
  source(system.file("examples", "ListTable.S", package ="RObjectTables"))
  attach(newRClosureTable(createListHandlers(x=1:3, y = letters[1:4])), name ="my list table")
  assign("x", 1, pos = "my list table")
  objects(pos = 2)
  exists("x", pos = 2)
  remove("x", 1, pos = "my list table")
  exists("x", pos = 2)
}  
\keyword{data}

