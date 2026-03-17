import { mount } from '@vue/test-utils'
import { describe, expect, it } from 'vitest'

import DashboardPage from '../features/dashboard/DashboardPage.vue'

describe('DashboardPage', () => {
  it('renders the token trend section', () => {
    const wrapper = mount(DashboardPage)

    expect(wrapper.find('[data-testid="dashboard-trend-card"]').exists()).toBe(true)
  })
})
