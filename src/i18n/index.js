import { createI18n } from 'vue-i18n'

// 中文语言包
const zh = {
  header: {
    currentTime: '当前时间：',
    fullScreen: '全屏',
    personalCenter: '个人中心',
    changePassword: '修改密码',
    logout: '退出登录',
    user: '用户'
  },
  sidebar: {
    dashboard: '首页',
    userManagement: '用户管理',
    roleManagement: '角色管理',
    menuManagement: '菜单管理',
    deptManagement: '部门管理',
    systemMonitor: '系统监控',
    dataStatistics: '数据统计'
  },
  home: {
    title: '欢迎使用管理系统',
    userCount: '用户总数',
    roleCount: '角色总数',
    menuCount: '菜单总数',
    deptCount: '部门总数',
    quickActions: '快捷操作',
    userStatistics: '用户统计图表',
    deptDistribution: '部门分布',
    systemInfo: '系统信息'
  },
  common: {
    confirm: '确定',
    cancel: '取消',
    warning: '警告',
    success: '成功',
    error: '错误',
    info: '信息',
    loading: '加载中',
    noData: '暂无数据'
  },
  messages: {
    languageSwitched: '语言已切换为中文',
    fullScreenEntered: '已进入全屏模式',
    fullScreenExited: '已退出全屏模式',
    browserNotSupported: '您的浏览器不支持全屏功能',
    personalCenterDeveloping: '个人中心功能开发中...',
    confirmLogout: '确定要退出登录吗？',
    logoutSuccess: '退出登录成功',
    logoutCancelled: '已取消退出'
  }
}

// 英文语言包
const en = {
  header: {
    currentTime: 'Current Time: ',
    fullScreen: 'Full Screen',
    personalCenter: 'Personal Center',
    changePassword: 'Change Password',
    logout: 'Logout',
    user: 'User'
  },
  sidebar: {
    dashboard: 'Dashboard',
    userManagement: 'User Management',
    roleManagement: 'Role Management',
    menuManagement: 'Menu Management',
    deptManagement: 'Department Management',
    systemMonitor: 'System Monitor',
    dataStatistics: 'Data Statistics'
  },
  home: {
    title: 'Welcome to Management System',
    userCount: 'Total Users',
    roleCount: 'Total Roles',
    menuCount: 'Total Menus',
    deptCount: 'Total Departments',
    quickActions: 'Quick Actions',
    userStatistics: 'User Statistics Chart',
    deptDistribution: 'Department Distribution',
    systemInfo: 'System Information'
  },
  common: {
    confirm: 'Confirm',
    cancel: 'Cancel',
    warning: 'Warning',
    success: 'Success',
    error: 'Error',
    info: 'Info',
    loading: 'Loading',
    noData: 'No Data'
  },
  messages: {
    languageSwitched: 'Language switched to English',
    fullScreenEntered: 'Entered full screen mode',
    fullScreenExited: 'Exited full screen mode',
    browserNotSupported: 'Your browser does not support full screen',
    personalCenterDeveloping: 'Personal center feature is under development...',
    confirmLogout: 'Are you sure you want to logout?',
    logoutSuccess: 'Logout successful',
    logoutCancelled: 'Logout cancelled'
  }
}

// 创建i18n实例
const i18n = createI18n({
  locale: 'zh', // 默认语言
  fallbackLocale: 'zh', // 回退语言
  messages: {
    zh,
    en
  }
})

export default i18n