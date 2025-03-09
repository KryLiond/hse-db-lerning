from config import NUM_APPOINTMENTS, NUM_CLIENTS
from datetime import datetime, timedelta
from random import choice, randint
from faker import Faker

fake = Faker('ru_RU')

def insert_appointments(cur, employee_ids=None, service_ids=None):
    
    start_date = datetime.now() - timedelta(days=30)
    appointment_data = []
    
    for _ in range(NUM_APPOINTMENTS):
        status = choice(['Запланирована', 'Завершена', 'Отменена'])
        appointment_date = fake.date_time_between(start_date=start_date, end_date='+30d')
        
        cur.execute("""
            INSERT INTO Appointments (ClientID, EmployeeID, ServiceID, AppointmentDate, Status)
            VALUES (%s, %s, %s, %s, %s) 
            RETURNING AppointmentID, Status, AppointmentDate
        """, (
            randint(1, NUM_CLIENTS),
            choice(employee_ids),
            choice(service_ids),
            appointment_date,
            status
        ))

        appointment_info = cur.fetchone()
        appointment_data.append(appointment_info)
    
    return appointment_data