CREATE DATABASE IF NOT EXISTS Noobs_Codeshare;
USE Noobs_Codeshare;

CREATE TABLE IF NOT EXISTS Users (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Username VARCHAR(255) NOT NULL UNIQUE,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    CreatedAt VARCHAR(255) NOT NULL,
    UpdatedAt VARCHAR(255),
    Status INT NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS Languages (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Source_Codes (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    LanguageId INT NOT NULL,
    Visibility INT NOT NULL,
    Code TEXT NOT NULL,
    CreatedBy INT,
    CreatedByAlt VARCHAR(255),
    CreatedAt VARCHAR(255) NOT NULL,
    ExpireAt VARCHAR(255),
    Status INT NOT NULL DEFAULT 1,
    FOREIGN KEY (LanguageId) REFERENCES Languages(Id),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id)
);

CREATE TABLE IF NOT EXISTS Shared_With (
    Source_Id INT NOT NULL,
    Shared_User_Id INT NOT NULL,
    PRIMARY KEY (Source_Id, Shared_User_Id),
    FOREIGN KEY (Source_Id) REFERENCES Source_Codes(Id),
    FOREIGN KEY (Shared_User_Id) REFERENCES Users(Id)
);

INSERT IGNORE INTO Languages (Id, Name) VALUES (1, 'Java'), (2, 'Python'), (3, 'C++'), (4, 'JavaScript'), (5, 'HTML'), (6, 'CSS'), (7, 'PHP'), (8, 'Ruby'), (9, 'Swift'), (10, 'Go');
