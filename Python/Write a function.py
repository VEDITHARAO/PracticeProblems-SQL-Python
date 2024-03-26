def is_leap(year):
    if year in range(1900,100001):
        # Write your logic here
        if(year%4==0 and year%100!=0):
            leap=True
        elif(year%400==0):
            leap=True
        else:
            leap=False

    
    return leap

