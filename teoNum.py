import math

def is_perfect_square(number: int) -> bool:
    """
    Returns True if the provided number is a
    perfect square (and False otherwise).
    """
    return math.isqrt(number) ** 2 == number

m=1053186953876963
e=56347
i=0
while True:
    t=math.ceil(math.sqrt(m))+i
    s=t**2-m
    print(t)
    print(s)
    if(is_perfect_square(s)):
        break
    i += 1


print(t+math.sqrt(s))

print(t-math.sqrt(s))