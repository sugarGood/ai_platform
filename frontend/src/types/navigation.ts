export type RouteScope = 'global' | 'project'

export interface NavItem {
  key: string
  label: string
  icon: string
  to: string
  badge?: string
}

export interface NavGroup {
  label: string
  items: NavItem[]
}

export interface PlaceholderContent {
  title: string
  description: string
  highlights: string[]
}
