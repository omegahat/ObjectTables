dbwrite <-
function(database, name, object)
{
 UseMethod("dbwrite")
}

dbobjects <-
function(database)
{
 UseMethod("dbobjects")
}


dbread <-
function(database, name, na = TRUE)
{
 UseMethod("dbread")
}

dbexists <-
function(database, name)
{
 UseMethod("dbexists")
}

dbremove <-
function(database, name)
{
 UseMethod("dbremove")
}

dbcanCache <-
function(database, name)
{
 UseMethod("dbcanCache")
}

dbattach <-
function(database)
{
 UseMethod("dbattach")
}

dbdetach <-
function(database)
{
 UseMethod("dbdetach")
}


dbwrite.default <- function(database, name, object) {stop("no method")}
dbread.default <- function(database, name, na=TRUE) {stop("no method")}
dbexists.default <- function(database, name) {stop("no method")}
dbremove.default <- function(database, name) {stop("no method")}
dbobjects.default <- function(database) {stop("no method")}
dbcanCache.default <- function(database, name) {FALSE}
dbattach.default <- function(database) {TRUE}
dbdetach.default <- function(database) {TRUE}
