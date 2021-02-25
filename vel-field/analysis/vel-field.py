import sys
import os
import pandas as pd
sys.path.append(
        os.path.dirname(
                os.path.dirname(
                        os.path.dirname(
                                os.path.abspath(__file__)))))
from common_func import get_disc

# Data
aa = pd.read_csv('vel-field-ad_csv_aa_0002.csv')
bb = pd.read_csv('vel-field-ad_csv_bb_0002.csv')
benchmark_aa_ux = pd.read_csv('ux_AA', delim_whitespace=True, header=None)
benchmark_aa_uy = pd.read_csv('uy_AA', delim_whitespace=True, header=None)
benchmark_bb_ux = pd.read_csv('ux_BB', delim_whitespace=True, header=None)
benchmark_bb_uy = pd.read_csv('uy_BB', delim_whitespace=True, header=None)

# Calculate % discrepancy
disc_aa_ux = get_disc(aa['vel_x'] / 100, benchmark_aa_ux)
disc_aa_uy = get_disc(aa['vel_y'] / 100, benchmark_aa_uy)
disc_bb_ux = get_disc(bb['vel_x'] / 100, benchmark_bb_ux)
disc_bb_uy = get_disc(bb['vel_y'] / 100, benchmark_bb_uy)

print("Discrepancy in ux along AA' = " + str(disc_aa_ux*100) + " %")
print("Discrepancy in uy along AA' = " + str(disc_aa_uy*100) + " %")
print("Discrepancy in ux along BB' = " + str(disc_bb_ux*100) + " %")
print("Discrepancy in uy along BB' = " + str(disc_bb_uy*100) + " %")

ave_aa_ux = 0
ave_aa_uy = 0
ave_bb_ux = 0
ave_bb_uy = 0
for i in range(4):
    ave_aa_ux += get_disc(benchmark_aa_ux[:][i+1], benchmark_aa_ux)
    ave_aa_uy += get_disc(benchmark_aa_uy[:][i+1], benchmark_aa_uy)
    ave_bb_ux += get_disc(benchmark_bb_ux[:][i+1], benchmark_bb_ux)
    ave_bb_uy += get_disc(benchmark_bb_uy[:][i+1], benchmark_bb_uy)
ave_aa_ux /= 4
ave_aa_uy /= 4
ave_bb_ux /= 4
ave_bb_uy /= 4

print("Benchmark average discrepancy in ux along AA' = " +
      str(ave_aa_ux*100) + " %")
print("Benchmark average discrepancy in uy along AA' = " +
      str(ave_aa_uy*100) + " %")
print("Benchmark average discrepancy in uy along BB' = " +
      str(ave_bb_ux*100) + " %")
print("Benchmark average discrepancy in uy along BB' = " +
      str(ave_bb_uy*100) + " %")