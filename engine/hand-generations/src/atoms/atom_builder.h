#ifndef ATOM_BUILDER_H
#define ATOM_BUILDER_H

#include <vector>
#include <atoms/lattice.h>
using namespace vd;

#include "../atoms/c.h"

class AtomBuilder
{
public:
    Atom *buildC(ushort type, ushort actives) const
    {
        return specify(new C(type, actives, (Lattice *)nullptr));
    }

    Atom *buildCd(ushort type, ushort actives, Crystal *crystal, const int3 &coords) const
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
