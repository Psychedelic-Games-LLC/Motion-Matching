PLATFORM ?= PLATFORM_DESKTOP
BUILD_MODE ?= RELEASE
RAYLIB_DIR = /home/xiani/_WORK/raylib
INCLUDE_DIR = -I ./ -I $(RAYLIB_DIR)/raylib/src -I $(RAYLIB_DIR)/raygui/src
LIBRARY_DIR = -L $(RAYLIB_DIR)/raylib/src
DEFINES = -D _DEFAULT_SOURCE -D RAYLIB_BUILD_MODE=$(BUILD_MODE) -D $(PLATFORM)

ifeq ($(PLATFORM),PLATFORM_DESKTOP)
    CC = g++
    EXT = .exe
    ifeq ($(BUILD_MODE),RELEASE)
        CFLAGS ?= $(DEFINES) -ffast-math -march=native -D NDEBUG -O3 $(RAYLIB_DIR)/raylib/src/raylib.rc.data $(INCLUDE_DIR) $(LIBRARY_DIR) 
	else
        CFLAGS ?= $(DEFINES) -g $(RAYLIB_DIR)/raylib/src/raylib.rc.data $(INCLUDE_DIR) $(LIBRARY_DIR) 
	endif
    LIBS = -lraylib -lopengl32 -lgdi32 -lwinmm
endif

ifeq ($(PLATFORM),PLATFORM_WEB)
    CC = emcc
    EXT = .html
    CFLAGS ?= $(DEFINES) $(RAYLIB_DIR)/raylib/src/libraylib.a -ffast-math -D NDEBUG -O3 -s USE_GLFW=3 -s FORCE_FILESYSTEM=1 -s MAX_WEBGL_VERSION=2 -s ALLOW_MEMORY_GROWTH=1 --preload-file $(dir $<)resources@resources --shell-file ./shell.html $(INCLUDE_DIR) $(LIBRARY_DIR)
    #CFLAGS ?= $(DEFINES) /home/xiani/_WORK/raylib-4.2.0_webassembly/lib/libraylib.a -ffast-math -D NDEBUG -O3 -s USE_GLFW=3 -s FORCE_FILESYSTEM=1 -s MAX_WEBGL_VERSION=2 -s ALLOW_MEMORY_GROWTH=1 --preload-file $(dir $<)resources@resources --shell-file ./shell.html $(INCLUDE_DIR) $(LIBRARY_DIR)
#    CFLAGS ?= $(DEFINES) /home/xiani/_WORK/raylib/raylib/cmake-build-release-wsl/raylib/libraylib.a -ffast-math -D NDEBUG -O3 -s USE_GLFW=3 -s FORCE_FILESYSTEM=1 -s MAX_WEBGL_VERSION=2 -s ALLOW_MEMORY_GROWTH=1 --preload-file $(dir $<)resources@resources --shell-file ./shell.html $(INCLUDE_DIR) $(LIBRARY_DIR)
endif

#SOURCE = $(wildcard *.cpp)
#HEADER = $(wildcard *.h)

SOURCE = controller.cpp
HEADER = $(wildcard *.h)

ifeq ($(VERSION),VERSION_LIB)
	SOURCE = mmatching.cpp
endif
ifeq ($(TYPE),TST)
	SOURCE = mmatching.cpp
endif

.PHONY: all

all: controller

controller: $(SOURCE) $(HEADER)
	$(CC) -o $@$(EXT) $(SOURCE) $(CFLAGS) $(LIBS) 

mmatching: $(SOURCE) $(HEADER)
	$(CC) -o $@$(EXT) $(SOURCE) $(CFLAGS) $(LIBS) -sEXPORTED_RUNTIME_METHODS=ccall,cwrap
	#$(CC) -o $@$(EXT) $(SOURCE) $(CFLAGS) $(LIBS) -sEXPORTED_FUNCTIONS=_clamp_character_position -sEXPORTED_RUNTIME_METHODS=ccall,cwrap

clean:
	rm controller$(EXT)
	rm mmatching$(EXT)
