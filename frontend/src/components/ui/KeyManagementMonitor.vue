<template>
  <div class="key-monitoring-container">
    <!-- Monitoring Control Panel -->
    <div class="monitoring-controls">
      <div class="control-header">
        <h3>使用监控</h3>
        <div class="control-actions">
          <select
            v-model="selectedPeriod"
            class="period-select"
            @change="changePeriod"
          >
            <option value="day">今日</option>
            <option value="week">本周</option>
            <option value="month">本月</option>
          </select>
          <button
            v-if="!isMonitoring"
            class="btn btn-primary"
            @click="startMonitoring"
          >
            <span class="icon">▶️</span>
            启动监控
          </button>
          <button
            v-else
            class="btn btn-secondary"
            @click="stopMonitoring"
          >
            <span class="icon">⏸️</span>
            停止监控
          </button>
        </div>
      </div>
      <div v-if="isMonitoring" class="monitoring-status">
        <span class="status-indicator">🟢</span>
        监控中 - 最后更新: {{ monitoringData.lastUpdate }}
      </div>
    </div>

    <!-- Real-time Usage -->
    <div class="monitoring-section">
      <h4 class="section-title">实时使用情况</h4>
      <div class="usage-feed" :class="{ updating: isUpdating }">
        <div
          v-for="record in monitoringData.usage.slice(0, 8)"
          :key="record.id"
          class="usage-record"
        >
          <span class="usage-time">{{ record.timestamp }}</span>
          <span class="usage-member">{{ record.member }}</span>
          <span class="usage-text">使用</span>
          <span class="usage-model" :class="getModelClass(record.model)">
            {{ record.model }}
          </span>
          <span class="usage-text">消耗</span>
          <span class="usage-tokens">{{ formatTokens(record.tokens) }} tokens</span>
        </div>
        <div v-if="monitoringData.usage.length === 0" class="no-data">
          暂无使用记录
        </div>
      </div>
    </div>

    <!-- Top Members -->
    <div class="monitoring-section">
      <h4 class="section-title">Top活跃成员</h4>
      <div class="top-members">
        <div
          v-for="member in monitoringData.topMembers.slice(0, 5)"
          :key="member.name"
          class="top-member"
        >
          <span class="member-rank">{{ member.rank }}.</span>
          <span class="member-name">{{ member.name }}</span>
          <span class="member-tokens">{{ formatTokens(member.tokens) }} tokens</span>
        </div>
        <div v-if="monitoringData.topMembers.length === 0" class="no-data">
          暂无数据
        </div>
      </div>
    </div>

    <!-- Alerts -->
    <div class="monitoring-section">
      <h4 class="section-title">
        异常告警
        <span v-if="monitoringData.alerts.length > 0" class="alert-count">
          {{ monitoringData.alerts.length }}
        </span>
      </h4>
      <div class="alerts-container">
        <div
          v-for="alert in monitoringData.alerts.slice(0, 5)"
          :key="alert.id"
          class="alert-item"
          :class="alert.type"
        >
          <div class="alert-header">
            <span class="alert-icon">{{ getAlertIcon(alert.type) }}</span>
            <span class="alert-title">{{ alert.title }}</span>
            <span class="alert-time">{{ alert.timestamp }}</span>
          </div>
          <div class="alert-message">{{ alert.message }}</div>
        </div>
        <div v-if="monitoringData.alerts.length === 0" class="no-alerts">
          <span class="icon">✅</span>
          暂无告警
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
      <button
        class="action-btn export-btn"
        @click="exportUsageReport"
        :disabled="!isMonitoring"
      >
        <span class="action-icon">📊</span>
        <span class="action-text">导出使用报告</span>
      </button>
      <button
        class="action-btn guide-btn"
        @click="generateMemberGuide"
        :disabled="!isMonitoring"
      >
        <span class="action-icon">📖</span>
        <span class="action-text">生成成员指南</span>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { useKeyMonitoring } from '../../composables/useKeyMonitoring'

// Props
interface Props {
  autoStart?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  autoStart: false
})

// Monitoring composable
const {
  isMonitoring,
  monitoringData,
  startMonitoring,
  stopMonitoring,
  exportUsageReport,
  generateMemberGuide,
  formatTokens,
  getAlertColor
} = useKeyMonitoring()

// Local state
const selectedPeriod = ref('month')
const isUpdating = ref(false)

// Model class mapping
const getModelClass = (model: string) => {
  const modelClasses = {
    'GPT-4': 'model-gpt4',
    'Claude-3': 'model-claude',
    'GPT-3.5': 'model-gpt35',
    '文心一言': 'model-wenxin'
  }
  return modelClasses[model] || 'model-default'
}

// Alert icon mapping
const getAlertIcon = (type: string) => {
  const icons = {
    warning: '⚠️',
    error: '🚨',
    info: '💡'
  }
  return icons[type] || '💡'
}

// Period change handler
const changePeriod = () => {
  console.log('监控时间段切换为:', selectedPeriod.value)
  // In a real app, this would trigger data refresh for the selected period
}

// Visual update indicator
watch(
  () => monitoringData.value.usage.length,
  () => {
    isUpdating.value = true
    setTimeout(() => {
      isUpdating.value = false
    }, 500)
  }
)

// Auto-start monitoring if enabled
if (props.autoStart) {
  startMonitoring()
}
</script>

<style scoped>
.key-monitoring-container {
  background: white;
  border-radius: 12px;
  border: 1px solid #E5E7EB;
  padding: 24px;
  margin: 20px 0;
}

.monitoring-controls {
  margin-bottom: 24px;
}

.control-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.control-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #111827;
}

.control-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.period-select {
  border: 1px solid #D1D5DB;
  padding: 8px 12px;
  border-radius: 8px;
  font-size: 14px;
  background: white;
}

.btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  border-radius: 8px;
  border: none;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
}

.btn-primary {
  background: #2563EB;
  color: white;
}

.btn-primary:hover {
  background: #1D4ED8;
}

.btn-secondary {
  background: #F3F4F6;
  color: #374151;
  border: 1px solid #D1D5DB;
}

.btn-secondary:hover {
  background: #E5E7EB;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.monitoring-status {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #059669;
  background: #ECFDF5;
  padding: 8px 12px;
  border-radius: 6px;
  border: 1px solid #A7F3D0;
}

.status-indicator {
  font-size: 8px;
}

.monitoring-section {
  margin-bottom: 24px;
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  color: #111827;
  margin: 0 0 12px 0;
  display: flex;
  align-items: center;
  gap: 8px;
}

.alert-count {
  background: #EF4444;
  color: white;
  font-size: 12px;
  padding: 2px 6px;
  border-radius: 10px;
  min-width: 20px;
  text-align: center;
}

.usage-feed {
  max-height: 200px;
  overflow-y: auto;
  background: #F9FAFB;
  border-radius: 8px;
  padding: 12px;
  transition: background-color 0.3s ease;
}

.usage-feed.updating {
  background: #FEF3F2;
}

.usage-record {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: #374151;
  margin-bottom: 8px;
  padding: 4px 0;
}

.usage-time {
  color: #111827;
  font-weight: 500;
  min-width: 50px;
}

.usage-member {
  font-weight: 500;
  min-width: 60px;
}

.usage-text {
  color: #6B7280;
}

.usage-model {
  font-weight: 600;
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 12px;
}

.model-gpt4 {
  background: #DBEAFE;
  color: #1D4ED8;
}

.model-claude {
  background: #D1FAE5;
  color: #059669;
}

.model-gpt35 {
  background: #FEF3C7;
  color: #D97706;
}

.model-wenxin {
  background: #E5E7EB;
  color: #374151;
}

.usage-tokens {
  font-weight: 500;
  color: #111827;
}

.top-members {
  background: #F9FAFB;
  border-radius: 8px;
  padding: 12px;
}

.top-member {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 14px;
  margin-bottom: 8px;
  padding: 4px 0;
}

.member-rank {
  font-weight: 600;
  color: #6B7280;
  min-width: 20px;
}

.member-name {
  flex: 1;
  font-weight: 500;
  color: #111827;
}

.member-tokens {
  color: #6B7280;
  font-size: 13px;
}

.alerts-container {
  space-y: 8px;
}

.alert-item {
  background: #F9FAFB;
  border-left: 4px solid #D1D5DB;
  border-radius: 8px;
  padding: 12px;
  margin-bottom: 8px;
}

.alert-item.warning {
  background: #FFFBEB;
  border-left-color: #F59E0B;
}

.alert-item.error {
  background: #FEF2F2;
  border-left-color: #EF4444;
}

.alert-item.info {
  background: #EFF6FF;
  border-left-color: #3B82F6;
}

.alert-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}

.alert-icon {
  font-size: 14px;
}

.alert-title {
  font-weight: 600;
  color: #111827;
  flex: 1;
}

.alert-time {
  font-size: 12px;
  color: #6B7280;
}

.alert-message {
  font-size: 13px;
  color: #374151;
  line-height: 1.5;
}

.no-data, .no-alerts {
  text-align: center;
  color: #6B7280;
  font-size: 14px;
  padding: 20px;
}

.no-alerts {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  background: #F0FDF4;
  border: 1px solid #BBF7D0;
  border-radius: 8px;
  color: #059669;
}

.quick-actions {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
  margin-top: 24px;
  padding-top: 24px;
  border-top: 1px solid #E5E7EB;
}

.action-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 16px;
  border: 1px solid #D1D5DB;
  border-radius: 12px;
  background: white;
  cursor: pointer;
  transition: all 0.2s ease;
  text-decoration: none;
  color: #374151;
  gap: 8px;
}

.action-btn:hover:not(:disabled) {
  border-color: #2563EB;
  background: #F8FAFC;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.action-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.action-icon {
  font-size: 20px;
}

.action-text {
  font-size: 13px;
  font-weight: 500;
}

/* Responsive design */
@media (max-width: 768px) {
  .key-monitoring-container {
    padding: 16px;
    margin: 16px 0;
  }

  .control-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }

  .control-actions {
    width: 100%;
    justify-content: space-between;
  }

  .quick-actions {
    grid-template-columns: 1fr;
  }
}
</style>