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
#  type = GeneratedMesh
#  dim = 2
#  nx = 200
#  ny = 200
#  xmin = 0
#  xmax = 200
#  ymin = 0
#  ymax = 200
[]

[Problem]
  type = FEProblem
[]

[Nt]
  var_name_base = group
  vacuum_boundaries = 'bottom left right top'
  create_temperature_var = false
  eigen = true
  initial_condition = 1
[]

[Precursors]
  [./pres]
    var_name_base = pre
    outlet_boundaries = 'bottom'
    constant_velocity_values = true
    u_def = 0
    v_def = 0
    w_def = 0
    nt_exp_form = false
    family = MONOMIAL
    order = CONSTANT
    transient = false
  [../]
[]

[Variables]
[]

[AuxVariables]
  [./temp]
    family = LAGRANGE
    order = FIRST
    initial_condition = 900
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
  [./velocities]
    type = SolutionUserObject
    mesh = '../vel-field/vel-field-stabilized_exodus.e'
    system_variables = 'ux uy'
    timestep = LATEST
    execute_on = INITIAL
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

[Kernels]
[]

[DGKernels]
#  [./diff_pre1]
#    type = DGDiffusion
#    variable = pre1
#    diff = 1.25e-06
#    epsilon = -1
#    sigma = 6
#  [../]
#  [./diff_pre2]
#    type = DGDiffusion
#    variable = pre2
#    diff = 1.25e-06
#    epsilon = -1
#    sigma = 6
#  [../]
#  [./diff_pre3]
#    type = DGDiffusion
#    variable = pre3
#    diff = 1.25e-06
#    epsilon = -1
#    sigma = 6
#  [../]
#  [./diff_pre4]
#    type = DGDiffusion
#    variable = pre4
#    diff = 1.25e-06
#    epsilon = -1
#    sigma = 6
#  [../]
#  [./diff_pre5]
#    type = DGDiffusion
#    variable = pre5
#    diff = 1.25e-06
#    epsilon = -1
#    sigma = 6
#  [../]
#  [./diff_pre6]
#    type = DGDiffusion
#    variable = pre6
#    diff = 1.25e-06
#    epsilon = -1
#    sigma = 6
#  [../]
#  [./diff_pre7]
#    type = DGDiffusion
#    variable = pre7
#    diff = 1.25e-06
#    epsilon = -1
#    sigma = 6
#  [../]
#  [./diff_pre8]
#    type = DGDiffusion
#    variable = pre8
#    diff = 1.25e-06
#    epsilon = -1
#    sigma = 6
#  [../]
[]

[Materials]
  [./fuel]
    type = GenericMoltresMaterial
    property_tables_root = '../neutron-data/benchmark_'
    interp_type = 'linear'
    prop_names = 'k rho cp tau'
    prop_values = '${k} ${density} ${cp} ${tau}'
  [../]
[]

[Executioner]
  type = InversePowerMethod
  max_power_iterations = 50
  auto_advance = true

  # fission power normalization
  normalization = 'powernorm'
  normal_factor = 1e7           # Watts, 1e9 / 100

  xdiff = 'group1diff'
  bx_norm = 'bnorm'
  k0 = 0.9900
  pfactor = 1e-2
  l_max_its = 100
  free_power_iterations = 4
  eig_check_tol = 1e-5

  solve_type = 'NEWTON'
  petsc_options = '-snes_converged_reason -ksp_converged_reason -snes_linesearch_monitor'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       NONZERO               superlu_dist'
  line_search = 'none'
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Postprocessors]
  [./bnorm]
    type = ElmIntegTotFissNtsPostprocessor
    execute_on = linear
  [../]
  [./tot_fissions]
    type = ElmIntegTotFissPostprocessor
    execute_on = linear
  [../]
  [./powernorm]
    type = ElmIntegTotFissHeatPostprocessor
    execute_on = linear
  [../]
  [./group1norm]
    type = ElementIntegralVariablePostprocessor
    variable = group1
    execute_on = linear
    outputs = 'console'
  [../]
  [./group1max]
    type = NodalMaxValue
    variable = group1
    execute_on = timestep_end
    outputs = 'console'
  [../]
  [./group1diff]
    type = ElementL2Diff
    variable = group1
    execute_on = 'linear timestep_end'
    use_displaced_mesh = false
  [../]
  [./group2norm]
    type = ElementIntegralVariablePostprocessor
    variable = group2
    execute_on = linear
    outputs = 'console'
  [../]
  [./group2max]
    type = NodalMaxValue
    variable = group2
    execute_on = timestep_end
    outputs = 'console'
  [../]
[]

[VectorPostprocessors]
  [./temp_aa]
    type = LineValueSampler
    variable = 'temp'
    start_point = '0 100 0'
    end_point = '200 100 0'
    num_points = 201
    sort_by = x
    execute_on = FINAL
  [../]
  [./temp_bb]
    type = LineValueSampler
    variable = 'temp'
    start_point = '100 0 0'
    end_point = '100 200 0'
    num_points = 201
    sort_by = y
    execute_on = FINAL
  [../]
  [./fiss_aa]
    type = LineValueSampler
    variable = 'group1 group2 group3 group4 group5 group6'
    start_point = '0 100 0'
    end_point = '200 100 0'
    num_points = 201
    sort_by = x
    execute_on = FINAL
  [../]
  [./fiss_bb]
    type = LineValueSampler
    variable = 'group1 group2 group3 group4 group5 group6'
    start_point = '100 0 0'
    end_point = '100 200 0'
    num_points = 201
    sort_by = y
    execute_on = FINAL
  [../]
[]

[Outputs]
  perf_graph = true
  print_linear_residuals = true
  [./out]
    type = Exodus
  [../]
  [./csv]
    type = CSV
    execute_on = FINAL
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]
