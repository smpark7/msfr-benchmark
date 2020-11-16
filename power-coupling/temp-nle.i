density = .002  # kg cm-3
cp = 3075      # J cm-3 K-1
k = .005        # W cm-1 K-1
gamma = 1       # W cm-3 K-1, Volumetric heat transfer coefficient
tau = .2        # SUPG stabilization factor

[GlobalParams]
  num_groups = 6
  num_precursor_groups = 8
  use_exp_form = false
  group_fluxes = 'group1 group2 group3 group4 group5 group6'
  pre_concs = 'pre1 pre2 pre3 pre4 pre5 pre6 pre7 pre8'
  sss2_input = true
  account_delayed = true
  temperature = temp
[../]

[Mesh]
  file = '../temperature/temp-steady-supg_out.e'
#   type = GeneratedMesh
#   dim = 2
#   nx = 200
#   ny = 200
#   xmin = 0
#   xmax = 200
#   ymin = 0
#   ymax = 200
[]

[Problem]
  type = FEProblem
[]

[Variables]
  [./temp]
    family = LAGRANGE
    order = FIRST
    initial_condition = 900
  [../]
[]

[AuxVariables]
  [./group1]
    family = LAGRANGE
    order = FIRST
    initial_condition = 1
  [../]
  [./group2]
    family = LAGRANGE
    order = FIRST
    initial_condition = 1
  [../]
  [./group3]
    family = LAGRANGE
    order = FIRST
    initial_condition = 1
  [../]
  [./group4]
    family = LAGRANGE
    order = FIRST
    initial_condition = 1
  [../]
  [./group5]
    family = LAGRANGE
    order = FIRST
    initial_condition = 1
  [../]
  [./group6]
    family = LAGRANGE
    order = FIRST
    initial_condition = 1
  [../]
  [./ux]
    family = LAGRANGE
    order = FIRST
  [../]
  [./uy]
    family = LAGRANGE
    order = FIRST
  [../]
  [./vel]
    family = LAGRANGE_VEC
    order = FIRST
  [../]
[]

[UserObjects]
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
    power = 3.23632e-11
    tot_fissions = 1
  [../]
  [./temp_all]
    type = INSTemperature
    variable = temp
    u = ux
    v = uy
  [../]
  [./temp_supg]
    type = INSADTemperatureAdvectionSUPG
    variable = temp
    velocity = vel
  [../]
  [./temp_sink]
    type = ManuHX
    variable = temp
    htc = ${gamma}
    tref = 900
  [../]
[]

[AuxKernels]
  [./ux]
    type = SolutionAux
    variable = ux
    from_variable = ux
    solution = velocities
  [../]
  [./uy]
    type = SolutionAux
    variable = uy
    from_variable = uy
    solution = velocities
  [../]
[]

[Functions]
  [./uxf]
    type = SolutionFunction
    from_variable = ux
    solution = velocities
  [../]
  [./uyf]
    type = SolutionFunction
    from_variable = uy
    solution = velocities
  [../]
[]

[ICs]
  [./vel_ic]
    type = VectorFunctionIC
    variable = vel
    function_x = uxf
    function_y = uyf
  [../]
[]

[Materials]
  [./fuel]
    type = GenericMoltresMaterial
    property_tables_root = '../neutron-data/benchmark_'
    interp_type = 'linear'
    prop_names = 'k rho cp tau'
    prop_values = '${k} ${density} ${cp} ${tau}'
    temperature = 900
  [../]
[]

[Executioner]
  type = Transient
  end_time = 100
  dtmin = .5
  auto_advance = true

  solve_type = 'NEWTON'
  petsc_options = '-snes_converged_reason -ksp_converged_reason -snes_linesearch_monitor'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       NONZERO               superlu_dist'
  line_search = 'none'

  nl_max_its = 20
  l_max_its = 30

  nl_abs_tol = 1e-6
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[MultiApps]
  [./tempApp]
    type = FullSolveMultiApp
    execute_on = timestep_end
    input_files = 'nts-nle.i'
#    no_backup_and_restore = true
#    keep_solution_during_restore = true
  [../]
[]

[Transfers]
  [./group1_transfer]
    type = MultiAppCopyTransfer
    multi_app = tempApp
    source_variable = 'group1'
    variable = 'group1'
    direction = from_multiapp
  [../]
  [./group2_transfer]
    type = MultiAppCopyTransfer
    multi_app = tempApp
    source_variable = 'group2'
    variable = 'group2'
    direction = from_multiapp
  [../]
  [./group3_transfer]
    type = MultiAppCopyTransfer
    multi_app = tempApp
    source_variable = 'group3'
    variable = 'group3'
    direction = from_multiapp
  [../]
  [./group4_transfer]
    type = MultiAppCopyTransfer
    multi_app = tempApp
    source_variable = 'group4'
    variable = 'group4'
    direction = from_multiapp
  [../]
  [./group5_transfer]
    type = MultiAppCopyTransfer
    multi_app = tempApp
    source_variable = 'group5'
    variable = 'group5'
    direction = from_multiapp
  [../]
  [./group6_transfer]
    type = MultiAppCopyTransfer
    multi_app = tempApp
    source_variable = 'group6'
    variable = 'group6'
    direction = from_multiapp
  [../]
  [./temp_transfer]
    type = MultiAppCopyTransfer
    multi_app = tempApp
    source_variable = 'temp'
    variable = 'temp'
    direction = to_multiapp
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
