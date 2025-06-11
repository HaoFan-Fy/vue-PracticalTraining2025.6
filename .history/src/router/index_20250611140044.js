import { createRouter, createWebHistory } from 'vue-router'
import Layout from '@/components/Layout.vue'
import Home from '@/views/Home.vue'
import Login from '@/views/Login.vue'
import Register from '@/views/Register.vue'
import ChangePassword from '@/views/ChangePassword.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/login',
      name: 'Login',
      component: Login
    },
    {
      path: '/register',
      name: 'Register',
      component: Register
    },
    {
      path: '/',
      redirect: '/home'
    },
    {
      path: '/home',
      component: Layout,
      children: [
        {
          path: '',
          name: 'Home',
          component: Home
        }
      ]
    },
    {
      path: '/change-password',
      component: Layout,
      children: [
        {
          path: '',
          name: 'ChangePassword',
          component: ChangePassword
        }
      ]
    },
    {
      path: '/system',
      component: Layout,
      children: [
        {
          path: 'user',
          name: 'UserManagement',
          component: () => import('@/views/system/UserManagement.vue')
        },
        {
          path: 'role',
          name: 'RoleManagement',
          component: () => import('@/views/system/RoleManagement.vue')
        },
        {
          path: 'menu',
          name: 'MenuManagement',
          component: () => import('@/views/system/MenuManagement.vue')
        },
        {
          path: 'dept',
          name: 'DeptManagement',
          component: () => import('@/views/system/DeptManagement.vue')
        },
        {
          path: 'monitor',
          name: 'Monitor',
          component: () => import('@/views/system/Monitor.vue')
        },
        {
          path: 'tool',
          name: 'Tool',
          component: () => import('@/views/system/Tool.vue')
        }
      ]
    }
  ]
})

// 路由守卫
router.beforeEach((to, from, next) => {
  // 同时检查localStorage和sessionStorage中的token
  const localToken = localStorage.getItem('token')
  const sessionToken = sessionStorage.getItem('token')
  const token = localToken || sessionToken
  
  // 如果访问登录页面，且已登录，则跳转到首页
  if (to.path === '/login' && token) {
    next('/home')
    return
  }
  
  // 如果访问需要认证的页面，但未登录，则跳转到登录页
  // 排除登录页和注册页
  if (to.path !== '/login' && to.path !== '/register' && !token) {
    next('/login')
    return
  }
  
  next()
})

export default router
