fileName <- function(x) {
 if(!file.exists("Data"))
   dir.create("Data")
 paste("Data", x, sep=.Platform$file.sep)
}

a <- 1:10
save("a", file=fileName("a"))
b <- letters[1:4]
save("b", file=fileName("b"))
d <- rnorm(10)
save("d", file=fileName("d"))

system("cd Data; tar cf Data.tar a b d")

