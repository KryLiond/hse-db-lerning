import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent))

from db_utils.db_connection import connect_to_db
from db_utils.positions import insert_positions
from db_utils.clients import insert_clients
from db_utils.employees import insert_employees
from db_utils.services import insert_services
from db_utils.appointments import insert_appointments
from db_utils.payments import insert_payments

def is_database_initialized(cur):
    tables = ['Clients', 'Employees', 'Services', 'Appointments']
    for table in tables:
        cur.execute(f"SELECT COUNT(*) FROM {table}")
        if cur.fetchone()[0] > 0:
            return True
    return False

def main():
    # Подключение к БД
    conn = connect_to_db()
    cur = conn.cursor()

    try:
         if not is_database_initialized(cur):
            insert_positions(cur)
            insert_clients(cur)
            employee_ids = insert_employees(cur)
            service_ids = insert_services(cur)
            appointment_data = insert_appointments(cur, employee_ids, service_ids)
            insert_payments(cur, appointment_data)

            conn.commit()
    finally:
        cur.close()
        conn.close()

if __name__ == "__main__":
    main()