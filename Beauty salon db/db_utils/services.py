from config import SERVICE_LIST

def insert_services(cur):
    service_ids = []
    for service in SERVICE_LIST:
        cur.execute("""
            INSERT INTO Services (ServiceName, Description, Price, Duration)
            VALUES (%s, %s, %s, %s) RETURNING ServiceID
        """, service)
        service_id = cur.fetchone()[0]
        service_ids.append(service_id)
    return service_ids