import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

data = pd.read_csv('nts-power_out_continuous_0002.csv')
sigmaf = [1.11309e-03, 1.08682e-03, 1.52219e-03,
          2.58190e-03, 5.36326e-03, 1.44917e-02]

fiss = np.zeros(201)
for i in range(6):
    group = 'group' + str(i+1)
    fiss += np.array(data[group] * sigmaf[i]) * 1e4

fig, ax = plt.subplots()
ax.plot(data['x'] / 100, fiss)
ax.set_xlim(0, 2)
ax.set_ylim(0, 2e19)

x = np.arange(0, 201, 25)
discrete = np.zeros(len(x))
for i in range(len(x)):
    discrete[i] = fiss[x[i]]

print(discrete)
