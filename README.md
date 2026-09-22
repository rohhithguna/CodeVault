# CodeVault

CodeVault is a secure and lightweight web-based code-sharing platform built using Java 21, Servlets, JDBC, MySQL, Bootstrap, and Apache Tomcat. It allows authenticated users to create, store, manage, and share source-code snippets through unique links with configurable visibility and expiration settings.

## Features

- User registration and authentication
- Secure session management
- Create, view, and manage code snippets
- Configurable paste visibility:
  - **Public**: Visible to anyone with the link
  - **Private**: Visible only to the creator
  - **Protected**: Visible to the creator and explicitly shared users
- Code expiration tracking
- Personal code library/dashboard
- "Shared With Me" library access
- MySQL persistence
- Responsive Bootstrap UI

## Technology Stack

| Technology | Purpose |
|------------|---------|
| Java 21 | Backend application logic |
| JSP | Server-side UI rendering |
| Servlets | HTTP request handling |
| JDBC | Database access and operations |
| MySQL | Persistent data storage |
| Bootstrap | Responsive frontend UI |
| JavaScript | Client-side interactions (e.g. Ace Editor) |
| Maven | Build and dependency management |
| Apache Tomcat 10 | Application server (Embedded via Cargo) |

## Architecture

```text
Browser
   |
   v
JSP / Bootstrap / JavaScript
   |
   v
Java Servlets (Controllers)
   |
   v
DAO Layer
   |
   v
JDBC
   |
   v
MySQL Database
```

- **JSP/Frontend:** Renders the user interface and captures inputs.
- **Servlets:** Receives requests, manages session verification, authorization, and dictates the flow to DAOs.
- **DAO Layer:** Encapsulates database interactions and provides standard methods for the Servlets to query and mutate data.
- **JDBC/MySQL:** Executes actual SQL commands, utilizing prepared statements for data safety.

## Application Flow

1. Registration -> Login -> Authenticated Session
2. Create Paste -> Select Language/Visibility/Expiration -> Store in MySQL
3. Generate Paste ID -> Provide Unique Paste URL
4. View / Copy Code / Share Paste link
5. Manage in Library or "Shared With Me"
6. Logout

## Security

- **BCrypt Password Hashing:** User passwords are encrypted using BCrypt prior to database insertion.
- **PreparedStatements:** Prevents SQL Injection attacks for all database interactions.
- **Session-based Authentication:** Verifies user identity via secure server-side sessions.
- **Authorization Checks:** Explicit ownership and visibility validation before serving protected/private code.
- **Environment-based Configuration:** Sensitive credentials are provided via `.env` variables (excluded from version control).
- **Safe Rendering:** Code rendering practices limit exposure to XSS.

## Database

| Table | Purpose |
|-------|---------|
| Users | Stores user account credentials (hashed) and details. |
| Source_Codes | Stores code snippets, metadata, language info, visibility, and expiration. |
| Languages | Stores supported syntax-highlighting languages. |
| Shared_With | Resolves many-to-many relationship mapping protected pastes to specific users. |

## Project Structure

```text
noobs-codeshare/
├── src/
│   ├── main/
│   │   ├── java/com/codeshare/
│   │   │   ├── controller/     # Servlet logic
│   │   │   ├── dao/            # Database access layer
│   │   │   ├── model/          # Data objects
│   │   │   └── service/        # Database connectivity & login
│   │   └── webapp/             # JSP pages, CSS, JS, assets
├── pom.xml                     # Maven project configuration
├── .env.example                # Safe environment variable placeholders
├── .gitignore                  # Git tracking exclusions
├── init_db.sql                 # Initial database schema setup
└── README.md                   # Project documentation
```

## Requirements

- Java Development Kit (JDK) 21
- Apache Maven
- MySQL Server
- Git

## Installation

1. **Clone repository:**
   ```bash
   git clone https://github.com/your-username/noobs-codeshare.git
   cd noobs-codeshare
   ```

2. **Create MySQL database:**
   Ensure your local MySQL server is running. Create the database and tables using the provided initialization script:
   ```bash
   mysql -u root -p < init_db.sql
   ```

3. **Configure environment variables:**
   Copy the example configuration file:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` to match your local MySQL credentials. (Do not commit the `.env` file to version control).

4. **Build project:**
   ```bash
   mvn clean package
   ```

## Running the Application

1. **Deploy/run using Tomcat:**
   Use the Maven Cargo plugin to run an embedded Tomcat server locally:
   ```bash
   mvn cargo:run
   ```

2. **Open the application:**
   Navigate to the following URL in your browser:
   `http://localhost:8081/noobs-codeshare/home`

## Usage

1. **Register** for an account.
2. **Login** with your credentials.
3. Access the dashboard and click **Create Paste**.
4. Enter your code, select the syntax language, and configure visibility/expiration.
5. Save the paste and copy the unique generated link.
6. Manage your existing pastes through the **Library**.
7. Access pastes shared explicitly with you through **Shared With Me**.
8. **Logout** when finished.

## Security Notes

- **Secrets must remain outside Git:** Ensure you never commit `.env` or hardcode database passwords. `.env.example` is provided strictly for placeholders.
- **Production Warning:** This application uses standard HTTP for local development. A production deployment requires HTTPS (SSL/TLS) to prevent session hijacking and proper environment variable secret management.

## Limitations

- Designed primarily as an academic/local project.
- No email verification or password recovery mechanisms.
- File and code sizes are restricted by default database column types (e.g., `LONGTEXT`).
- No production deployment configuration provided.

## Future Enhancements

- Syntax highlighting improvements and theme toggles.
- Advanced search and filtering capabilities in the Library.
- Rate limiting for paste creations to prevent abuse.
- Full automated testing suite (JUnit/Mockito).
- HTTPS production deployment configuration.
