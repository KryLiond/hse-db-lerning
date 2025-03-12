
-- Получить список всех запланированных записей с информацией о клиенте, сотруднике и услуге

SELECT 
    a.AppointmentID,
    c.FirstName || ' ' || c.LastName AS ClientName,
    e.FirstName || ' ' || e.LastName AS EmployeeName,
    s.ServiceName,
    a.AppointmentDate
FROM 
    Appointments a
JOIN 
    Clients c ON a.ClientID = c.ClientID
JOIN 
    Employees e ON a.EmployeeID = e.EmployeeID
JOIN 
    Services s ON a.ServiceID = s.ServiceID
WHERE 
    a.Status = 'Запланирована'
ORDER BY 
    a.AppointmentDate;