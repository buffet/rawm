include config.mk

SRCPREFIX = src

RWMSRC   := $(wildcard $(SRCPREFIX)/rawm/*.c) $(SRCPREFIX)/common.c
RWMOBJ   := $(RWMSRC:.c=.o)
RWMTARGET = rawm

RCSRC   := $(wildcard $(SRCPREFIX)/rawmc/*.c) $(SRCPREFIX)/common.c
RCOBJ   := $(RCSRC:.c=.o)
RCTARGET = rawmc

SRC      = $(RWMSRC) $(RCSRC)
OBJ      = $(RWMOBJ) $(RCOBJ)
DEPS     = $(OBJ:.o=.d)
TARGETS  = $(RWMTARGET) $(RCTARGET)

MANTARGET = rawm.1.gz

.PHONY: all all-nodoc doc install uninstall clean

all: all-nodoc doc

all-nodoc: $(TARGETS)

$(RWMTARGET): $(RWMOBJ)
	$(LD) -o $@ $^ $(LDFLAGS)

$(RCTARGET): $(RCOBJ)
	$(LD) -o $@ $^ $(LDFLAGS)

doc: $(MANTARGET)

$(MANTARGET): misc/rawm.1
	sed 's/{{VERSION}}/v$(VERSION)/g' $< | gzip >$@

install: all misc/rawm.desktop
	install -Dm755 $(RWMTARGET) "$(DESTDIR)$(BINPREFIX)/$(RWMTARGET)"
	install -Dm755 $(RCTARGET) "$(DESTDIR)$(BINPREFIX)/$(RCTARGET)"
	install -Dm644 misc/rawm.desktop "$(DESTDIR)$(XSESSIONS)/rawm.desktop"
	install -Dm644 $(MANTARGET) "$(DESTDIR)$(MANPREFIX)/man1/$(MANTARGET)"

uninstall:
	$(RM) "$(DESTDIR)$(BINPREFIX)/$(RWMTARGET)"
	$(RM) "$(DESTDIR)$(BINPREFIX)/$(RCTARGET)"
	$(RM) "$(DESTDIR)$(XSESSIONS)/rawm.desktop"
	$(RM) "$(DESTDIR)$(MANPREFIX)/man1/$(MANTARGET)"

clean:
	$(RM) $(DEPS)
	$(RM) $(OBJ)
	$(RM) $(TARGETS)
	$(RM) $(MANTARGET)

-include $(DEPS)
