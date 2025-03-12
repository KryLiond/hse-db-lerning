-- Посчитать общую выручку по каждой услуге за последний месяц

SELECT 
    s.ServiceName,
    COUNT(a.AppointmentID) AS TotalAppointments,
    SUM(s.Price) AS TotalRevenue
FROM 
    Appointments a
JOIN 
    Services s ON a.ServiceID = s.ServiceID
JOIN 
    Payments p ON a.AppointmentID = p.AppointmentID
WHERE 
    a.Status = 'Завершена' AND
    a.AppointmentDate >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY 
    s.ServiceName
ORDER BY 
    TotalRevenue DESC;