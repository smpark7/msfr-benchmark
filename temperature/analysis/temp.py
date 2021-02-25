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
aa = pd.read_csv('temp-full-coupled_csv_aa_0002.csv')
bb = pd.read_csv('temp-full-coupled_csv_bb_0002.csv')
benchmark_aa = pd.read_csv('T_AA', delim_whitespace=True, header=None)
benchmark_bb = pd.read_csv('T_BB', delim_whitespace=True, header=None)

# Calculate % discrepancy
disc_aa = get_disc(aa['temp'], benchmark_aa)
disc_bb = get_disc(bb['temp'], benchmark_bb)

print("Discrepancy in temperature along AA' = " +
      str(disc_aa*100) + " %")
print("Discrepancy in temperature along BB' = " +
      str(disc_bb*100) + " %")

ave_aa = 0
ave_bb = 0
for i in range(6):
    ave_aa += get_disc(benchmark_aa[:][i+1], benchmark_aa)
    ave_bb += get_disc(benchmark_bb[:][i+1], benchmark_bb)
ave_aa /= 6
ave_bb /= 6

print("Benchmark average discrepancy in temperature along AA' = " +
      str(ave_aa*100) + " %")
print("Benchmark average discrepancy in temperature along BB' = " +
      str(ave_bb*100) + " %")
