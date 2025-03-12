-- Вставка нового сотрудника

INSERT INTO Employees (
    FirstName,
    LastName,
    Phone,
    Email,
    PositionID,
    HireDate
) VALUES (
    'Иван',               -- FirstName
    'Иванов',             -- LastName
    '+71859295647',       -- Phone
    'ivan.ivanov@gmail.com', -- Email
    1,                    -- PositionID
    CURRENT_DATE          -- HireDate
);