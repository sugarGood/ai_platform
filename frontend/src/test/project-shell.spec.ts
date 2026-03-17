import { mount } from '@vue/test-utils'
import { createMemoryHistory, createRouter } from 'vue-router'
import { describe, expect, it } from 'vitest'

import App from '../App.vue'
import { routes } from '../router'

describe('project shell', () => {
  it('shows project navigation and overview content on project routes', async () => {
    const router = createRouter({
      history: createMemoryHistory(),
      routes,
    })
    router.push('/projects/mall/overview')
    await router.isReady()

    const wrapper = mount(App, {
      global: {
        plugins: [router],
      },
    })

    expect(wrapper.find('[data-testid="project-sidebar"]').exists()).toBe(true)
    expect(wrapper.find('[data-testid="topbar-title"]').text()).toContain('商城系统')
    expect(wrapper.find('[data-testid="project-overview-services"]').exists()).toBe(true)
  })
})
