import { mount } from '@vue/test-utils'
import { createMemoryHistory, createRouter } from 'vue-router'
import { describe, expect, it } from 'vitest'

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
      global: {
        plugins: [router],
      },
    })

    expect(wrapper.find('[data-testid="app-shell"]').exists()).toBe(true)
  })
})
