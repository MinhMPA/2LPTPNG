# Main Makefile with site-specific overrides in config.mk
-include config.mk

# --- Default values (override these in config.mk) ---
CC       ?=   mpicc
EXEC        ?= 2LPTnonlocal
OBJS        ?= main.o power.o checkchoose.o allvars.o save.o read_param.o read_glass.o \
               nrsrc/nrutil.o nrsrc/qromb.o nrsrc/polint.o nrsrc/trapzd.o
INCL        ?= allvars.h proto.h nrsrc/nrutil.h Makefile

# Compilation and optimization flags
OPTIMIZE    ?= -O3 -Wall

# Include and library flags
INTEL_LIBS  ?= -L$(INTEL_LIBDIR)
GSL_INCL    ?= -I$(GSL_HOME)/include
GSL_LIBS    ?= -L$(GSL_HOME)/lib
FFTW_INCL   ?= -I$(FFTW_HOME)/include
FFTW_LIBS   ?= -L$(FFTW_HOME)/lib -ldrfftw_mpi -ldfftw_mpi -ldrfftw -ldfftw
HDF5_INCL   ?= -I$(HDF5_HOME)/include -DH5_USE_16_API
HDF5_LIBS   ?= -L$(HDF5_HOME)/lib -lhdf5 -lz
MPI_INCL 	?= -I$(MPI_HOME)/include
MPI_LIBS    ?= -L$(MPI_HOME)/lib -lmpi

# Aggregated libraries
# Make sure the linker searches there, and encodes an rpath so at runtime
# the dynamic loader can find libimf.so, libsvml.so, libintlc.so.5, etc.
LDFLAGS ?= $(INTEL_LIBS) \
           -Wl,-rpath=$(INTEL_LIBDIR) \
           -Wl,-rpath-link=$(INTEL_LIBDIR)

# And link in the math, SVML, and INTLC libraries
LIBS        ?= $(MPI_LIBS) -limf -lsvml -lintlc -lm $(FFTW_LIBS) $(GSL_LIBS) -lgsl -lgslcblas $(HDF5_LIBS)

# Final compiler flags
CFLAGS      ?= $(OPTIONS) $(OPTIMIZE) $(MPI_INCL) $(FFTW_INCL) $(GSL_INCL) $(HDF5_INCL)

# Build target
$(EXEC): $(OBJS)
	$(CC) $(OPTIMIZE) $(OBJS) $(LDFLAGS) $(LIBS) -o $(EXEC)

# Implicit rule: objects depend on headers
$(OBJS): $(INCL)

.PHONY: clean
clean:
	rm -f $(OBJS) $(EXEC)
