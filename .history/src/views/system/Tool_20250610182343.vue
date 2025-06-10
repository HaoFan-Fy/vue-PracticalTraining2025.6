<template>
  <div class="tool-page">
    <!-- 系统维护工具 -->
    <el-card class="tool-section">
      <template #header>
        <span>系统维护工具</span>
      </template>
      <el-row :gutter="20">
        <el-col :span="8">
          <div class="tool-item">
            <div class="tool-icon">
              <el-icon><Delete /></el-icon>
            </div>
            <div class="tool-content">
              <h4>清理缓存</h4>
              <p>清理系统缓存文件，释放存储空间</p>
              <el-button type="primary" @click="clearCache" :loading="cacheLoading">
                {{ cacheLoading ? '清理中...' : '开始清理' }}
              </el-button>
            </div>
          </div>
        </el-col>
        <el-col :span="8">
          <div class="tool-item">
            <div class="tool-icon">
              <el-icon><Download /></el-icon>
            </div>
            <div class="tool-content">
              <h4>数据备份</h4>
              <p>备份系统数据到本地文件</p>
              <el-button type="success" @click="backupData" :loading="backupLoading">
                {{ backupLoading ? '备份中...' : '开始备份' }}
              </el-button>
            </div>
          </div>
        </el-col>
        <el-col :span="8">
          <div class="tool-item">
            <div class="tool-icon">
              <el-icon><Upload /></el-icon>
            </div>
            <div class="tool-content">
              <h4>数据恢复</h4>
              <p>从备份文件恢复系统数据</p>
              <el-button type="warning" @click="restoreData">
                选择文件恢复
              </el-button>
            </div>
          </div>
        </el-col>
      </el-row>
    </el-card>

    <!-- 数据库工具 -->
    <el-card class="tool-section">
      <template #header>
        <span>数据库工具</span>
      </template>
      <el-row :gutter="20">
        <el-col :span="12">
          <div class="tool-item">
            <div class="tool-icon">
              <el-icon><Refresh /></el-icon>
            </div>
            <div class="tool-content">
              <h4>重置数据库</h4>
              <p>将数据库重置为初始状态</p>
              <el-button type="danger" @click="resetDatabase">
                重置数据库
              </el-button>
            </div>
          </div>
        </el-col>
        <el-col :span="12">
          <div class="tool-item">
            <div class="tool-icon">
              <el-icon><DataAnalysis /></el-icon>
            </div>
            <div class="tool-content">
              <h4>数据统计</h4>
              <p>查看系统数据统计信息</p>
              <el-button type="info" @click="showStatistics">
                查看统计
              </el-button>
            </div>
          </div>
        </el-col>
      </el-row>
    </el-card>

    <!-- 系统配置工具 -->
    <el-card class="tool-section">
      <template #header>
        <span>系统配置</span>
      </template>
      <el-form :model="configForm" label-width="120px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="系统名称">
              <el-input v-model="configForm.systemName" placeholder="请输入系统名称" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="API地址">
              <el-input v-model="configForm.apiUrl" placeholder="请输入API地址" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="会话超时">
              <el-input-number v-model="configForm.sessionTimeout" :min="1" :max="1440" /> 分钟
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="分页大小">
              <el-input-number v-model="configForm.pageSize" :min="5" :max="100" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="启用日志">
              <el-switch v-model="configForm.enableLog" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="调试模式">
              <el-switch v-model="configForm.debugMode" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item>
          <el-button type="primary" @click="saveConfig">
            保存配置
          </el-button>
          <el-button @click="resetConfig">
            重置配置
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 日志查看器 -->
    <el-card class="tool-section">
      <template #header>
        <div class="card-header">
          <span>系统日志</span>
          <div>
            <el-select v-model="logLevel" placeholder="选择日志级别" style="width: 120px; margin-right: 10px;">
              <el-option label="全部" value="" />
              <el-option label="信息" value="info" />
              <el-option label="警告" value="warn" />
              <el-option label="错误" value="error" />
            </el-select>
            <el-button size="small" @click="refreshLogs">
              <el-icon><Refresh /></el-icon>
              刷新
            </el-button>
            <el-button size="small" @click="exportLogs">
              <el-icon><Download /></el-icon>
              导出
            </el-button>
          </div>
        </div>
      </template>
      <el-table :data="filteredLogs" style="width: 100%" max-height="400">
        <el-table-column prop="time" label="时间" width="180" />
        <el-table-column prop="level" label="级别" width="80">
          <template #default="scope">
            <el-tag :type="getLogLevelType(scope.row.level)" size="small">
              {{ scope.row.level.toUpperCase() }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="module" label="模块" width="120" />
        <el-table-column prop="message" label="消息" />
      </el-table>
    </el-card>

    <!-- 数据统计对话框 -->
    <el-dialog v-model="statisticsVisible" title="数据统计" width="600px">
      <el-row :gutter="20">
        <el-col :span="12">
          <el-statistic title="用户总数" :value="statistics.userCount" />
        </el-col>
        <el-col :span="12">
          <el-statistic title="角色总数" :value="statistics.roleCount" />
        </el-col>
      </el-row>
      <el-row :gutter="20" style="margin-top: 20px;">
        <el-col :span="12">
          <el-statistic title="菜单总数" :value="statistics.menuCount" />
        </el-col>
        <el-col :span="12">
          <el-statistic title="部门总数" :value="statistics.deptCount" />
        </el-col>
      </el-row>
      <template #footer>
        <el-button @click="statisticsVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ElMessage, ElMessageBox } from 'element-plus'

/**
 * 系统工具页面组件
 */
export default {
  name: 'Tool',
  data() {
    return {
      // 加载状态
      cacheLoading: false,
      backupLoading: false,
      
      // 系统配置
      configForm: {
        systemName: '管理系统',
        apiUrl: 'http://localhost:3000',
        sessionTimeout: 30,
        pageSize: 10,
        enableLog: true,
        debugMode: false
      },
      
      // 日志相关
      logLevel: '',
      systemLogs: [
        {
          time: '2024-01-15 10:30:25',
          level: 'info',
          module: '用户管理',
          message: '用户登录成功: admin'
        },
        {
          time: '2024-01-15 10:25:12',
          level: 'warn',
          module: '系统监控',
          message: 'CPU使用率超过80%'
        },
        {
          time: '2024-01-15 10:20:08',
          level: 'error',
          module: '数据库',
          message: '数据库连接超时'
        },
        {
          time: '2024-01-15 10:15:33',
          level: 'info',
          module: '角色管理',
          message: '新增角色: 操作员'
        },
        {
          time: '2024-01-15 10:10:45',
          level: 'info',
          module: '菜单管理',
          message: '更新菜单权限'
        }
      ],
      
      // 统计信息
      statisticsVisible: false,
      statistics: {
        userCount: 0,
        roleCount: 0,
        menuCount: 0,
        deptCount: 0
      }
    }
  },
  computed: {
    /**
     * 过滤后的日志
     */
    filteredLogs() {
      if (!this.logLevel) {
        return this.systemLogs
      }
      return this.systemLogs.filter(log => log.level === this.logLevel)
    }
  },
  mounted() {
    this.loadConfig()
  },
  methods: {
    /**
     * 清理缓存
     */
    async clearCache() {
      this.cacheLoading = true
      try {
        // 模拟清理过程
        await new Promise(resolve => setTimeout(resolve, 2000))
        ElMessage.success('缓存清理完成')
      } catch (error) {
        ElMessage.error('缓存清理失败')
      } finally {
        this.cacheLoading = false
      }
    },

    /**
     * 数据备份
     */
    async backupData() {
      this.backupLoading = true
      try {
        // 模拟备份过程
        await new Promise(resolve => setTimeout(resolve, 3000))
        
        // 创建备份文件下载
        const backupData = {
          timestamp: new Date().toISOString(),
          data: {
            users: 'user data...',
            roles: 'role data...',
            menus: 'menu data...',
            depts: 'dept data...'
          }
        }
        
        const blob = new Blob([JSON.stringify(backupData, null, 2)], {
          type: 'application/json'
        })
        const url = URL.createObjectURL(blob)
        const a = document.createElement('a')
        a.href = url
        a.download = `backup_${new Date().toISOString().split('T')[0]}.json`
        a.click()
        URL.revokeObjectURL(url)
        
        ElMessage.success('数据备份完成')
      } catch (error) {
        ElMessage.error('数据备份失败')
      } finally {
        this.backupLoading = false
      }
    },

    /**
     * 数据恢复
     */
    restoreData() {
      const input = document.createElement('input')
      input.type = 'file'
      input.accept = '.json'
      input.onchange = (event) => {
        const file = event.target.files[0]
        if (file) {
          const reader = new FileReader()
          reader.onload = (e) => {
            try {
              const data = JSON.parse(e.target.result)
              console.log('恢复数据:', data)
              ElMessage.success('数据恢复完成')
            } catch (error) {
              ElMessage.error('文件格式错误')
            }
          }
          reader.readAsText(file)
        }
      }
      input.click()
    },

    /**
     * 重置数据库
     */
    async resetDatabase() {
      try {
        await ElMessageBox.confirm(
          '此操作将重置数据库到初始状态，所有数据将被清空，是否继续？',
          '警告',
          {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }
        )
        
        // 模拟重置过程
        await new Promise(resolve => setTimeout(resolve, 2000))
        ElMessage.success('数据库重置完成')
      } catch {
        ElMessage.info('已取消重置')
      }
    },

    /**
     * 显示统计信息
     */
    async showStatistics() {
      try {
        // 模拟获取统计数据
        const [userRes, roleRes, menuRes, deptRes] = await Promise.all([
          this.$http.get('/sys_user'),
          this.$http.get('/sys_role'),
          this.$http.get('/sys_menu'),
          this.$http.get('/sys_dept')
        ])
        
        this.statistics = {
          userCount: userRes.data?.length || 0,
          roleCount: roleRes.data?.length || 0,
          menuCount: menuRes.data?.length || 0,
          deptCount: deptRes.data?.length || 0
        }
        
        this.statisticsVisible = true
      } catch (error) {
        console.error('获取统计数据失败:', error)
        ElMessage.error('获取统计数据失败')
      }
    },

    /**
     * 保存配置
     */
    saveConfig() {
      // 保存到本地存储
      localStorage.setItem('systemConfig', JSON.stringify(this.configForm))
      ElMessage.success('配置保存成功')
    },

    /**
     * 重置配置
     */
    resetConfig() {
      this.configForm = {
        systemName: '管理系统',
        apiUrl: 'http://localhost:3000',
        sessionTimeout: 30,
        pageSize: 10,
        enableLog: true,
        debugMode: false
      }
      ElMessage.success('配置已重置')
    },

    /**
     * 加载配置
     */
    loadConfig() {
      const savedConfig = localStorage.getItem('systemConfig')
      if (savedConfig) {
        try {
          this.configForm = JSON.parse(savedConfig)
        } catch (error) {
          console.error('加载配置失败:', error)
        }
      }
    },

    /**
     * 刷新日志
     */
    refreshLogs() {
      ElMessage.success('日志已刷新')
    },

    /**
     * 导出日志
     */
    exportLogs() {
      const logs = this.filteredLogs
      const csvContent = 'data:text/csv;charset=utf-8,' +
        '时间,级别,模块,消息\n' +
        logs.map(log => `${log.time},${log.level},${log.module},${log.message}`).join('\n')
      
      const encodedUri = encodeURI(csvContent)
      const link = document.createElement('a')
      link.setAttribute('href', encodedUri)
      link.setAttribute('download', `system_logs_${new Date().toISOString().split('T')[0]}.csv`)
      link.click()
      
      ElMessage.success('日志导出完成')
    },

    /**
     * 获取日志级别类型
     */
    getLogLevelType(level) {
      const types = {
        info: '',
        warn: 'warning',
        error: 'danger'
      }
      return types[level] || ''
    }
  }
}
</script>

<style scoped>
.tool-page {
  padding: 20px;
}

.tool-section {
  margin-bottom: 20px;
}

.tool-item {
  display: flex;
  align-items: center;
  padding: 20px;
  border: 1px solid #e4e7ed;
  border-radius: 8px;
  height: 120px;
}

.tool-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20px;
  font-size: 24px;
  color: white;
}

.tool-content {
  flex: 1;
}

.tool-content h4 {
  margin: 0 0 8px 0;
  font-size: 16px;
  color: #333;
}

.tool-content p {
  margin: 0 0 15px 0;
  font-size: 14px;
  color: #666;
  line-height: 1.4;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
</style>