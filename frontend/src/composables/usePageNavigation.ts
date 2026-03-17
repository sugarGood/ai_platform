/**
 * Page navigation utilities for Vue frontend compatibility with HTML prototype
 * This provides the showProjectPage() integration mentioned in requirements
 */

import { useRouter } from 'vue-router'
import { useKeyMonitoring } from './useKeyMonitoring'

export function usePageNavigation() {
  const router = useRouter()
  const { startMonitoring, stopMonitoring, isMonitoring } = useKeyMonitoring()

  /**
   * Enhanced showProjectPage function that integrates monitoring lifecycle
   * This is the main function mentioned in requirements for showProjectPage() integration
   */
  const showProjectPage = (projectId: string, section: string) => {
    console.log(`导航到项目页面: ${projectId}/${section}`)

    // Stop any existing monitoring
    if (isMonitoring.value) {
      console.log('页面切换前停止现有监控')
      stopMonitoring()
    }

    // Navigate to the project page
    router.push(`/projects/${projectId}/${section}`)

    // Auto-start monitoring for key management pages
    if (section === 'keymanagement') {
      console.log('检测到Key管理页面，准备启动监控系统')
      setTimeout(() => {
        startMonitoring()
      }, 1500) // Delay to ensure page is fully loaded
    }
  }

  /**
   * Enhanced page switching that maintains monitoring state
   */
  const switchToKeyManagement = (projectId: string) => {
    showProjectPage(projectId, 'keymanagement')
  }

  /**
   * Navigate away from key management with proper cleanup
   */
  const exitKeyManagement = (projectId: string, targetSection = 'overview') => {
    console.log('离开Key管理页面，执行清理操作')
    if (isMonitoring.value) {
      stopMonitoring()
    }
    showProjectPage(projectId, targetSection)
  }

  /**
   * Global navigation compatibility for HTML prototype integration
   */
  const showPage = (pageId: string) => {
    console.log(`全局页面导航: ${pageId}`)

    // Handle key management specific pages
    if (pageId === 'keymanagement' || pageId.includes('keymanagement')) {
      // Extract project ID if available, default to first project
      const projectId = 'mall-system'
      showProjectPage(projectId, 'keymanagement')
      return
    }

    // Handle other global pages
    const globalPages = {
      'dashboard': '/',
      'projects': '/projects',
      'efficiency': '/global/efficiency',
      'cicd': '/global/cicd',
      'envs': '/global/envs',
      'incidents': '/global/incidents',
      'workflows': '/global/workflows',
      'functions': '/global/functions',
      'ai-monitor': '/global/ai-monitor',
      'evals': '/global/evals',
      'atomic': '/global/atomic',
      'knowledge': '/global/knowledge',
      'skills': '/global/skills',
      'templates': '/global/templates',
      'keys': '/global/keys',
      'audit': '/global/audit',
      'settings': '/global/settings'
    }

    const targetPath = globalPages[pageId as keyof typeof globalPages] || '/'

    // Stop monitoring when navigating away from key management
    if (isMonitoring.value) {
      console.log('全局导航时停止Key监控')
      stopMonitoring()
    }

    router.push(targetPath)
  }

  /**
   * Monitoring state management utilities
   */
  const getMonitoringStatus = () => ({
    isActive: isMonitoring.value,
    canStart: !isMonitoring.value,
    canStop: isMonitoring.value
  })

  return {
    // Main navigation functions
    showProjectPage,
    switchToKeyManagement,
    exitKeyManagement,
    showPage,

    // Monitoring integration
    getMonitoringStatus,

    // Direct monitoring controls (for manual usage)
    startMonitoring,
    stopMonitoring
  }
}

// Global function for HTML prototype compatibility
// This makes showProjectPage() available globally as mentioned in requirements
export const initGlobalPageNavigation = () => {
  const { showProjectPage, showPage } = usePageNavigation()

  // Attach to window for HTML prototype compatibility
  if (typeof window !== 'undefined') {
    ;(window as any).showProjectPage = showProjectPage
    ;(window as any).showPage = showPage
    console.log('全局页面导航函数已注册')
  }

  return { showProjectPage, showPage }
}