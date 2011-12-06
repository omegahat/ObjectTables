ifdef ADMIN
 include Install/GNUmakefile.admin
endif

all: RTables.so
#all: RObjectTable.so SimpleTable.so RFunctionTable.so
#RTables.so

PKG_CFLAGS+= -DTRY_EVAL=1

C_SRC=RObjectTable.c RFunctionTable.c init.c

#SimpleTable.c RUtils.c

RObjectTable.so:
SimpleTable.so:

NOTANGLE=notangle
DirectoryTable.so: DirectoryTable.c
	R SHLIB -o $@ DirectoryTable.so DirectoryTable.c

DirectoryTable.c: DirectoryTable.nw
	$(NOTANGLE) -R$@ $< > $@

RObjectTables.S: DirectoryTable.nw
	$(NOTANGLE) -R$@ $< > $@


SimpleTable.so: SimpleTable.c
	(PKG_CFLAGS="-I$(R_HOME)/src/include"; export PKG_CFLAGS; R SHLIB -o $@ SimpleTable.c)

RObjectTable.so: RObjectTable.c
	(PKG_CFLAGS="-I$(R_HOME)/src/include"; export PKG_CFLAGS; R SHLIB -o $@ RObjectTable.c)

%.so: %.c
	(PKG_CFLAGS="-DTRY_EVAL=1 -I$(R_HOME)/src/include"; export PKG_CFLAGS; R SHLIB -o $@ $*.c)

RTables.so: $(C_SRC)
	(PKG_CFLAGS="-DTRY_EVAL=1 -I$(R_HOME)/src/include"; export PKG_CFLAGS; R SHLIB -o $@ $(C_SRC))

clean:
	-rm *.o *.so 


%.dvi: %.tex
	(TEXINPUTS=.:$(OMEGA_HOME)/Docs:: ; export TEXINPUTS ; latex $<)

%.ps: %.dvi
	dvips -o $@ $<

%.pdf: %.tex
	pdflatex $<

R_DATA=a b d

Data.tar:
	if test ! -d Data ; then mkdir Data ; fi
	R --vanilla < examples/TarData.S 2>&1 > /dev/null
	tar cf $@ -C Data $(R_DATA)

