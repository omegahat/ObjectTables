
#tar <- tarObjectTable("/home/duncan/Projects/R-dev-web/RObjectTables/Data/Data.tar")
if(!file.exists("Data/Data.tar")) 
  source("TarData.S")

if(!exists("tarObjectTable"))
  source("TarTables.S")

tar <- tarObjectTable("Data/Data.tar")
db <- newRFunctionTable(tar)
attach(db)

exists("a", 2)
print(a)
print(get("a", 2))
