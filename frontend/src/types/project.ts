import type { ActivityEvent, Incident } from './dashboard'

export type ProjectStatusTone = 'success' | 'warning'

export interface ProjectSummary {
  id: string
  name: string
  icon: string
  typeLabel: string
  description: string
  statusLabel: string
  statusTone: ProjectStatusTone
  sprintLabel: string
  tokenLabel: string
  serviceCount: number
  memberCount: number
  members: string[]
}

export interface ProjectServiceHealth {
  id: string
  name: string
  techStack: string
  statusLabel: string
  statusTone: 'success' | 'primary' | 'warning'
  deployMeta: string
}

export interface ProjectDetail extends ProjectSummary {
  currentSprint: string
  sprintProgress: string
  incidentsSummary: string
  monthlyTokenDelta: string
  services: ProjectServiceHealth[]
  activities: ActivityEvent[]
  incidents: Incident[]
}

export type BackendProjectType = 'PRODUCT' | 'INTERNAL_SYSTEM' | 'TECH_PLATFORM' | 'DATA_PRODUCT'

export type BackendBranchStrategy = 'GIT_FLOW' | 'TRUNK_BASED' | 'FEATURE_BRANCH'

export interface BackendProjectResponse {
  id: number
  name: string
  code: string
  projectType: BackendProjectType
  branchStrategy: BackendBranchStrategy
  status: string
}

export interface BackendProjectMemberResponse {
  id: number
  projectId: number
  name: string
  email: string
  role: string
  status: string
}

export interface BackendProjectServiceResponse {
  id: number
  projectId: number
  name: string
  serviceType: string
  defaultBranch: string
  status: string
}

export interface BackendProjectAiKeyUsageResponse {
  projectId: number
  provider: string
  totalMonthlyQuota: number
  totalUsedQuota: number
  remainingQuota: number
  usageRatePercent: number
  activeKeyCount: number
  disabledKeyCount: number
  alertingKeyCount: number
  exhaustedKeyCount: number
}

export interface CreateBackendProjectPayload {
  name: string
  code: string
  projectType: BackendProjectType
  branchStrategy: BackendBranchStrategy
}
