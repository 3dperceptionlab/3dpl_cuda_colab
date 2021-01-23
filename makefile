###########################################################

## USER SPECIFIC DIRECTORIES ##

# CUDA directory:
CUDA_ROOT_DIR=/usr/local/cuda

##########################################################

## CC COMPILER OPTIONS ##

# CC compiler options:
CC=g++
CC_FLAGS=
CC_LIBS=

##########################################################

## NVCC COMPILER OPTIONS ##

# NVCC compiler options:
NVCC=nvcc
NVCC_FLAGS=
NVCC_LIBS=

# CUDA library directory:
CUDA_LIB_DIR= -L$(CUDA_ROOT_DIR)/lib64
# CUDA include directory:
CUDA_INC_DIR= -I$(CUDA_ROOT_DIR)/include
# CUDA linking libraries:
CUDA_LINK_LIBS= -lcudart

##########################################################

## Project file structure ##

# Colab base folder
COLAB_DIR = /content/3dpl_cuda_colab

# Include header files diretory:
INC_DIR = $(COLAB_DIR)/include

# Source files directory:
SRC_DIR = $(COLAB_DIR)/src

# Object files directory:
OBJ_DIR = $(COLAB_DIR)/obj

# Binary files directory:
BIN_DIR = $(COLAB_DIR)/bin

##########################################################

## Make variables ##

# Target executable name:
EXE = filtro_mediana

# CPP source files:
SRC_CPP	= $(wildcard $(SRC_DIR)/*.cpp)
# CPP object files:
_OBJS_CPP	= $(patsubst $(SRC_DIR)/%.cpp, %.o, $(SRC_CPP))
OBJS_CPP	= $(addprefix $(OBJ_DIR)/, $(_OBJS_CPP))
# CU source files
SRC_CU	= $(wildcard $(SRC_DIR)/*.cu)
# CU object files:
_OBJS_CU	= $(patsubst $(SRC_DIR)/%.cu, %.o, $(SRC_CU))
OBJS_CU	= $(addprefix $(OBJ_DIR)/, $(_OBJS_CU))
# Object files:
OBJS = $(OBJS_CPP) $(OBJS_CU)

##########################################################

## Compile ##

# Link c++ and CUDA compiled object files to target executable:
$(EXE) : $(OBJ_DIR) $(OBJS)
	$(CC) $(CC_FLAGS) $(OBJS) -o $(EXE) $(CUDA_INC_DIR) $(CUDA_LIB_DIR) $(CUDA_LINK_LIBS)
 
# Compile main .cpp file to object files:
#$(OBJ_DIR)/%.o : %.cpp
#	$(CC) $(CC_FLAGS) -c $< -o $@

# Compile C++ source files to object files:
$(OBJ_DIR)/%.o : $(SRC_DIR)/%.cpp
	$(CC) $(CC_FLAGS) -c $< -o $@

# Compile CUDA source files to object files:
$(OBJ_DIR)/%.o : $(SRC_DIR)/%.cu
	$(NVCC) $(NVCC_FLAGS) -c $< -o $@ $(NVCC_LIBS)

# Clean objects in object directory.
clean:
	rm -f $(OBJ_DIR)/* *.o $(EXE)