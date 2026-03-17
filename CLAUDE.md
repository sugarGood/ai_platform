# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **AI 中台 (Enterprise AI Platform)** — an enterprise AI management platform that consists of multiple components:

1. **HTML Prototype** (`ai-platform-prototype.html`) — Single-file interactive prototype with all UI features
2. **Vue 3 Frontend** (`frontend/`) — Production web application built with Vue 3 + TypeScript + Vite
3. **Spring Boot Backend** (`backend/`) — REST API server using Spring Boot 3 + MyBatis Plus
4. **Database Schema** (`sql/`) — MySQL database with comprehensive schema and mock data

## Development Commands

### Frontend (Vue 3 + TypeScript + Vite)
```bash
cd frontend
npm install           # Install dependencies
npm run dev           # Start dev server (http://localhost:5173)
npm run build         # Build for production
npm run preview       # Preview production build
npm run test          # Run tests with Vitest
```

### Backend (Spring Boot 3)
```bash
cd backend
mvn clean install    # Build project
mvn spring-boot:run   # Start server (http://localhost:8080)
mvn test              # Run tests
```

### Database Setup
The backend uses H2 in-memory database for development by default. To use MySQL:
1. Start MySQL and create database `ai_platform`
2. Run schema: `sql/2026-03-16-full-schema-v2.sql`
3. Load mock data: `sql/2026-03-16-mock-data.sql`
4. Update `backend/src/main/resources/application.yml` with MySQL configuration

## Architecture

### Full Stack Structure
```
ai_platform/
├── ai-platform-prototype.html  # Interactive UI prototype (single file)
├── frontend/                   # Vue 3 production app
│   ├── src/
│   │   ├── components/shell/   # Navigation components
│   │   ├── components/ui/      # Reusable UI components
│   │   ├── pages/             # Page components
│   │   └── router/            # Vue Router configuration
├── backend/                   # Spring Boot API server
│   ├── src/main/java/com/aiplatform/backend/
│   │   ├── aikey/            # AI key management module
│   │   ├── common/           # Shared utilities and exceptions
│   │   ├── project/          # Project management module
│   │   └── member/           # Member management module
└── sql/                      # Database schema and data
```

### Frontend (Vue 3)
- **Framework**: Vue 3 with Composition API
- **Build Tool**: Vite for fast development and builds
- **Language**: TypeScript for type safety
- **Routing**: Vue Router 5 for SPA navigation
- **Testing**: Vitest + Vue Test Utils

### Backend (Spring Boot 3)
- **Framework**: Spring Boot 3 with Java 17
- **Database**: MyBatis Plus for database operations
- **Architecture**: Domain-driven design with controller/service/mapper layers
- **Database**: H2 (dev) / MySQL (prod)
- **API**: RESTful endpoints following `/api/{module}` pattern

### HTML Prototype Features
The single-file prototype demonstrates the complete UI:
- **Global sidebar** (`#sidebar-global`): Platform-level navigation
- **Project sidebar** (`#sidebar-project`): Project-scoped navigation
- **Page routing**: CSS-based `.active` class switching
- **Key functions**: `showPage()`, `enterProject()`, `exitProject()`, `showProjectPage()`
- **Theme system**: CSS custom properties (--primary, --danger, etc.)
- **Modals**: `.modal.open` pattern with `openModal()/closeModal()`

## Key Modules

### AI Key Management (`backend/aikey/`)
- Manages API keys and token quotas for different AI models
- Supports per-project token allocation and usage tracking
- REST endpoints: `/api/aikeys/*`

### Project Management (`backend/project/`)
- Core project CRUD operations
- Project-service relationships
- Member management and permissions

### Database Schema
- **Core tables**: projects, services, members, ai_keys, usage_logs
- **Schema files**: `sql/2026-03-16-full-schema-v2.sql`
- **Mock data**: `sql/2026-03-16-mock-data.sql`

## Language

UI text is in Chinese (zh-CN). Code comments, API endpoints, and function names are in English.

## Testing

- **Frontend**: Run `npm run test` in frontend/ directory
- **Backend**: Run `mvn test` in backend/ directory
- **Database**: Use H2 console at http://localhost:8080/h2-console (when backend is running)
