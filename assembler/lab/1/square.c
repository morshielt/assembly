#include <stdint.h>

//int64_t ssquare(int32_t x) {
//    return (int64_t)x * (int64_t)x;
//}

//uint64_t usquare(uint32_t x) {
//    return (uint64_t)x * (uint64_t)x;
//}

int64_t sddiv(int64_t x) {
    return x / 2; // shr, sar - shifty logiczny/arytmetyczny
    // bo div wolniejsze niż shift

}

int64_t ssdiv(int64_t x) {
    return x >> 1; // sar
}

uint64_t uddiv(uint64_t x) {
    return x / 2;  // shr
}

uint64_t usdiv(uint64_t x) {
    return x >> 1;
}

int64_t smmul(int64_t x) {
    return x * 2;
    // lea reg, [reg + reg*4+100]
    // można *4, 8, 16, 32 (no jakoś któreś z tych liczb)
    // load effective address - nie służyło do mnożenia xD
    // początek, przesunięcie, który elem w strukturze i z tego mieć adres
    // ale to jest szybkie, a mul troszku mniej

    // te nop'y na końcu wyrównują

}

int64_t ssmul(int64_t x) {
    return x << 1;
}

uint64_t ummul(uint64_t x) {
    return x * 2;
}

uint64_t usmul(uint64_t x) {
    return x << 1;
}
