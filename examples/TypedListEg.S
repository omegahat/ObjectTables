if(!exists("createListHandlers"))
  source("ListTable.S")

if(!exists("createTypedListHandlers"))
  source("TypedListTable.S")


h <- createTypedListHandlers()
attach(newRClosureTable(h), name = "typed table")

h$setType("x", "integer")
h$setType("f", "foo")

assign("x", 1:10, pos = 2)
try(assign("x", 10, pos = 2))

a <- 1
class(a) <- "foo"
assign("f", a, pos = 2)

try(assign("f", "a string", pos = 2))

#print(h$types())

# detach("typed table")


