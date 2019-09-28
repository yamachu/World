CXX = g++
C99 = gcc -std=c99
LINK = g++
AR = ar
#DEBUG_FLAG=-g
CXXFLAGS = -O1 -Wall -fPIC $(DEBUG_FLAG)
CFLAGS = $(CXXFLAGS)
LDFLAGS =
ARFLAGS = -rv
OUT_DIR = ./build
DIST_DIR = ./dist
ARCH =
ifdef ARCH
	ARCH_DIST_DIR = $(DIST_DIR)/$(ARCH)
	OUT_DIR := $(OUT_DIR)/$(ARCH)
endif
OBJS = $(OUT_DIR)/objs/world/cheaptrick.o $(OUT_DIR)/objs/world/common.o $(OUT_DIR)/objs/world/d4c.o $(OUT_DIR)/objs/world/dio.o $(OUT_DIR)/objs/world/fft.o $(OUT_DIR)/objs/world/harvest.o $(OUT_DIR)/objs/world/matlabfunctions.o $(OUT_DIR)/objs/world/stonemask.o $(OUT_DIR)/objs/world/synthesis.o $(OUT_DIR)/objs/world/synthesisrealtime.o $(OUT_DIR)/objs/world/codec.o
LIBS =
MKDIR = mkdir -p $(1)
ifeq ($(shell echo "check_quotes"),"check_quotes")
	# Windows
	MKDIR = mkdir $(subst /,\,$(1)) > nul 2>&1 || (exit 0)
endif

all: default test

###############################################################################################################
### Tests
###############################################################################################################
test: $(OUT_DIR)/test $(OUT_DIR)/ctest

test_OBJS=$(OUT_DIR)/objs/tools/audioio.o $(OUT_DIR)/objs/test/test.o
$(OUT_DIR)/test: $(OUT_DIR)/libworld.a $(test_OBJS)
	$(LINK) $(CXXFLAGS) -o $(OUT_DIR)/test $(test_OBJS) $(OUT_DIR)/libworld.a -lm

ctest_OBJS=$(OUT_DIR)/objs/tools/audioio.o $(OUT_DIR)/objs/test/ctest.o
$(OUT_DIR)/ctest: $(OUT_DIR)/libworld.a $(ctest_OBJS)
	$(LINK) $(CXXFLAGS) -o $(OUT_DIR)/ctest $(ctest_OBJS) $(OUT_DIR)/libworld.a -lm

$(OUT_DIR)/objs/test/test.o : tools/audioio.h src/world/d4c.h src/world/dio.h src/world/harvest.h src/world/matlabfunctions.h src/world/cheaptrick.h src/world/stonemask.h src/world/synthesis.h src/world/common.h src/world/fft.h src/world/macrodefinitions.h
$(OUT_DIR)/objs/test/ctest.o : tools/audioio.h src/world/d4c.h src/world/dio.h src/world/harvest.h src/world/matlabfunctions.h src/world/cheaptrick.h src/world/stonemask.h src/world/synthesis.h src/world/common.h src/world/fft.h src/world/macrodefinitions.h

###############################################################################################################
### Library
###############################################################################################################
default: $(OUT_DIR)/libworld.a

$(OUT_DIR)/libworld.a: $(OBJS)
	$(AR) $(ARFLAGS) $(OUT_DIR)/libworld.a $(OBJS) $(LIBS)
	@echo Done.

$(OUT_DIR)/objs/world/cheaptrick.o : src/world/cheaptrick.h src/world/common.h src/world/constantnumbers.h src/world/matlabfunctions.h src/world/macrodefinitions.h
$(OUT_DIR)/objs/world/common.o : src/world/common.h src/world/constantnumbers.h src/world/matlabfunctions.h src/world/macrodefinitions.h
$(OUT_DIR)/objs/world/d4c.o : src/world/d4c.h src/world/common.h src/world/constantnumbers.h src/world/matlabfunctions.h src/world/macrodefinitions.h
$(OUT_DIR)/objs/world/dio.o : src/world/dio.h src/world/common.h src/world/constantnumbers.h src/world/matlabfunctions.h src/world/macrodefinitions.h
$(OUT_DIR)/objs/world/fft.o : src/world/fft.h src/world/macrodefinitions.h
$(OUT_DIR)/objs/world/harvest.o : src/world/harvest.h src/world/fft.h src/world/common.h src/world/constantnumbers.h src/world/matlabfunctions.h src/world/macrodefinitions.h
$(OUT_DIR)/objs/world/matlabfunctions.o : src/world/constantnumbers.h src/world/matlabfunctions.h src/world/macrodefinitions.h
$(OUT_DIR)/objs/world/stonemask.o : src/world/stonemask.h src/world/fft.h src/world/common.h src/world/constantnumbers.h src/world/matlabfunctions.h src/world/macrodefinitions.h
$(OUT_DIR)/objs/world/synthesis.o : src/world/synthesis.h src/world/common.h src/world/constantnumbers.h src/world/matlabfunctions.h src/world/macrodefinitions.h
$(OUT_DIR)/objs/world/synthesisrealtime.o : src/world/synthesisrealtime.h src/world/common.h src/world/constantnumbers.h src/world/matlabfunctions.h src/world/macrodefinitions.h

mac_shared: $(OUT_DIR)/libworld.dylib

$(OUT_DIR)/libworld.dylib: $(OBJS) $(OUT_DIR)/objs/tools/audioio.o $(OUT_DIR)/objs/tools/parameterio.o $(OUT_DIR)/objs/utils/version.o
	$(CXX) $(CXXFLAGS) -dynamiclib $(OBJS) $(OUT_DIR)/objs/tools/audioio.o $(OUT_DIR)/objs/tools/parameterio.o  $(OUT_DIR)/objs/utils/version.o -o "$@"

$(ARCH_DIST_DIR)/libworld.so: $(OBJS) $(OUT_DIR)/objs/tools/audioio.o $(OUT_DIR)/objs/tools/parameterio.o $(OUT_DIR)/objs/utils/version.o
	$(MAKE) $(ARCH_DIST_DIR)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -shared $^ -o "$@"

ios_static: $(OUT_DIR)/ios_libworld.a

$(OUT_DIR)/ios_libworld.a: $(OBJS) $(OUT_DIR)/objs/tools/audioio.o $(OUT_DIR)/objs/tools/parameterio.o $(OUT_DIR)/objs/utils/version.o
	$(AR) $(ARFLAGS) "$@" $(OBJS) $(OUT_DIR)/objs/tools/audioio.o $(OUT_DIR)/objs/tools/parameterio.o  $(OUT_DIR)/objs/utils/version.o
	$(RANLIB) "$@"

build/linux: ARCH = linux
build/linux:
	$(MAKE) $(DIST_DIR)/$(ARCH)/libworld.so ARCH=$(ARCH)

###############################################################################################################
### Global rules
###############################################################################################################
$(OUT_DIR)/objs/test/%.o : test/%.c
	$(call MKDIR,$(OUT_DIR)/objs/test)
	$(C99) $(CFLAGS) -Isrc -Itools -o "$@" -c "$<"

$(OUT_DIR)/objs/test/%.o : test/%.cpp
	$(call MKDIR,$(OUT_DIR)/objs/test)
	$(CXX) $(CXXFLAGS) -Isrc -Itools -o "$@" -c "$<"

$(OUT_DIR)/objs/tools/%.o : tools/%.cpp
	$(call MKDIR,$(OUT_DIR)/objs/tools)
	$(CXX) $(CXXFLAGS) -Isrc -o "$@" -c "$<"

$(OUT_DIR)/objs/world/%.o : src/%.cpp
	$(call MKDIR,$(OUT_DIR)/objs/world)
	$(CXX) $(CXXFLAGS) -Isrc -o "$@" -c "$<"

$(OUT_DIR)/objs/utils/%.o : utils/%.cpp
	mkdir -p $(OUT_DIR)/objs/utils
	$(CXX) $(CXXFLAGS) -o "$@" -c "$<"

$(ARCH_DIST_DIR):
	$(call MKDIR,$@)

clean:
	@echo 'Removing all temporary binaries... '
	@$(RM) $(OUT_DIR)/libworld.a $(OBJS) $(OUT_DIR)/objs/tools/audioio.o $(OUT_DIR)/objs/tools/parameterio.o $(OUT_DIR)/objs/utils/version.o
	@$(RM) $(test_OBJS) $(ctest_OBJS) $(OUT_DIR)/test $(OUT_DIR)/ctest
	@echo Done.

clear: clean

.PHONY: clean clear test default build/linux
.DELETE_ON_ERRORS:
