#ifndef OVERALL_H
#define OVERALL_H

#include <species/base_spec.h>
#include <species/source_spec.h>
#include <species/dependent_spec.h>
#include <species/parent_spec.h>
#include <species/additional_atoms_wrapper.h>
#include <species/symmetric.h>
#include <tools/typed.h>
using namespace vd;

#include "../handbook.h"

template <class B, ushort ST>
class Overall : public Typed<B, ST>
{
    typedef Typed<B, ST> ParentType;

    bool _markedForRemove = false;

public:
    void remove() override;

protected:
    template <class... Args> Overall(Args... args) : ParentType(args...) {}

    bool isMarked() const { return _markedForRemove; }
};

//////////////////////////////////////////////////////////////////////////////////////

template <class B, ushort ST>
void Overall<B, ST>::remove()
{
//    if (this->isMarked()) return; // in each dependent types
    _markedForRemove = true;

    ParentType::remove();
    Handbook::scavenger().markSpec(this);
}

#endif // OVERALL_H
