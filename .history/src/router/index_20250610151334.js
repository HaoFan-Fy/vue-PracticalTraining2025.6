import { createRouter, createWebHistory } from 'vue-router'
import Layout from '@/components/Layout.vue'
import Demo from '@/views/Demo.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'layout',
      component: Layout,
      children: [
        {
          path: '',
          redirect: '/home'
        },
        {
          path: '/home',
          name: 'home',
          component: Demo
        },
        {
          path: '/test',
          name: 'test',
          component: Demo
        }
      ]
    }
  ]
})

export default router
