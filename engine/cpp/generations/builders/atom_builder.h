#ifndef ATOM_BUILDER_H
#define ATOM_BUILDER_H

#include <vector>
#include "../atoms/c.h"
#include "../../atoms/lattice.h"

#include <assert.h>

using namespace vd;

class AtomBuilder
{
public:
    Atom *buildC(uint type, uint actives) const
    {
        return specify(new C(type, actives, (Lattice *)0));
    }

    Atom *buildCd(uint type, uint actives, const Crystal *crystal, const int3 &coords) const
    {
        return specify(new C(type, actives, new Lattice(crystal, coords)));
    }

private:
    Atom *specify(Atom *atom) const
    {
        atom->specifyType();
        return atom;
    }
};

#endif // ATOM_BUILDER_H
