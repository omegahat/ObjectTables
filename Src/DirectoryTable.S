# This defines methods for a class of object table 
# that uses a directory to store its contents.
# This is similar to the S4/S-Plus style of object
# storage in which each object is written to 
# its own file. The name of an objects file is 
# the name of the variable.
# This makes sharing environments almost impossible
# in a trivial manner. One can use different extensions
# to this mechanism, e.g. using subdirectories to group
# objects.
#
# This version is implemented entirely in R code
# rather than using C code.
# Given that the file and directory access tools
# are written in C, this should be sufficient for
# many applications and serves as a good example
# of the Object Table mechanism.

#
# One can envisage extending this in a variety of 
# different manners:
#  a) changing the format of the objects on disk
#     e.g. using compression, storing as XML representations,
#     
#  b) filtering the names of the files,
#  c) using local caching and time stamps of the files,
#  d) type specification for variables which checks assignments
#     are of the specified type.
#  ...
#

DirectoryObjectTable <-
#
# A constructor function for a Directory object table
# that takes the name of the directory in which objects
# should be read and written.
#
# The name of the directory is fully expanded.
#
function(directory, create = TRUE)
{
 if(!length(grep(paste("^", .Platform$file.sep, sep=""), directory)))
   directory <- paste(getwd(), directory, sep=.Platform$file.sep)

 d <- list(dir=directory)
 class(d) <- c("DirectoryTable", "UserDefinedDatabase")

 if(!file.exists(directory)) {
   if(create) {
     dir.create(directory)
     warning("Created ", directory)
   } else
     warning(directory, " does not exist")
 }

 if(!file.info(directory)$isdir)
   stop(paste(directory, "is not a directory"))
 
 d
}

dbobjects.DirectoryTable <-
#
# Return a list of the `variables'/files in the 
# directory. This uses \code{list.files}.
#
function(database)
{
  list.files(database$dir)
}

dbread.DirectoryTable <-
#
# Get/read an object from the table by finding
# the associated file with the name of the variable
# and using \code{load} to read it.
#
function(database, name, na=1)
{
 Name <- paste(database$dir,name, sep = .Platform$file.sep)
 if(!file.exists(Name)) {
    # We don't have it. So return the value 
    # that was given to us to indicate this - `na'.
    # The internal code checks whether the return
    # value is this object to identify that the object
    # was not found. (It would be nicer to use exists()
    # first.) 
   return(na)
 }

  # We have found the file and now we load its contents
  # into a fresh, new environment object. 
  # Then we return the contents of that environment 
 e <- new.env()
 load(Name, e)
   
  # Now look at its contents. We may have more than one 
  # object stored in a single file. For example somebody
  # may have issued a command such as save(x, y, z, file="....")
  # If this is the case, return them as a list.
  # Alternatively, the simple case is that there is a single value.
  # and we return that value. 
  # It is possible that this does not have the same name as the 
  # file name so we have to find the object by name. 
 what <- objects(envir=e)
 if(length(what) == 1) {
   get(what, envir=e)
 } else {
   l <- list()
   i <- function(x) {
     l[[x]] <<- get(x, envir=e)
     T
   }
   sapply(what, i)
   l
 }
}


dbwrite.DirectoryTable <-
#
# save an object to the directory managed by this table.
#
function(database, name, object) 
{
  save(object, file=paste(database$dir, name, sep=.Platform$file.sep))
}

dbexists.DirectoryTable <-
#
# check whether there is a variable in the table
# by looking for a file in the directory named `name'
#
function(database, name)
{
 file.exists(paste(database$dir, name, sep=.Platform$file.sep))
}

dbremove.DirectoryTable <-
#
# remove a variable from the table by removing the
# associated file.
#
function(database, name)
{
 fileName <- paste(database$dir, name, sep=.Platform$file.sep)
 if(!file.exists(fileName))
  stop(paste("No file named", fileName))

 file.remove(fileName)
}


