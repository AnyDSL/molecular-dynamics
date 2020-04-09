#include <algorithm>
#include <chrono>
#include <iostream>

using namespace std;

template<typename TimeType, typename TimeUnit = chrono::nanoseconds>
class MultiTimer {
public:
    MultiTimer(size_t ntimers, size_t nruns, TimeType _factor) : run(0), factor(_factor) {
        counters.resize(nruns);

        for(auto& run_counter: counters) {
            run_counter.resize(ntimers, 0);
        }
    }

    ~MultiTimer() {}

    void startRun() { clock = chrono::high_resolution_clock::now(); }
    void finishRun() { ++run; }

    void accum(size_t timer_id) {
        auto current_clock = chrono::high_resolution_clock::now();
        counters[run][timer_id] += static_cast<TimeType>(chrono::duration_cast<TimeUnit>(current_clock - clock).count()) * factor;
        clock = chrono::high_resolution_clock::now();
    }

    TimeType getRunsTotalAverage() {
        TimeType total_time = 0;

        for(auto& run_counter: counters) {
            total_time += accumulate(run_counter.begin(), run_counter.end(), 0);
        }

        return total_time / (TimeType) counters.size();
    }

    TimeType getRunsAverage(size_t timer_id) {
        TimeType sum = 0;

        for(auto& run_counter: counters) {
            sum += run_counter[timer_id];
        }

        return sum / (TimeType) counters.size();
    }

private:
    vector<vector<TimeType>> counters;
    chrono::high_resolution_clock::time_point clock;
    int run;
    TimeType factor;
};
