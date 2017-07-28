
CC = cl

CFLAGS = /O2 /Ob2 /Oi /Ot /Oy /I .\src
LFLAGS = /LTCG

CORES = src\cheaptrick.obj src\codec.obj src\common.obj src\d4c.obj src\dio.obj src\fft.obj src\harvest.obj src\matlabfunctions.obj src\stonemask.obj src\synthesis.obj src\synthesisrealtime.obj

all: world.lib

world.lib: $(CORES)
	lib $(LFLAGS) /OUT:$@ $(CORES)

{src}.cpp{src}.obj:
	$(CC) $(CFLAGS) /c $< /Fo$@

clean:
	del *.lib
	del *.obj
