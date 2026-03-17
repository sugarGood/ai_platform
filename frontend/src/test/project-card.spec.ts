import { mount } from '@vue/test-utils'
import { describe, expect, it } from 'vitest'

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
          sprintLabel: 'Sprint 8 · 58% complete',
          tokenLabel: '320K',
          serviceCount: 3,
          memberCount: 6,
          members: ['A', 'B', 'C'],
          statusTone: 'success',
        },
      },
    })

    await wrapper.trigger('click')

    expect(wrapper.emitted('select')).toHaveLength(1)
  })
})
