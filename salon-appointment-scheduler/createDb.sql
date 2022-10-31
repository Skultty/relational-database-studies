-- Since we are goinG to run this file each time after adding a new sql command, we need to drop the db if it already exists 
DROP DATABASE IF EXISTS salon;

-- Create the database
CREATE DATABASE salon;

-- Use the database
\c salon

-- Create table for customers
CREATE TABLE customers(
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(15) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL
);

-- Create table for services
CREATE TABLE services(
    service_id SERIAL PRIMARY KEY,
    name VARCHAR(15) NOT NULL
);

-- Create table for appointments
CREATE TABLE appointments(
    appointment_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) NOT NULL,
    service_id INT REFERENCES services(service_id) NOT NULL,
    time VARCHAR(15) NOT NULL
);

-- Insert some services
INSERT INTO services(name) VALUES('cut'), ('color'), ('perm'), ('style'), ('trim');