# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **AI 中台 (Enterprise AI Platform)** — a single-file HTML prototype for an enterprise AI management dashboard. The entire application lives in `ai-platform-prototype.html` (~2850 lines), combining HTML structure, CSS styles, and vanilla JavaScript with no build tools or dependencies.

## Architecture

The app is a single-page application with two navigation modes:

- **Global sidebar** (`#sidebar-global`): Platform-level pages (dashboard, projects, AI capabilities, settings, etc.)
- **Project sidebar** (`#sidebar-project`): Shown when entering a specific project, with project-scoped navigation

### Page Routing

Pages are `<div class="page">` elements toggled via CSS class `.active`. Key navigation functions:
- `showPage(name)` — switches global pages, updates sidebar active state and topbar title
- `enterProject(icon, name, sprint)` / `exitProject()` — toggles between global and project sidebars
- `showProjectPage(name)` — navigates within a project context
- `showServiceDetail(svcKey)` — drills into a service detail view with tabs

### Key Page Sections

| Page ID pattern | Section |
|---|---|
| `page-dashboard` | Token usage stats, charts, recent activity |
| `page-projects` | Project cards grid |
| `page-proj-*` | Project-scoped pages (overview, agile/kanban, knowledge, incidents, services, members, skill config, settings) |
| `page-svc-detail` | Service detail with tabbed views |
| `page-workflows` | Agent workflow editor with visual flow diagrams |
| `page-functions` | Function/tool management with parameter schemas |
| `page-ai-monitor` | AI execution monitoring |
| `page-evals` | AI evaluation center |
| `page-atomic` | Atomic capability library |
| `page-cicd`, `page-envs` | CI/CD pipelines, environment management |
| `page-keys`, `page-audit` | API key management, audit/security |

### CSS Design System

CSS custom properties defined in `:root` control the theme (colors, spacing). Key variables: `--primary`, `--danger`, `--success`, `--warning`, `--sidebar-bg`. All styles are inline in `<style>` — no external CSS.

### Modals

Modals use `<div class="modal">` with `.open` class. Opened/closed via `openModal(name)` / `closeModal(name)`. Clicking the overlay backdrop also closes them.

## Development

Open `ai-platform-prototype.html` directly in a browser — no server or build step required. All content is static/mock data for prototyping purposes.

## Language

UI text is in Chinese (zh-CN). Code comments and function names are in English.
