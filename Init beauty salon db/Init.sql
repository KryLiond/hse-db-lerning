-- Таблица для должностей
CREATE TABLE Positions (
    PositionID SERIAL PRIMARY KEY,
    PositionName VARCHAR(100) NOT NULL,
    Description TEXT
);

-- Таблица для клиентов
CREATE TABLE Clients (
    ClientID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100),
    DateOfBirth DATE,
    RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Таблица для услуг
CREATE TABLE Services (
    ServiceID SERIAL PRIMARY KEY,
    ServiceName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    Duration INT NOT NULL -- продолжительность в минутах
);

-- Таблица для сотрудников
CREATE TABLE Employees (
    EmployeeID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100),
    PositionID INT,
    HireDate DATE NOT NULL,
    FOREIGN KEY (PositionID) REFERENCES Positions(PositionID) ON DELETE SET NULL
);

-- Таблица для записей
CREATE TABLE Appointments (
    AppointmentID SERIAL PRIMARY KEY,
    ClientID INT,
    EmployeeID INT,
    ServiceID INT,
    AppointmentDate TIMESTAMP NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('Запланирована', 'Завершена', 'Отменена')) NOT NULL,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID) ON DELETE CASCADE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL,
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID) ON DELETE CASCADE
);

-- Таблица для оплат
CREATE TABLE Payments (
    PaymentID SERIAL PRIMARY KEY,
    AppointmentID INT UNIQUE,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod VARCHAR(20) CHECK (PaymentMethod IN ('Наличные', 'Карта')) NOT NULL,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID) ON DELETE CASCADE
);
