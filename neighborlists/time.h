#ifndef TIME_H
#define TIME_H

#include <iostream>
#include <chrono>

std::chrono::high_resolution_clock::time_point measure_time() {
    return std::chrono::high_resolution_clock::now();
}

template <typename TimeUnit = std::chrono::milliseconds>
auto calculate_time_difference(std::chrono::high_resolution_clock::time_point begin, std::chrono::high_resolution_clock::time_point end) {
    return std::chrono::duration_cast<TimeUnit>(end - begin).count();
}


#endif // TIME

