#include "bridge_ctsi.h"
#include "../handbook.h"
#include "../reactions/typical/dimer_formation.h"

void BridgeCTsi::find(BaseSpec *parent)
{
    Atom *anchor = parent->atom(0);

    if (anchor->is(28))
    {
        if (!anchor->prevIs(28))
        {
            auto spec = std::shared_ptr<BaseSpec>(new BridgeCTsi(BRIDGE_CTsi, parent));

#ifdef PRINT
            spec->wasFound();
#endif // PRINT

            anchor->describe(28, spec);

            Handbook::keeper().store<KEE_BRIDGE_CTsi>(spec.get());
        }
    }
    else
    {
        if (anchor->hasRole(28, BRIDGE_CTsi))
        {
            auto spec = dynamic_cast<SpecificSpec *>(anchor->specByRole(28, BRIDGE_CTsi));
            assert(spec);
            spec->removeReactions();

#ifdef PARALLEL
#pragma omp critical (print)
#endif // PARALLEL
            std::cout << omp_get_thread_num() << " $ " << "bridgeCTsi " << spec << " was forgotten" << std::endl;

#ifdef PRINT
            spec->wasForgotten();
#endif // PRINT

            anchor->forget(28, BRIDGE_CTsi);
        }
    }
}

void BridgeCTsi::findChildren()
{
    DimerFormation::find(this);
}