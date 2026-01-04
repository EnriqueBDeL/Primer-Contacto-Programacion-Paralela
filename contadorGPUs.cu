#include <stdio.h>
#include <cuda_runtime.h>

int main() {
    int count;
    cudaGetDeviceCount(&count);
    printf("Devices: %d\n", count);
    return 0;
}
