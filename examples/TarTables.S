tarObjectTable <-
function(fileName, cache = TRUE)
{
 if(!file.exists(fileName))
    stop(paste("File", fileName, "does not exist"))

 if(length(grep("^/", fileName)) == 0) {
   dir <- system("pwd", intern=T)
   fileName <- paste(dir, fileName, sep=.Platform$file.sep)
 }

 els <- strsplit(fileName, split=.Platform$file.sep)[[1]]
 if(length(els) == 1) {
    dir <- system("pwd", intern=T)
 } else
    dir <- paste(els[-length(els)], sep=.Platform$file.sep, collapse=.Platform$file.sep)

 d <- list(fileName=fileName, cache = cache, tempDir = ifelse(cache, tempfile(), NULL), NULL, directory = dir)
 class(d) <- c("TarObjectTable", "UserDefinedDatabase")

 d
}

dbobjects.TarObjectTable <-
#
# get the objects available from the archive
# by doing a table listing on the tar file.
# 
function(db)
{
  system(paste("tar tf", db$fileName), intern=T)
}

dbexists.TarObjectTable <-
#
# Check whether an object exists in the archive by searching
# the names returned by calling objects() for this database.
#
function(db, name)
{
 Names <- dbobjects(db)
 !is.na(match(name, Names))
}

dbread.TarObjectTable <-
#
# Read a single entry from the database.
# Extract the entry in the tar file and the use load()
# to get its value.
#
function(db, name, na = TRUE)
{
# cat("Looking for",name,"\n")
# print(db)
 if(TRUE) {
   # Generate the temporary directory and store its name.
  if(is.null(db$tempDir)) {
    dir <- tempfile()
  } else  {
    dir <- db$tempDir
  }

   parent <- db$directory
 } else {
   dir <- paste(dirname(db$fileName), "jasper", sep=.Platform$file.sep)
   parent <- ".."
 }


    # Check to see if the particular name is in the cache already.
  if(db$cache == FALSE || !file.exists(paste(dir, name, sep=.Platform$file.sep))) {
    if(!file.exists(dir))
      dir.create(dir)
    cmd <- paste("cd", dir,";", "tar xvf",
                 paste(parent,basename(db$fileName), sep=.Platform$file.sep), name)
#    cat("Executing", cmd,"\n")
    ok <- system(cmd, intern=T, ignore.stderr=TRUE)
#    print(ok)
  } else
    cat("(Cached value from tar file)\n")


  fileName <- paste(dir, name, sep=.Platform$file.sep)
  if(file.exists(fileName)) {
    e <- new.env()
    load(paste(dir, name, sep=.Platform$file.sep), e)
    get(objects(envir=e)[1], envir=e)
  } else
    return(.Call("R_getUnboundValue", PACKAGE="RObjectTables"))
}

dbwrite.TarObjectTable <-
function(db, name, object)
{
 stop("This is a read-only database")
}

dbremove.TarObjectTable <-
function(db, name)
{
 stop("This is a read-only database")
}

dbattach.TarObjectTable <-
function(db)
{
 TRUE
}


dbdetach.TarObjectTable <-
function(db)
{
 if(!is.null(db$tempDir) && file.exists(db$tempDir)) {
   cat("Removing temporary directory", db$tempDir, "\n")
   unlink(db$tempDir, TRUE)
 }
  
 TRUE
}
