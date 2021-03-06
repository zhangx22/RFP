#include "TempDiffusion.h"

template<>
InputParameters validParams<TempDiffusion>()
{
  InputParameters params = validParams<Diffusion>();
  return params;
}

TempDiffusion::TempDiffusion(const InputParameters & parameters) :
    Diffusion(parameters),
    _k(getMaterialPropertyByName<Real>("TConductivity"))

{
}

Real TempDiffusion::computeQpResidual()
{
  return _k[_qp] * Diffusion::computeQpResidual();
}

Real TempDiffusion::computeQpJacobian()
{
  return _k[_qp] * Diffusion::computeQpJacobian();
}
