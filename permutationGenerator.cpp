#include<iostream>
#include<cstdint>
#include<cstdlib>
#include<random>
#include<algorithm>
#include<chrono>

int main(int argc, char* argv[]) {
    using clk = std::chrono::high_resolution_clock;
    using dur = std::chrono::duration<double>;
    auto beg = clk::now();
    double sec;

    uint64_t size;
    char* t = nullptr;
    if (argc != 2 || (size = strtoull(argv[1], &t, 10)) == 0  || errno) {
        std::cerr << "Generates a permutation of length n with exactly one cycle.\n"
            << "Outputs to stdout n+1 64-bit integers (the first is n, the rest is the permutation).\n"
            << "Exactly one parameter must be passed, n: a nonnegative nonzero integer." << std::endl;
        return 1;
    }

    std::cerr << "Generating permutation of " << size << " 8 byte elements, for a total of " 
        << 8*size << " bytes of memory usage (" << (8.0*size)/(1<<30) << " GiB). This program's"
        << " max RSS should be double that: " << (16.0*size)/(1<<30) << " GiB." << std::endl;

    std::cerr << "Allocating arr of size " << size << std::endl;
    beg = clk::now();
    uint64_t *arr = new uint64_t[size];
    std::cerr << "Done in " << dur(clk::now() - beg).count() << " seconds" << std::endl;
    std::cerr << "generating random permutation" << std::endl;
    beg = clk::now();
    for (uint64_t i = 0; i < size; ++i) 
        arr[i] = i;

    std::random_device rd;
    std::mt19937 g(rd());

    std::shuffle(arr, arr+size, g);
    std::cerr << "Done in " << (sec = dur(clk::now() - beg).count()) << " seconds" << std::endl;

    std::cerr << "converting to permutation with one cycle" << std::endl;
    beg = clk::now();
    uint64_t *arr2 = new uint64_t[size];
    arr2[arr[size-1]] = arr[0];
    for (uint64_t i = 0; i < size - 1; ++i)
        arr2[arr[i]] = arr[i+1];
    std::cerr << "Done in " << (sec = dur(clk::now() - beg).count()) << " seconds" << std::endl;
    
    delete [] arr;

    std::cout.write(reinterpret_cast<char*>(&size), sizeof(uint64_t));
    std::cout.write(reinterpret_cast<char*>(arr2), sizeof(uint64_t)*size);

    /*
    std::cerr << size << std::endl;
    for (uint64_t i = 0; i < size; ++i)
        std::cerr << arr2[i] << '\t';
    std::cerr << std::endl;
    */
    
    delete [] arr2;

    return 0;
}
