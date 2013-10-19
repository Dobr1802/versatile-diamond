#ifndef BASE_SPEC_H
#define BASE_SPEC_H

#include <vector>
#include <unordered_set>
#include <memory>
#include "atom.h"

namespace vd
{

class BaseSpec
{
public:
    virtual ~BaseSpec() {}

    virtual ushort type() const = 0;
    virtual void setupAtomTypes(std::shared_ptr<BaseSpec> &spec, ushort *types) = 0;

//    virtual Atom *anchor() const = 0;
    virtual Atom *atom(ushort index) = 0;

    virtual ushort size() const = 0; // TODO: временный метод для тест-спеков

    virtual void findChildren() = 0;
};



template <ushort ATOMS_NUM>
class SourceBaseSpec : public BaseSpec
{
    ushort _type;
    Atom *_atoms[ATOMS_NUM];

public:
    SourceBaseSpec(ushort type, Atom **atoms);

    ushort type() const { return _type; }
    void setupAtomTypes(std::shared_ptr<BaseSpec> &spec, ushort *types);

//    Atom *anchor() const { return atom(0); }
    Atom *atom(ushort index);

    ushort size() const { return ATOMS_NUM; } // TODO: временный метод для тест-спеков
};

template <ushort ATOMS_NUM>
SourceBaseSpec<ATOMS_NUM>::SourceBaseSpec(ushort type, Atom **atoms) : _type(type)
{
    for (int i = 0; i < ATOMS_NUM; ++i)
    {
        _atoms[i] = atoms[i];
    }
}

template <ushort ATOMS_NUM>
void SourceBaseSpec<ATOMS_NUM>::setupAtomTypes(std::shared_ptr<BaseSpec> &spec, ushort *types)
{
    for (int i = 0; i < ATOMS_NUM; ++i)
    {
        _atoms[i]->describe(types[i], spec);
    }
}

template <ushort ATOMS_NUM>
Atom *SourceBaseSpec<ATOMS_NUM>::atom(ushort index)
{
    assert(ATOMS_NUM > index);
    return _atoms[index];
}

}

#endif // BASE_SPEC_H
