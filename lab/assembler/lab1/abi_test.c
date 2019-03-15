//void foo1(long, int, short, signed char, unsigned char, unsigned short, unsigned int, unsigned long);
//
//void bar1() {
//foo1(1, 2, 3, 4, 5, 6, 7, 8);
//}

/*
<- 64 ->
<- RSP
sub    rsp,0x8 // 8 bajtów, 64 bity

<- 64 ->
......  rsp wskazuje teraz niżej po subie
<- RSP

mov    r9d,0x6
mov    r8d,0x5
push   0x8


<- 64 ->
......  rsp wskazuje teraz niżej po subie
0x8
<- RSP

push   0x7
<- 64 ->
......  pusto
0x8
0x7
<- RSP

// wyrówaninie - adres musi być poedzileny przez 16, 2 elem, rozjechałby podzielność, modulo 16 musi się zgadzać,
// daletgo jest puste miejsce nad w naszym stosie

mov    ecx,0x4
mov    edx,0x3
mov    esi,0x2
mov    edi,0x1

// wyrówaninie - adres musi być poedzileny przez 16, 2 elem, rozjechałby podzielność, modulo 16 musi się zgadzać,
// daletgo jest puste miejsce nad w naszym stosie


//adresy na stosie podzielne przez 16, czyli co dwie komórki, bo jedna ma 8

call   2d <bar1+0x2d>
<- 64 ->
......  pusto
0x8
0x7
return
<- RSP

wywoałnie fukncji zrobiło ret / wywołujący musi sprzątać(?)
<- 64 ->
......  pusto
0x8
0x7
<- RSP


add    rsp,0x18 //przesunęło o 3 bloki w górę
<- 64 ->
<- RSP
......  pusto
0x8
0x7


*/

//////////////////////////////////////////////////////////////////////////

struct a {
    int x;
    int y;
} b;

//void foo2(long, struct a, int*, int);
//
//void bar2() {
//    struct a b;
//    b.x = 55;
//    b.y = 9;
//    int s = 88;
//    // wskażniki są przekazywane przez przekazywanie adresu, na któ©y ten wskaźnik wskazują
//    foo2(0x123456789abcdef0, b, &s, -1);
//    // przekazywanie dużej struktury - część w rejestrze, część na stosie
//    // małą strukturę upycha do jednego rejestru jak daje radę
//    //    9:   48 be 37 00 00 00 09    movabs rsi,0x900000037
//}

// dissassembler nam odwrócić na najbardzijej znaczące od prawej, tak jak u nas, naturalnie,
// chociaż  my mamy w argumencie jako little endian, fun fact
// 11:   48 bf f0 de bc 9a 78    movabs rdi,0x123456789abcdef0

///////////////////////////////////////////////////////////////////////////////
//1.3

//long foo11() {
//    return 0x1;
//}

//long foo12() {
//    return 0x123456789abcdef0;
//}

__int128_t foo13() {
    return 2999999994444999999;
}

struct a foo16(struct a x) {
    return x;
}

//1.4
//int foo14(signed char x) {
//    return x;
//}
//
//
//unsigned foo15(unsigned char x) {
//    return x;
//}



