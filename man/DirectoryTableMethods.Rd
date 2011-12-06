\name{dbexists.DirectoryTable}
\alias{dbexists.DirectoryTable}
\alias{dbread.DirectoryTable}
\alias{dbremove.DirectoryTable}
\alias{dbwrite.DirectoryTable}
\alias{dbobjects.DirectoryTable}
\title{Methods for accessing DirectoryTable objects}
\description{
  Methods for the \code{DirectoryTable} objects used
  for managing R variables (name-value bindings)
  in a directory rather than in memory.
}
\usage{
dbread.DirectoryTable(database, name, na=1)
dbwrite.DirectoryTable(database, name, object)
dbexists.DirectoryTable(database, name)
dbobjects.DirectoryTable(database)
dbremove.DirectoryTable(database, name)
}

\arguments{
  \item{database}{the \code{DirectoryTable} object}
  \item{name}{the name of the variable of interest}
  \item{na}{a value which is to be returned if there is no
    variable in the table corresponding to the requested name.
    This differentiates a non-existent variable from one with
    a value of \code{NULL}, say.}
  \item{object}{the value to be assigned to the specified variable.}
}
\details{
  See the corresponding generic functions.
}
\value{
  See the corresponding generic functions.
}
\references{

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

}
\keyword{data}
