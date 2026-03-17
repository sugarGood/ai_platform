export type Tone = 'default' | 'primary' | 'success' | 'warning' | 'danger' | 'muted'

export interface PageAction {
  label: string
  variant?: 'primary' | 'secondary'
}

export interface PageMetric {
  id: string
  icon: string
  label: string
  value: string
  delta: string
  tone?: 'default' | 'primary' | 'success' | 'warning' | 'danger'
}

export interface InfoLine {
  label: string
  value: string
  tone?: Tone
  mono?: boolean
}

export interface ListItem {
  title: string
  meta?: string
  description?: string
  badge?: string
  tone?: Tone
  progress?: number
}

export interface CatalogItem {
  title: string
  subtitle?: string
  icon?: string
  badge?: string
  tone?: Tone
  lines?: InfoLine[]
  description?: string
  cta?: string
  to?: string
}

export interface NoteItem {
  label?: string
  content: string
  tone?: Tone
}

export interface ProgressItem {
  label: string
  value: string
  progress: number
  tone?: Tone
  hint?: string
}

export interface TableCell {
  text: string
  tone?: Tone
  mono?: boolean
}

export interface TableData {
  columns: string[]
  rows: TableCell[][]
}

export interface KanbanColumn {
  title: string
  badge?: string
  tone?: Tone
  items: ListItem[]
}

export type ModuleSection =
  | {
      type: 'hero'
      eyebrow?: string
      title?: string
      description: string
      actions?: PageAction[]
    }
  | {
      type: 'metrics'
      items: PageMetric[]
    }
  | {
      type: 'list-grid'
      columns?: 1 | 2 | 3
      cards: {
        title: string
        badge?: string
        items: ListItem[]
        note?: NoteItem
      }[]
    }
  | {
      type: 'catalog-grid'
      columns?: 1 | 2 | 3
      title?: string
      items: CatalogItem[]
    }
  | {
      type: 'table'
      title: string
      badge?: string
      table: TableData
      note?: string
    }
  | {
      type: 'progress'
      title: string
      badge?: string
      items: ProgressItem[]
      note?: NoteItem
    }
  | {
      type: 'notes'
      title: string
      badge?: string
      notes: NoteItem[]
    }
  | {
      type: 'code'
      title: string
      badge?: string
      description?: string
      code: string
      actions?: PageAction[]
    }
  | {
      type: 'kanban'
      title: string
      columns: KanbanColumn[]
    }
  | {
      type: 'split'
      columns?: 2 | 3
      items: Array<{
        title: string
        badge?: string
        lines?: InfoLine[]
        notes?: NoteItem[]
        list?: ListItem[]
        code?: string
        actions?: PageAction[]
      }>
    }

export interface ModulePageConfig {
  sections: ModuleSection[]
}
