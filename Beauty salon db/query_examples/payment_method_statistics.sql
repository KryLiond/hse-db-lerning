-- Получить статистику по оплатам по каждому методу оплаты

SELECT 
    PaymentMethod,
    COUNT(PaymentID) AS TotalPayments,
    SUM(Amount) AS TotalAmount
FROM 
    Payments
GROUP BY 
    PaymentMethod
ORDER BY 
    TotalAmount DESC;