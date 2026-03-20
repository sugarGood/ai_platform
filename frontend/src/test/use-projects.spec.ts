import { afterEach, describe, expect, it, vi } from 'vitest'

const backendList = [
  {
    id: 101,
    name: '支付网关',
    code: 'PAYMENT_GATEWAY',
    projectType: 'TECH_PLATFORM',
    branchStrategy: 'TRUNK_BASED',
    status: 'ACTIVE',
  },
] as const

afterEach(() => {
  vi.restoreAllMocks()
  vi.unstubAllGlobals()
  vi.resetModules()
})

describe('useProjects', () => {
  it('loads projects from backend api', async () => {
    vi.stubGlobal(
      'fetch',
      vi.fn().mockResolvedValue(
        new Response(JSON.stringify(backendList), {
          status: 200,
          headers: { 'Content-Type': 'application/json' },
        }),
      ),
    )

    const { useProjects } = await import('../composables/useProjects')
    const { loadProjects, projectState, projectSummaries } = useProjects()

    await loadProjects(true)

    expect(projectState.loadedFromApi).toBe(true)
    expect(projectSummaries.value).toHaveLength(1)
    expect(projectSummaries.value[0]?.id).toBe('101')
    expect(projectSummaries.value[0]?.name).toBe('支付网关')
  })

  it('creates project then refreshes list', async () => {
    const fetchMock = vi.fn()
    fetchMock
      .mockResolvedValueOnce(
        new Response(JSON.stringify(backendList), {
          status: 200,
          headers: { 'Content-Type': 'application/json' },
        }),
      )
      .mockResolvedValueOnce(
        new Response(
          JSON.stringify({
            id: 202,
            name: '用户中心',
            code: 'USER_CENTER',
            projectType: 'INTERNAL_SYSTEM',
            branchStrategy: 'GIT_FLOW',
            status: 'ACTIVE',
          }),
          {
            status: 201,
            headers: { 'Content-Type': 'application/json' },
          },
        ),
      )
      .mockResolvedValueOnce(
        new Response(
          JSON.stringify([
            ...backendList,
            {
              id: 202,
              name: '用户中心',
              code: 'USER_CENTER',
              projectType: 'INTERNAL_SYSTEM',
              branchStrategy: 'GIT_FLOW',
              status: 'ACTIVE',
            },
          ]),
          {
            status: 200,
            headers: { 'Content-Type': 'application/json' },
          },
        ),
      )

    vi.stubGlobal('fetch', fetchMock)

    const { createProject, useProjects } = await import('../composables/useProjects')
    const { loadProjects, projectSummaries } = useProjects()

    await loadProjects(true)
    await createProject({
      name: '用户中心',
      code: 'USER_CENTER',
      projectType: 'INTERNAL_SYSTEM',
      branchStrategy: 'GIT_FLOW',
    })

    expect(fetchMock).toHaveBeenCalledTimes(3)
    expect(projectSummaries.value.map((project) => project.id)).toEqual(['101', '202'])
  })
})
