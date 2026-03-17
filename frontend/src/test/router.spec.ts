import { describe, expect, it } from 'vitest'

import router from '../router'

describe('router', () => {
  it('resolves dashboard route metadata', () => {
    const match = router.resolve('/dashboard')

    expect(match.name).toBe('dashboard')
    expect(match.meta.scope).toBe('global')
  })

  it('resolves project overview metadata', () => {
    const match = router.resolve('/projects/mall/overview')

    expect(match.name).toBe('project-overview')
    expect(match.meta.scope).toBe('project')
  })

  it('resolves service detail metadata', () => {
    const match = router.resolve('/projects/mall/services/mall-backend')

    expect(match.name).toBe('service-detail')
    expect(match.meta.scope).toBe('project')
  })
})
