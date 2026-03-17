import { mount } from '@vue/test-utils'
import { createMemoryHistory, createRouter } from 'vue-router'
import { describe, expect, it } from 'vitest'

import App from '../App.vue'
import { routes } from '../router'

describe('topbar actions', () => {
  it('opens notifications panel when clicking notification button', async () => {
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

    await wrapper.get('[data-testid="topbar-notifications"]').trigger('click')

    expect(wrapper.find('[data-testid="notifications-panel"]').exists()).toBe(true)
  })

  it('opens new project modal from project entry action', async () => {
    const router = createRouter({
      history: createMemoryHistory(),
      routes,
    })
    router.push('/projects')
    await router.isReady()

    const wrapper = mount(App, {
      global: {
        plugins: [router],
      },
    })

    await wrapper.get('[data-testid="new-project-entry"]').trigger('click')

    expect(wrapper.find('[data-testid="new-project-modal"]').exists()).toBe(true)
  })
})
