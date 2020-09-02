import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

aa = pd.read_csv('vel-field-stabilized_csv_aa_0062.csv')
bb = pd.read_csv('vel-field-stabilized_csv_bb_0062.csv')

fig, ax = plt.subplots()
ax.plot(bb['ux'] / 100, bb['y'] / 100)
ax.set_ylim(0, 2)
ax.set_xlim(-.2, .6)

x = np.arange(0, 201, 25)
aa_ux = np.zeros(len(x))
aa_uy = np.zeros(len(x))
bb_ux = np.zeros(len(x))
bb_uy = np.zeros(len(x))

for i in range(len(x)):
    aa_ux[i] = aa['ux'][x[i]]
    aa_uy[i] = aa['uy'][x[i]]
    bb_ux[i] = bb['ux'][x[i]]
    bb_uy[i] = bb['uy'][x[i]]

print(aa_ux)
print(aa_uy)
print(bb_ux)
print(bb_uy)
