#include "methyl_on_dimer_cmsu.h"
#include "../../reactions/typical/methyl_to_high_bridge.h"

ushort MethylOnDimerCMsu::__indexes[1] = { 0 };
ushort MethylOnDimerCMsu::__roles[1] = { 29 };

void MethylOnDimerCMsu::find(MethylOnDimerCMu *parent)
{
    Atom *anchor = parent->atom(0);

    if (anchor->is(29))
    {
        if (!anchor->hasRole(29, METHYL_ON_DIMER_CMsu))
        {
            auto spec = new MethylOnDimerCMsu(parent);
            spec->store();
        }
    }
}

void MethylOnDimerCMsu::findChildren()
{
    MethylToHighBridge::find(this);
}