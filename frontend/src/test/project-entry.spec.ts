import { mount } from '@vue/test-utils'
import { createMemoryHistory, createRouter } from 'vue-router'
import { describe, expect, it } from 'vitest'

import App from '../App.vue'
import { routes } from '../router'

describe('project entry', () => {
  it('navigates from projects to project overview when a project is selected', async () => {
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

    await wrapper.find('[data-project-id="mall"]').trigger('click')

    expect(router.currentRoute.value.fullPath).toBe('/projects/mall/overview')
  })
})
