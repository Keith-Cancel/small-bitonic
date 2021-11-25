# Small Bitonic
A bitonic sort for small arrays of size 8 and 16 written in AVX-2 assembly. The assembly file has been written in such a way that it supports linux, macOS and windows.

## Results
When testing on a Xeon E3-1230 v5 these 2 functions where about 50% faster than C++'s std::sort().

## Uses
Mainly useful for acting a recursion terminator in a larger sorting algorithm.
