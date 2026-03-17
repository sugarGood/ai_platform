import { mount } from '@vue/test-utils'
import { createMemoryHistory, createRouter } from 'vue-router'
import { describe, expect, it } from 'vitest'

import App from '../App.vue'
import { routes } from '../router'

describe('module actions', () => {
  it('opens action dialog when clicking a module action button', async () => {
    const router = createRouter({
      history: createMemoryHistory(),
      routes,
    })
    router.push('/placeholder/workflows')
    await router.isReady()

    const wrapper = mount(App, {
      global: {
        plugins: [router],
      },
    })

    await wrapper.get('[data-testid="module-action-新建工作流"]').trigger('click')

    expect(wrapper.find('[data-testid="action-modal"]').exists()).toBe(true)
    expect(wrapper.text()).toContain('新建工作流')
  })
})
