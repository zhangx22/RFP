#FC in the filename means Fully Coupled
[Mesh]
  type = GeneratedMesh
  dim = 1
  # nx = 125
  nx = 1500
  #ny = 2
  xmax = 0.005 # non dimensional length of test chamber
  #ymax = .1e-3 # Test chamber radius
  uniform_refine = 0
[]

[Variables]
  active = 'Temperature Cure'

  [./Temperature]
    order = FIRST
    family = LAGRANGE
    initial_condition = '30'
  [../]
  
  [./Cure]
    order = FIRST
    family = LAGRANGE
    initial_condition = '0.000'
  [../]
[]

[Kernels]
  active = 'tempdiff tempderv coupledcurederv cureformula curederv' 

  [./tempdiff] #temperature diffusion term
    type = TempDiffusion
    variable = Temperature
    
  [../]

  [./coupledcurederv]
    type = CoupledCureTimeDerivative
    variable = Temperature
    v = Cure
    
  [../]
  
  [./tempderv]
  type = HeatConductionTimeDerivative
  variable = Temperature
  lumping='false'
  #specific_heat = '1'
  #density = '1'
  #the specific heat and density are added in materials and not in this block
  [../]
  
  [./cureformula]
  type=DCPDnonDgeneral
  variable = Cure
  v = Temperature #this is the coupled variable
  Ttrig = '1'
  Tintl = '0'
  _E = '82179.5'
  _n = '2.2275'
  _Kcat = '0'
  
  
  [../]
  
  [./curederv]
  type=TimeDerivative
  variable = Cure
  lumping='false'
  [../]  
  
[]

[BCs]
  active = 'templeft '

  [./templeft]
    type = DirichletBC
    #type = NeumannBC
   variable = Temperature
    boundary = 'left'
    value = '335'
    
  [../]
   
[]




#[Problem]  #makes the problem axisymmetric
#  type = FEProblem
#  coord_type = RZ
#  rz_coord_axis = Y
#[]

# Rm is 5mm
[Materials]
  [./DCPD]
    type = GenericConstantMaterial

    prop_names = 'specific_heat density Hr TConductivity A'
    prop_values = '1526 1100 500000 0.235 1.7873e10' # polymer attributes
  [../]
  
#  [./PDMS]
#    type = GenericConstantMaterial
#    block = '1'
#    prop_names = 'specific_heat density Hr TConductivity A'  # ro = 2575 Kg/m^3  Cp = 802.5 J/Kg-K  K= 1.2 W/Kg-K       prop_values = '1.0 0.605882 0 3.23136e-13' # PDMS attributes
#    prop_values = '1526 970 0 0.15  1.7873e10' # PDMS attributes

# 800 2230 0 1.14  8.55e15
  [../]
  
  #[./Copper]
  #  type = GenericConstantMaterial
  #  block = '4'
  #  prop_names = 'specific_heat density Hr TConductivity'
  #  prop_values = '1 2.4399 0 7.3474e-5' # wire attributes
  #[../]

[]

#[Preconditioning]  #to be removed in an ordinary run
#  [./SMP]
#    type = FDP
#    full = true
#  [../]
#[]

[Executioner]
  type = Transient
  #num_steps = 12000
   num_steps = 600000 
  #l_rel_tol = 1e-7
  nl_rel_tol = 1e-6
  
  [./TimeStepper]
    type = ConstantDT    
    dt =  0.005
  [../]
  
  [./TimeIntegrator]
   type = ImplicitEuler
[../]
  
  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  
[]

[Adaptivity]
  marker = errorfrac  #this line when commented, switches off adaptivity
  max_h_level = 6
  #steps = 2 #this line gets ignored in a transient run
  [./Indicators]
    [./error]
      type = GradientJumpIndicator
      variable = Temperature
      outputs = none
    [../]
    
  [../]
  [./Markers]
    [./errorfrac]
      type = ErrorFractionMarker
      refine = 0.9
      coarsen = 0.02
      indicator = error
      outputs = none
    [../]
    
  [../]
[]


[Controls]
  [./bcs]
    type = TimePeriod
    disable_objects = 'BCs::templeft'
    start_time = '5' #'2005360'  '1317808'   
    execute_on = 'initial timestep_begin'
  [../]  
[]

[Outputs] 
  execute_on = 'timestep_end' # Limit the output to timestep end (removes initial condition)
  [./console]
    type = Console
    perf_log = true          # enable performance logging    
  [../]
  [./cp]
    type = Checkpoint
    num_files = 4
    interval = 1
  [../]
  [./exodus]
    type = Exodus
    execute_on = 'initial timestep_end' # output the initial condition for the file
    file_base = Rc5_5mm # set the file base (the extension is automatically applied) 
    interval = 10          # only output every 10 step
  [../]  
[]

