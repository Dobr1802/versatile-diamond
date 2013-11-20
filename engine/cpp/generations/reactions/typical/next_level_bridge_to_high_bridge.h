#ifndef NEXT_LEVEL_BRIDGE_TO_HIGH_BRIDGE_H
#define NEXT_LEVEL_BRIDGE_TO_HIGH_BRIDGE_H

#include "../../species/specific/bridge_crs_cti_cli.h"
#include "../mono_typical.h"

class NextLevelBridgeToHighBridge : public MonoTypical<NEXT_LEVEL_BRIDGE_TO_HIGH_BRIDGE>
{
public:
    static void find(BridgeCRsCTiCLi *target);

//    using MonoTypical::MonoTypical;
    NextLevelBridgeToHighBridge(SpecificSpec *target) : MonoTypical(target) {}

    double rate() const { return 3.5e6; }
    void doIt();

    std::string name() const override { return "next layer bridge to high bridge"; }
};

#endif // NEXT_LEVEL_BRIDGE_TO_HIGH_BRIDGE_H
