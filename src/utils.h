#include <stdlib.h>

#ifndef wapcaplet_utils_h_
#define wapcaplet_utils_h_

#ifndef malloc_custom
#define malloc_custom

typedef void *(*custom_m_alloc)(size_t);
typedef void *(*custom_re_alloc)(void*, size_t);
typedef void *(*custom_c_alloc)(size_t, size_t);
typedef char *(*custom_str_dup)(const char*);
typedef char *(*custom_strn_dup)(const char*, size_t);
typedef void (*custom_f_ree)(void*);

void *m_alloc(size_t size);
void *re_alloc(void *ptr, size_t size);
void *c_alloc(size_t elementCount, size_t size);
char *str_dup(const char* s);
char *strn_dup(const char* s, size_t size);
void f_ree(void *ptr);

#define malloc(size) m_alloc(size)
#define realloc(ptr, size) re_alloc(ptr, size)
#define calloc(elementCount, size) c_alloc(elementCount, size)
#define strdup(ptr) str_dup(ptr)
#define strndup(ptr, size) strn_dup(ptr, size)
#define free(ptr) f_ree(ptr)

#endif

#endif
