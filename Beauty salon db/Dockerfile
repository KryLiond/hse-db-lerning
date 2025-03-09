FROM python:3.9-slim

RUN pip install faker psycopg2-binary

WORKDIR /app

COPY . .

CMD ["python", "generate_data.py"]