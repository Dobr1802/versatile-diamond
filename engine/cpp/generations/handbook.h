#ifndef HANDBOOK_H
#define HANDBOOK_H

#include <omp.h>
#include "../tools/common.h"
#include "../species/keeper.h"
#include "../reactions/scavenger.h"
#include "../mc/mc.h"

#include "finder.h"
#include "names.h"
#include "crystals/diamond.h"

class Handbook
{
    // TODO: to be need to store number of species that need for start finding of association reactions
    typedef Keeper<2> DKeeper;
    static DKeeper __keeper;

    typedef Scavenger<1> DScavenger;
    static DScavenger __scavenger;

    typedef MC<2, 2> DMC;
    static DMC __mc;

public:
    static DKeeper &keeper();
    static DScavenger &scavenger();
    static DMC &mc();

    // atoms
    static const ushort __atomsNum;

private:
    static const bool __atomsAccordance[];
    static const ushort __atomsSpecifing[];

public:
    static bool atomIs(ushort complexType, ushort typeOf);
    static ushort specificate(ushort type);
};

#endif // HANDBOOK_H