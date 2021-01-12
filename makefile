PREFIX ?= /usr/local
DOCDIR ?= $(PREFIX)/share/doc/qrfile

install:
	@echo "Installing QRfile..."
	@mkdir -p $(DESTDIR)$(PREFIX)/bin
	@cp -p qrfile $(DESTDIR)$(PREFIX)/bin/qrfile
	@mkdir -p $(DESTDIR)$(DOCDIR)
	@cp -p README.md $(DESTDIR)$(DOCDIR)/README.md
	@chmod 755 $(DESTDIR)$(PREFIX)/bin/qrfile
	@chmod 755 $(DESTDIR)$(DOCDIR)/README.md
	@echo "Done"

uninstall:
	@echo "Uninstalling QRfile..."
	@rm -rf $(DESTDIR)$(PREFIX)/bin/qrfile
	@rm -rf $(DESTDIR)$(DOCDIR)
	@echo "Done"
