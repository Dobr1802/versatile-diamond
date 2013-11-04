#ifndef ADDITIONAL_ATOMS_WRAPPER_H
#define ADDITIONAL_ATOMS_WRAPPER_H

#include "../tools/common.h"
#include "../atoms/atom.h"

#ifdef PRINT
#include <functional>
#include <iostream>
#endif // PRINT

namespace vd
{

template <class B, ushort ATOMS_NUM>
class AdditionalAtomsWrapper : public B
{
    Atom *_additionalAtoms[ATOMS_NUM];

public:
    template <class... Ts>
    AdditionalAtomsWrapper(Atom **additionalAtoms, Ts... args);

    Atom *atom(ushort index) override;

#ifdef PRINT
    void info() override;
    void eachAtom(const std::function<void (Atom *)> &lambda) override;
#endif // PRINT
};

template <class B, ushort ATOMS_NUM>
template <class... Ts>
AdditionalAtomsWrapper<B, ATOMS_NUM>::AdditionalAtomsWrapper(Atom **additionalAtoms, Ts... args) : B(args...)
{
    for (int i = 0; i < ATOMS_NUM; ++i)
    {
        _additionalAtoms[i] = additionalAtoms[i];
    }
}

template <class B, ushort ATOMS_NUM>
Atom *AdditionalAtomsWrapper<B, ATOMS_NUM>::atom(ushort index)
{
    return (index < ATOMS_NUM) ? _additionalAtoms[index] : B::atom(index - ATOMS_NUM);
}

#ifdef PRINT
template <class B, ushort ATOMS_NUM>
void AdditionalAtomsWrapper<B, ATOMS_NUM>::info()
{
    B::info();
    std::cout << " && additional: ";
    for (int i = 0; i < ATOMS_NUM; ++i)
    {
        std::cout << " ";
        _additionalAtoms[i]->info();
    }
}

template <class B, ushort ATOMS_NUM>
void AdditionalAtomsWrapper<B, ATOMS_NUM>::eachAtom(const std::function<void (Atom *)> &lambda)
{
    for (int i = 0; i < ATOMS_NUM; ++i)
    {
        lambda(_additionalAtoms[i]);
    }

    B::eachAtom(lambda);
}
#endif // PRINT

}

#endif // ADDITIONAL_ATOMS_WRAPPER_H