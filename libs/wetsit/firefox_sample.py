#! /usr/bin/env python
# -*- coding: utf-8 -*-
from _ast import Num
import pdb

class config_sample(object):

    ROBOT_LIBRARY_VERSION = 1.0

    def __init__(self):
        pass

    def keyword(self):
        pass


class list_sample():
    
    def __init__(self):
        pass
    
    def list_control(self):
        l1 = ['b','c','d','b','c','a','a']
        l2 = {}.fromkeys(l1).keys()
        print l2
        
    def extendlist(self,val,list=None):
        if list is None:
            list = []
        list.append(val)
        return list
        
if __name__ == "__main__":
    '''
    list_sample().list_control()
    nl = list_sample()
    print nl.extendlist(10)
    print nl.extendlist(123,[])
    print nl.extendlist('a')

    
    def multipliers():
        return [lambda x : i * x for i in range(4)]
    print [m(2) for m in multipliers()]
    
    '''
    def binarySearch(l,t):
        low,high = 0 ,len(l) - 1
        while low < high:
            #print low, high
            mid = (low + high) / 2
            if l[mid] > t:
                high = mid
            elif l[mid] < t:
                low = mid + 1
            else:
                return mid
        return low if l[low] == t else False
    l = [1, 4, 12, 45, 66, 99, 120, 444]
    print binarySearch(l,13)
    print binarySearch(l,120)
    
    
    def qsort(seq):
        
        if seq == []:
            return []
        else:
            pivot = seq[0]
            lesser = qsort([x for x in seq[1:] if x < pivot])
            greater = qsort([x for x in seq[1:] if x > pivot])
            return lesser + [pivot] + greater
    seq = [5,6,78,9,0,-1,2,3,-65,12]
    print (qsort(seq))
    
    def chengfabiao(n):
        """ 9 * 9 乘法表
            用逗号分隔几个打印项，因为print的最后没有逗号，所以每一次循环都会换行。 
        """
        if n <= 0:
            return 0
        for cs in range(1,n):
            print '\n'
            for cbs in range(1,cs + 1):
                print "%d x %d=%2d "%(cs,cbs,cs * cbs) ,    

    chengfabiao(10)

    def countDivisors(num):
        ans = 1
        x = 2
        while x * x <= num:
            cnt = 1
            while num  %  x == 0:
                cnt += 1
                num /= x 
            ans *= cnt
            x += 1 
        return ans * (1 + (num > 1))
    print countDivisors(1000)
    
    def divisors1(num):
        if num < 6:
            return 0
        divs = []
        for x in range(num//2,0,-1):
            if num % x == 0:
               divs.append(x) 
            else:
                continue
        if len(divs):
            return divs, num
        
    def checkDivisors(divs,num):
        sum = 0
        for di in divs:
            sum += di
        if sum == num:
            return Num
    
    def countWanmeishu(nums):
        """
        完全数（Perfect number），又称完美数或完备数，是一些特殊的自然数。
        它所有的真因子（即除了自身以外的约数）的和（即因子函数），恰好等于它本身。
        如果一个数恰好等于它的因子之和，则称该数为“完全数”。
        第一个完全数是6，第二个完全数是28，第三个完全数是496，后面的完全数还有8128、33550336等等。
        求某个范围内的完全数，先获取该范围内的所有数的约数（整除数），在验证约数之和是否等于自身。
        调用divisors1(num) 获取每个数的约数
        调用checkDivisors(divs,num) 验证约数之和是否等于自身
        """
        count = []
        for ni in range(nums):
            divs = divisors1(ni)       
            if divs and checkDivisors(divs[0],divs[1]):
                print "完美数： {}, 因子：{} \n".format(divs[1],divs[0])
                count.append((divs))
        
    #countWanmeishu(1000000)
        
    def fullSqrtNum(num):
        """
        一个整数，它加上100和加上268后都是一个完全平方数
        """
        import math
        for i in range(num):
            x = int(math.sqrt(i + 100))
            y = int(math.sqrt(i + 268))
            if (x * x == i + 100) and (y * y == i + 268):
                print i
                
    fullSqrtNum(1000)
            
            
    """
    对于数列a = [1,2,3,4,5] 
    a[::2] = [1,3,5] a[::-2] = [5,3,1]
    """
    
    """
    一行代码实现对列表的偶数位的元素加3求和
    """
    sum([x for x in a if a.index(x) % 2 ==0 and x != 1])
    
    