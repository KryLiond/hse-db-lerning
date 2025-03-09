from config import NUM_EMPLOYEES, POSITIONS, MANAGERIAL_POSITIONS
from random import randint
from faker import Faker

fake = Faker('ru_RU')

def insert_employees(cur):
    employee_ids = []
    
    for _ in range(NUM_EMPLOYEES):
        position_name, description = POSITIONS[randint(0, len(POSITIONS) - 1)]
        
        if position_name in MANAGERIAL_POSITIONS:
            cur.execute("""
                SELECT COUNT(*) FROM Employees WHERE PositionID = (
                    SELECT PositionID FROM Positions WHERE PositionName = %s
                )
            """, (position_name,))
            current_count = cur.fetchone()[0]
            
            if current_count >= MANAGERIAL_POSITIONS[position_name]:
                continue

        phone = fake.phone_number()[:15]
        cur.execute("""
            INSERT INTO Employees (FirstName, LastName, Phone, Email, PositionID, HireDate)
            VALUES (%s, %s, %s, %s, (
                SELECT PositionID FROM Positions WHERE PositionName = %s
            ), %s) RETURNING EmployeeID
        """, (
            fake.first_name(),
            fake.last_name(),
            phone,
            fake.email(),
            position_name,
            fake.date_between(start_date='-5y', end_date='today')
        ))
        employee_id = cur.fetchone()[0]
        employee_ids.append(employee_id)
    
    return employee_ids