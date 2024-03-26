if __name__ == '__main__':
    records=[]
    for _ in range(int(input())):
        name = input()
        score = float(input())
        records.append([name,score])
    records.sort(key=lambda x:x[1])
    sortedscores=sorted(list(set([x[1] for x in records])))
    secondlowestscore=sortedscores[1]
    
    finallist=[]
    for x in records:
        if secondlowestscore==x[1]:
            finallist.append(x[0])
    for student in sorted(finallist):
        print(student)
    

        
        
    
                
    #b = [i for i in records if i[0] == records[0][0]]
    #print(b)
    #c = [j for j in b if j[0] == b[0][0]]
    #print(c)
    #c.sort(key=lambda x: x[1])
    #for i in range(len(c)):
        #print(c[i][0])


