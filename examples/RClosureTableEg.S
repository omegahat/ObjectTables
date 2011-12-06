tb <- createListHandlers(x=1,y=letters[1:3])
db <- newRClosureTable(db=tb)
attach(db, name = "my database")

objects(2)

find("x")
find("y")

print(x)
print(y)

print(get("x", pos=2))
print(get("y", pos=2))

print(get("x", pos="my database"))

assign("w", 1, pos=2)
print(get("w", pos=2))
try(assign("z", rnorm(10), pos="db"))

print(get("w", pos=2))
