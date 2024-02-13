x1 = int(input('Введите целоечисленное значение 1 конца первого отрезка: ')) 
y1 = int(input('Введите целоечисленное значение 2 конца первого отрезка: ')) 
x2 = int(input('Введите целоечисленное значение 1 конца второго отрезка: ')) 
y2 = int(input('Введите целоечисленное значение 2 конца второго отрезка: ')) 
 
line1 =((x1, y1), (x2, y2)) 
print(line1) 
 


def is_degenerated(line1): 
    if (line1[0][0]==line1[1][0]==line1[0][1]==line1[1][1]) or (line1[0][0]==line1[1][0] and line1[0][1]==line1[1][1]):
    #if line1[0]==line1[1]
        return "True" 
    else: 
        return "False" 
print('is_degenerated ', is_degenerated(line1))

#True
#line1 =((11, 11), (11, 11)) 
#is_degenerated(line1)

#True
#line1 =((11, 12), (11, 12)) 
#is_degenerated(line1)

#False
#line1 =((11, 12), (13, 14)) 
#is_degenerated(line1)




def is_horizontal(line1): 
    if (line1[0][1]==line1[1][1]) and (line1[0][0]!=line1[1][0]) : 
        return "True" 
    else: 
        return "False" 
print('is_horizontal ', is_horizontal(line1))

#True
#line1 =((19, 9), (11, 9)) 
#is_horizontal(line1)

#False
#line1 =((11, 12), (12, 16)) 
#is_horizontal(line1)




def is_vertical(line1):
    if (line1[0][0]==line1[1][0]) and (line1[0][1]!=line1[1][1]): 
        return "True" 
    else: 
        return "False" 
print('is_vertical', is_vertical(line1))

#True
#line1 =((19, 1), (19, 10)) 
#is_vertical(line1)

#False
#line1 =((11, 12), (12, 12)) 
#is_vertical(line1)



def is_inclined(line1):
    if (line1[0][1]!=line1[1][1]) and (line1[0][0]!=line1[1][0]): 
        return "True" 
    else: 
        return "False" 
print('is_inclined', is_inclined(line1))

#True
#line1 =((11, 12), (12, 12)) 
#is_inclined(line1)