import { mount } from '@vue/test-utils'
import { createMemoryHistory, createRouter } from 'vue-router'
import { describe, expect, it } from 'vitest'

import App from '../App.vue'
import { routes } from '../router'

describe('shell navigation', () => {
  it('shows the global sidebar on dashboard', async () => {
    const router = createRouter({
      history: createMemoryHistory(),
      routes,
    })
    router.push('/dashboard')
    await router.isReady()

    const wrapper = mount(App, {
      global: {
        plugins: [router],
      },
    })

    expect(wrapper.find('[data-testid="global-sidebar"]').exists()).toBe(true)
    expect(wrapper.find('[data-testid="project-sidebar"]').exists()).toBe(false)
  })
})
