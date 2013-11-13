#include "dimer.h"
#include "methyl_on_dimer.h"
#include "../specific/dimer_cri_cli.h"
#include "../specific/dimer_crs.h"

#include <assert.h>

ushort Dimer::__indexes[2] = { 0, 3 };
ushort Dimer::__roles[2] = { 22, 22 };

void Dimer::find(Atom *anchor)
{
    if (anchor->is(22))
    {
        auto spec = specFromAtom(anchor);
        if (spec)
        {
            static_cast<Dimer *>(spec)->correspondFindChildren();
        }
        else
        {
            auto nbrs = diamondBy(anchor)->front_100(anchor);
            if (nbrs[0]) checkAndAdd(anchor, nbrs[0]);
            if (nbrs[1] && nbrs[1]->isVisited()) checkAndAdd(anchor, nbrs[1]);
        }
    }
}

void Dimer::findChildren()
{
    MethylOnDimer::find(this);
    DimerCRiCLi::find(this);
    DimerCRs::find(this);
}

void Dimer::checkAndAdd(Atom *anchor, Atom *neighbour)
{
    if (neighbour->is(22) && anchor->hasBondWith(neighbour))
    {
        assert(neighbour->hasRole(3, BRIDGE)); // may be need move to if condition
        assert(neighbour->lattice());

        BaseSpec *parents[2] = {
            anchor->specByRole(3, BRIDGE),
            neighbour->specByRole(3, BRIDGE)
        };
        auto spec = new Dimer(parents);
        spec->store();
    }
}

BaseSpec *Dimer::specFromAtom(Atom *anchor)
{
    auto spec = anchor->specByRole(22, DIMER);
    if (!spec) return nullptr;

    uint ai = anotherIndex(spec, anchor);
    Atom *another = spec->atom(ai);

    return (ai != 0 || another->isVisited()) ? spec : nullptr;
}

uint Dimer::anotherIndex(BaseSpec *spec, Atom *anchor)
{
    return (spec->atom(0) == anchor) ? 3 : 0;
}