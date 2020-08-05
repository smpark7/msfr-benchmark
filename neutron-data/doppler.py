import sys, os
import numpy as np

def extrapolate(input_file):
    """ Extrapolates cross section data from 900 K to 1500 K based on the
    formula from Tiberga et al. (2020)
    """

    rho_900 = 2.0e3         # Density at 900 K [kg m-3]
    alpha = 2.0e-4      # Thermal expansion coeff [K-1]

    # Calculate density at 1500 K
    rho_1500 = rho_900 / (1 + alpha * (1500-900))

    f = open(input_file, 'r+')
    lines = f.readlines()
    data_900 = list(lines[0].split())

    data_1500 = [0, ] * len(data_900)
    data_1500[0] = '1500'
    for i in range(1, len(data_900)):
        data = float(data_900[i]) * rho_1500 / rho_900
        data_1500[i] = '{:0.5e}'.format(data)

    f.close()

    s = " "
    data_900 = s.join(data_900)
    data_900 += "\n"
    data_1500 = s.join(data_1500)
    lines = [data_900, data_1500]

    h = open(input_file, 'w')
    h.writelines(lines)
    h.close()

extrapolate(sys.argv[1])

