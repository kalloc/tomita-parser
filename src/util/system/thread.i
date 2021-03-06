//do not use directly
#pragma once
#include "platform.h"

#if defined(_win_)
    #include "winint.h"
    #include <process.h>

    typedef HANDLE THREADHANDLE;
#else
    #include <pthread.h>
    #include <sched.h>
    #include <errno.h>
    #include <string.h>

    typedef pthread_t THREADHANDLE;
#endif

#if defined(_freebsd_)
    #include <pthread_np.h>
#elif defined(_linux_)
    #include <sys/prctl.h>
#endif

#include <util/digest/numeric.h>

static inline size_t SystemCurrentThreadIdImpl() throw () {
    #if defined(_unix_)
        return (size_t)pthread_self();
    #elif defined(_win_)
        return (size_t)GetCurrentThreadId();
    #else
        #error todo
    #endif
}

template <class T>
static inline T ThreadIdHashFunction(T t) throw () {
    /*
     * we must permute threadid bits, because some strange platforms(such Linux)
     * have strange threadid numeric properties
     */
    return IntHash(t);
}

static inline size_t SystemCurrentThreadId() throw () {
    return ThreadIdHashFunction(SystemCurrentThreadIdImpl());
}
