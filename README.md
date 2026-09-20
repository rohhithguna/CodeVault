# CodeShare

## Overview
CodeShare is a lightweight Java web application designed to allow users to securely store and share code snippets. It provides a simple, clean interface for code pasting and incorporates essential security features such as BCrypt password hashing, session-based authentication, explicit visibility settings (Public/Private/Protected), and SQL injection/XSS protection.

## Features
- User registration and authentication
- Create, view, and manage code pastes
- Configurable paste visibility:
  - **Public**: Visible to anyone
  - **Private**: Visible only to the creator
  - **Protected**: Visible to the creator and explicitly shared users
- Expiration tracking for pastes
- Secure dashboard/library

## Technology Stack
- Java 17+
- Servlets & JSP
- JDBC
- MySQL
- Apache Tomcat (Embedded via Cargo)
- Bootstrap (Frontend styling)

## Requirements
- Java Development Kit (JDK) 17 or higher
- Apache Maven
- MySQL Server

## Local Setup
1. **Clone project:**
   ```bash
   git clone https://github.com/your-username/noobs-codeshare.git
   cd noobs-codeshare
   ```

2. **Configure MySQL:**
   Ensure your local MySQL server is running. Create the database and tables using the provided initialization script:
   ```bash
   mysql -u root -p < init_db.sql
   ```

3. **Configure environment variables:**
   Copy the example configuration file:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` to match your local MySQL credentials.

4. **Build project:**
   ```bash
   mvn clean package
   ```

5. **Deploy/run using Tomcat:**
   Use the Maven Cargo plugin to run an embedded Tomcat server:
   ```bash
   mvn cargo:run
   ```

6. **Open the application:**
   Navigate to the following URL in your browser:
   http://localhost:8081/noobs-codeshare/home

## Configuration
The application requires the following environment variables (defined in your `.env` file):
```env
DATABASE_URL=jdbc:mysql://localhost:3306/Noobs_Codeshare
DB_USERNAME=your_database_username
DB_PASSWORD=your_database_password
```
*Note: Do not commit your real `.env` file containing actual passwords to version control.*
