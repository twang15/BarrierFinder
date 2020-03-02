#!/usr/bin/python
import math

for i in range(1, 15):
    denorminator = math.factorial(3*i)
    temp = math.factorial(i)
    divisor = pow(temp, 3)
    print i, denorminator/divisor
