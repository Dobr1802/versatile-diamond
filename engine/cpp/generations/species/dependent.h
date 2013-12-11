#ifndef DEPENDENT_H
#define DEPENDENT_H

#include "../../species/dependent_spec.h"
using namespace vd;

#include "parent.h"

template <ushort ST, ushort PARENTS_NUM, class B = DependentSpec<PARENTS_NUM>>
class Dependent : public Parent<B, ST, PARENTS_NUM>
{
    typedef Parent<B, ST, PARENTS_NUM> ParentType;

protected:
    template <class... Args>
    Dependent(Args... args) : ParentType(args...) {}

public:
    void store() override;
};

template <ushort ST, ushort PARENTS_NUM, class B>
void Dependent<ST, PARENTS_NUM, B>::store()
{
    B::store();
    ParentType::store();
}

#endif // DEPENDENT_H
