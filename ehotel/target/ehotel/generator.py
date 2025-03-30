import faker

adresses = [faker.Faker().address() for _ in range(40)]
output = '{'
for i in range(40):
    output += "\"" + adresses[i] + "\""
    if i != 39:
        output += ', '
output += '}'
print(output)