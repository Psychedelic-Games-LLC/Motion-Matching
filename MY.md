1 add emsdk to PATH
```bash
source ~/_WORK/Motion-Matching/emsdk/emsdk_env.sh
```

2 use this to compile controller
```bash
make PLATFORM=PLATFORM_WEB TYPE=TST
```
```bash
 make PLATFORM=PLATFORM_WEB TYPE=TST mmatching
```


https://github.com/raysan5/raylib/wiki/Working-for-Web-(HTML5)

emcc -o game.html game.c -Os -Wall ./path-to/libraylib.a -I. -Ipath-to-raylib-h -L. -Lpath-to-libraylib-a -s USE_GLFW=3 --shell-file path-to/shell.html -DPLATFORM_WEB
```bash
emcc -o controller.html controller.cpp -Os -Wall /home/xiani/_WORK/raylib/raylib/src/libraylib.a -I. -I/home/xiani/_WORK/raylib/raylib/src/ -I/home/xiani/_WORK/raylib/raygui/src/ -L. -L/home/xiani/_WORK/raylib/raylib/src/ -s USE_GLFW=3 --shell-file ./shell.html -DPLATFORM_WEB
```
