#include "base_spec.h"

#ifdef PRINT

#include <omp.h>
#include <iostream>

namespace vd
{

void BaseSpec::wasFound()
{
#ifdef PARALLEL
#pragma omp critical (print)
    {
#endif // PARALLEL
        info();
        std::cout << " was found" << std::endl;
#ifdef PARALLEL
    }
#endif // PARALLEL
}

void BaseSpec::wasForgotten()
{
#ifdef PARALLEL
#pragma omp critical (print)
    {
#endif // PARALLEL
        info();
        std::cout << " was forgotten" << std::endl;
#ifdef PARALLEL
    }
#endif // PARALLEL
}

}

#endif // PRINT