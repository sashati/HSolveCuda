#/**********************************************************************
#** This program is part of 'MOOSE', the
#** Messaging Object Oriented Simulation Environment,
#** also known as GENESIS 3 base code.
#**           copyright (C) 2004 Upinder S. Bhalla. and NCBS
#** It is made available under the terms of the
#** GNU General Public License version 2
#** See the file COPYING.LIB for the full notice.
#**********************************************************************/

TARGET = _hsolve.o
#CLIB = cudaLibrary/_hsolveCudaLib.o
OBJ = \
	HSolveStruct.o \
	HinesMatrixProxy.o \
	HSolvePassive.o \
	RateLookup.o \
	HSolveActive.o \
	HSolveActiveSetup.o \
	HSolveInterface.o \
	HSolveCuda.o \
	HSolveUtils.o \
	testHSolve.o \
	ZombieCompartment.o \
	ZombieCaConc.o \
	ZombieHHChannel.o \
#	HSC_PerformSimulation.o \
	

HEADERS = \
	../basecode/header.h

#SUBDIR = \
#	cudaLibrary \
#	testHines

default: $(TARGET)

$(OBJ)	: $(HEADERS)
HSolveStruct.o:	HSolveStruct.h
HinesMatrixProxy.o:	HinesMatrixProxy.h TestHSolve.h HinesMatrixProxy.cpp
HSolvePassive.o:	HSolvePassive.h HinesMatrixProxy.h HSolveStruct.h HSolveUtils.h TestHSolve.h ../biophysics/Compartment.h
RateLookup.o:	RateLookup.h
HSolveActive.o:	HSolveActive.h RateLookup.h HSolvePassive.h HinesMatrixProxy.h HSolveStruct.h
HSolveActiveSetup.o:	HSolveActive.h RateLookup.h HSolvePassive.h HinesMatrixProxy.h HSolveStruct.h HSolveUtils.h ../biophysics/HHChannel.h ../biophysics/ChanBase.h ../biophysics/HHGate.h ../biophysics/CaConc.h
HSolveInterface.o:	HSolveCuda.h HSolveActive.h RateLookup.h HSolvePassive.h HinesMatrixProxy.h HSolveStruct.h
HSolveCuda.o:	../biophysics/Compartment.h ZombieCompartment.h ../biophysics/CaConc.h ZombieCaConc.h ../biophysics/HHGate.h ../biophysics/ChanBase.h ../biophysics/HHChannel.h ZombieHHChannel.h HSolveCuda.h HSolveActive.h RateLookup.h HSolvePassive.h HinesMatrixProxy.h HSolveStruct.h ../basecode/ElementValueFinfo.h
ZombieCompartment.o:	ZombieCompartment.h ../randnum/randnum.h ../biophysics/Compartment.h HSolveCuda.h HSolveActive.h RateLookup.h HSolvePassive.h HinesMatrixProxy.h HSolveStruct.h ../basecode/ElementValueFinfo.h
ZombieCaConc.o:	ZombieCaConc.h ../biophysics/CaConc.h HSolveCuda.h HSolveActive.h RateLookup.h HSolvePassive.h HinesMatrixProxy.h HSolveStruct.h ../basecode/ElementValueFinfo.h
ZombieHHChannel.o:	ZombieHHChannel.h ../biophysics/HHChannel.h ../biophysics/ChanBase.h ../biophysics/HHGate.h HSolveCuda.h HSolveActive.h RateLookup.h HSolvePassive.h HinesMatrixProxy.h HSolveStruct.h ../basecode/ElementValueFinfo.h
HSC_PerformSimulation.o:	HSC_PerformSimulation.cpp	HSC_PerformSimulation.hpp

.cpp.o:
	$(CXX) $(CXXFLAGS) $(SMOLDYN_FLAGS) -I. -I../basecode -I../msg $< -c -I/usr/local/cuda/include

$(TARGET): $(OBJ) $(SMOLDYN_OBJ) $(HEADERS)
	@(for i in $(SUBDIR) ; do $(MAKE) -C $$i; done)
	$(LD) -r -o $(TARGET) $(OBJ) $(SMOLDYN_OBJ) $(SMOLDYN_LIB_PATH) $(SMOLDYN_LIBS) $(GSL_LIBS) $(CLIB) 

clean:
	@(for i in $(SUBDIR) ; do $(MAKE) -C $$i clean;  done)
	rm -f *.o $(TARGET) core core.*
