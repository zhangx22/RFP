#ifndef TEMPDIFF_H
#define TEMPDIFF_H

#include "Diffusion.h"

class TempDiffusion;

template<>
InputParameters validParams<TempDiffusion>();

class TempDiffusion : public Diffusion
{
public:
  TempDiffusion(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

	const MaterialProperty<Real> & _k; //added,to enable multi domain conductivity definition

  //                   const   _k(getMaterialProperty<Real>("TConductivity"));
};

#endif  //TEMPDIFF_H
