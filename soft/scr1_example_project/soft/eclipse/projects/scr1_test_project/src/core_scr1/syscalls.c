#include "global_defs.h"
#include <stdint.h>
#include <sys/stat.h>

#if (G_CORE == CORE_SCR1)

int _close(int __unused file)
{
    return -1;
}

int _fstat(int __unused file, struct stat * __unused st)
{
	st->st_mode = S_IFCHR;
	return 0;
}

int _isatty(int __unused file)
{
    return 1;
}

int _lseek(int __unused file, int __unused ptr, int __unused dir)
{
    return 0;
}

int _open(const char __unused *name, int __unused flags, int __unused mode)
{
    return -1;
}

int _read(int __unused file, __unused char * ptr, int __unused len)
{
	int res = 0;

    return res;
}

caddr_t _sbrk(int incr)
{
	static char *heap_end = 0;

	extern char _end;
	extern char __STACK_START__;

	char *prev_heap_end;

	if (heap_end == 0) {
		heap_end = &_end;
	}
	prev_heap_end = heap_end;

	if (heap_end + incr > &__STACK_START__) {
		while(1){};
		return (caddr_t)0;
	}

	heap_end += incr;
	return (caddr_t) prev_heap_end;
}

#endif // G_CORE
