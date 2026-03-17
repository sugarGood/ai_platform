import { mount } from '@vue/test-utils'
import { createMemoryHistory, createRouter } from 'vue-router'
import { describe, expect, it } from 'vitest'

import App from '../App.vue'
import { routes } from '../router'

describe('service detail page', () => {
  it('renders service overview and MCP tool content', async () => {
    const router = createRouter({
      history: createMemoryHistory(),
      routes,
    })
    router.push('/projects/mall/services/mall-backend')
    await router.isReady()

    const wrapper = mount(App, {
      global: {
        plugins: [router],
      },
    })

    expect(wrapper.text()).toContain('mall-backend')
    expect(wrapper.text()).toContain('search_knowledge')
    expect(wrapper.text()).toContain('CI/CD')
  })
})
