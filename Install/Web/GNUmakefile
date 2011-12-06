OMEGA_HOME=../../../..


include $(OMEGA_HOME)/Config/GNUmakefile.SWebPackageConfig
include $(OMEGA_HOME)/R/Config/RPackageWebConfig


CSS_FILES=$(OMEGA_HOME)/Docs/OmegaTech.css

CHANGES=../Changes.html
AUX_DOCS=$(BUGS) $(TODO) $(FAQ) $(CHANGES)

OTHER_DOCS=../INSTALL.html ../README.html

install: pkg/$(PKG_NAME)/inst/Docs index.html examples
	scp -r index.html examples  $(OTHER_DOCS) pkg/$(PKG_NAME)/inst/Docs $(CSS_FILES) $(AUX_DOCS) $(PKG_TAR_FILE) $(TARGET_DIR)
	$(update-r-mirror)

include $(OMEGA_HOME)/Config/GNUmakefile.SWebPackageRules