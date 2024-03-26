if __name__ == '__main__':
    n = int(input())
    arr = map(int, input().split())
    a1=list(arr)
    a2=[]
    for i in a1:
        if i not in a2:
            a2.append(i)
    a2.sort()
    print(a2[-2])
                
            
        
