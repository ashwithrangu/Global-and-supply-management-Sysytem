create database GLSCMS;
use GLSCMS;

CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    name VARCHAR(100),
    address TEXT
);


CREATE TABLE Carriers (
    carrier_id INT PRIMARY KEY,
    name VARCHAR(100),
    type ENUM('air', 'land', 'sea'),
    contact_info TEXT
);

CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY,
    location VARCHAR(100),
    capacity INT
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    role VARCHAR(50),
    assigned_warehouse_id INT,
    assigned_carrier_id INT,
    CHECK (
        (assigned_warehouse_id IS NOT NULL AND assigned_carrier_id IS NULL) OR
        (assigned_warehouse_id IS NULL AND assigned_carrier_id IS NOT NULL)
    ),
    FOREIGN KEY (assigned_warehouse_id) REFERENCES Warehouses(warehouse_id),
    FOREIGN KEY (assigned_carrier_id) REFERENCES Carriers(carrier_id)
);

CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY,
    origin VARCHAR(100),
    destination VARCHAR(100),
    weight DECIMAL(10, 2),
    content_description TEXT,
    shipment_date DATE,
    sender_id INT,
    receiver_id INT,
    FOREIGN KEY (sender_id) REFERENCES Clients(client_id),
    FOREIGN KEY (receiver_id) REFERENCES Clients(client_id)
);

CREATE TABLE Shipment_Carriers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    shipment_id INT,
    carrier_id INT,
    leg_number INT, -- for multi-leg tracking
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id),
    FOREIGN KEY (carrier_id) REFERENCES Carriers(carrier_id)
);

CREATE TABLE Shipment_Warehouse_History (
    id INT PRIMARY KEY AUTO_INCREMENT,
    shipment_id INT,
    warehouse_id INT,
    arrival_date DATE,
    departure_date DATE,
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id)
);


CREATE TABLE Current_Warehouse_Storage (
    shipment_id INT PRIMARY KEY,
    warehouse_id INT,
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id)
);




















-- Insert into Clients
INSERT INTO Clients VALUES (1, 'Alpha Corp', '123 Industrial Area, Delhi');
INSERT INTO Clients VALUES (2, 'Beta Logistics', '456 Tech Park, Mumbai');
INSERT INTO Clients VALUES (3, 'Gamma Traders', '789 Market Street, Chennai');
INSERT INTO Clients VALUES (4, 'Delta Exports', '111 Harbour Road, Kochi');
INSERT INTO Clients VALUES (5, 'Omega Imports', '202 East End, Kolkata');

-- Insert into Carriers
INSERT INTO Carriers VALUES (1, 'AirXpress', 'air', 'contact@airxpress.com');
INSERT INTO Carriers VALUES (2, 'LandTrans', 'land', 'support@landtrans.in');
INSERT INTO Carriers VALUES (3, 'SeaGo', 'sea', 'info@seago.org');
INSERT INTO Carriers VALUES (4, 'QuickLogistics', 'land', 'quick@logistics.com');
INSERT INTO Carriers VALUES (5, 'SkyLink', 'air', 'skylink@air.net');

-- Insert into Warehouses
INSERT INTO Warehouses VALUES (1, 'Delhi Hub', 5000);
INSERT INTO Warehouses VALUES (2, 'Mumbai Central', 7000);
INSERT INTO Warehouses VALUES (3, 'Chennai Storage', 6000);
INSERT INTO Warehouses VALUES (4, 'Kolkata Point', 5500);
INSERT INTO Warehouses VALUES (5, 'Hyderabad Depot', 6500);

-- Insert into Employees
INSERT INTO Employees VALUES (1, 'Raj Kumar', 'Warehouse Manager', 1, NULL);
INSERT INTO Employees VALUES (2, 'Neha Verma', 'Driver', NULL, 2);
INSERT INTO Employees VALUES (3, 'John Dsouza', 'Warehouse Staff', 3, NULL);
INSERT INTO Employees VALUES (4, 'Ayesha Khan', 'Pilot', NULL, 1);
INSERT INTO Employees VALUES (5, 'Suresh Nair', 'Warehouse Supervisor', 2, NULL);

-- Insert into Shipments
INSERT INTO Shipments VALUES (101, 'Delhi', 'Chennai', 1200.50, 'Electronics goods', '2025-06-10', 1, 3);
INSERT INTO Shipments VALUES (102, 'Mumbai', 'Kolkata', 850.00, 'Textiles', '2025-06-11', 2, 5);
INSERT INTO Shipments VALUES (103, 'Chennai', 'Delhi', 950.25, 'Auto Parts', '2025-06-12', 3, 1);
INSERT INTO Shipments VALUES (104, 'Kolkata', 'Hyderabad', 700.75, 'Books', '2025-06-13', 5, 4);
INSERT INTO Shipments VALUES (105, 'Hyderabad', 'Mumbai', 1100.00, 'Medical Supplies', '2025-06-14', 4, 2);

-- Insert into Shipment_Carriers
INSERT INTO Shipment_Carriers (shipment_id, carrier_id, leg_number) VALUES (101, 1, 1);
INSERT INTO Shipment_Carriers (shipment_id, carrier_id, leg_number) VALUES (101, 2, 2);
INSERT INTO Shipment_Carriers (shipment_id, carrier_id, leg_number) VALUES (102, 2, 1);
INSERT INTO Shipment_Carriers (shipment_id, carrier_id, leg_number) VALUES (103, 1, 1);
INSERT INTO Shipment_Carriers (shipment_id, carrier_id, leg_number) VALUES (104, 3, 1);

-- Insert into Shipment_Warehouse_History
INSERT INTO Shipment_Warehouse_History (shipment_id, warehouse_id, arrival_date, departure_date)
VALUES (101, 1, '2025-06-10', '2025-06-11');
INSERT INTO Shipment_Warehouse_History (shipment_id, warehouse_id, arrival_date, departure_date)
VALUES (101, 3, '2025-06-12', '2025-06-13');
INSERT INTO Shipment_Warehouse_History (shipment_id, warehouse_id, arrival_date, departure_date)
VALUES (102, 2, '2025-06-11', '2025-06-12');
INSERT INTO Shipment_Warehouse_History (shipment_id, warehouse_id, arrival_date, departure_date)
VALUES (104, 4, '2025-06-13', '2025-06-14');
INSERT INTO Shipment_Warehouse_History (shipment_id, warehouse_id, arrival_date, departure_date)
VALUES (105, 5, '2025-06-14', '2025-06-15');

-- Insert into Current_Warehouse_Storage
INSERT INTO Current_Warehouse_Storage VALUES (103, 1);
INSERT INTO Current_Warehouse_Storage VALUES (104, 4);
INSERT INTO Current_Warehouse_Storage VALUES (105, 5);
INSERT INTO Current_Warehouse_Storage VALUES (101, 3);
INSERT INTO Current_Warehouse_Storage VALUES (102, 2);
