
CC = cl

CFLAGS = /O2 /Ob2 /Oi /Ot /Oy /I .\src
LFLAGS = /LTCG

OUT_DIR = .\build

CORES = $(OUT_DIR)\world\cheaptrick.obj $(OUT_DIR)\world\codec.obj $(OUT_DIR)\world\common.obj $(OUT_DIR)\world\d4c.obj $(OUT_DIR)\world\dio.obj $(OUT_DIR)\world\fft.obj $(OUT_DIR)\world\harvest.obj $(OUT_DIR)\world\matlabfunctions.obj $(OUT_DIR)\world\stonemask.obj $(OUT_DIR)\world\synthesis.obj $(OUT_DIR)\world\synthesisrealtime.obj

all: world.lib

world.lib: $(CORES)
	lib $(LFLAGS) /OUT:$@ $(CORES)

{src}.cpp{$(OUT_DIR)\world}.obj:
	$(CC) $(CFLAGS) /c $< /Fo$@

.cpp.obj:
	$(CC) $(CFLAGS) /c $< /Fo$(OUT_DIR)\$@

clean:
	del *.lib
	del *.obj
