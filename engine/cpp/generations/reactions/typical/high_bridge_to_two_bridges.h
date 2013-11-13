#ifndef HIGH_BRIDGE_TO_TWO_BRIDGES_H
#define HIGH_BRIDGE_TO_TWO_BRIDGES_H

#include "../../species/specific/high_bridge.h"
#include "../../species/specific/bridge_crs.h"
#include "../many_typical.h"

class HighBridgeToTwoBridges : public ManyTypical<HIGH_BRIDGE_STAND_TO_TWO_BRIDGES, 2>
{
public:
    static void find(HighBridge *target);
    static void find(BridgeCRs *target);

//    using ManyTypical::ManyTypical;
    HighBridgeToTwoBridges(SpecificSpec **targets) : ManyTypical(targets) {}

    double rate() const { return 7.7e6; }
    void doIt();

#ifdef PRINT
    std::string name() const override { return "high bridge incorporates in crystal lattice near another bridge"; }
#endif // PRINT
};

#endif // HIGH_BRIDGE_TO_TWO_BRIDGES_H