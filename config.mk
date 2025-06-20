# Config file for raven, viper clusters at MPCDF
CC   = mpicc
CXX  = mpicxx

export MPI_HOME = $(I_MPI_ROOT)

# Fix missing Intel Math Library links to FFTW2 library
INTEL_LIBDIR = $(INTEL_HOME)/compiler/latest/linux/compiler/lib/intel64_lin

#OPT   +=  -DPRODUCEGAS   # Set this to automatically produce gas particles
                          # for a single DM species in the input file by interleaved by a half a grid spacing
                          # only for Gaussian and ZA

#OPT   +=  -DMULTICOMPONENTGLASSFILE  # set this if the initial glass file contains multiple components
                                      # only for Gaussian and ZA

#OPT   +=  -DDIFFERENT_TRANSFER_FUNC  # set this if you want to implement a transfer function that depends on
                                      # particle type
                                      # only for Gaussian and ZA

OPT   +=  -DNO64BITID     # switch this on if you want normal 32-bit IDs

#OPT  +=  -DCORRECT_CIC  # only switch this on if particles start from a glass (as opposed to grid)
                         # only for Gaussian and ZA

#OPT += -DONLY_ZA    # swith this on if you want ZA initial conditions (2LPT otherwise)

#MODE = -DONLY_GAUSSIAN
MODE = -DLOCAL_FNL
#MODE = -DEQUIL_FNL
#MODE = -DORTOG_FNL
#MODE = -DORTOG_LSS_FNL


ifeq ($(MODE),-DONLY_GAUSSIAN)
	EXEC:=2LPT
else ifeq ($(MODE),-DLOCAL_FNL)
	EXEC:=2LPTNGLC
else ifeq ($(MODE),-DEQUIL_FNL)
	EXEC:=2LPTNGEQ
else ifeq ($(MODE),-DORTOG_FNL)
	EXEC:=2LPTNGOR
else ifeq ($(MODE),-DORTOG_LSS_FNL)
	EXEC:=2LPTNGORLSS
endif
OPT += $(MODE)
OPTIONS =  $(OPT)
OPTIMIZE = -std=gnu99 -O3 -g -Wall -Wno-unused-but-set-variable -Wno-uninitialized -Wno-unknown-pragmas -Wno-unused-function -march=native
ifeq (NUM_THREADS,$(findstring NUM_THREADS,$(CONFIGVARS)))
OPTIMIZE +=  -fopenmp
OPT      += -DIMPOSE_PINNING -DSOCKETS=4 -DMAX_CORES=16
endif
