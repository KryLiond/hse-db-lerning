-- Таблица должностей
CREATE TABLE Positions (
    PositionID SERIAL PRIMARY KEY,
    PositionName VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    CHECK (PositionName <> '')
);

-- Клиенты
CREATE TABLE Clients (
    ClientID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL CHECK (FirstName <> ''),
    LastName VARCHAR(50) NOT NULL CHECK (LastName <> ''),
    Phone VARCHAR(15) NOT NULL CHECK (Phone <> ''),
    Email VARCHAR(100) UNIQUE CHECK (Email ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
    DateOfBirth DATE CHECK (DateOfBirth < CURRENT_DATE),
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Услуги
CREATE TABLE Services (
    ServiceID SERIAL PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL UNIQUE CHECK (ServiceName <> ''),
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL CHECK (Price > 0),
    Duration INT NOT NULL CHECK (Duration > 0)
);

-- Сотрудники
CREATE TABLE Employees (
    EmployeeID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL CHECK (FirstName <> ''),
    LastName VARCHAR(50) NOT NULL CHECK (LastName <> ''),
    Phone VARCHAR(15) NOT NULL CHECK (Phone <> ''),
    Email VARCHAR(100) UNIQUE CHECK (Email ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
    PositionID INT NOT NULL REFERENCES Positions(PositionID) ON DELETE RESTRICT,
    HireDate DATE NOT NULL CHECK (HireDate <= CURRENT_DATE)
);

-- Записи
CREATE TABLE Appointments (
    AppointmentID SERIAL PRIMARY KEY,
    ClientID INT NOT NULL REFERENCES Clients(ClientID) ON DELETE CASCADE,
    EmployeeID INT NOT NULL REFERENCES Employees(EmployeeID) ON DELETE CASCADE,
    ServiceID INT NOT NULL REFERENCES Services(ServiceID) ON DELETE CASCADE,
    AppointmentDate TIMESTAMP NOT NULL,
    Status VARCHAR(20) NOT NULL CHECK (Status IN ('Запланирована', 'Завершена', 'Отменена')),
    UNIQUE (EmployeeID, AppointmentDate)
);

-- Оплаты
CREATE TABLE Payments (
    PaymentID SERIAL PRIMARY KEY,
    AppointmentID INT NOT NULL UNIQUE REFERENCES Appointments(AppointmentID) ON DELETE CASCADE,
    Amount DECIMAL(10, 2) NOT NULL CHECK (Amount > 0),
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod VARCHAR(20) NOT NULL CHECK (PaymentMethod IN ('Наличные', 'Карта'))
);

-- Индексы
CREATE INDEX idx_appointments_date ON Appointments(AppointmentDate);
CREATE INDEX idx_appointments_status ON Appointments(Status);
CREATE INDEX idx_clients_phone ON Clients(Phone);
CREATE INDEX idx_employees_position ON Employees(PositionID);


-- Триггеры

-- Функция для проверки цены
CREATE OR REPLACE FUNCTION check_service_price()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Price < 100 THEN
        RAISE EXCEPTION 'Цена услуги не может быть меньше 100 рублей';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер для таблицы Services
CREATE TRIGGER trigger_check_service_price
BEFORE INSERT OR UPDATE ON Services
FOR EACH ROW
EXECUTE FUNCTION check_service_price();

-- Функция для обновления статуса
CREATE OR REPLACE FUNCTION update_appointment_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.AppointmentDate < CURRENT_TIMESTAMP AND NEW.Status = 'Запланирована' THEN
        NEW.Status := 'Завершена';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер для таблицы Appointments
CREATE TRIGGER trigger_update_appointment_status
BEFORE INSERT OR UPDATE ON Appointments
FOR EACH ROW
EXECUTE FUNCTION update_appointment_status();