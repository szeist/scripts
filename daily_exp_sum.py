#!/usr/bin/env python
"""
Generates an image to the stdout with the sequence of partial sums
of an exponential sum based on the current date, plotted in the complex plane.

https://www.johndcook.com/expsum/
"""

import sys
from datetime import datetime
import matplotlib.pyplot as plt
import numpy as np

POINTS = 10000
COLOR = '#008800'

def date_polynom(idx, date):
    year = date.year - 2000
    month = date.month
    day = date.day
    return idx/float(month) + idx**2/float(day) + idx**3/float(year)

def date_polynom_exponential(idx, date):
    return np.exp(2 * np.pi * 1j * date_polynom(idx, date))

def get_current_partial_sums():
    now = datetime.now().date()
    exponentials = np.array([date_polynom_exponential(n, now) for n in range(3, POINTS + 3)])
    return exponentials.cumsum()

def plot_partial_sums(partial_sums):
    figure = plt.figure()
    axes = figure.add_subplot(111)
    axes.plot(partial_sums.real, partial_sums.imag, color=COLOR, linewidth=0.7)
    axes.set_aspect('auto')
    axes.axis('off')


if __name__ == '__main__':
    CURRENT_SUMS = get_current_partial_sums()
    plt.style.use('dark_background')
    plot_partial_sums(CURRENT_SUMS)
    plt.savefig(sys.stdout, dpi=210, bbox_inches='tight')
