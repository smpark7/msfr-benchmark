density = 2.0e-3        # kg cm-3
viscosity = .5          # dynamic viscosity, mu = nu * rho, kg cm-1 s-1
c_p = 6.15              # J cm-3 K-1
Pr = 3.075e5            # Prandtl number
Sc = 2.0e8              # Schmidt number

[GlobalParams]
  integrate_p_by_parts = true
  gravity = '0 0 0'  
[]

[Mesh]
  [./generated_mesh]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 200
    ny = 200
    xmin = 0
    xmax = 200
    ymin = 0
    ymax = 200
    elem_type = QUAD9
  [../]
  [./corner_node]
    type = ExtraNodesetGenerator
    new_boundary = 'pinned_node'
    coord = '200.0 200.0'
    input = generated_mesh
  [../]
[]

[Problem]
  type = FEProblem
[]

[Variables]
  [./ux]
    family = LAGRANGE
    order = SECOND
    initial_condition = 0
  [../]
  [./uy]
    family = LAGRANGE
    order = SECOND
    initial_condition = 0
  [../]
  [./p]
    family = LAGRANGE
    order = FIRST
  [../]
[]

[Kernels]
  [./mass]
    type = INSMass
    variable = p
    u = ux
    v = uy
    p = p
  [../]
  [./ux_time_deriv]
    type = INSMomentumTimeDerivative
    variable = ux
  [../]
  [./uy_time_deriv]
    type = INSMomentumTimeDerivative
    variable = uy
  [../]
  [./ux_momentum_space]
    type = INSMomentumLaplaceForm
    variable = ux
    u = ux
    v = uy
    p = p
    component = 0
  [../]
  [./uy_momentum_space]
    type = INSMomentumLaplaceForm
    variable = uy
    u = ux
    v = uy
    p = p
    component = 1
  [../]
[]

[BCs]
  [./ux_non_slip]
    type = DirichletBC
    variable = ux
    value = 0
    boundary = 'bottom left right'
  [../]
  [./uy_non_slip]
    type = DirichletBC
    variable = uy
    value = 0
    boundary = 'bottom left right top'
  [../]
  [./ux_lid]
    type = FunctionDirichletBC
    variable = ux
    function = 'velFunc'
    boundary = 'top'
  [../]
  [./p_pin]
    type = DirichletBC
    variable = p
    value = 0
    boundary = 'pinned_node'
  [../]
[]

[Functions]
  [./velFunc]
    type = ParsedFunction
    value = '50.0'
  [../]
[]

[Materials]
  [./fuel]
    type = GenericConstantMaterial
    prop_names = 'rho mu'
    prop_values = '2.0e-3 .5'
  [../]
[]

[Executioner]
  type = Transient
  end_time = 2000

  solve_type = 'NEWTON'
  petsc_options = '-snes_converged_reason -ksp_converged_reason -snes_linesearch_monitor'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu       NONZERO'
  line_search = 'none'

  nl_max_its = 15
  l_max_its = 30

  nl_abs_tol = 1e-10

  dtmin = 2e-2
  dtmax = 1
  steady_state_detection = true
  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 2e-2
    cutback_factor = .5
    growth_factor = 1.2
    optimal_iterations = 10
    iteration_window = 4
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
  [../]
[]

[Outputs]
  [./exodus]
    type = Exodus
    execute_on = 'timestep_end'
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]

