<template>
  <div class="home-container">
    <el-card class="welcome-card">
      <template #header>
        <div class="card-header">
          <span>欢迎使用管理后台系统</span>
        </div>
      </template>
      <div class="welcome-content">
        <el-row :gutter="20">
          <el-col :span="8">
            <div class="stat-item">
              <el-icon class="stat-icon" color="#409EFF">
                <User />
              </el-icon>
              <div class="stat-info">
                <div class="stat-number">{{ userCount }}</div>
                <div class="stat-label">用户总数</div>
              </div>
            </div>
          </el-col>
          <el-col :span="8">
            <div class="stat-item">
              <el-icon class="stat-icon" color="#67C23A">
                <UserFilled />
              </el-icon>
              <div class="stat-info">
                <div class="stat-number">{{ roleCount }}</div>
                <div class="stat-label">角色总数</div>
              </div>
            </div>
          </el-col>
          <el-col :span="8">
            <div class="stat-item">
              <el-icon class="stat-icon" color="#E6A23C">
                <Menu />
              </el-icon>
              <div class="stat-info">
                <div class="stat-number">{{ menuCount }}</div>
                <div class="stat-label">菜单总数</div>
              </div>
            </div>
          </el-col>
        </el-row>
      </div>
    </el-card>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>系统信息</span>
            </div>
          </template>
          <div class="system-info">
            <div class="info-item">
              <span class="info-label">系统版本：</span>
              <span class="info-value">v1.0.0</span>
            </div>
            <div class="info-item">
              <span class="info-label">Vue版本：</span>
              <span class="info-value">3.4.21</span>
            </div>
            <div class="info-item">
              <span class="info-label">Element Plus：</span>
              <span class="info-value">2.7.3</span>
            </div>
            <div class="info-item">
              <span class="info-label">当前用户：</span>
              <span class="info-value">{{ currentUser }}</span>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>快速操作</span>
            </div>
          </template>
          <div class="quick-actions">
            <el-button type="primary" @click="goToUserManagement">
              <el-icon><User /></el-icon>
              用户管理
            </el-button>
            <el-button type="success" @click="goToRoleManagement">
              <el-icon><UserFilled /></el-icon>
              角色管理
            </el-button>
            <el-button type="warning" @click="goToMenuManagement">
              <el-icon><Menu /></el-icon>
              菜单管理
            </el-button>
            <el-button type="info" @click="goToDeptManagement">
              <el-icon><OfficeBuilding /></el-icon>
              部门管理
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Home',
  data() {
    return {
      userCount: 0,
      roleCount: 0,
      menuCount: 0,
      currentUser: '管理员'
    }
  },
  async mounted() {
    await this.loadStatistics()
    this.loadUserInfo()
  },
  methods: {
    /**
     * 加载统计数据
     */
    async loadStatistics() {
      try {
        // 获取用户总数
        const userResponse = await axios.get('http://localhost:3000/sys_user')
        this.userCount = userResponse.data?.length || 0
        
        // 获取角色总数
        const roleResponse = await axios.get('http://localhost:3000/sys_role')
        this.roleCount = roleResponse.data?.length || 0
        
        // 获取菜单总数
        const menuResponse = await axios.get('http://localhost:3000/sys_menu')
        this.menuCount = menuResponse.data?.length || 0
      } catch (error) {
        console.warn('无法获取统计数据:', error)
        // 使用默认值
        this.userCount = 10
        this.roleCount = 5
        this.menuCount = 15
      }
    },

    /**
     * 加载用户信息
     */
    loadUserInfo() {
      const employee = localStorage.getItem('employee')
      if (employee) {
        const userData = JSON.parse(employee)
        this.currentUser = userData.employeename || userData.username || '管理员'
      }
    },

    /**
     * 跳转到用户管理
     */
    goToUserManagement() {
      this.$router.push('/system/user')
    },

    /**
     * 跳转到角色管理
     */
    goToRoleManagement() {
      this.$router.push('/system/role')
    },

    /**
     * 跳转到菜单管理
     */
    goToMenuManagement() {
      this.$router.push('/system/menu')
    },

    /**
     * 跳转到部门管理
     */
    goToDeptManagement() {
      this.$router.push('/system/dept')
    }
  }
}
</script>

<style scoped>
.home-container {
  padding: 20px;
}

.welcome-card {
  margin-bottom: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: bold;
  font-size: 16px;
}

.welcome-content {
  padding: 20px 0;
}

.stat-item {
  display: flex;
  align-items: center;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 8px;
  transition: all 0.3s;
}

.stat-item:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  font-size: 40px;
  margin-right: 15px;
}

.stat-info {
  flex: 1;
}

.stat-number {
  font-size: 28px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  color: #909399;
}

.system-info {
  padding: 10px 0;
}

.info-item {
  display: flex;
  justify-content: space-between;
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
}

.info-item:last-child {
  border-bottom: none;
}

.info-label {
  color: #606266;
  font-weight: 500;
}

.info-value {
  color: #303133;
  font-weight: bold;
}

.quick-actions {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.quick-actions .el-button {
  justify-content: flex-start;
  padding: 12px 20px;
}

.quick-actions .el-button .el-icon {
  margin-right: 8px;
}
</style>