#ifndef HIGH_BRIDGE_CMS_H
#define HIGH_BRIDGE_CMS_H

#include "high_bridge.h"

class HighBridgeCMs : public Specific<Base<DependentSpec<BaseSpec>, HIGH_BRIDGE_CMs, 1>>
{
public:
    static void find(HighBridge *parent);

    HighBridgeCMs(ParentSpec *parent) : Specific(parent) {}

#ifdef PRINT
    const char *name() const final;
#endif // PRINT

protected:
    void findAllTypicalReactions() final;
};

#endif // HIGH_BRIDGE_CMS_H
