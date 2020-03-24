#ifndef TIME_H
#define TIME_H

#include <iostream>
#include <cstdint>
#include <chrono>
#include <vector>
#include <algorithm>
#include <numeric>

using namespace std;

chrono::high_resolution_clock::time_point measure_time() {
    return chrono::high_resolution_clock::now();
}

template <typename TimeUnit = chrono::milliseconds>
auto calculate_time_difference(chrono::high_resolution_clock::time_point begin, chrono::high_resolution_clock::time_point end) {
    return chrono::duration_cast<TimeUnit>(end - begin).count();
}

double compute_mean(vector<double> const& v) {
    double sum = accumulate(v.begin(), v.end(), 0.0);
    return sum / (double) v.size();
}

double compute_standard_deviation(vector<double> const& v, double const mean) {
    vector<double> diff(v.size());
    transform(v.begin(), v.end(), diff.begin(), [mean](double x) { return x - mean; });
    double sq_sum = inner_product(diff.begin(), diff.end(), diff.begin(), 0.0);
    return sqrt(sq_sum / (double) v.size());
}


#endif // TIME

