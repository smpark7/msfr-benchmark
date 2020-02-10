import numpy as np
import pandas as pd

x = np.arange(0, 201, 25)

# %% AA' line data

aa = pd.read_csv('aa-line-fine.csv')
aa_ux, aa_uy = np.zeros(len(x)), np.zeros(len(x))

for i in range(len(x)):
    aa_ux[i] = aa['u:0'][x[i]] * .01
    aa_uy[i] = aa['u:1'][x[i]] * .01

# %% BB' line data

bb = pd.read_csv('bb-line-fine.csv')
bb_ux, bb_uy = np.zeros(len(x)), np.zeros(len(x))

for i in range(len(x)):
    bb_ux[i] = bb['u:0'][x[i]] * .01
    bb_uy[i] = bb['u:1'][x[i]] * .01
