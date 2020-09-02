import numpy as np
import matplotlib.pyplot as plt

n = [50, 100, 150, 200, 250, 300, 400]
keff = [1.0046463, 1.0046715, 1.0046762, 1.0046778,
        1.0046786, 1.0046790, 1.0046794]
reactivity = [(i-1)/i*1e5 for i in keff]
time = [26.7, 97.1, 245.9, 506.5, 931.3, 1600.4, 4049.5]  # n = 16, ppn = 8

fig, ax = plt.subplots()
ax.plot(n, reactivity, marker='o', linestyle='')
ax.set_ylim(462, 466)

fig, ax = plt.subplots()
ax.plot(n, time, marker='o', linestyle='')
ax.set_xlim(40, 410)
ax.set_ylim(0, 4500)
