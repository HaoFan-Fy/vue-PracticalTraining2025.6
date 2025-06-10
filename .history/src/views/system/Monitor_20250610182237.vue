<template>
  <div class="monitor-page">
    <!-- 系统概览 -->
    <el-row :gutter="20" class="overview-cards">
      <el-col :span="6">
        <el-card class="overview-card">
          <div class="card-content">
            <div class="card-icon cpu">
              <el-icon><Monitor /></el-icon>
            </div>
            <div class="card-info">
              <div class="card-title">CPU使用率</div>
              <div class="card-value">{{ systemInfo.cpuUsage }}%</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="overview-card">
          <div class="card-content">
            <div class="card-icon memory">
              <el-icon><Cpu /></el-icon>
            </div>
            <div class="card-info">
              <div class="card-title">内存使用率</div>
              <div class="card-value">{{ systemInfo.memoryUsage }}%</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="overview-card">
          <div class="card-content">
            <div class="card-icon disk">
              <el-icon><HardDrive /></el-icon>
            </div>
            <div class="card-info">
              <div class="card-title">磁盘使用率</div>
              <div class="card-value">{{ systemInfo.diskUsage }}%</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="overview-card">
          <div class="card-content">
            <div class="card-icon network">
              <el-icon><Connection /></el-icon>
            </div>
            <div class="card-info">
              <div class="card-title">网络状态</div>
              <div class="card-value">{{ systemInfo.networkStatus }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 服务状态 -->
    <el-card class="service-status">
      <template #header>
        <div class="card-header">
          <span>服务状态</span>
          <el-button type="primary" size="small" @click="refreshServices">
            <el-icon><Refresh /></el-icon>
            刷新
          </el-button>
        </div>
      </template>
      <el-table :data="serviceList" style="width: 100%">
        <el-table-column prop="name" label="服务名称" width="200" />
        <el-table-column prop="status" label="状态" width="120">
          <template #default="scope">
            <el-tag :type="scope.row.status === '运行中' ? 'success' : 'danger'">
              {{ scope.row.status }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="port" label="端口" width="100" />
        <el-table-column prop="uptime" label="运行时间" width="150" />
        <el-table-column prop="description" label="描述" />
        <el-table-column label="操作" width="150">
          <template #default="scope">
            <el-button
              size="small"
              :type="scope.row.status === '运行中' ? 'danger' : 'success'"
              @click="toggleService(scope.row)"
            >
              {{ scope.row.status === '运行中' ? '停止' : '启动' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 实时日志 -->
    <el-card class="log-monitor">
      <template #header>
        <div class="card-header">
          <span>实时日志</span>
          <div>
            <el-button size="small" @click="clearLogs">
              <el-icon><Delete /></el-icon>
              清空
            </el-button>
            <el-button size="small" @click="toggleAutoRefresh">
              <el-icon><VideoPlay /></el-icon>
              {{ autoRefresh ? '停止' : '开始' }}自动刷新
            </el-button>
          </div>
        </div>
      </template>
      <div class="log-container">
        <div v-for="(log, index) in logs" :key="index" class="log-item" :class="log.level">
          <span class="log-time">{{ log.time }}</span>
          <span class="log-level">[{{ log.level.toUpperCase() }}]</span>
          <span class="log-message">{{ log.message }}</span>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script>
import { ElMessage } from 'element-plus'

/**
 * 系统监控页面组件
 */
export default {
  name: 'Monitor',
  data() {
    return {
      // 系统信息
      systemInfo: {
        cpuUsage: 0,
        memoryUsage: 0,
        diskUsage: 0,
        networkStatus: '正常'
      },
      // 服务列表
      serviceList: [
        {
          name: 'JSON Server',
          status: '运行中',
          port: '3000',
          uptime: '2小时30分',
          description: 'API模拟服务'
        },
        {
          name: 'Vue Dev Server',
          status: '运行中',
          port: '5173',
          uptime: '2小时25分',
          description: '前端开发服务'
        },
        {
          name: 'Database',
          status: '停止',
          port: '3306',
          uptime: '-',
          description: '数据库服务'
        }
      ],
      // 日志
      logs: [],
      autoRefresh: false,
      refreshTimer: null
    }
  },
  mounted() {
    this.initMonitor()
    this.startSystemMonitor()
  },
  beforeUnmount() {
    this.stopAutoRefresh()
    if (this.systemTimer) {
      clearInterval(this.systemTimer)
    }
  },
  methods: {
    /**
     * 初始化监控
     */
    initMonitor() {
      this.addLog('info', '系统监控初始化完成')
      this.updateSystemInfo()
    },

    /**
     * 开始系统监控
     */
    startSystemMonitor() {
      this.systemTimer = setInterval(() => {
        this.updateSystemInfo()
      }, 5000)
    },

    /**
     * 更新系统信息
     */
    updateSystemInfo() {
      // 模拟系统数据更新
      this.systemInfo.cpuUsage = Math.floor(Math.random() * 30) + 20
      this.systemInfo.memoryUsage = Math.floor(Math.random() * 40) + 30
      this.systemInfo.diskUsage = Math.floor(Math.random() * 20) + 45
      
      // 随机网络状态
      const networkStates = ['正常', '延迟', '异常']
      this.systemInfo.networkStatus = networkStates[Math.floor(Math.random() * networkStates.length)]
    },

    /**
     * 刷新服务状态
     */
    refreshServices() {
      this.addLog('info', '刷新服务状态')
      ElMessage.success('服务状态已刷新')
    },

    /**
     * 切换服务状态
     */
    toggleService(service) {
      const action = service.status === '运行中' ? '停止' : '启动'
      service.status = service.status === '运行中' ? '停止' : '运行中'
      service.uptime = service.status === '运行中' ? '刚刚启动' : '-'
      
      this.addLog('info', `${action}服务: ${service.name}`)
      ElMessage.success(`${service.name} 已${action}`)
    },

    /**
     * 添加日志
     */
    addLog(level, message) {
      const now = new Date()
      const time = now.toLocaleTimeString()
      
      this.logs.unshift({
        time,
        level,
        message
      })
      
      // 限制日志数量
      if (this.logs.length > 100) {
        this.logs = this.logs.slice(0, 100)
      }
    },

    /**
     * 清空日志
     */
    clearLogs() {
      this.logs = []
      ElMessage.success('日志已清空')
    },

    /**
     * 切换自动刷新
     */
    toggleAutoRefresh() {
      if (this.autoRefresh) {
        this.stopAutoRefresh()
      } else {
        this.startAutoRefresh()
      }
    },

    /**
     * 开始自动刷新
     */
    startAutoRefresh() {
      this.autoRefresh = true
      this.refreshTimer = setInterval(() => {
        this.addLog('info', '自动刷新系统状态')
      }, 10000)
      this.addLog('info', '开始自动刷新')
    },

    /**
     * 停止自动刷新
     */
    stopAutoRefresh() {
      this.autoRefresh = false
      if (this.refreshTimer) {
        clearInterval(this.refreshTimer)
        this.refreshTimer = null
      }
      this.addLog('info', '停止自动刷新')
    }
  }
}
</script>

<style scoped>
.monitor-page {
  padding: 20px;
}

.overview-cards {
  margin-bottom: 20px;
}

.overview-card {
  height: 120px;
}

.card-content {
  display: flex;
  align-items: center;
  height: 100%;
}

.card-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 15px;
  font-size: 24px;
  color: white;
}

.card-icon.cpu {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.card-icon.memory {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.card-icon.disk {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.card-icon.network {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
}

.card-info {
  flex: 1;
}

.card-title {
  font-size: 14px;
  color: #666;
  margin-bottom: 8px;
}

.card-value {
  font-size: 24px;
  font-weight: bold;
  color: #333;
}

.service-status {
  margin-bottom: 20px;
}

.log-monitor {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.log-container {
  height: 300px;
  overflow-y: auto;
  background: #f5f5f5;
  padding: 10px;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
}

.log-item {
  margin-bottom: 5px;
  padding: 5px;
  border-radius: 3px;
}

.log-item.info {
  background: #e3f2fd;
  color: #1976d2;
}

.log-item.warn {
  background: #fff3e0;
  color: #f57c00;
}

.log-item.error {
  background: #ffebee;
  color: #d32f2f;
}

.log-time {
  color: #666;
  margin-right: 10px;
}

.log-level {
  font-weight: bold;
  margin-right: 10px;
}

.log-message {
  flex: 1;
}
</style>