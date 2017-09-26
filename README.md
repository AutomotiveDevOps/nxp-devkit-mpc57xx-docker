# DEVKIT-Makefile
Makefiles for NXP's DEVKIT-MPC57xx boards.


https://www.nxp.com/support/developer-resources/run-time-software/s32-design-studio-ide/s32-design-studio-ide:S32DS?&tab=Design_Tools_Tab

https://cache.nxp.com/secured/updates/S32DS/e200_gcc_1.2.tar.bz2


### Make

https://nuwen.net/mingw.html


https://blog.melski.net/2015/01/12/whats-new-in-gnu-make-4-1/

> The $(file) function was added in GNU make 4.0 to enable writing to files from a makefile without having to invoke a second process to do so. For example, where previously you had to do something like $(shell echo hello > myfile), now you can instead use $(file > myfile,foo). In theory this is more efficient, since it avoids creating another process, and it enables the user to easily write large blocks of text which would exceed command-line length limitations on some platforms.