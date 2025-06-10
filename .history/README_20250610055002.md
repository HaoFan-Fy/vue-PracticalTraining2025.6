## 基于Vue3的通用管理后台搭建

项目已完成内容：

1. vue，element-plus, element-plus icon 自动导入配置
2. router路由，pinia状态管理框架代码的引入
3. 使用vite构建和管理项目周期

## 目标

经典后台管理系统：DEMO一下

![1716166254141](image/README/1716166254141.png)

## 需求分析

结合需求和elment-plus综合分析，主体界面整体框架伪代码如下：

```js
<template>
  <div>
    {/* 最外层容器使用 el-container: section */}
    <el-container style="min-height: 100vh">
      <!--    侧边栏,使用 el-aside组件    -->
      <el-aside>
        <!--   左边栏内容组件    -->
        <Aside/>
      </el-aside>
      <!--    右边容器 el-container    -->
      <el-container>
        <!--  右边顶部栏：使用 el-header    -->
        <el-header>
          <!--    顶部内容组件    -->
          <Header/>
        </el-header>
        <!--变化的主体内容部分-->
        <el-main>
          <!--左边菜单点击，对应的组件渲染部分-->
          <router-view/>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>
```

[Container 布局容器 | Element Plus (element-plus.org)](https://element-plus.org/zh-CN/component/container.html#container-%E5%B8%83%E5%B1%80%E5%AE%B9%E5%99%A8)

![layout-overall](./image/layout-frame.png)

## 布局设计和实现

### 项目的调整

![tz](./image/README/tz.png)

1. App.vue代码修改，如下：

   ```javascript
   <script setup>
   </script>

   <template>
     <RouterView />
   </template>

   <style scoped>
   </style>


   ```

   运行程序测试一下，界面应该显示根路径 / 对应的组件
2. 除了根路径 / 对应的组件，其余组件全部删掉
   删除 components目录下所有内容

   删除 views目录下所有内容，除了 Demo.vue

   router/index.js修改成以下：

   ```js
    import { createRouter, createWebHistory } from 'vue-router'
    import Demo from '@/views/Demo.vue'

    const router = createRouter({
      history: createWebHistory(import.meta.env.BASE_URL),
      routes: [
        {
          path: '/',
          name: 'home',
          component: Demo
        },
      ]
    })

    export default router

   ```

   运行程序测试一下，界面应该显示根路径 / 对应的组件
3. 修改vite.config.js,添加server配置，运行时可以自动打开浏览器

   ```js
   server: {
       open: true,
       port: 8080,
   }
   ```

### 头部实现

### 左边栏设计

### 主体部分实现
