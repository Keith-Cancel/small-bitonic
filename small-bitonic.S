/*
MIT License

Copyright (c) 2021 Keith-Cancel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#if defined(__linux__)
    #define SYSTEM_V_ABI 1
#elif defined(__APPLE__) && defined(__MACH__)
    #define SYSTEM_V_ABI 1
#elif defined(__OpenBSD__) || defined(__FreeBSD__) || defined(__NetBSD__)
    #define SYSTEM_V_ABI 1
#elif defined(_WIN32) || defined(__WIN32) || defined(_WIN64)
    #define WIN_X64_ABI 1
#endif

// define these as empty macros on SYSTEM V
// that way on a non-windows system there is no errors.
#if defined(SYSTEM_V_ABI)
.macro .seh_proc a
.endm

.macro .seh_endproc
.endm

.macro .seh_endprologue
.endm

.macro .seh_pushreg a
.endm
#endif

#if defined(SYSTEM_V_ABI)
    #define arg1 %rdi
#elif defined(WIN_X64_ABI)
    #define arg1 %rcx
#else
    #error Unknown x86_64 ABI. Sadly not ported to your system.
#endif

    .text
    .globl	    bitonic_8
    .align 16
    .seh_proc	bitonic_8
bitonic_8:
    .seh_endprologue
    vmovdqu   (arg1), %ymm0
    vpshufd   $177,  %ymm0, %ymm4
    vpmaxud   %ymm0, %ymm4, %ymm2
    vpminud   %ymm0, %ymm4, %ymm0
    vpblendd  $153,  %ymm0, %ymm2, %ymm0

    vpshufd   $78,   %ymm0, %ymm4
    vpmaxud   %ymm0, %ymm4, %ymm2
    vpminud   %ymm0, %ymm4, %ymm0
    vpblendd  $60,   %ymm0, %ymm2, %ymm0

    vpshufd   $177,  %ymm0, %ymm4
    vpmaxud   %ymm0, %ymm4, %ymm2
    vpminud   %ymm0, %ymm4, %ymm0
    vpblendd  $90,   %ymm0, %ymm2, %ymm0

    vperm2i128 $1,   %ymm0, %ymm0, %ymm4
    vpmaxud   %ymm0, %ymm4, %ymm2
    vpminud   %ymm0, %ymm4, %ymm0
    vpblendd  $15,   %ymm0, %ymm2, %ymm0

    vpshufd   $78,   %ymm0, %ymm4
    vpmaxud   %ymm0, %ymm4, %ymm2
    vpminud   %ymm0, %ymm4, %ymm0
    vpblendd  $51,   %ymm0, %ymm2, %ymm0

    vpshufd   $177,  %ymm0, %ymm4
    vpmaxud   %ymm0, %ymm4, %ymm2
    vpminud   %ymm0, %ymm4, %ymm0
    vpblendd  $85,   %ymm0, %ymm2, %ymm0

    vmovdqu	%ymm0, (arg1)
	vzeroupper
	ret
    .seh_endproc

    .text
    .globl	    bitonic_16
    .align 16
    .seh_proc	bitonic_16
bitonic_16:
    .seh_endprologue
    vmovdqu    (arg1),  %ymm0
    vmovdqu  32(arg1),  %ymm1

    # bitonic swap between adjacent words
    vpshufd   $177,  %ymm0, %ymm4
    vpshufd   $177,  %ymm1, %ymm5

    vpmaxud   %ymm0, %ymm4, %ymm2
    vpmaxud   %ymm1, %ymm5, %ymm3

    vpminud   %ymm0, %ymm4, %ymm0
    vpminud   %ymm1, %ymm5, %ymm1

    vpblendd  $153,  %ymm0, %ymm2, %ymm0
    vpblendd  $102,  %ymm1, %ymm3, %ymm1

    # bitonic swap every other word
    vpshufd   $78,   %ymm0, %ymm4
    vpshufd   $78,   %ymm1, %ymm5

    vpmaxud   %ymm0, %ymm4, %ymm2
    vpmaxud   %ymm1, %ymm5, %ymm3

    vpminud   %ymm0, %ymm4, %ymm0
    vpminud   %ymm1, %ymm5, %ymm1

    vpblendd  $60,   %ymm0, %ymm2, %ymm0
    vpblendd  $195,  %ymm1, %ymm3, %ymm1

    # bitonic swap between adjacent words
    vpshufd   $177,  %ymm0, %ymm4
    vpshufd   $177,  %ymm1, %ymm5

    vpmaxud   %ymm0, %ymm4, %ymm2
    vpmaxud   %ymm1, %ymm5, %ymm3

    vpminud   %ymm0, %ymm4, %ymm0
    vpminud   %ymm1, %ymm5, %ymm1

    vpblendd  $90,   %ymm0, %ymm2, %ymm0
    vpblendd  $165,  %ymm1, %ymm3, %ymm1

    # bitonic swap between halves
    vperm2i128 $1,  %ymm0, %ymm0, %ymm4
    vperm2i128 $1,  %ymm1, %ymm1, %ymm5

    vpmaxud   %ymm0, %ymm4, %ymm2
    vpmaxud   %ymm1, %ymm5, %ymm3

    vpminud   %ymm0, %ymm4, %ymm0
    vpminud   %ymm1, %ymm5, %ymm1

    vpblendd  $15,   %ymm0, %ymm2, %ymm0
    vpblendd  $240,    %ymm1, %ymm3, %ymm1

    # bitonic swap between adjacent words
    vpshufd   $78,   %ymm0, %ymm4
    vpshufd   $78,   %ymm1, %ymm5

    vpmaxud   %ymm0, %ymm4, %ymm2
    vpmaxud   %ymm1, %ymm5, %ymm3

    vpminud   %ymm0, %ymm4, %ymm0
    vpminud   %ymm1, %ymm5, %ymm1

    vpblendd  $51,   %ymm0, %ymm2, %ymm0
    vpblendd  $204,  %ymm1, %ymm3, %ymm1

    # bitonic swap between adjacent words
    vpshufd   $177,  %ymm0, %ymm4
    vpshufd   $177,  %ymm1, %ymm5

    vpmaxud   %ymm0, %ymm4, %ymm2
    vpmaxud   %ymm1, %ymm5, %ymm3

    vpminud   %ymm0, %ymm4, %ymm0
    vpminud   %ymm1, %ymm5, %ymm1

    vpblendd  $85,   %ymm0, %ymm2, %ymm0
    vpblendd  $170,  %ymm1, %ymm3, %ymm1

    # bitonic swap between registers
    vpmaxud   %ymm0, %ymm1, %ymm3
    vpminud   %ymm0, %ymm1, %ymm0

    # bitonic swap between halves
    vperm2i128 $1,  %ymm0, %ymm0, %ymm4
    vperm2i128 $1,  %ymm3, %ymm3, %ymm5

    vpmaxud   %ymm0, %ymm4, %ymm2
    vpmaxud   %ymm3, %ymm5, %ymm1

    vpminud   %ymm0, %ymm4, %ymm0
    vpminud   %ymm3, %ymm5, %ymm3

    vpblendd  $15,   %ymm0, %ymm2, %ymm0
    vpblendd  $15,   %ymm3, %ymm1, %ymm1

    # bitonic swap between adjacent words
    vpshufd   $78,   %ymm0, %ymm4
    vpshufd   $78,   %ymm1, %ymm5

    vpmaxud   %ymm0, %ymm4, %ymm2
    vpmaxud   %ymm1, %ymm5, %ymm3

    vpminud   %ymm0, %ymm4, %ymm0
    vpminud   %ymm1, %ymm5, %ymm1

    vpblendd  $51,   %ymm0, %ymm2, %ymm0
    vpblendd  $51,   %ymm1, %ymm3, %ymm1

    # bitonic swap between adjacent words
    vpshufd   $177,  %ymm0, %ymm4
    vpshufd   $177,  %ymm1, %ymm5

    vpmaxud   %ymm0, %ymm4, %ymm2
    vpmaxud   %ymm1, %ymm5, %ymm3

    vpminud   %ymm0, %ymm4, %ymm0
    vpminud   %ymm1, %ymm5, %ymm1

    vpblendd  $85,   %ymm0, %ymm2, %ymm0
    vpblendd  $85,   %ymm1, %ymm3, %ymm1
    vmovdqu    %ymm0,   (arg1)
    vmovdqu    %ymm1, 32(arg1)
    vzeroupper
    ret
    .seh_endproc