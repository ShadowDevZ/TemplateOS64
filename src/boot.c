#include "limine/include/limine.h"
#include "limine/flanterm/flanterm.h"
#include "limine/flanterm/backends/fb.h"
#include "include/boot.h"
volatile struct limine_framebuffer_request framebuffer_request = {
    .id = LIMINE_FRAMEBUFFER_REQUEST,
    .revision = 0
};



struct flanterm_context *ft_ctx;

void *memcpy(void *dest, const void *src, size_t n) {
    uint8_t *pdest = (uint8_t *)dest;
    const uint8_t *psrc = (const uint8_t *)src;

    for (size_t i = 0; i < n; i++) {
        pdest[i] = psrc[i];
    }

    return dest;
}

void *memset(void *s, int c, size_t n) {
    uint8_t *p = (uint8_t *)s;

    for (size_t i = 0; i < n; i++) {
        p[i] = (uint8_t)c;
    }

    return s;
}


void _start() {
    if (framebuffer_request.response->framebuffer_count < 1 || framebuffer_request.response->framebuffers[0] == NULL) {
        halt_cpu();
    } 
    ft_ctx = flanterm_fb_simple_init(
    framebuffer_request.response->framebuffers[0]->address, framebuffer_request.response->framebuffers[0]->width, \
    framebuffer_request.response->framebuffers[0]->height, \
    framebuffer_request.response->framebuffers[0]->pitch);

     const char msg[] = "Hello world\n";
    flanterm_write(ft_ctx, msg, sizeof(msg));

    halt_cpu();
}