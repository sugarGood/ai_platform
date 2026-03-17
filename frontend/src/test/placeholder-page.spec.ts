import { mount } from '@vue/test-utils'
import { createMemoryHistory, createRouter } from 'vue-router'
import { describe, expect, it } from 'vitest'

import App from '../App.vue'
import { routes } from '../router'

describe('rich pages', () => {
  it('renders workflow management content on global module routes', async () => {
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

    expect(wrapper.text()).toContain('代码 Review Agent')
    expect(wrapper.text()).toContain('Bug 诊断修复 Agent')
  })

  it('renders project services content on project module routes', async () => {
    const router = createRouter({
      history: createMemoryHistory(),
      routes,
    })
    router.push('/projects/mall/services')
    await router.isReady()

    const wrapper = mount(App, {
      global: {
        plugins: [router],
      },
    })

    expect(wrapper.text()).toContain('mall-backend')
    expect(wrapper.text()).toContain('添加新服务')
  })
})
