#ifndef TIME_H
#define TIME_H

#include <iostream>
#include <cstdint>
#include <chrono>
#include <vector>
#include <algorithm>
#include <numeric>

std::chrono::high_resolution_clock::time_point measure_time() {
    return std::chrono::high_resolution_clock::now();
}

template <typename TimeUnit = std::chrono::milliseconds>
auto calculate_time_difference(std::chrono::high_resolution_clock::time_point begin, std::chrono::high_resolution_clock::time_point end) {
    return std::chrono::duration_cast<TimeUnit>(end - begin).count();
}

double compute_mean(std::vector<double> const& v) {
    double sum = std::accumulate(v.begin(), v.end(), 0.0);
    return sum / (double) v.size();
}

double compute_standard_deviation(std::vector<double> const& v, double const mean) {
    std::vector<double> diff(v.size());
    std::transform(v.begin(), v.end(), diff.begin(), [mean](double x) { return x - mean; });
    double sq_sum = std::inner_product(diff.begin(), diff.end(), diff.begin(), 0.0);
    return std::sqrt(sq_sum / (double) v.size());
}


#endif // TIME

