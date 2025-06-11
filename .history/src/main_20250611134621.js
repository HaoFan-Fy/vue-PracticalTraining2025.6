import './assets/base.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import axios from 'axios'

import App from './App.vue'
import router from './router'
import permissionDirective from './directives/permission'

const app = createApp(App)

// 全局注册EP图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

// 注册权限指令
app.directive('permission', permissionDirective)

// 配置axios默认设置
axios.defaults.baseURL = 'http://localhost:3000'
axios.defaults.timeout = 10000

// 添加请求拦截器
axios.interceptors.request.use(
  config => {
    console.log('API请求:', config.method?.toUpperCase(), config.url)
    return config
  },
  error => {
    return Promise.reject(error)
  }
)

// 添加响应拦截器
axios.interceptors.response.use(
  response => {
    console.log('API响应:', response.status, response.config.url)
    return response
  },
  error => {
    console.error('API错误:', error.response?.status, error.config?.url, error.message)
    return Promise.reject(error)
  }
)

app.config.globalProperties.$http = axios

app.use(createPinia())
app.use(router)
app.use(ElementPlus)

app.mount('#app')
