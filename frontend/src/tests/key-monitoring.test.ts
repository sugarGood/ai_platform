/**
 * Comprehensive test suite for Key Management Monitoring System
 * Tests all the core functions mentioned in requirements
 */

import { describe, it, expect, beforeEach, afterEach, vi } from 'vitest'
import { useKeyMonitoring } from '../composables/useKeyMonitoring'

// Mock DOM API for file downloads
Object.defineProperty(window, 'URL', {
  value: {
    createObjectURL: vi.fn(() => 'mock-url'),
    revokeObjectURL: vi.fn(),
  },
})

// Mock document.createElement and DOM manipulation
Object.defineProperty(document, 'createElement', {
  value: vi.fn((tagName) => {
    const element = {
      tagName,
      href: '',
      download: '',
      click: vi.fn(),
      appendChild: vi.fn(),
      removeChild: vi.fn(),
    }
    return element
  }),
})

Object.defineProperty(document, 'body', {
  value: {
    appendChild: vi.fn(),
    removeChild: vi.fn(),
  },
})

describe('Key Monitoring System', () => {
  let monitoring: ReturnType<typeof useKeyMonitoring>

  beforeEach(() => {
    monitoring = useKeyMonitoring()
    vi.clearAllMocks()
  })

  afterEach(() => {
    if (monitoring.isMonitoring.value) {
      monitoring.stopMonitoring()
    }
  })

  describe('Core Monitoring Functions', () => {
    it('should implement updateUsageMonitoring function', () => {
      expect(monitoring.updateUsageMonitoring).toBeDefined()
      expect(typeof monitoring.updateUsageMonitoring).toBe('function')

      // Test usage monitoring updates
      monitoring.updateUsageMonitoring()
      expect(monitoring.monitoringData.value.usage.length).toBeGreaterThan(0)
      expect(monitoring.monitoringData.value.lastUpdate).toBeTruthy()
    })

    it('should implement updateTopMembers function', () => {
      expect(monitoring.updateTopMembers).toBeDefined()
      expect(typeof monitoring.updateTopMembers).toBe('function')

      // Test top members update
      monitoring.updateTopMembers()
      expect(monitoring.monitoringData.value.topMembers.length).toBeGreaterThan(0)

      // Verify ranking is correct
      const topMembers = monitoring.monitoringData.value.topMembers
      for (let i = 0; i < topMembers.length - 1; i++) {
        expect(topMembers[i].tokens).toBeGreaterThanOrEqual(topMembers[i + 1].tokens)
      }
    })

    it('should implement updateAlerts function', () => {
      expect(monitoring.updateAlerts).toBeDefined()
      expect(typeof monitoring.updateAlerts).toBe('function')

      // Test alerts update
      monitoring.updateAlerts()

      // Verify alert structure if any alerts exist
      const alerts = monitoring.monitoringData.value.alerts
      alerts.forEach(alert => {
        expect(alert).toHaveProperty('id')
        expect(alert).toHaveProperty('type')
        expect(alert).toHaveProperty('title')
        expect(alert).toHaveProperty('message')
        expect(alert).toHaveProperty('timestamp')
        expect(['warning', 'error', 'info']).toContain(alert.type)
      })
    })
  })

  describe('Monitoring Lifecycle', () => {
    it('should implement startMonitoring function', () => {
      expect(monitoring.startMonitoring).toBeDefined()
      expect(typeof monitoring.startMonitoring).toBe('function')

      // Initially not monitoring
      expect(monitoring.isMonitoring.value).toBe(false)

      // Start monitoring
      monitoring.startMonitoring()
      expect(monitoring.isMonitoring.value).toBe(true)

      // Should have initial data
      expect(monitoring.monitoringData.value.usage.length).toBeGreaterThan(0)
      expect(monitoring.monitoringData.value.topMembers.length).toBeGreaterThan(0)
      expect(monitoring.monitoringData.value.lastUpdate).toBeTruthy()
    })

    it('should implement stopMonitoring function', () => {
      expect(monitoring.stopMonitoring).toBeDefined()
      expect(typeof monitoring.stopMonitoring).toBe('function')

      // Start then stop monitoring
      monitoring.startMonitoring()
      expect(monitoring.isMonitoring.value).toBe(true)

      monitoring.stopMonitoring()
      expect(monitoring.isMonitoring.value).toBe(false)
    })

    it('should handle 30-second interval updates', async () => {
      vi.useFakeTimers()

      monitoring.startMonitoring()
      const initialUsageCount = monitoring.monitoringData.value.usage.length

      // Fast-forward 30 seconds
      vi.advanceTimersByTime(30000)

      // Should have new usage data
      expect(monitoring.monitoringData.value.usage.length).toBeGreaterThan(initialUsageCount)

      vi.useRealTimers()
    })
  })

  describe('Export and Guide Functions', () => {
    it('should implement exportUsageReport function', async () => {
      expect(monitoring.exportUsageReport).toBeDefined()
      expect(typeof monitoring.exportUsageReport).toBe('function')

      // Mock window.alert to prevent actual alerts in tests
      const mockAlert = vi.fn()
      global.alert = mockAlert

      await monitoring.exportUsageReport()

      // Verify file download was triggered
      expect(document.createElement).toHaveBeenCalledWith('a')
      expect(mockAlert).toHaveBeenCalledWith(expect.stringContaining('使用报告已导出'))
    })

    it('should implement generateMemberGuide function', async () => {
      expect(monitoring.generateMemberGuide).toBeDefined()
      expect(typeof monitoring.generateMemberGuide).toBe('function')

      // Mock window.alert to prevent actual alerts in tests
      const mockAlert = vi.fn()
      global.alert = mockAlert

      await monitoring.generateMemberGuide()

      // Verify guide generation was triggered
      expect(document.createElement).toHaveBeenCalledWith('a')
      expect(mockAlert).toHaveBeenCalledWith(expect.stringContaining('成员使用指南已生成'))
    })
  })

  describe('Utility Functions', () => {
    it('should implement formatTokens function', () => {
      expect(monitoring.formatTokens).toBeDefined()
      expect(typeof monitoring.formatTokens).toBe('function')

      // Test different token amounts
      expect(monitoring.formatTokens(500)).toBe('500')
      expect(monitoring.formatTokens(1500)).toBe('1K')
      expect(monitoring.formatTokens(1500000)).toBe('1.5M')
    })

    it('should implement getAlertColor function', () => {
      expect(monitoring.getAlertColor).toBeDefined()
      expect(typeof monitoring.getAlertColor).toBe('function')

      // Test different alert types
      expect(monitoring.getAlertColor('warning')).toBe('#F79009')
      expect(monitoring.getAlertColor('error')).toBe('#F04438')
      expect(monitoring.getAlertColor('info')).toBe('#175CD3')
    })
  })

  describe('Data Validation', () => {
    it('should generate valid usage records', () => {
      monitoring.updateUsageMonitoring()
      const usage = monitoring.monitoringData.value.usage[0]

      expect(usage).toHaveProperty('id')
      expect(usage).toHaveProperty('timestamp')
      expect(usage).toHaveProperty('member')
      expect(usage).toHaveProperty('model')
      expect(usage).toHaveProperty('tokens')
      expect(typeof usage.tokens).toBe('number')
      expect(usage.tokens).toBeGreaterThan(0)
    })

    it('should maintain proper member ranking', () => {
      monitoring.updateTopMembers()
      const members = monitoring.monitoringData.value.topMembers

      // Should be sorted by tokens (descending)
      for (let i = 0; i < members.length - 1; i++) {
        expect(members[i].tokens).toBeGreaterThanOrEqual(members[i + 1].tokens)
        expect(members[i].rank).toBe(i + 1)
      }
    })

    it('should limit data size appropriately', () => {
      // Generate lots of usage records
      for (let i = 0; i < 30; i++) {
        monitoring.updateUsageMonitoring()
      }

      // Should not exceed limit
      expect(monitoring.monitoringData.value.usage.length).toBeLessThanOrEqual(20)

      // Generate lots of alerts
      for (let i = 0; i < 15; i++) {
        monitoring.updateAlerts()
      }

      // Should not exceed limit
      expect(monitoring.monitoringData.value.alerts.length).toBeLessThanOrEqual(10)
    })
  })

  describe('Error Handling', () => {
    it('should handle multiple start calls gracefully', () => {
      monitoring.startMonitoring()
      monitoring.startMonitoring() // Should not cause issues

      expect(monitoring.isMonitoring.value).toBe(true)
    })

    it('should handle multiple stop calls gracefully', () => {
      monitoring.startMonitoring()
      monitoring.stopMonitoring()
      monitoring.stopMonitoring() // Should not cause issues

      expect(monitoring.isMonitoring.value).toBe(false)
    })

    it('should handle component unmount cleanup', () => {
      monitoring.startMonitoring()
      expect(monitoring.isMonitoring.value).toBe(true)

      // Simulate component unmount
      monitoring.stopMonitoring()
      expect(monitoring.isMonitoring.value).toBe(false)
    })
  })
})

describe('Page Navigation Integration', () => {
  it('should have showProjectPage integration ready', async () => {
    // This test verifies the integration points mentioned in requirements
    const { initGlobalPageNavigation } = await import('../composables/usePageNavigation')

    expect(initGlobalPageNavigation).toBeDefined()
    expect(typeof initGlobalPageNavigation).toBe('function')

    // Should return navigation functions
    const navigation = initGlobalPageNavigation()
    expect(navigation.showProjectPage).toBeDefined()
    expect(navigation.showPage).toBeDefined()
  })
})

// Integration test for complete monitoring workflow
describe('Complete Monitoring Workflow', () => {
  it('should complete a full monitoring cycle', async () => {
    const monitoring = useKeyMonitoring()

    // 1. Start monitoring
    monitoring.startMonitoring()
    expect(monitoring.isMonitoring.value).toBe(true)

    // 2. Update all monitoring data
    monitoring.updateUsageMonitoring()
    monitoring.updateTopMembers()
    monitoring.updateAlerts()

    // 3. Verify data is populated
    expect(monitoring.monitoringData.value.usage.length).toBeGreaterThan(0)
    expect(monitoring.monitoringData.value.topMembers.length).toBeGreaterThan(0)
    expect(monitoring.monitoringData.value.lastUpdate).toBeTruthy()

    // 4. Test export functions
    const mockAlert = vi.fn()
    global.alert = mockAlert

    await monitoring.exportUsageReport()
    await monitoring.generateMemberGuide()

    expect(mockAlert).toHaveBeenCalledTimes(2)

    // 5. Stop monitoring
    monitoring.stopMonitoring()
    expect(monitoring.isMonitoring.value).toBe(false)
  })
})