/*
=========================================================
Project : Employee Database Analytics System
File    : 01_Create_Database.sql
Author  : Ayush Kale
Database: EmployeeDB

Description:
Creates the EmployeeDB database if it does not already
exist and switches the current session to it.

=========================================================
*/
IF DB_ID('EmployeeDB') IS NULL
BEGIN
    CREATE DATABASE EmployeeDB;
    PRINT 'Database created successfully.';
END
ELSE
BEGIN
    PRINT 'Database already exists.';
END
GO

USE EmployeeDB;
GO