import { ref, onUnmounted } from 'vue'

// Mock data interface for monitoring
interface UsageRecord {
  id: string
  timestamp: string
  member: string
  model: string
  tokens: number
}

interface TopMember {
  name: string
  tokens: number
  rank: number
}

interface Alert {
  id: string
  type: 'warning' | 'error' | 'info'
  title: string
  message: string
  member?: string
  timestamp: string
}

interface MonitoringData {
  usage: UsageRecord[]
  topMembers: TopMember[]
  alerts: Alert[]
  lastUpdate: string
}

export function useKeyMonitoring() {
  const isMonitoring = ref(false)
  const monitoringData = ref<MonitoringData>({
    usage: [],
    topMembers: [],
    alerts: [],
    lastUpdate: ''
  })

  let monitoringInterval: NodeJS.Timeout | null = null

  // Mock data generators
  const generateMockUsageRecord = (): UsageRecord => {
    const members = ['张三', '李四', '王五', '赵六']
    const models = ['GPT-4', 'Claude-3', 'GPT-3.5', '文心一言']
    const tokens = Math.floor(Math.random() * 5000) + 500

    return {
      id: Date.now().toString() + Math.random(),
      timestamp: new Date().toLocaleTimeString('zh-CN', {
        hour12: false,
        hour: '2-digit',
        minute: '2-digit'
      }),
      member: members[Math.floor(Math.random() * members.length)],
      model: models[Math.floor(Math.random() * models.length)],
      tokens
    }
  }

  const generateMockTopMembers = (): TopMember[] => {
    return [
      { name: '张三', tokens: 892000, rank: 1 },
      { name: '王五', tokens: 856000, rank: 2 },
      { name: '李四', tokens: 654000, rank: 3 },
      { name: '赵六', tokens: 342000, rank: 4 }
    ].sort((a, b) => b.tokens - a.tokens)
      .map((member, index) => ({ ...member, rank: index + 1 }))
  }

  const generateMockAlerts = (): Alert[] => {
    const alerts: Alert[] = []

    // Random quota warning
    if (Math.random() > 0.7) {
      alerts.push({
        id: 'quota-warning-' + Date.now(),
        type: 'warning',
        title: '配额预警',
        message: '王五本月使用量已超额7%，建议调整配额或优化使用',
        member: '王五',
        timestamp: new Date().toLocaleTimeString('zh-CN')
      })
    }

    // Random usage optimization suggestion
    if (Math.random() > 0.6) {
      alerts.push({
        id: 'optimization-' + Date.now(),
        type: 'info',
        title: '优化建议',
        message: '项目整体使用率68%，可考虑为新成员分配剩余配额',
        timestamp: new Date().toLocaleTimeString('zh-CN')
      })
    }

    // Random error alert
    if (Math.random() > 0.9) {
      alerts.push({
        id: 'error-' + Date.now(),
        type: 'error',
        title: 'API 调用异常',
        message: 'GPT-4 接口出现频繁超时，建议检查网络连接',
        timestamp: new Date().toLocaleTimeString('zh-CN')
      })
    }

    return alerts
  }

  // Core monitoring functions
  const updateUsageMonitoring = () => {
    // Add new usage record
    const newRecord = generateMockUsageRecord()
    monitoringData.value.usage.unshift(newRecord)

    // Keep only last 20 records
    if (monitoringData.value.usage.length > 20) {
      monitoringData.value.usage = monitoringData.value.usage.slice(0, 20)
    }

    monitoringData.value.lastUpdate = new Date().toLocaleTimeString('zh-CN')

    console.log('实时使用数据已更新:', newRecord)
  }

  const updateTopMembers = () => {
    // Simulate member usage changes
    monitoringData.value.topMembers = generateMockTopMembers()
    console.log('Top成员排行已更新')
  }

  const updateAlerts = () => {
    // Generate new alerts and remove old ones
    const newAlerts = generateMockAlerts()

    // Remove alerts older than 30 minutes
    const thirtyMinsAgo = new Date(Date.now() - 30 * 60 * 1000)
    const existingAlerts = monitoringData.value.alerts.filter(alert =>
      new Date(alert.timestamp) > thirtyMinsAgo
    )

    monitoringData.value.alerts = [...newAlerts, ...existingAlerts].slice(0, 10)
    console.log('异常告警已更新，当前告警数:', monitoringData.value.alerts.length)
  }

  const startMonitoring = () => {
    if (isMonitoring.value) {
      console.log('监控已在运行中')
      return
    }

    console.log('启动Key使用监控系统...')
    isMonitoring.value = true

    // Initialize with mock data
    updateUsageMonitoring()
    updateTopMembers()
    updateAlerts()

    // Set up 30-second interval
    monitoringInterval = setInterval(() => {
      if (isMonitoring.value) {
        updateUsageMonitoring()

        // Update top members every 2 minutes
        if (Math.random() > 0.5) {
          updateTopMembers()
        }

        // Update alerts every minute
        if (Math.random() > 0.3) {
          updateAlerts()
        }
      }
    }, 30000) // 30 seconds interval

    console.log('监控系统已启动，30秒间隔刷新')
  }

  const stopMonitoring = () => {
    if (!isMonitoring.value) {
      console.log('监控未在运行中')
      return
    }

    console.log('停止Key使用监控系统...')
    isMonitoring.value = false

    if (monitoringInterval) {
      clearInterval(monitoringInterval)
      monitoringInterval = null
    }

    console.log('监控系统已停止')
  }

  // Export and guide functions
  const exportUsageReport = async () => {
    console.log('导出使用报告...')

    const reportData = {
      项目名称: '商城系统',
      报告时间: new Date().toLocaleString('zh-CN'),
      统计周期: '近30天',
      总使用量: '2.4M tokens',
      活跃成员: monitoringData.value.topMembers.length,
      异常告警: monitoringData.value.alerts.length,
      详细数据: {
        成员使用排行: monitoringData.value.topMembers,
        最近使用记录: monitoringData.value.usage.slice(0, 10),
        当前告警: monitoringData.value.alerts
      }
    }

    // Simulate file download
    const blob = new Blob([JSON.stringify(reportData, null, 2)], {
      type: 'application/json'
    })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `key-usage-report-${new Date().toISOString().split('T')[0]}.json`
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)

    console.log('使用报告导出完成')
    alert('使用报告已导出到下载目录')
  }

  const generateMemberGuide = async () => {
    console.log('生成成员使用指南...')

    const guideContent = `
# Key 使用指南

## 项目概述
项目名称：商城系统
更新时间：${new Date().toLocaleString('zh-CN')}

## 可用模型
- **GPT-4**: 适用于复杂代码生成和分析
- **Claude-3**: 适合文档编写和代码审查
- **GPT-3.5**: 轻量级任务和快速响应
- **文心一言**: 中文场景优化

## 成员配额
${monitoringData.value.topMembers.map(member =>
  `- ${member.name}: ${member.tokens.toLocaleString()} tokens/月`
).join('\n')}

## 使用建议
1. 优先使用 GPT-3.5 处理简单任务，节约配额
2. 复杂代码生成使用 GPT-4 或 Claude-3
3. 中文相关任务推荐使用文心一言
4. 注意监控个人使用量，避免超额

## 最佳实践
- 使用明确的提示词，提高回复质量
- 避免重复相同请求，浪费配额
- 定期查看使用统计和告警信息

## 联系支持
如有问题请联系项目管理员或访问内部文档。
`

    // Simulate guide generation
    const blob = new Blob([guideContent], { type: 'text/markdown' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `member-guide-${new Date().toISOString().split('T')[0]}.md`
    document.body.appendChild(a)
    a.click()
    document.body.removeChild(a)
    URL.revokeObjectURL(url)

    console.log('成员使用指南生成完成')
    alert('成员使用指南已生成并下载')
  }

  // Format functions for display
  const formatTokens = (amount: number): string => {
    if (amount >= 1000000) {
      return Math.floor(amount / 1000000 * 10) / 10 + 'M'
    } else if (amount >= 1000) {
      return Math.floor(amount / 1000) + 'K'
    }
    return amount.toString()
  }

  const getAlertColor = (type: Alert['type']) => {
    const colors = {
      warning: '#F79009',
      error: '#F04438',
      info: '#175CD3'
    }
    return colors[type] || colors.info
  }

  // Cleanup on component unmount
  onUnmounted(() => {
    stopMonitoring()
  })

  return {
    // State
    isMonitoring,
    monitoringData,

    // Core functions
    updateUsageMonitoring,
    updateTopMembers,
    updateAlerts,
    startMonitoring,
    stopMonitoring,

    // Export functions
    exportUsageReport,
    generateMemberGuide,

    // Utilities
    formatTokens,
    getAlertColor
  }
}