import { createRouter, createWebHistory } from 'vue-router'
import Layout from '@/components/Layout.vue'
import Home from '@/views/Home.vue'
import Login from '@/views/Login.vue'
import Register from '@/views/Register.vue'

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
        }
      ]
    }
  ]
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  
  // 如果访问登录页面，且已登录，则跳转到首页
  if (to.path === '/login' && token) {
    next('/home')
    return
  }
  
  // 如果访问需要认证的页面，但未登录，则跳转到登录页
  if (to.path !== '/login' && !token) {
    next('/login')
    return
  }
  
  next()
})

export default router
