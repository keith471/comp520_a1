from __future__ import print_function

import sys

num = float(raw_input('Enter the numerator >>> '))
denom = float(raw_input('Enter the denominator >>> '))

rem = num
while rem >= denom:
    rem = rem - denom

print()
print('The remainder is')
print(rem)
print()
