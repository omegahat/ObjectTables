\name{unbound}
\alias{unbound}
\title{Get the object representing an unbound variable}
\description{
  This retrieves the built-in R object representing the value
  of an unbound variable, i.e. an undefined value.
  This can be returned by the \code{\link{dbread}} method
  of an object table if it does not have a definition for the
  requested variable. This makes it easy to handle such cases
  in the R code rather than in the underlying C-level interface
  that glues the internal engine and the user-level object table implementations.
}
\usage{
unbound()
}
\value{
 Returns the internal C-level value of \code{R_UnboundValue}.
}
\author{Duncan Temple Lang <duncan@research.bell-labs.com>}

\seealso{
\code{\link{dbread}}
}

\examples{
\dontrun{
  dbread.FixedList <-
  function(database, name) {
     if(is.na(name, match(names(database$elements))))
       return(unbound())

     return(database$elements[[name]])
  }
}
}
\keyword{data}
