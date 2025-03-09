from datetime import timedelta
from random import choice, randint

def insert_payments(cur, appointment_data):
    for appointment_id, status, appointment_date in appointment_data:
        if status == 'Завершена':
            cur.execute("""
                SELECT s.Price 
                FROM Appointments a
                JOIN Services s ON a.ServiceID = s.ServiceID
                WHERE a.AppointmentID = %s
            """, (appointment_id,))
            price = cur.fetchone()[0]

            payment_method = choice(['Наличные', 'Карта'])
            payment_date = appointment_date + timedelta(minutes=randint(10, 60))

            cur.execute("""
                INSERT INTO Payments (AppointmentID, Amount, PaymentDate, PaymentMethod)
                VALUES (%s, %s, %s, %s)
            """, (
                appointment_id,
                price,
                payment_date,
                payment_method
            ))