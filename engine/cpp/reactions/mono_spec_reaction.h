#ifndef MONO_SPEC_REACTION_H
#define MONO_SPEC_REACTION_H

#include "../species/specific_spec.h"
#include "wrappable_reaction.h"

#ifdef PRINT
#include <iostream>
#endif // PRINT

namespace vd
{

class MonoSpecReaction : public WrappableReaction
{
    SpecificSpec *_target = nullptr;

public:
    Atom *anchor() const override;

    void storeAs(SpecReaction *reaction) override;
    bool removeAsFrom(SpecReaction *reaction, SpecificSpec *target) override;

#ifdef PRINT
    void info(std::ostream &os);
#endif // PRINT

    SpecificSpec *target() { return _target; }

protected:
    MonoSpecReaction(SpecificSpec *target) : _target(target) {}
};

}

#endif // MONO_SPEC_REACTION_H
