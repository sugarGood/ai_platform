import type {
  BackendProjectAiKeyUsageResponse,
  BackendProjectMemberResponse,
  BackendProjectResponse,
  BackendProjectServiceResponse,
  CreateBackendProjectPayload,
} from '../types/project'

const rawApiBaseUrl = (import.meta.env.VITE_API_BASE_URL?.trim() || '/api').replace(/\/$/, '')

function buildApiUrl(path: string) {
  if (/^https?:\/\//.test(rawApiBaseUrl)) {
    return `${rawApiBaseUrl}${path}`
  }

  return `${rawApiBaseUrl}${path}`
}

async function readErrorMessage(response: Response) {
  const contentType = response.headers.get('content-type') || ''

  if (contentType.includes('application/json')) {
    try {
      const body = (await response.json()) as Record<string, unknown>
      const message = typeof body.message === 'string' ? body.message : undefined
      const error = typeof body.error === 'string' ? body.error : undefined
      const details = Array.isArray(body.errors) ? body.errors.join('；') : undefined

      return message || error || details || `请求失败：${response.status}`
    } catch {
      return `请求失败：${response.status}`
    }
  }

  const text = await response.text()
  return text.trim() || `请求失败：${response.status}`
}

async function requestJson<T>(path: string, init: RequestInit = {}) {
  const response = await fetch(buildApiUrl(path), {
    ...init,
    headers: {
      Accept: 'application/json',
      ...(init.body ? { 'Content-Type': 'application/json' } : {}),
      ...init.headers,
    },
  })

  if (!response.ok) {
    throw new Error(await readErrorMessage(response))
  }

  return (await response.json()) as T
}

export function listProjects() {
  return requestJson<BackendProjectResponse[]>('/projects')
}

export function createProject(payload: CreateBackendProjectPayload) {
  return requestJson<BackendProjectResponse>('/projects', {
    method: 'POST',
    body: JSON.stringify(payload),
  })
}

export function listProjectMembers(projectId: number) {
  return requestJson<BackendProjectMemberResponse[]>(`/projects/${projectId}/members`)
}

export function listProjectServices(projectId: number) {
  return requestJson<BackendProjectServiceResponse[]>(`/projects/${projectId}/services`)
}

export function getProjectAiKeyUsage(projectId: number) {
  return requestJson<BackendProjectAiKeyUsageResponse>(`/projects/${projectId}/ai-keys/usage`)
}
