from config import POSITIONS

def insert_positions(cur):
    for position_name, description in POSITIONS:
        cur.execute("""
            INSERT INTO Positions (PositionName, Description)
            VALUES (%s, %s)
        """, (position_name, description))