#ifndef HANDBOOK_H
#define HANDBOOK_H

#include <omp.h>
#include "../common.h"

#include "dmc.h"
#include "names.h"
#include "crystals/diamond.h"
#include "base_specs/bridge.h"
#include "base_specs/dimer.h"
#include "specific_specs/bridge_cts.h"

class Handbook
{
    static DMC __mc;
public:
    static DMC &mc();

    // atoms
private:

    // TODO: move it to Atom (unitialized static variables, initializing of that will be in generated code)
    static const ushort __atomsNum;
    static const bool __atomsAccordance[];

    static const ushort __atomsSpecifing[];

public:
    static bool atomIs(ushort complexType, ushort typeOf);
    static ushort specificate(ushort type);
};

#endif // HANDBOOK_H
