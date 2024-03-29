#ifdef __EMSCRIPTEN__
#include <emscripten/emscripten.h>
#else
#define EMSCRIPTEN_KEEPALIVE
#endif

#ifdef __cplusplus
#define EXTERN extern "C"
#else
#define EXTERN
#endif


EMSCRIPTEN_KEEPALIVE int main()
{
    return 0;
}

EXTERN EMSCRIPTEN_KEEPALIVE int myFunction(int n)
{
    if (n == 0)
        return 1;
    else
        return n * myFunction(n-1);

}
