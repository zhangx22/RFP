/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/
#include "ExampleApp.h"
#include "Moose.h"
#include "Factory.h"
#include "AppFactory.h"
#include "MooseSyntax.h"

// Example 2 Includes

#include "TempDiffusion.h"               // <- I included TempDiffusion kernel
#include "HeatConductionTimeDerivative.h"// <- I included time derivative kernel

#include "DCPDnonDgeneralPT.h" //I included for non dimensional, DCPD general conc. from Kessler for PT CURE MODEL

#include "CoupledCureTimeDerivative.h"

#include "TimeDerivative.h"
#include "CoupledTimeDerivative.h"
template<>
InputParameters validParams<ExampleApp>()
{
  InputParameters params = validParams<MooseApp>();

  params.set<bool>("use_legacy_uo_initialization") = false;
  params.set<bool>("use_legacy_uo_aux_computation") = false;
  return params;
}

ExampleApp::ExampleApp(InputParameters parameters) :
    MooseApp(parameters)
{
  srand(processor_id());

  Moose::registerObjects(_factory);
  ExampleApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ExampleApp::associateSyntax(_syntax, _action_factory);
}

ExampleApp::~ExampleApp()
{
}

void
ExampleApp::registerObjects(Factory & factory)
{
  // Register any custom objects you have built on the MOOSE Framework
  registerKernel(CoupledCureTimeDerivative);  // <- registration
  registerKernel(TempDiffusion);      // <- registration for temperature diffusion created by me
  registerKernel(HeatConductionTimeDerivative);     // <- registration for heat conduction time derivative kernel
  //registerKernel(CoupledTimeDerivative); //will be used for cure time derivative
  //registerKernel(TimeDerivative);
  
 registerKernel(DCPDnonDgeneralPT); //contains DCPD general nondimensional cure function from Kessler paper for PT CURE MODEL

// registerKernel(MatDiffusionBase);
//registerKernel(AnisotropicDiffusion);
}

void
ExampleApp::registerApps()
{
  registerApp(ExampleApp);
}

void
ExampleApp::associateSyntax(Syntax& /*syntax*/, ActionFactory & /*action_factory*/)
{
}
