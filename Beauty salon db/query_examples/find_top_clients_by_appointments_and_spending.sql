-- Найти всех сотрудников, которые не имели записей за последнюю неделю

WITH ClientStats AS (
    SELECT 
        c.ClientID,
        c.FirstName || ' ' || c.LastName AS ClientName,
        COUNT(a.AppointmentID) AS AppointmentCount,
        SUM(s.Price) AS TotalSpent
    FROM 
        Clients c
    JOIN 
        Appointments a ON c.ClientID = a.ClientID
    JOIN 
        Services s ON a.ServiceID = s.ServiceID
    GROUP BY 
        c.ClientID
)
SELECT 
    *
FROM 
    ClientStats
WHERE 
    AppointmentCount > 5 AND
    TotalSpent > (SELECT AVG(TotalSpent) FROM ClientStats);