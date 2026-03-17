export interface DashboardMetric {
  id: string
  icon: string
  label: string
  value: string
  delta: string
  tone?: 'primary' | 'danger' | 'success' | 'default'
}

export interface TokenTrendPoint {
  label: string
  value: number
}

export interface DepartmentUsage {
  id: string
  name: string
  usage: string
  progress: number
  tone?: 'default' | 'warning'
}

export interface Incident {
  id: string
  title: string
  meta: string
  severity: 'critical' | 'warning' | 'info'
  severityLabel: string
}

export interface ActivityEvent {
  id: string
  time: string
  content: string
}
