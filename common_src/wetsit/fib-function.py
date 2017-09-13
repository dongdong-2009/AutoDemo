
def fib(n):
    a, b = 0, 1
    for ni in range(n):
        a, b = b, a + b
    return b

print fib(10)
    

def memo(func):
    cache = {}
    def wrap(*args):
        if args not in cache:
            cache[args] = func(*args)
        return cache[args]
    return wrap

@memo
def fib(n):
    if n < 2:
        return 1
    return fib(n - 1) + fib(n - 2)

print ("########################memo A %s " % memo(10))
