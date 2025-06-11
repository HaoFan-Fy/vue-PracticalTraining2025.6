<template>
  <div class="home-container">
    <el-card class="welcome-card">
      <template #header>
        <div class="card-header">
          <span>{{ $t('home.title') }}</span>
        </div>
      </template>
      <div class="welcome-content">
        <el-row :gutter="20">
          <el-col :span="6" v-if="hasPermission('system:user:list')">
            <div class="stat-item">
              <el-icon class="stat-icon" color="#409EFF">
                <User />
              </el-icon>
              <div class="stat-info">
                <div class="stat-number">{{ userCount }}</div>
                <div class="stat-label">{{ $t('home.userCount') }}</div>
              </div>
            </div>
          </el-col>
          <el-col :span="6" v-if="hasPermission('system:role:list')">
            <div class="stat-item">
              <el-icon class="stat-icon" color="#67C23A">
                <UserFilled />
              </el-icon>
              <div class="stat-info">
                <div class="stat-number">{{ roleCount }}</div>
                <div class="stat-label">{{ $t('home.roleCount') }}</div>
              </div>
            </div>
          </el-col>
          <el-col :span="6" v-if="hasPermission('system:menu:list')">
            <div class="stat-item">
              <el-icon class="stat-icon" color="#E6A23C">
                <Menu />
              </el-icon>
              <div class="stat-info">
                <div class="stat-number">{{ menuCount }}</div>
                <div class="stat-label">{{ $t('home.menuCount') }}</div>
              </div>
            </div>
          </el-col>
          <el-col :span="6" v-if="hasPermission('system:dept:list')">
            <div class="stat-item">
              <el-icon class="stat-icon" color="#F56C6C">
                <OfficeBuilding />
              </el-icon>
              <div class="stat-info">
                <div class="stat-number">{{ deptCount }}</div>
                <div class="stat-label">{{ $t('home.deptCount') }}</div>
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
              <span>{{ $t('home.userStatistics') }}</span>
            </div>
          </template>
          <div ref="userChart" class="chart-container"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>{{ $t('home.deptDistribution') }}</span>
            </div>
          </template>
          <div ref="deptChart" class="chart-container"></div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>{{ $t('home.systemInfo') }}</span>
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
              <span class="info-value">2.6.1</span>
            </div>
            <div class="info-item">
              <span class="info-label">当前用户：</span>
              <span class="info-value">{{ currentUser }}</span>
            </div>
            <div class="info-item">
              <span class="info-label">登录时间：</span>
              <span class="info-value">{{ loginTime }}</span>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <template #header>
            <div class="card-header">
              <span>{{ $t('home.quickActions') }}</span>
            </div>
          </template>
          <div class="quick-actions">
            <el-button v-if="hasPermission('system:user:list')" type="primary" @click="goToUserManagement">
              <el-icon><User /></el-icon>
              {{ $t('sidebar.userManagement') }}
            </el-button>
            <el-button v-if="hasPermission('system:role:list')" type="success" @click="goToRoleManagement">
              <el-icon><UserFilled /></el-icon>
              {{ $t('sidebar.roleManagement') }}
            </el-button>
            <el-button v-if="hasPermission('system:menu:list')" type="warning" @click="goToMenuManagement">
              <el-icon><Menu /></el-icon>
              {{ $t('sidebar.menuManagement') }}
            </el-button>
            <el-button v-if="hasPermission('system:dept:list')" type="info" @click="goToDeptManagement">
              <el-icon><OfficeBuilding /></el-icon>
              {{ $t('sidebar.deptManagement') }}
            </el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 企业数据分析展示 -->
    <div class="mt-5">
      <h2 class="text-2xl font-bold text-gray-900 mb-6">{{ $t('home.businessAnalysis') }}</h2>
      
      <!-- 关键指标卡片 -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-6">
        <div class="stat-card">
          <h4>{{ $t('home.totalRevenue') }}</h4>
          <div class="stat-value">¥{{ formatNumber(businessData.totalRevenue) }}</div>
          <div class="stat-change">+12.5% {{ $t('home.fromLastMonth') }}</div>
        </div>
        <div class="stat-card" style="background: linear-gradient(135deg, #10b981, #059669);">
          <h4>{{ $t('home.totalOrders') }}</h4>
          <div class="stat-value">{{ formatNumber(businessData.totalOrders) }}</div>
          <div class="stat-change">+8.2% {{ $t('home.fromLastMonth') }}</div>
        </div>
        <div class="stat-card" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
          <h4>{{ $t('home.totalCustomers') }}</h4>
          <div class="stat-value">{{ formatNumber(businessData.totalCustomers) }}</div>
          <div class="stat-change">+15.3% {{ $t('home.fromLastMonth') }}</div>
        </div>
        <div class="stat-card" style="background: linear-gradient(135deg, #ef4444, #dc2626);">
          <h4>{{ $t('home.totalExpenses') }}</h4>
          <div class="stat-value">¥{{ formatNumber(businessData.totalExpenses) }}</div>
          <div class="stat-change">-3.1% {{ $t('home.fromLastMonth') }}</div>
        </div>
      </div>

      <!-- 图表区域 -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
        <!-- 销售趋势图 -->
        <div class="dashboard-card">
          <h3>{{ $t('home.salesTrend') }}</h3>
          <div ref="salesChart" class="chart-container"></div>
        </div>
        
        <!-- 收入支出对比图 -->
        <div class="dashboard-card">
          <h3>{{ $t('home.revenueExpense') }}</h3>
          <div ref="revenueChart" class="chart-container"></div>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- 产品销售分布 -->
        <div class="dashboard-card">
          <h3>{{ $t('home.productSales') }}</h3>
          <div ref="productChart" class="chart-container"></div>
        </div>
        
        <!-- 客户地区分布 -->
        <div class="dashboard-card">
          <h3>{{ $t('home.customerRegion') }}</h3>
          <div ref="regionChart" class="chart-container"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import * as echarts from 'echarts'
import dayjs from 'dayjs'
import permissionMixin from '@/mixins/permission'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler
} from 'chart.js'
import { tailwindConfig, hexToRGB, generateRandomData, generateDateLabels } from '@/utils/Utils'

import { User, UserFilled, Menu, OfficeBuilding } from '@element-plus/icons-vue'

// 注册 Chart.js 组件
ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
  Filler
)
export default {
  name: 'Home',
  mixins: [permissionMixin],
  components: {
    User,
    UserFilled,
    Menu,
    OfficeBuilding
  },
  data() {
    return {
      userCount: 0,
      roleCount: 0,
      menuCount: 0,
      deptCount: 0,
      currentUser: '管理员',
      loginTime: '',
      userChart: null,
      deptChart: null,
      // 新增的业务分析图表实例
      salesChart: null,
      revenueChart: null,
      productChart: null,
      regionChart: null,
      // 业务数据
      businessData: {
        totalRevenue: 4800000,   // 当月总收入：480万
        totalOrders: 2850,       // 当月总订单数：2850单
        totalCustomers: 12500,   // 总客户数：1.25万
        totalExpenses: 3200000,  // 当月总支出：320万
        salesData: [],           // 销售趋势数据
        revenueData: [],         // 收入支出对比数据
        productData: [],         // 产品销售分布数据
        regionData: []           // 客户地区分布数据
      }
    }
  },
  async mounted() {
    await this.loadStatistics()
    this.loadUserInfo()
    this.loadBusinessData()
    this.initCharts()
    this.initBusinessCharts()
  },
  beforeUnmount() {
    // 销毁图表实例
    if (this.userChart) {
      this.userChart.dispose()
    }
    if (this.deptChart) {
      this.deptChart.dispose()
    }
    // 销毁业务分析图表实例
    if (this.salesChart) {
      this.salesChart.destroy()
    }
    if (this.revenueChart) {
      this.revenueChart.destroy()
    }
    if (this.productChart) {
      this.productChart.destroy()
    }
    if (this.regionChart) {
      this.regionChart.destroy()
    }
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
        
        // 获取部门总数
        const deptResponse = await axios.get('http://localhost:3000/sys_dept')
        this.deptCount = deptResponse.data?.length || 0
      } catch (error) {
        console.warn('无法获取统计数据:', error)
        // 使用默认值
        this.userCount = 10
        this.roleCount = 5
        this.menuCount = 15
        this.deptCount = 8
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
      // 设置登录时间
      this.loginTime = dayjs().format('YYYY-MM-DD HH:mm:ss')
    },

    /**
     * 初始化图表
     */
    initCharts() {
      this.$nextTick(() => {
        this.initUserChart()
        this.initDeptChart()
      })
    },

    /**
     * 初始化用户统计图表
     */
    initUserChart() {
      if (!this.$refs.userChart) return
      
      this.userChart = echarts.init(this.$refs.userChart)
      
      const option = {
        title: {
          text: '用户状态分布',
          left: 'center',
          textStyle: {
            fontSize: 14
          }
        },
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 'left',
          data: ['正常用户', '停用用户']
        },
        series: [
          {
            name: '用户状态',
            type: 'pie',
            radius: '50%',
            data: [
              { value: Math.floor(this.userCount * 0.8), name: '正常用户' },
              { value: Math.floor(this.userCount * 0.2), name: '停用用户' }
            ],
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          }
        ]
      }
      
      this.userChart.setOption(option)
    },

    /**
     * 初始化部门分布图表
     */
    initDeptChart() {
      if (!this.$refs.deptChart) return
      
      this.deptChart = echarts.init(this.$refs.deptChart)
      
      const option = {
        title: {
          text: '部门人员分布',
          left: 'center',
          textStyle: {
            fontSize: 14
          }
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: ['技术部', '市场部', '人事部', '财务部', '运营部']
        },
        yAxis: {
          type: 'value'
        },
        series: [
          {
            name: '人员数量',
            type: 'bar',
            data: [12, 8, 6, 4, 10],
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: '#83bff6' },
                { offset: 0.5, color: '#188df0' },
                { offset: 1, color: '#188df0' }
              ])
            }
          }
        ]
      }
      
      this.deptChart.setOption(option)
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
    },

    /**
     * 加载业务数据
     */
    async loadBusinessData() {
      try {
        // 模拟从API获取业务数据
        // 实际项目中这里应该调用真实的API
        const months = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
        
        // 销售趋势数据 - 模拟真实的季节性波动
        const salesTrendData = [2800000, 2650000, 3200000, 3450000, 3800000, 4200000, 4500000, 4300000, 3900000, 3600000, 3300000, 4800000]
        this.businessData.salesData = {
          labels: months,
          datasets: [{
            label: '销售额',
            data: salesTrendData,
            borderColor: tailwindConfig().theme.colors.blue[500],
            backgroundColor: `rgba(${hexToRGB(tailwindConfig().theme.colors.blue[500])}, 0.1)`,
            tension: 0.4,
            fill: true
          }]
        }

        // 收入支出对比数据 - 更真实的财务数据
        const revenueData = [3200000, 2980000, 3650000, 3890000, 4200000, 4650000, 4980000, 4750000, 4300000, 3950000, 3650000, 5200000]
        const expenseData = [2100000, 1950000, 2300000, 2450000, 2650000, 2900000, 3100000, 2980000, 2700000, 2500000, 2300000, 3200000]
        this.businessData.revenueData = {
          labels: months,
          datasets: [
            {
              label: '收入',
              data: revenueData,
              backgroundColor: tailwindConfig().theme.colors.green[500]
            },
            {
              label: '支出',
              data: expenseData,
              backgroundColor: tailwindConfig().theme.colors.red[500]
            }
          ]
        }

        // 产品销售分布数据 - 具体的产品名称和销售占比
        this.businessData.productData = {
          labels: ['智能手机', '笔记本电脑', '平板电脑', '智能手表', '无线耳机', '智能音箱'],
          datasets: [{
            data: [35, 28, 15, 12, 7, 3],
            backgroundColor: [
              '#3B82F6', // 蓝色
              '#10B981', // 绿色
              '#F59E0B', // 黄色
              '#8B5CF6', // 紫色
              '#EF4444', // 红色
              '#6B7280'  // 灰色
            ],
            borderWidth: 2,
            borderColor: '#ffffff'
          }]
        }

        // 客户地区分布数据 - 更详细的地区客户数据
        this.businessData.regionData = {
          labels: ['华东地区', '华南地区', '华北地区', '华中地区', '西南地区', '西北地区', '东北地区'],
          datasets: [{
            label: '客户数量',
            data: [1850, 1420, 1680, 980, 750, 520, 680],
            backgroundColor: [
              'rgba(59, 130, 246, 0.8)',   // 蓝色
              'rgba(16, 185, 129, 0.8)',   // 绿色
              'rgba(245, 158, 11, 0.8)',   // 黄色
              'rgba(139, 92, 246, 0.8)',   // 紫色
              'rgba(239, 68, 68, 0.8)',    // 红色
              'rgba(107, 114, 128, 0.8)',  // 灰色
              'rgba(236, 72, 153, 0.8)'    // 粉色
            ],
            borderColor: [
              'rgb(59, 130, 246)',
              'rgb(16, 185, 129)',
              'rgb(245, 158, 11)',
              'rgb(139, 92, 246)',
              'rgb(239, 68, 68)',
              'rgb(107, 114, 128)',
              'rgb(236, 72, 153)'
            ],
            borderWidth: 1
          }]
        }

        // 更新关键指标数据
        this.businessData.totalRevenue = 4800000  // 当月收入
        this.businessData.totalOrders = 2850      // 当月订单数
        this.businessData.totalCustomers = 12500  // 总客户数
        this.businessData.totalExpenses = 3200000 // 当月支出
        
      } catch (error) {
        console.warn('无法获取业务数据:', error)
        // 使用默认数据
        this.setDefaultBusinessData()
      }
    },

    /**
     * 设置默认业务数据
     */
    setDefaultBusinessData() {
      const months = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']
      
      this.businessData.salesData = {
        labels: months,
        datasets: [{
          label: '销售额',
          data: generateRandomData(12, 2000000, 5000000),
          borderColor: '#3B82F6',
          backgroundColor: 'rgba(59, 130, 246, 0.1)',
          tension: 0.4,
          fill: true
        }]
      }

      this.businessData.revenueData = {
        labels: months,
        datasets: [
          {
            label: '收入',
            data: generateRandomData(12, 2500000, 5500000),
            backgroundColor: '#10B981'
          },
          {
            label: '支出',
            data: generateRandomData(12, 1500000, 3500000),
            backgroundColor: '#EF4444'
          }
        ]
      }

      this.businessData.productData = {
        labels: ['智能手机', '笔记本电脑', '平板电脑', '智能手表', '无线耳机', '智能音箱'],
        datasets: [{
          data: [35, 28, 15, 12, 7, 3],
          backgroundColor: ['#3B82F6', '#10B981', '#F59E0B', '#8B5CF6', '#EF4444', '#6B7280']
        }]
      }

      this.businessData.regionData = {
        labels: ['华东地区', '华南地区', '华北地区', '华中地区', '西南地区', '西北地区', '东北地区'],
        datasets: [{
          label: '客户数量',
          data: generateRandomData(7, 500, 2000),
          backgroundColor: 'rgba(59, 130, 246, 0.8)',
          borderColor: 'rgb(59, 130, 246)',
          borderWidth: 1
        }]
      }
    },

    /**
     * 格式化数字显示
     */
    formatNumber(num) {
      if (num >= 10000) {
        return (num / 10000).toFixed(1) + '万'
      }
      return num.toLocaleString()
    },

    /**
     * 初始化业务分析图表
     */
    initBusinessCharts() {
      this.$nextTick(() => {
        this.initSalesChart()
        this.initRevenueChart()
        this.initProductChart()
        this.initRegionChart()
      })
    },

    /**
     * 初始化销售趋势图
     */
    initSalesChart() {
      if (!this.$refs.salesChart) return
      
      const ctx = this.$refs.salesChart.getContext('2d')
      this.salesChart = new ChartJS(ctx, {
        type: 'line',
        data: this.businessData.salesData,
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              display: false
            }
          },
          scales: {
            y: {
              beginAtZero: true,
              ticks: {
                callback: function(value) {
                  return '¥' + (value / 10000).toFixed(0) + '万'
                }
              }
            }
          }
        }
      })
    },

    /**
     * 初始化收入支出对比图
     */
    initRevenueChart() {
      if (!this.$refs.revenueChart) return
      
      const ctx = this.$refs.revenueChart.getContext('2d')
      this.revenueChart = new ChartJS(ctx, {
        type: 'bar',
        data: this.businessData.revenueData,
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'top'
            }
          },
          scales: {
            y: {
              beginAtZero: true,
              ticks: {
                callback: function(value) {
                  return '¥' + (value / 10000).toFixed(0) + '万'
                }
              }
            }
          }
        }
      })
    },

    /**
     * 初始化产品销售分布图
     */
    initProductChart() {
      if (!this.$refs.productChart) return
      
      const ctx = this.$refs.productChart.getContext('2d')
      this.productChart = new ChartJS(ctx, {
        type: 'doughnut',
        data: this.businessData.productData,
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'bottom'
            }
          }
        }
      })
    },

    /**
     * 初始化客户地区分布图
     */
    initRegionChart() {
      if (!this.$refs.regionChart) return
      
      const ctx = this.$refs.regionChart.getContext('2d')
      this.regionChart = new ChartJS(ctx, {
        type: 'bar',
        data: this.businessData.regionData,
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              display: false
            }
          },
          scales: {
            y: {
              beginAtZero: true
            }
          }
        }
      })
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

.chart-container {
  width: 100%;
  height: 300px;
  min-height: 300px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .stat-item {
    margin-bottom: 20px;
  }
  
  .chart-container {
    height: 250px;
    min-height: 250px;
  }
  
  .quick-actions .el-button {
    width: 100%;
    margin: 5px 0;
  }
}
</style>