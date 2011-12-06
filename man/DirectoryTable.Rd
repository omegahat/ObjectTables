\name{DirectoryObjectTable}
\alias{DirectoryObjectTable}
\title{Create an R variable table using a directory}
\description{
  This creates a \code{DirectoryTable}
  object which is used to manage R variables
  by reading and writing them to disk in
  the directory associated with the table.
  The variables can be accessed in the usual manner
  i.e. by name without the need for an explicit
  \code{\link{get}}.
  This gives S-like storage by writing
  the objects to disk when they are assigned
  rather than at the end if the session.
}
\usage{
DirectoryObjectTable(directory, create = TRUE)
}
\arguments{
  \item{directory}{a string giving the name of the directory in which the variables
    will be stored.}
  \item{create}{a logical value indicating whether the directory should
    be created if it does not exist.}  
}
\details{
  This creates an object of class \code{DirectoryTable}
  that stores the name of the directory.
  This is passed to the different \code{db*} methods
  (\code{\link{dbread}}, \code{\link{dbobjects}},
  \code{\link{dbexists}}, \code{\link{dbwrite}}, \dots
  as the first argument).
}
\value{
  An object of class \code{DirectoryTable}
  that also inherits from \code{UserDefinedDatabase}.
  This is a list containing a single element.
  \item{dir}{the fully expanded name of the directory
    associated with table.}
}
\references{\url{http://developer.r-project.org/RObjectTables.pdf}
  \url{http://www.omegahat.org/RinS} for storing R and S-Plus objects
  in a common format.
}
\author{Duncan Temple Lang}

\seealso{
  \code{\link{dbread}},
  \code{\link{dbobjects}},
  \code{\link{dbexists}},
  \code{\link{dbwrite}},
  \code{\link{newRFunctionTable}},  
  \code{\link[pkg:base]{attach}},
  \code{\link[pkg:base]{detach}}  
}

\examples{
  db <- DirectoryObjectTable("/tmp/myRData")
  dbwrite(db, "x", 1:10)
  dbwrite(db, "y", letters[1:3])
  dbobjects(db)
  dbread(db, "x")

  attach(newRFunctionTable(db), name = "myRData")

  assign("z", c(TRUE, FALSE), pos = "myRData")
  get("z", pos = 2)
  get("z")
  z

  detach("myRData")
}
\keyword{data}
