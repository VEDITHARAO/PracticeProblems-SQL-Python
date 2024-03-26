if __name__ == '__main__':
    N = int(input())
    list=[]
    j=1
    for j in range(N):
        str=input().split()
        if str[0]=="insert":
            e=int(str[1])
            i=int(str[2])
            list.insert(e,i)
        elif str[0]=="print":
            print(list)
        elif str[0]=="remove":
            e=int(str[1])
            list.remove(e)
        elif str[0]=="append":
            e=int(str[1])
            list.append(e)
        elif str[0]=="sort":
            list.sort()
        elif str[0]=="pop":
            list.pop()
        elif str[0]=="reverse":
            list.reverse()
        else:
            print("Command Invalid")
