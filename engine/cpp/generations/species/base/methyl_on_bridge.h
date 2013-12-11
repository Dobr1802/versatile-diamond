#ifndef METHYL_ON_BRIDGE_H
#define METHYL_ON_BRIDGE_H

#include "../../../species/additional_atoms_wrapper.h"
#include "../dependent.h"
#include "bridge.h"

class MethylOnBridge : public Dependent<METHYL_ON_BRIDGE, 2, AdditionalAtomsWrapper<DependentSpec<1>, 1>>
{
public:
    static void find(Bridge *target);

//    using Dependent::Dependent;
    MethylOnBridge(Atom **additionalAtoms, BaseSpec *parent) : Dependent(additionalAtoms, &parent) {}

#ifdef PRINT
    std::string name() const override { return "methyl on bridge"; }
#endif // PRINT

    ushort *indexes() const override { return __indexes; }
    ushort *roles() const override { return __roles; }

protected:
    void findAllChildren() override;

private:
    static ushort __indexes[2];
    static ushort __roles[2];
};

#endif // METHYL_ON_BRIDGE_H
