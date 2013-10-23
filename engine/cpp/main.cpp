#include "generations/handbook.h"
#include "generations/crystals/diamond.h"

#include "tests/support/open_diamond.h"

#include <omp.h>
#include <iostream>
using namespace std;

int main()
{
//    omp_set_num_threads(1);

//    Diamond *diamond = new OpenDiamond(2);
//    Diamond *diamond = new Diamond(dim3(100, 100, 20), 10);
    Diamond *diamond = new Diamond(dim3(4, 4, 4), 2);
    diamond->initialize();

    cout << Handbook::mc().totalRate() << endl;

//    for (int i = 0; i < 1; ++i)
//    {
//        cout << i << ". ";
//        Handbook::mc().doRandom();
//        cout << Handbook::mc().totalRate() << endl;
//    }

    Handbook::mc().doOneOfMul<SURFACE_ACTIVATION>();
    cout << Handbook::mc().totalRate() << endl;

    Handbook::mc().doOneOfMul<SURFACE_DEACTIVATION>();
    cout << Handbook::mc().totalRate() << endl;

    Handbook::mc().doOneOfOne<DIMER_FORMATION>();
    cout << Handbook::mc().totalRate() << endl;


//    Atom *a = diamond->atom(int3(2, 2, 1)), *b = diamond->atom(int3(2, 3, 1));
//    ReactionActivation raa(a);
//    raa.doIt();

//    cout << Handbook::mc().totalRate() << endl;

//    ReactionActivation rab(b);
//    rab.doIt();

//    cout << Handbook::mc().totalRate() << endl;

//    a->bondWith(b);

//    a->changeType(22);
//    b->changeType(22);

//    a->findChildren();
//    b->findChildren();

//    cout << Handbook::mc().totalRate() << endl;

//    Atom *c = diamond->atom(int3(4, 2, 1));
//    ReactionActivation rac(c);
//    rac.doIt();
//    rac.doIt();

//    cout << Handbook::mc().totalRate() << endl;

    delete diamond;
    return 0;
}
