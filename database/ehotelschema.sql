CREATE TABLE ehotelschema.hotel_chain (
    chain_id INT PRIMARY KEY,
    office_address VARCHAR(100) NOT NULL,
    chain_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL
);

CREATE TABLE ehotelschema.hotel (
    hotel_id INT PRIMARY KEY,
    chain_id INT NOT NULL,
    hotel_address VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    rating DECIMAL(2,1) NOT NULL,
    manager_id INT NOT NULL,
    FOREIGN KEY (chain_id) REFERENCES ehotelschema.hotel_chain(chain_id),
    FOREIGN KEY (manager_id) REFERENCES ehotelschema.employee(SIN)
);

CREATE TABLE ehotelschema.room (
    room_number INT PRIMARY KEY,
    hotel_id INT NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    price DECIMAL(6,2) NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES ehotelschema.hotel(hotel_id)
);

CREATE TABLE ehotelschema.client (
    SIN INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    registration_date DATE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    pw VARCHAR(50) NOT NULL
);

CREATE TABLE ehotelschema.employee (
    SIN INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    employee_role VARCHAR(50) NOT NULL,
    works_at INT NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    pw VARCHAR(50) NOT NULL,
    FOREIGN KEY (works_at) REFERENCES ehotelschema.hotel(hotel_id)
);

CREATE TABLE ehotelschema.reservation (
    reservation_id INT PRIMARY KEY,
    room_number INT NOT NULL,
    SIN INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    reservation_date DATE NOT NULL,
    FOREIGN KEY (room_number) REFERENCES ehotelschema.room(room_number),
    FOREIGN KEY (SIN) REFERENCES ehotelschema.client(SIN)
);