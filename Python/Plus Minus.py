#!/bin/python3

import math
import os
import random
import re
import sys

#
# Complete the 'plusMinus' function below.
#
# The function accepts INTEGER_ARRAY arr as parameter.
#

def plusMinus(arr):
    # Write your code here
    z=0
    p=0
    n=0
    c=0
    t=len(arr)
    for i in arr:
        if i>c:
            p+=1
        s=p/t
        
        if i<c:
            n+=1
        f=n/t
        if i==c:
            z+=1
        g=z/t
    print ('{:.6f}'.format(s),'\n','{:.6f}'.format(f),'\n','{:.6f}'.format(g))
if __name__ == '__main__':
    n = int(input().strip())

    arr = list(map(int, input().rstrip().split()))

    plusMinus(arr)
