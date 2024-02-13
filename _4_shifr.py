a = str(input('Введите слово '))
def encrypt(a):
    result = ''
    b = len(a)
    for i in range (0, b, 2): #0 - начало, b - длина слова - 1, 2 - шаг (только "чётные" буквы)
        if i+1 < b: #буква с иденксом на 1 больше от начального не выходит за диапазон самого слова
            result = result + a[i+1] + a[i]
        else: #сумма букв нечётная, и дошли в переборе до момента, где i+1 отстусвует
            result = result + a[i]
    return(result)
print(encrypt(a))
