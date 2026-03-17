import type { ActivityEvent, Incident } from './dashboard'

export interface ProjectSummary {
  id: string
  name: string
  icon: string
  typeLabel: string
  description: string
  statusLabel: string
  statusTone: 'success' | 'warning'
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
