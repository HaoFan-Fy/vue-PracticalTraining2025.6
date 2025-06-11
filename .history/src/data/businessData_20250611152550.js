/**
 * 企业数据分析演示数据
 * 包含销售、财务、产品、客户等各类业务数据
 */

// 月份标签
export const monthLabels = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月']

// 销售趋势数据（12个月）
export const salesTrendData = {
  labels: monthLabels,
  datasets: [{
    label: '销售额（万元）',
    data: [280, 265, 320, 345, 380, 420, 450, 430, 390, 360, 330, 480],
    borderColor: '#3B82F6',
    backgroundColor: 'rgba(59, 130, 246, 0.1)',
    tension: 0.4,
    fill: true
  }]
}

// 收入支出对比数据
export const revenueExpenseData = {
  labels: monthLabels,
  datasets: [
    {
      label: '收入（万元）',
      data: [320, 298, 365, 389, 420, 465, 498, 475, 430, 395, 365, 520],
      backgroundColor: '#10B981'
    },
    {
      label: '支出（万元）',
      data: [210, 195, 230, 245, 265, 290, 310, 298, 270, 250, 230, 320],
      backgroundColor: '#EF4444'
    }
  ]
}

// 产品销售分布数据
export const productSalesData = {
  labels: ['智能手机', '笔记本电脑', '平板电脑', '智能手表', '无线耳机', '智能音箱'],
  datasets: [{
    data: [35, 28, 15, 12, 7, 3],
    backgroundColor: [
      '#3B82F6', // 蓝色 - 智能手机
      '#10B981', // 绿色 - 笔记本电脑
      '#F59E0B', // 黄色 - 平板电脑
      '#8B5CF6', // 紫色 - 智能手表
      '#EF4444', // 红色 - 无线耳机
      '#6B7280'  // 灰色 - 智能音箱
    ],
    borderWidth: 2,
    borderColor: '#ffffff'
  }]
}

// 客户地区分布数据
export const customerRegionData = {
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

// 关键业务指标
export const keyMetrics = {
  totalRevenue: 4800000,   // 当月总收入：480万
  totalOrders: 2850,       // 当月总订单数：2850单
  totalCustomers: 12500,   // 总客户数：1.25万
  totalExpenses: 3200000,  // 当月总支出：320万
  revenueGrowth: 12.5,     // 收入增长率：12.5%
  orderGrowth: 8.2,        // 订单增长率：8.2%
  customerGrowth: 15.3,    // 客户增长率：15.3%
  expenseChange: -3.1      // 支出变化率：-3.1%
}

// 产品详细信息
export const productDetails = [
  {
    name: '智能手机',
    sales: 35,
    revenue: 1680000,
    units: 420,
    avgPrice: 4000,
    growth: 15.2
  },
  {
    name: '笔记本电脑',
    sales: 28,
    revenue: 1344000,
    units: 168,
    avgPrice: 8000,
    growth: 8.7
  },
  {
    name: '平板电脑',
    sales: 15,
    revenue: 720000,
    units: 240,
    avgPrice: 3000,
    growth: -2.3
  },
  {
    name: '智能手表',
    sales: 12,
    revenue: 576000,
    units: 288,
    avgPrice: 2000,
    growth: 22.1
  },
  {
    name: '无线耳机',
    sales: 7,
    revenue: 336000,
    units: 560,
    avgPrice: 600,
    growth: 18.5
  },
  {
    name: '智能音箱',
    sales: 3,
    revenue: 144000,
    units: 144,
    avgPrice: 1000,
    growth: 5.2
  }
]

// 地区详细信息
export const regionDetails = [
  {
    name: '华东地区',
    customers: 1850,
    revenue: 1440000,
    orders: 925,
    avgOrderValue: 1557,
    growth: 18.2
  },
  {
    name: '华南地区',
    customers: 1420,
    revenue: 1136000,
    orders: 710,
    avgOrderValue: 1600,
    growth: 12.8
  },
  {
    name: '华北地区',
    customers: 1680,
    revenue: 1176000,
    orders: 840,
    avgOrderValue: 1400,
    growth: 15.5
  },
  {
    name: '华中地区',
    customers: 980,
    revenue: 686000,
    orders: 490,
    avgOrderValue: 1400,
    growth: 8.9
  },
  {
    name: '西南地区',
    customers: 750,
    revenue: 525000,
    orders: 375,
    avgOrderValue: 1400,
    growth: 6.2
  },
  {
    name: '西北地区',
    customers: 520,
    revenue: 364000,
    orders: 260,
    avgOrderValue: 1400,
    growth: 3.8
  },
  {
    name: '东北地区',
    customers: 680,
    revenue: 476000,
    orders: 340,
    avgOrderValue: 1400,
    growth: 4.5
  }
]

// 销售团队数据
export const salesTeamData = [
  {
    name: '张明',
    department: '华东销售部',
    sales: 580000,
    target: 500000,
    completion: 116,
    customers: 45
  },
  {
    name: '李华',
    department: '华南销售部',
    sales: 520000,
    target: 480000,
    completion: 108.3,
    customers: 38
  },
  {
    name: '王强',
    department: '华北销售部',
    sales: 480000,
    target: 450000,
    completion: 106.7,
    customers: 42
  },
  {
    name: '赵丽',
    department: '华中销售部',
    sales: 420000,
    target: 400000,
    completion: 105,
    customers: 35
  },
  {
    name: '陈伟',
    department: '西南销售部',
    sales: 380000,
    target: 350000,
    completion: 108.6,
    customers: 28
  }
]

// 月度趋势详细数据
export const monthlyTrends = {
  revenue: [3200000, 2980000, 3650000, 3890000, 4200000, 4650000, 4980000, 4750000, 4300000, 3950000, 3650000, 5200000],
  orders: [2100, 1950, 2300, 2450, 2650, 2900, 3100, 2980, 2700, 2500, 2300, 3200],
  customers: [150, 180, 220, 280, 320, 380, 420, 390, 350, 310, 280, 450],
  avgOrderValue: [1524, 1528, 1587, 1588, 1585, 1603, 1606, 1594, 1593, 1580, 1587, 1625]
}

// 导出所有数据
export default {
  monthLabels,
  salesTrendData,
  revenueExpenseData,
  productSalesData,
  customerRegionData,
  keyMetrics,
  productDetails,
  regionDetails,
  salesTeamData,
  monthlyTrends
}