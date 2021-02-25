import sys
import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
sys.path.append(
        os.path.dirname(
                os.path.dirname(
                        os.path.dirname(
                                os.path.abspath(__file__)))))
from common_func import get_disc

# Data
aa = pd.read_csv('nts-power_csv_continuous_0002.csv')
benchmark_aa = pd.read_csv('fiss_dens_AA', delim_whitespace=True, header=None)

# Fission cross section data
sigmaf = [1.11309e-03, 1.08682e-03, 1.52219e-03,
          2.58190e-03, 5.36326e-03, 1.44917e-02]

# Pre-multiply with appropriate group fission XS and sum at each position
fiss = np.zeros(201)
for i in range(6):
    group = 'group' + str(i+1)
    fiss += np.array(aa[group] * sigmaf[i]) * 1e6

# Calculate % discrepancy
disc_aa = get_disc(fiss, benchmark_aa)

print("Discrepancy in fission rate along AA' = " +
      str(disc_aa*100) + " %")

ave_aa = 0
for i in range(6):
    ave_aa += get_disc(benchmark_aa[:][i+1], benchmark_aa)
ave_aa /= 6

print("Benchmark average discrepancy in fission rate along AA' = " +
      str(ave_aa*100) + " %")