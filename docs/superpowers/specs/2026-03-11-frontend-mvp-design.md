# AI Platform Frontend MVP Design

## Background

The repository currently contains a product specification in [README.md](C:/Users/76741/Desktop/ai_platform/README.md) and a single-file high-fidelity prototype in [ai-platform-prototype.html](C:/Users/76741/Desktop/ai_platform/ai-platform-prototype.html). There is no existing frontend application scaffold in the workspace.

The user wants frontend implementation work to begin now. During brainstorming, we aligned on a first-phase MVP that is:

- high fidelity to the existing prototype
- implemented as an actual frontend project instead of a single HTML file
- limited in scope to the most valuable navigation and content paths
- ready to expand into the rest of the platform later

## Goal

Build a Vue 3 + TypeScript + Vite frontend that reproduces the prototype's visual style and interaction model for the core platform journey:

1. Platform dashboard
2. Project list
3. Project overview
4. Platform and project navigation shells
5. Placeholder pages for the remaining menu entries

The result should feel like the prototype, but be structured as maintainable application code with typed mock data, reusable UI sections, route-based navigation, and test coverage for the core navigation behavior.

## Scope

### In Scope

- Create a new frontend project in `frontend/`
- Use Vue 3, TypeScript, Vite, Vue Router, Vitest, and Vue Test Utils
- Recreate the prototype's overall layout style:
  - dark left navigation
  - light content canvas
  - card-based dashboard UI
  - dense enterprise admin feel
- Implement these routes:
  - `/dashboard`
  - `/projects`
  - `/projects/:projectId/overview`
  - `/projects/:projectId/:section`
  - `/placeholder/:pageKey`
- Implement these user-visible experiences:
  - global platform shell
  - project shell after entering a project
  - dashboard page
  - project list page
  - project overview page
  - placeholder pages for the rest of the navigation
- Provide mock data that matches the domain language from the README and prototype
- Add focused tests for routing, shell switching, title updates, and project-entry behavior

### Out of Scope

- Backend API integration
- Authentication and authorization
- Data persistence
- Real charts backed by analytics systems
- Drag-and-drop Kanban or workflow editing
- Service detail pages, CI/CD detail flows, or incident drill-down interactions
- Full implementation of all prototype modules

## Product Experience

### Experience Principles

- Preserve the prototype's enterprise management-console feel rather than redesigning it.
- Keep the first meaningful flow complete: platform dashboard -> projects -> enter project -> project overview.
- Make placeholder pages feel intentional, not empty, so the application still presents as a coherent product shell.
- Prioritize desktop fidelity first, while still degrading cleanly on narrower widths.

### Primary User Flow

1. User lands on the platform dashboard at `/dashboard`.
2. User sees platform metrics, trend visualization, incidents, and recent activity.
3. User navigates to `/projects`.
4. User sees featured project cards and the full projects table.
5. User clicks a project card or table row.
6. User is routed to `/projects/:projectId/overview`.
7. The shell switches from global navigation to project navigation.
8. The top bar title and sidebar context update to reflect the selected project.
9. User can visit other project sections and see scoped placeholders for not-yet-built modules.

## Information Architecture

### Global Mode

Global mode uses the platform-level sidebar and includes:

- Dashboard
- Efficiency Board
- Project Space
- CI/CD
- Environment Management
- Incident Center
- Agent Workflows
- Function Management
- AI Monitor
- AI Evaluation
- Atomic Capability Library
- Global Knowledge Base
- Skill Library
- Template Library
- Key Management
- Audit Security
- Settings

For MVP, only `Dashboard` and `Project Space` have full page implementations. The rest route to a consistent placeholder experience.

### Project Mode

Project mode is entered when the user visits any `/projects/:projectId/...` route. It uses a project-specific sidebar and includes:

- Overview
- Agile Process
- Knowledge Base
- Incidents
- Services
- Members
- Skill Config
- Project Settings

For MVP, only `Overview` is fully implemented. The rest route to scoped placeholder content that retains project context.

## Architecture

### Application Layers

The frontend should be decomposed into four layers:

1. Layout layer
   - application frame
   - global sidebar
   - project sidebar
   - top bar

2. Page layer
   - dashboard page
   - projects page
   - project overview page
   - placeholder page

3. Feature/component layer
   - stat cards
   - section cards
   - ranking list
   - incident list
   - timeline
   - project card
   - lightweight chart rendering
   - table presentation

4. Data/type layer
   - typed mock data
   - route metadata helpers
   - domain interfaces

This keeps presentation reusable without abstracting prematurely into a large design system.

### Route Model

The router is the source of truth for mode and page selection.

- Routes under `/projects/:projectId/...` are project-scoped.
- Routes outside that namespace are global-scoped.
- The shell uses route metadata and params to determine:
  - which sidebar to render
  - what title to show
  - whether a project context banner should appear

### State Model

No global state library is needed in the MVP.

- Route params identify the active project.
- Computed helpers derive current navigation state.
- Mock data functions resolve dashboard, project list, and project detail data.
- Local UI state is limited to small view concerns such as active placeholders or responsive menu toggles.

This avoids over-engineering while leaving room for Pinia later if the product grows.

## Visual Design

### Fidelity Targets

The implementation should stay visually close to the prototype in these areas:

- sidebar proportions and tone
- card spacing and rounded corners
- blue-accent enterprise UI theme
- compact metrics presentation
- row/list styling for incidents and activity
- project card hierarchy and metadata density

### Engineering Adjustments

Some changes are intentionally allowed to make the prototype production-friendly:

- use app-wide CSS variables instead of one massive page-level stylesheet
- split large sections into Vue components
- improve responsive behavior for narrower desktop widths and tablets
- replace inline prototype styles with structured component styling
- use semantic buttons, headings, and landmarks where practical

### Responsive Rules

- Desktop first at widths around 1280px and above
- Two-column dashboard sections may collapse to one column on medium screens
- Sidebar remains the core navigation mechanism
- On smaller widths, content stacks cleanly without losing hierarchy

## Data Design

### Domain Types

The MVP data layer should introduce typed interfaces for at least:

- `DashboardMetric`
- `TokenTrendPoint`
- `DepartmentUsage`
- `Incident`
- `ActivityEvent`
- `ProjectSummary`
- `ProjectDetail`
- `ProjectServiceHealth`
- `NavItem`

### Mock Data Sources

Mock data should be organized by domain rather than dumped into one file:

- dashboard data
- global navigation data
- project list data
- project details data
- placeholder descriptions

Mock values should stay aligned with the prototype copy and the README's terminology.

## Components

### Layout Components

- `AppShell`
  - top-level page frame
  - switches between global and project navigation
  - renders top bar and routed content

- `GlobalSidebar`
  - renders global navigation groups
  - highlights current page

- `ProjectSidebar`
  - renders project info header and project navigation groups
  - highlights current project section

- `TopBar`
  - displays current title
  - shows lightweight actions such as notifications and primary CTA

### Reusable UI Sections

- `StatCard`
- `CardPanel`
- `MiniBarChart`
- `RankingList`
- `IncidentList`
- `ActivityTimeline`
- `ProjectCard`
- `ProjectTable`
- `PlaceholderState`

Each component should have one clear purpose and remain understandable without reading multiple unrelated files.

## Page Designs

### Dashboard Page

Must include:

- top metrics row
- token trend card
- department ranking card
- recent incidents card
- project activity card

Data remains static for MVP, but layout and copy should match the prototype closely.

### Projects Page

Must include:

- page intro/header area
- featured project cards
- full projects table
- navigation into project overview when clicking cards or rows

Filtering and creation controls can be visually present without full behavior if they are clearly marked as non-functional or simplified.

### Project Overview Page

Must include:

- project-scoped stats row
- services health list
- project activity feed

The page should feel like a true mode shift from platform view to project workspace.

### Placeholder Pages

Must include:

- module name
- short explanatory copy
- "coming next" or reserved-state presentation
- contextual hints relevant to the selected module

Global placeholders should feel platform-scoped. Project placeholders should feel project-scoped.

## Error Handling and Edge Cases

### Unknown Routes

- Unknown global routes should redirect to `/dashboard`.
- Unknown project sections should route to the project placeholder page if the project exists.

### Unknown Project IDs

- If a project id is not found in mock data, render a friendly not-found state inside the application shell.
- The user should still be able to navigate back to the projects page.

### Sparse Placeholder Content

- Placeholder pages must never be blank.
- If no specialized mock content exists for a module, use a generic but polished reserved-state template.

## Testing Strategy

The MVP should use focused component and route-level tests to validate behavior that matters most:

- dashboard route renders the dashboard page title/content
- projects route renders project cards from mock data
- clicking a project entry navigates into project mode
- project overview route swaps to the project sidebar
- top bar title updates based on the active route
- placeholder routes render correct scoped labels

Tests should prefer user-observable behavior over implementation details.

## File Strategy

The project will likely require these top-level frontend areas:

- `frontend/src/app`
- `frontend/src/layouts`
- `frontend/src/components`
- `frontend/src/features/dashboard`
- `frontend/src/features/projects`
- `frontend/src/features/project`
- `frontend/src/mocks`
- `frontend/src/router`
- `frontend/src/types`
- `frontend/src/styles`
- `frontend/src/test`

This layout is intentionally feature-oriented enough to scale, but still simple for an MVP.

## Acceptance Criteria

The design is successful when:

- a standalone Vue frontend runs locally
- the UI is recognizably faithful to the prototype
- the global dashboard, projects list, and project overview are implemented
- navigation correctly switches between global and project shells
- remaining entries lead to coherent placeholder pages
- the application builds successfully
- the key navigation tests pass

## Spec Review

**Status:** Approved after self-review

**Notes:**

- Scope is intentionally limited to a single frontend MVP plan.
- Architecture boundaries are explicit between shell, pages, reusable sections, and mock data.
- No TODOs, placeholders, or deferred design gaps remain that would block planning.
