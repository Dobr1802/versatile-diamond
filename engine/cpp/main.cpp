#include "mc/common_mc_data.h"
#include "generations/handbook.h"
#include "generations/crystals/diamond.h"

#include "tests/support/open_diamond.h"

#include <iostream>
using namespace std;
#ifdef PRINT
#endif // PRINT

int main()
{
#ifdef PARALLEL
    omp_set_num_threads(THREADS_NUM);
#endif // PARALLEL

#ifdef PRINT
#ifdef PARALLEL
    cout << "Start as PARALLEL mode" << endl;
#else
    cout << "Start as SINGLE THREAD mode" << endl;
#endif // PARALLEL
#endif // PRINT

//    Diamond *diamond = new Diamond(dim3(100, 100, 10));
    Diamond *diamond = new Diamond(dim3(20, 20, 10));
//    Diamond *diamond = new Diamond(dim3(3, 3, 4));
    diamond->initialize();

    cout << "Atoms num: " << diamond->countAtoms() << endl;
#ifdef PRINT
    cout << Handbook::mc().totalRate() << endl;
    int i = 0;
#endif // PRINT

    CommonMCData mcData;
#ifdef PARALLEL
#pragma omp parallel
#endif // PARALLEL
//    for (int i = 0; i < 5; ++i)
    while (Handbook::mc().totalTime() < 0.5)
    {
        Handbook::mc().doRandom(&mcData);

#ifdef PRINT
#ifdef PARALLEL
#pragma omp critical (print)
#endif // PARALLEL
        cout << (++i) << ". " << Handbook::mc().totalRate() << "\n\n\n" << endl;
#endif // PRINT
    }

#ifdef PRINT
#endif // PRINT
    cout << "Atoms num: " << diamond->countAtoms() << endl;

    delete diamond;
    return 0;
}
