#ifndef DIMER_DROP_AT_END_H
#define DIMER_DROP_AT_END_H

#include "../concretizable_role.h"
#include "../lateral.h"

class DimerDropAtEnd : public ConcretizableRole<Lateral, DIMER_DROP_AT_END, 1>
{
public:
    template <class... Args>
    DimerDropAtEnd(Args... args) : ConcretizableRole(args...) {}

    double rate() const { return 4.9e3; }
    std::string name() const { return "dimer drop at end of dimers row"; }

    void createUnconcreted(LateralSpec *removableSpec) override;
};

#endif // DIMER_DROP_AT_END_H
