#
# Makefile
#
# Copyright (C) 2010 - 2014 Creytiv.com
#

PROJECT	  := restunc
VERSION   := 0.4.0

ifeq ($(LIBRE_MK),)
LIBRE_MK  := $(shell [ -f ../re/mk/re.mk ] && \
	echo "../re/mk/re.mk")
endif
ifeq ($(LIBRE_MK),)
LIBRE_MK  := $(shell [ -f /usr/share/re/re.mk ] && \
	echo "/usr/share/re/re.mk")
endif
ifeq ($(LIBRE_MK),)
LIBRE_MK  := $(shell [ -f /usr/local/share/re/re.mk ] && \
	echo "/usr/local/share/re/re.mk")
endif

include $(LIBRE_MK)

INSTALL := install
ifeq ($(DESTDIR),)
PREFIX  := /usr/local
else
PREFIX  := /usr
endif
BINDIR	:= $(PREFIX)/bin
CFLAGS	+= -I$(LIBRE_INC)
LFLAGS	+=
BIN	:= $(PROJECT)$(BIN_SUFFIX)

include src/srcs.mk

OBJS	?= $(patsubst %.c,$(BUILD)/src/%.o,$(SRCS))

all: $(BIN)

-include $(OBJS:.o=.d)

$(BIN): $(OBJS)
	@echo "  LD      $@"
	@$(LD) $(LFLAGS) $^ -L$(LIBRE_SO) -lre $(LIBS) -o $@

$(BUILD)/%.o: %.c $(BUILD) Makefile src/srcs.mk
	@echo "  CC      $@"
	@$(CC) $(CFLAGS) -o $@ -c $< $(DFLAGS)

$(BUILD): Makefile
	@mkdir -p $(BUILD)/src
	@touch $@

clean:
	@rm -rf $(BIN) $(BUILD)/

install: $(BIN)
	@mkdir -p $(DESTDIR)$(BINDIR)
	$(INSTALL) -m 0755 $(BIN) $(DESTDIR)$(BINDIR)
