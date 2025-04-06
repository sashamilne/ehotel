import faker
from random import randint

adresses = ['\'' + faker.Faker().address() + '\'' for _ in range(40)]
hotelids = [i for i in range(40)]
chainids = [i//8 + 1 for i in range(40)]
phonenumbers = [randint(1000000000, 9999999999) for _ in range(40)]
emails = ['\'' + faker.Faker().email() +'\'' for _ in range(40)]
ratings = [faker.Faker().random_int(min=1, max=5) for _ in range(40)]


print(*adresses)
print(*hotelids)
print(*chainids)
print(*phonenumbers)
print(*emails) 

for i in range(40):
    print(f"INSERT INTO ehotelschema.hotel (hotel_id, chain_id, hotel_address, phone_number, email, rating) VALUES ({hotelids[i]}, {chainids[i]}, {adresses[i]},  {phonenumbers[i]}, {emails[i]}, {ratings[i]});")


