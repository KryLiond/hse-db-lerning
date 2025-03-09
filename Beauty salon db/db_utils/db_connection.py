import os
import psycopg2
from time import sleep

def connect_to_db():
    retries = 5
    while retries:
        try:
            conn = psycopg2.connect(
                host=os.environ['PG_HOST'],
                port=os.environ['PG_PORT'],
                dbname=os.environ['PG_DB'],
                user=os.environ['PG_USER'],
                password=os.environ['PG_PASSWORD']
            )
            print("Соединение с БД установлено")
            return conn
        except psycopg2.OperationalError:
            print("Попытка подключения к БД...")
            retries -= 1
            sleep(5)
    raise Exception("БД недоступна")