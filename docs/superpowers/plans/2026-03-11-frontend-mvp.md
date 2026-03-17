# Frontend MVP Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Vue 3 frontend MVP that high-fidelity recreates the platform dashboard, project list, and project overview from the prototype with route-driven global/project shells and polished placeholder pages.

**Architecture:** The frontend lives in a new `frontend/` Vite application. Vue Router drives global and project modes, typed mock data backs the first release, and small focused UI sections compose the three implemented pages. Styling uses shared CSS variables and layout primitives to preserve the prototype's visual language without collapsing back into a single massive file.

**Tech Stack:** Vue 3, TypeScript, Vite, Vue Router, Vitest, Vue Test Utils, npm

---

## Chunk 1: Project Scaffold And Test Harness

### Task 1: Create the frontend application skeleton

**Files:**
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\package.json`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\tsconfig*.json`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\vite.config.ts`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\index.html`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\main.ts`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\App.vue`

- [ ] **Step 1: Scaffold the Vite Vue TypeScript app**

Run: `npm create vite@latest frontend -- --template vue-ts`
Expected: Vite creates the `frontend/` project structure without errors.

- [ ] **Step 2: Install base dependencies**

Run: `npm install`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: dependency installation completes successfully.

- [ ] **Step 3: Add routing and test dependencies**

Run: `npm install vue-router`
Run: `npm install -D vitest @vitejs/plugin-vue jsdom @vue/test-utils`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: router and test dependencies are added to `package.json`.

- [ ] **Step 4: Write a failing test for the app shell smoke render**

Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\test\app-shell.spec.ts`

```ts
import { describe, expect, it } from 'vitest'
import { mount } from '@vue/test-utils'
import { createRouter, createMemoryHistory } from 'vue-router'

import App from '../App.vue'
import { routes } from '../router'

describe('App shell', () => {
  it('renders the shell container', async () => {
    const router = createRouter({
      history: createMemoryHistory(),
      routes,
    })
    router.push('/dashboard')
    await router.isReady()

    const wrapper = mount(App, {
      global: { plugins: [router] },
    })

    expect(wrapper.find('[data-testid="app-shell"]').exists()).toBe(true)
  })
})
```

- [ ] **Step 5: Run the test to verify it fails**

Run: `npm run test -- app-shell.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: FAIL because the generated app does not yet render `[data-testid="app-shell"]`.

- [ ] **Step 6: Replace generated starter code with the minimal shell implementation**

Implement a minimal `App.vue` that renders:

```vue
<template>
  <div data-testid="app-shell">
    <AppShell />
  </div>
</template>
```

Also add the minimal router export required for the test:

```ts
export const routes = [
  {
    path: '/dashboard',
    name: 'dashboard',
    component: { template: '<div />' },
    meta: { scope: 'global', title: '工作台' },
  },
]
```

Update `main.ts` to create the app with the router.

- [ ] **Step 7: Run the test to verify it passes**

Run: `npm run test -- app-shell.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: PASS.

## Chunk 2: Router, Domain Types, And Mock Data

### Task 2: Define route model and typed mock data

**Files:**
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\router\index.ts`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\types\dashboard.ts`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\types\project.ts`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\types\navigation.ts`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\mocks\dashboard.ts`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\mocks\projects.ts`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\mocks\navigation.ts`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\mocks\placeholders.ts`

- [ ] **Step 1: Write a failing router test for dashboard and project overview routes**

Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\test\router.spec.ts`

```ts
import { describe, expect, it } from 'vitest'
import router from '../router'

describe('router', () => {
  it('resolves dashboard route metadata', () => {
    const match = router.resolve('/dashboard')

    expect(match.name).toBe('dashboard')
    expect(match.meta.scope).toBe('global')
  })

  it('resolves project overview metadata', () => {
    const match = router.resolve('/projects/mall/overview')

    expect(match.name).toBe('project-overview')
    expect(match.meta.scope).toBe('project')
  })
})
```

- [ ] **Step 2: Run the router test to verify it fails**

Run: `npm run test -- router.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: FAIL because the router file and metadata do not exist yet.

- [ ] **Step 3: Implement the route table and typed mock modules**

Add route names, meta fields, and typed mock exports for:

- dashboard
- projects
- project overview
- project placeholder
- global placeholder

Use project ids consistent with the prototype such as `mall`, `user-center`, `data-board`, and `payment-gateway`.

- [ ] **Step 4: Run the router test to verify it passes**

Run: `npm run test -- router.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: PASS.

## Chunk 3: Shell Layout, Navigation, And Shared Styles

### Task 3: Build the application shell and navigation components

**Files:**
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\layouts\AppShell.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\components\shell\GlobalSidebar.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\components\shell\ProjectSidebar.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\components\shell\TopBar.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\composables\useAppShell.ts`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\styles\tokens.css`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\styles\base.css`

- [ ] **Step 1: Write a failing shell behavior test**

Create or extend: `C:\Users\76741\Desktop\ai_platform\frontend\src\test\shell.spec.ts`

```ts
import { describe, expect, it } from 'vitest'
import { mount } from '@vue/test-utils'
import { createMemoryHistory, createRouter } from 'vue-router'

import App from '../App.vue'
import { routes } from '../router'

describe('shell navigation', () => {
  it('shows the global sidebar on dashboard', async () => {
    const router = createRouter({ history: createMemoryHistory(), routes })
    router.push('/dashboard')
    await router.isReady()

    const wrapper = mount(App, {
      global: { plugins: [router] },
    })

    expect(wrapper.find('[data-testid="global-sidebar"]').exists()).toBe(true)
    expect(wrapper.find('[data-testid="project-sidebar"]').exists()).toBe(false)
  })
})
```

- [ ] **Step 2: Run the shell test to verify it fails**

Run: `npm run test -- shell.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: FAIL because the shell and sidebars do not exist yet.

- [ ] **Step 3: Implement the app shell and shared CSS foundation**

The shell should:

- detect global vs project scope from the route
- render the correct sidebar
- compute the top bar title from route metadata and project data
- expose stable `data-testid` hooks for tests
- register the shared CSS files in `main.ts`

- [ ] **Step 4: Run the shell test to verify it passes**

Run: `npm run test -- shell.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: PASS.

## Chunk 4: Reusable Dashboard And Project UI Sections

### Task 4: Build reusable presentation components

**Files:**
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\components\ui\CardPanel.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\components\ui\StatCard.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\components\ui\MiniBarChart.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\components\ui\RankingList.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\components\ui\IncidentList.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\components\ui\ActivityTimeline.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\components\ui\ProjectCard.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\components\ui\ProjectTable.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\components\ui\PlaceholderState.vue`

- [ ] **Step 1: Write a failing component test for project card click behavior**

Create or extend: `C:\Users\76741\Desktop\ai_platform\frontend\src\test\project-card.spec.ts`

```ts
import { describe, expect, it } from 'vitest'
import { mount } from '@vue/test-utils'

import ProjectCard from '../components/ui/ProjectCard.vue'

describe('ProjectCard', () => {
  it('emits select when clicked', async () => {
    const wrapper = mount(ProjectCard, {
      props: {
        project: {
          id: 'mall',
          name: 'Mall System',
          icon: 'cart',
          typeLabel: 'Product',
          description: 'B2C commerce platform',
          statusLabel: 'Active',
          sprintLabel: 'Sprint 8 · 58% 完成',
          tokenLabel: '320K',
          serviceCount: 3,
          memberCount: 6,
        },
      },
    })

    await wrapper.trigger('click')

    expect(wrapper.emitted('select')).toHaveLength(1)
  })
})
```

- [ ] **Step 2: Run the component test to verify it fails**

Run: `npm run test -- project-card.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: FAIL because the component does not exist yet.

- [ ] **Step 3: Implement the reusable UI sections with prototype-faithful styling**

Each component should accept typed props and remain presentational. Avoid embedding routing logic inside them.

- [ ] **Step 4: Run the component test to verify it passes**

Run: `npm run test -- project-card.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: PASS.

## Chunk 5: Dashboard Page

### Task 5: Implement the dashboard page

**Files:**
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\features\dashboard\DashboardPage.vue`

- [ ] **Step 1: Write a failing page test for dashboard content**

Create or extend: `C:\Users\76741\Desktop\ai_platform\frontend\src\test\dashboard-page.spec.ts`

```ts
import { describe, expect, it } from 'vitest'
import { mount } from '@vue/test-utils'

import DashboardPage from '../features/dashboard/DashboardPage.vue'

describe('DashboardPage', () => {
  it('renders the token trend section', () => {
    const wrapper = mount(DashboardPage)

    expect(wrapper.find('[data-testid="dashboard-trend-card"]').exists()).toBe(true)
  })
})
```

- [ ] **Step 2: Run the page test to verify it fails**

Run: `npm run test -- dashboard-page.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: FAIL because the page does not exist yet.

- [ ] **Step 3: Implement the dashboard page from mock data**

Use the reusable sections to render:

- metric cards
- token trend card
- department ranking card
- recent incidents
- project activity timeline

- [ ] **Step 4: Run the page test to verify it passes**

Run: `npm run test -- dashboard-page.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: PASS.

## Chunk 6: Projects Page And Entry Into Project Mode

### Task 6: Implement the projects page and route navigation into project overview

**Files:**
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\features\projects\ProjectsPage.vue`

- [ ] **Step 1: Write a failing route integration test for entering a project**

Create or extend: `C:\Users\76741\Desktop\ai_platform\frontend\src\test\project-entry.spec.ts`

```ts
import { describe, expect, it } from 'vitest'
import { mount } from '@vue/test-utils'
import { createMemoryHistory, createRouter } from 'vue-router'

import App from '../App.vue'
import { routes } from '../router'

describe('project entry', () => {
  it('navigates from projects to project overview when a project is selected', async () => {
    const router = createRouter({ history: createMemoryHistory(), routes })
    router.push('/projects')
    await router.isReady()

    const wrapper = mount(App, {
      global: { plugins: [router] },
    })

    await wrapper.find('[data-project-id="mall"]').trigger('click')

    expect(router.currentRoute.value.fullPath).toBe('/projects/mall/overview')
  })
})
```

- [ ] **Step 2: Run the integration test to verify it fails**

Run: `npm run test -- project-entry.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: FAIL because the page and click navigation do not exist yet.

- [ ] **Step 3: Implement the projects page**

Render:

- page heading and CTA area
- featured cards using `ProjectCard`
- full projects table using `ProjectTable`
- click handlers that route to `/projects/:projectId/overview`

- [ ] **Step 4: Run the integration test to verify it passes**

Run: `npm run test -- project-entry.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: PASS.

## Chunk 7: Project Overview And Placeholder Pages

### Task 7: Implement project overview and placeholder pages

**Files:**
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\features\project\ProjectOverviewPage.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\features\placeholder\PlaceholderPage.vue`
- Create: `C:\Users\76741\Desktop\ai_platform\frontend\src\features\project\NotFoundProjectState.vue`

- [ ] **Step 1: Write a failing test for project sidebar mode and title updates**

Create or extend: `C:\Users\76741\Desktop\ai_platform\frontend\src\test\project-shell.spec.ts`

```ts
import { describe, expect, it } from 'vitest'
import { mount } from '@vue/test-utils'
import { createMemoryHistory, createRouter } from 'vue-router'

import App from '../App.vue'
import { routes } from '../router'

describe('project shell', () => {
  it('shows project navigation and project title on overview routes', async () => {
    const router = createRouter({ history: createMemoryHistory(), routes })
    router.push('/projects/mall/overview')
    await router.isReady()

    const wrapper = mount(App, {
      global: { plugins: [router] },
    })

    expect(wrapper.find('[data-testid="project-sidebar"]').exists()).toBe(true)
    expect(wrapper.find('[data-testid="topbar-title"]').text()).not.toBe('')
  })
})
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `npm run test -- project-shell.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: FAIL because the project overview and title logic are not fully implemented yet.

- [ ] **Step 3: Implement the project overview page and placeholders**

The overview page should render:

- project stats
- service health list
- project activity

Placeholder pages should render:

- scoped title
- explanatory copy
- reserved-state cards

Also add project-not-found handling for unknown ids.

- [ ] **Step 4: Run the test to verify it passes**

Run: `npm run test -- project-shell.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: PASS.

## Chunk 8: Final Integration, Styling Pass, And Verification

### Task 8: Wire the routes into the shell and verify the MVP

**Files:**
- Modify: `C:\Users\76741\Desktop\ai_platform\frontend\src\App.vue`
- Modify: `C:\Users\76741\Desktop\ai_platform\frontend\src\router\index.ts`
- Modify: `C:\Users\76741\Desktop\ai_platform\frontend\src\main.ts`
- Modify: any frontend component files needed for final polish

- [ ] **Step 1: Write a failing test for placeholder scope labeling**

Create or extend: `C:\Users\76741\Desktop\ai_platform\frontend\src\test\placeholder-page.spec.ts`

```ts
import { describe, expect, it } from 'vitest'
import { mount } from '@vue/test-utils'
import { createMemoryHistory, createRouter } from 'vue-router'

import App from '../App.vue'
import { routes } from '../router'

describe('placeholder pages', () => {
  it('renders project-scoped placeholder content for unfinished project modules', async () => {
    const router = createRouter({ history: createMemoryHistory(), routes })
    router.push('/projects/mall/services')
    await router.isReady()

    const wrapper = mount(App, {
      global: { plugins: [router] },
    })

    expect(wrapper.find('[data-testid="placeholder-scope"]').text()).toBe('project')
    expect(wrapper.find('[data-testid="placeholder-page-key"]').text()).toBe('services')
  })
})
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `npm run test -- placeholder-page.spec.ts`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: FAIL until placeholder page content is fully wired.

- [ ] **Step 3: Complete the final integration and polish pass**

Ensure:

- all implemented routes render through the shell
- navigation active states match the current route
- placeholder copy is correct for global/project scope
- CSS spacing and layout resemble the prototype
- starter files that are no longer needed are removed

- [ ] **Step 4: Run the targeted test suite**

Run: `npm run test`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: PASS for the MVP tests.

- [ ] **Step 5: Run a production build**

Run: `npm run build`
Workdir: `C:\Users\76741\Desktop\ai_platform\frontend`
Expected: Vite build completes successfully.

## Plan Review

**Status:** Approved after self-review

**Notes:**

- The plan stays inside one frontend MVP slice.
- Each chunk maps directly to the design spec.
- Verification commands and expected outcomes are included throughout.
