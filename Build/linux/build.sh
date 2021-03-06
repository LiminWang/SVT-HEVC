#!/bin/bash

function clean {
	rm -R -f debug
	rm -R -f release
    	rm -R -f ../../Bin/Debug
    	rm -R -f ../../Bin/Release


}



function debug {
	mkdir -p debug
	mkdir -p ../../Bin/Debug
	cd debug
	PATH=$PATH:/usr/local/bin/
	cmake ../../../Source 					\
		-DCMAKE_BUILD_TYPE=Debug			\
		-DCMAKE_C_COMPILER=$CMAKE_COMPILER		\
		-DCMAKE_CXX_COMPILER=$GXX_COMPILER		\
		-DCMAKE_ASM_NASM_COMPILER=$CMAKE_ASSEMBLER	\
		-DCOMPILE_AS_CPP=$COMPILE_AS_CPP		\
		-DCMAKE_AR=`which $AR_COMPILER`			\
		-DCMAKE_RANLIB=`which $RANLIB_COMPILER`	\
	
		
	python ../scrub-make.py
		
	# Compile the Library	
	make -j HevcEncoder
	cp Lib/System/libHevcEncoder.so ../../../Bin/Debug/libHevcEncoder.so
	# Compile the App
	make HevcEncoderApp
	cp App/HevcEncoderApp ../../../Bin/Debug/HevcEncoderApp
	cd ..
}

function release {
	mkdir -p release
	mkdir -p ../../Bin/Release
	cd release
	PATH=$PATH:/usr/local/bin/
	cmake ../../../Source 					\
		-DCMAKE_BUILD_TYPE=Release			\
		-DCMAKE_C_COMPILER=$CMAKE_COMPILER		\
		-DCMAKE_CXX_COMPILER=$GXX_COMPILER		\
		-DCMAKE_ASM_NASM_COMPILER=$CMAKE_ASSEMBLER	\
		-DCOMPILE_AS_CPP=$COMPILE_AS_CPP		\
		-DCMAKE_AR=`which $AR_COMPILER`			\
		-DCMAKE_RANLIB=`which $RANLIB_COMPILER`	\
		

	python ../scrub-make.py
	
	# Compile the Library	
	make HevcEncoder -j
	cp Lib/System/libHevcEncoder.so ../../../Bin/Release/libHevcEncoder.so
	# Compile the App
	make HevcEncoderApp
	cp App/HevcEncoderApp ../../../Bin/Release/HevcEncoderApp
	cd ..	
}

# Defines
CMAKE_ASSEMBLER=yasm
GCC_COMPILER=gcc
ICC_COMPILER=/opt/intel/composerxe/bin/icc
GXX_COMPILER=g++
AR_COMPILER=gcc-ar
RANLIB_COMPILER=gcc-ranlib
COMPILE_AS_CPP=0

if [ ! -e $ICC_COMPILER ]; then
	CMAKE_COMPILER=$GCC_COMPILER
elif [ "$1" == "gcc" ]; then
	CMAKE_COMPILER=$GCC_COMPILER
elif [ "$2" == "gcc" ]; then
	CMAKE_COMPILER=$GCC_COMPILER
else
	CMAKE_COMPILER=$ICC_COMPILER
	AR_COMPILER=`dirname $ICC_COMPILER`/xiar
fi

if [ "$1" == "cpp" ]; then
	COMPILE_AS_CPP=1
elif [ "$2" == "cpp" ]; then
	COMPILE_AS_CPP=1
else
	COMPILE_AS_CPP=0
fi	

if [ $# -eq 0 ]; then
	debug
	release
elif [ "$1" = "clean" ]; then
	clean
elif [ "$1" = "debug" ]; then
	debug
elif [ "$1" = "release" ]; then
	release
elif [ "$1" = "cpp" ]; then
	debug
	release
elif [ "$1" = "all" ]; then
	debug
	release
elif [ "$1" = "gcc" ]; then
	debug
	release
else
	echo "build.sh <clean|all|debug|release|help>"
fi

exit
 
