# Event Finder — Full-Stack Web Application

A responsive event-discovery and registration platform built with React, Java Spring Boot, JDBC and MySQL. This is an expanded implementation of the original Event Finder report, replacing the initial Node.js/JSON approach with the updated React + Java + JDBC + MySQL stack.

## Features
- Browse upcoming events and view event details.
- Search by title, location and description; filter by category and date.
- User registration/login with BCrypt password hashing and JWT authentication.
- Authenticated users can publish events. Event creators (and admins) can edit/delete their own events through the API.
- Register for events, prevent duplicate registrations and enforce event capacity.
- View and cancel your registrations in the dashboard.
- Responsive desktop and mobile interface.

## Technology
- Frontend: React 18, Vite, React Router, Axios, Lucide icons, CSS.
- Backend: Java 17+, Spring Boot 3, Spring Security, Spring JdbcTemplate (JDBC), Maven, JWT.
- Database: MySQL 8+.

## Prerequisites
Install JDK 17 or later, Maven 3.8+, Node.js 18+, npm and MySQL 8+.

## 1. Create the database
Start MySQL and execute the SQL in `database/schema.sql` using MySQL Workbench or the MySQL CLI:

```bash
mysql -u root -p < database/schema.sql
```

This creates the `event_finder` database, tables, constraints and categories.

## 2. Configure and run the backend
From the `backend` directory, set environment variables (PowerShell example):

```powershell
$env:DB_URL="jdbc:mysql://localhost:3306/event_finder?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
$env:DB_USERNAME="root"
$env:DB_PASSWORD="YOUR_MYSQL_PASSWORD"
$env:JWT_SECRET="replace-with-a-long-random-secret-at-least-32-characters"
mvn spring-boot:run
```

On macOS/Linux use `export NAME=value` before `mvn spring-boot:run`. The API runs at `http://localhost:8080`. Never commit real credentials.

## 3. Run the frontend
Open another terminal:

```bash
cd frontend
npm install
npm run dev
```

Open `http://localhost:5173`. Optional: create `frontend/.env` with `VITE_API_URL=http://localhost:8080/api` if your API is hosted elsewhere.

## 4. First use
1. Open the frontend and create a user account.
2. Log in and choose **Create an event** to publish an event.
3. Explore events, open an event and register.
4. Open Dashboard to see or cancel your registrations.

The public registration endpoint creates a `USER` role by default. For an administrator, update a trusted account's role directly in MySQL: `UPDATE users SET role='ADMIN' WHERE email='your-admin-email';`. Do not expose admin role assignment in a public API.

## API overview
| Method | Endpoint | Access |
|---|---|---|
| POST | `/api/auth/register` | Public |
| POST | `/api/auth/login` | Public |
| GET | `/api/events` | Public; supports `q`, `categoryId`, `date` |
| GET | `/api/events/{id}` | Public |
| POST | `/api/events` | Authenticated |
| PUT/DELETE | `/api/events/{id}` | Owner or ADMIN |
| GET | `/api/categories` | Public |
| POST | `/api/registrations` | Authenticated |
| GET | `/api/registrations/my` | Authenticated |
| DELETE | `/api/registrations/{id}` | Registration owner |
| GET | `/api/users/profile` | Authenticated |

Authenticated requests use `Authorization: Bearer <token>`. All SQL values are passed through JDBC parameters/prepared statements.

## Project structure
```text
event-finder/
├── backend/                 # Spring Boot REST API
│   └── src/main/java/com/eventfinder/
│       ├── config/           # Security and CORS
│       ├── controller/       # REST endpoints and exception handling
│       ├── dao/              # JDBC data access
│       ├── dto/              # Request/response records
│       ├── model/            # Domain records
│       ├── security/         # JWT filter/service
│       └── service/          # Authentication business logic
├── frontend/                # React + Vite application
├── database/                # Schema and seed scripts
└── README.md
```

## Deployment notes
Build the frontend using `npm run build` in `frontend`; deploy the generated `dist/` directory to a static host. Build the backend using `mvn clean package` in `backend`; deploy the generated JAR to a Java host. Provision a managed MySQL database and set `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`, and a strong `JWT_SECRET` in the backend environment. Set `VITE_API_URL` to the deployed API base URL at frontend build time. Update the backend CORS allowlist in `SecurityConfig` to include your production frontend origin before deployment and enforce HTTPS.

## Important implementation notes
- JDBC is used through `JdbcTemplate`; Hibernate/JPA and MongoDB are not used.
- Passwords are stored as BCrypt hashes, never as plaintext.
- The application does not include payment processing, email verification, image uploads or password-reset flows. Event images are supplied as external image URLs.
- Before a public production launch, add rate limiting, email verification, stronger audit logging, integration tests, transactional locking for capacity under high concurrency, and a production-specific CORS configuration.

## Screenshots
Add screenshots of the homepage, Explore page, event details, login and dashboard here after running the application.
