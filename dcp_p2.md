Given an array of integers, return a new array such that each element at index i of the new array is the product of all the numbers in the original array except the one at i.

For example, if our input was [1, 2, 3, 4, 5], the expected output would be [120, 60, 40, 30, 24]. If our input was [3, 2, 1], the expected output would be [2, 3, 6].

Follow-up: what if you can't use division?

```python
import unittest as ut
from functools import reduce

def myNewArray(mylist):
    product = reduce((lambda x, y: x * y), mylist)
    outList=[]
    for x in mylist:
        outList.append(product/x)
    return list(map(int,outList))

# test cases 
utc=ut.TestCase('run')
try:
    utc.assertSequenceEqual(myNewArray([1, 2, 3]),[6,3,2])
    utc.assertSequenceEqual(myNewArray([1, 2, 3, 4, 5]),[120, 60, 40, 30, 24])
except AssertionError as e:
    print(e)
```
