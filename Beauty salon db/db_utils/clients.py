from faker import Faker
from config import NUM_CLIENTS

fake = Faker('ru_RU')

def insert_clients(cur):
	for _ in range(NUM_CLIENTS):
			phone = fake.phone_number()[:15]
			cur.execute("""
					INSERT INTO Clients (FirstName, LastName, Phone, Email, DateOfBirth)
					VALUES (%s, %s, %s, %s, %s)
			""", (
					fake.first_name(),
					fake.last_name(),
					phone,
					fake.email(),
					fake.date_of_birth(minimum_age=18, maximum_age=65)
			))