# Enter your code here. Read input from STDIN. Print output to STDOUT
M=int(input())
h=input().split()
if(len(h)==M):
    newlis=list(map(int,h))
    a=set(newlis)
N=int(input())
k=input().split()
if(len(k)==N):
    newlis=list(map(int,k))
    b=set(newlis)
result=a.union(b)-(a.intersection(b))
r=list(result)
r.sort()
for f in range(len(r)):
    print(r[f])
    
    

    
