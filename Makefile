#!/bin/make
#
# Makefile for wapcaplet
#
# Copyright 2009-2015 John-Mark Bell <jmb@netsurf-browser.org>

# Component settings
COMPONENT := wapcaplet
COMPONENT_VERSION := 0.4.3
# Default to a static library
COMPONENT_TYPE ?= lib-static

# Setup the tooling
PREFIX ?= /opt/netsurf
NSSHARED ?= $(PREFIX)/share/netsurf-buildsystem
include $(NSSHARED)/makefiles/Makefile.tools

# Reevaluate when used, as BUILDDIR won't be defined yet
TESTRUNNER = $(BUILDDIR)/test_testrunner$(EXEEXT)

# Toolchain flags
WARNFLAGS := -Wall -W -Wundef -Wpointer-arith -Wcast-align \
	-Wwrite-strings -Wstrict-prototypes -Wmissing-prototypes \
	-Wmissing-declarations -Wnested-externs
# BeOS/Haiku standard library headers issue warnings
ifneq ($(BUILD),i586-pc-haiku)
  WARNFLAGS := $(WARNFLAGS) -Werror
endif

CFLAGS := -D_BSD_SOURCE -D_DEFAULT_SOURCE \
	-I$(CURDIR)/include/ -I$(CURDIR)/src \
	$(WARNFLAGS) $(CFLAGS)
ifneq ($(GCCVER),2)
  CFLAGS := $(CFLAGS) -std=c99
else
  # __inline__ is a GCCism
  CFLAGS := $(CFLAGS) -Dinline="__inline__"
endif

include $(NSBUILD)/Makefile.top

ifeq ($(WANT_TEST),yes)
  ifneq ($(PKGCONFIG),)
    TESTCFLAGS := $(TESTCFLAGS) $(shell $(PKGCONFIG) --cflags check)
    TESTLDFLAGS := $(TESTLDFLAGS) $(shell $(PKGCONFIG) --libs check)
  else
    TESTLDFLAGS := $(TESTLDFLAGS) -lcheck
  endif
endif

# Extra installation rules
I := /$(INCLUDEDIR)/libwapcaplet
INSTALL_ITEMS := $(INSTALL_ITEMS) $(I):include/libwapcaplet/libwapcaplet.h
INSTALL_ITEMS := $(INSTALL_ITEMS) /$(LIBDIR)/pkgconfig:lib$(COMPONENT).pc.in
INSTALL_ITEMS := $(INSTALL_ITEMS) /$(LIBDIR):$(OUTPUT)
