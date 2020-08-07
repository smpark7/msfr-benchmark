density = .002  # kg cm-3
cp = 6.15       # J cm-3 K-1
k = .005        # W cm-1 K-1
gamma = 1       # W cm-3 K-1, Volumetric heat transfer coefficient

[GlobalParams]
  num_groups = 6
  num_precursor_groups = 8
  group_fluxes = 'group1 group2 group3 group4 group5 group6'
  pre_concs = 'pre1 pre2 pre3 pre4 pre5 pre6 pre7 pre8'
  temperature = temp
  sss2_input = true
[../]

[Mesh]
    type = GeneratedMesh
    dim = 2
    nx = 200
    ny = 200
    xmin = 0
    xmax = 200
    ymin = 0
    ymax = 200
    elem_type = QUAD9
[]

[Problem]
  type = FEProblem
[]

[Variables]
  [./temp]
    family = LAGRANGE
    order = FIRST
    initial_condition = 900
    scaling = 1e-2
  [../]
[]

[AuxVariables]
  [./group1]
    family = LAGRANGE
    order = FIRST
  [../]
  [./group2]
    family = LAGRANGE
    order = FIRST
  [../]
  [./group3]
    family = LAGRANGE
    order = FIRST
  [../]
  [./group4]
    family = LAGRANGE
    order = FIRST
  [../]
  [./group5]
    family = LAGRANGE
    order = FIRST
  [../]
  [./group6]
    family = LAGRANGE
    order = FIRST
  [../]
  [./ux]
    family = LAGRANGE
    order = FIRST
  [../]
  [./uy]
    family = LAGRANGE
    order = FIRST
  [../]
[]

[UserObjects]
  [./fluxes]
    type = SolutionUserObject
    mesh = '../neutronics/nts-power_out.e'
    system_variables = 'group1 group2 group3 group4 group5 group6'
    timestep = LATEST
    execute_on = INITIAL
  [../]
  [./velocities]
    type = SolutionUserObject
    mesh = '../vel-field/vel-field-stabilized_exodus.e'
    system_variables = 'ux uy'
    timestep = LATEST
    execute_on = INITIAL
  [../]
[]

[Kernels]
  [./temp_source]
    type = FissionHeatSource
    nt_scale = 1
    variable = temp
    power = 1
    tot_fissions = 1
  [../]
  [./temp_all]
    type = INSTemperature
    variable = temp
    u = ux
    v = uy
  [../]
  [./temp_sink]
    type = ManuHX
    variable = temp
    htc = ${gamma}
    tref = 900
  [../]
[]

[AuxKernels]
  [./group1]
    type = SolutionAux
    variable = group1
    from_variable = group1
    solution = fluxes
    execute_on = INITIAL
  [../]
  [./group2]
    type = SolutionAux
    variable = group2
    from_variable = group2
    solution = fluxes
    execute_on = INITIAL
  [../]
  [./group3]
    type = SolutionAux
    variable = group3
    from_variable = group3
    solution = fluxes
    execute_on = INITIAL
  [../]
  [./group4]
    type = SolutionAux
    variable = group4
    from_variable = group4
    solution = fluxes
    execute_on = INITIAL
  [../]
  [./group5]
    type = SolutionAux
    variable = group5
    from_variable = group5
    solution = fluxes
    execute_on = INITIAL
  [../]
  [./group6]
    type = SolutionAux
    variable = group6
    from_variable = group6
    solution = fluxes
    execute_on = INITIAL
  [../]
  [./ux]
    type = SolutionAux
    variable = ux
    from_variable = ux
    solution = velocities
    execute_on = INITIAL
  [../]
  [./uy]
    type = SolutionAux
    variable = uy
    from_variable = uy
    solution = velocities
    execute_on = INITIAL
  [../]
[]

[Materials]
  [./fuel]
    type = GenericMoltresMaterial
    property_tables_root = '../neutron-data/benchmark_'
    interp_type = 'linear'
    prop_names = 'k rho cp'
    prop_values = '${k} ${density} ${cp}'
  [../]
[]

[Executioner]
  type = Steady

  solve_type = 'NEWTON'
  petsc_options = '-snes_converged_reason -ksp_converged_reason -snes_linesearch_monitor'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       NONZERO               superlu_dist'
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Postprocessors]
[]

[VectorPostprocessors]
  [./aa]
    type = LineValueSampler
    variable = 'temp'
    start_point = '0 100 0'
    end_point = '200 100 0'
    num_points = 201
    sort_by = x
    execute_on = TIMESTEP_END
    outputs = 'csv'
  [../]
  [./bb]
    type = LineValueSampler
    variable = 'temp'
    start_point = '100 0 0'
    end_point = '100 200 0'
    num_points = 201
    sort_by = y
    execute_on = TIMESTEP_END
    outputs = 'csv'
  [../]
[]

[Outputs]
  perf_graph = true
  print_linear_residuals = true
  exodus = true
  [./csv]
    type = CSV
    execute_on = 'final'
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]
