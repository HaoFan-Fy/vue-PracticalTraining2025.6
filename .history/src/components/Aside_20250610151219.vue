<template>
  <el-menu 
    style="min-height: 100%;overflow-x: hidden" 
    background-color="#333744" 
    text-color="#fff"
    active-text-color="#ffd04b" 
    :collapse-transition="false" 
    :collapse="isCollapse" 
    :default-active="$route.path"
    router
  >
    <!-- Logo区域 -->
    <div style="height: 60px;line-height: 60px;text-align: center">
      <img src="../assets/logo.svg" alt="" style="width: 20px;position: relative;top: 5px;margin-right: 5px">
      <b style="color: #fff" v-show="logoTextShow">管理后台</b>
    </div>
    
    <!-- 动态菜单 -->
    <div v-for="item in menus" :key="item.id">
      <!-- 一级菜单（有路径） -->
      <div v-if="item.path">
        <el-menu-item :index="item.path">
          <component :is="item.icon" style="width: 18px; height: 18px; margin-right: 4px;" :title="item.name">
          </component>
          <template #title>{{ item.name }}</template>
        </el-menu-item>
      </div>
      <!-- 一级菜单（有子菜单） -->
      <div v-else>
        <el-sub-menu :index="item.id + ''">
          <template #title>
            <component :is="item.icon" style="width: 18px; height: 18px; margin-right: 4px;" />
            <span>{{ item.name }}</span>
          </template>
          <div v-for="subItem in item.children" :key="subItem.id">
            <el-menu-item :index="subItem.path">
              <component v-if="subItem.icon" :is="subItem.icon" style="width: 18px; height: 18px" />
              <template #title>{{ subItem.name }}</template>
            </el-menu-item>
          </div>
        </el-sub-menu>
      </div>
    </div>
  </el-menu>
</template>

<script>
import axios from 'axios'

export default {
  name: "Aside",
  props: {
    isCollapse: Boolean,
    logoTextShow: Boolean
  },
  data() {
    return {
      menus: []
    };
  },
  async mounted() {
    await this.loadMenuData();
  },
  methods: {
    /**
     * 加载菜单数据
     * 优先从API获取，如果失败则使用本地数据
     */
    async loadMenuData() {
      try {
        // 尝试从API获取菜单数据
        const response = await axios.get('http://localhost:3000/sys_menu');
        if (response.data && response.data.length > 0) {
          this.menus = this.buildMenuTree(response.data);
        } else {
          this.loadLocalMenuData();
        }
      } catch (error) {
        console.warn('无法从API获取菜单数据，使用本地数据:', error);
        this.loadLocalMenuData();
      }
    },

    /**
     * 加载本地菜单数据（备用方案）
     */
    loadLocalMenuData() {
      // 设置本地测试数据
      const employee = {
        "employeeid": 72,
        "username": "admin",
        "password": "admin123",
        "employeename": "管理员",
        "token": "mock-jwt-token-admin",
        "role": "ROLE_ADMIN",
        "lang": "zh"
      };
      localStorage.setItem("employee", JSON.stringify(employee));
      
      const menus = [
        {
          "id": 1,
          "name": "首页",
          "path": "/home",
          "icon": "HomeFilled",
          "description": "首页",
          "pid": null,
          "pagePath": "Home",
          "children": [],
          "sortNum": 1,
          "lang": "zhCn"
        },
        {
          "id": 2,
          "name": "系统管理",
          "path": null,
          "icon": "Setting",
          "description": "系统管理",
          "pid": null,
          "pagePath": null,
          "children": [
            {
              "id": 21,
              "name": "用户管理",
              "path": "/system/user",
              "icon": "User",
              "description": "用户管理",
              "pid": 2,
              "pagePath": "system/User",
              "children": null,
              "sortNum": 1,
              "lang": "zhCn"
            },
            {
              "id": 22,
              "name": "角色管理",
              "path": "/system/role",
              "icon": "UserFilled",
              "description": "角色管理",
              "pid": 2,
              "pagePath": "system/Role",
              "children": null,
              "sortNum": 2,
              "lang": "zhCn"
            },
            {
              "id": 23,
              "name": "菜单管理",
              "path": "/system/menu",
              "icon": "Menu",
              "description": "菜单管理",
              "pid": 2,
              "pagePath": "system/Menu",
              "children": null,
              "sortNum": 3,
              "lang": "zhCn"
            },
            {
              "id": 24,
              "name": "部门管理",
              "path": "/system/dept",
              "icon": "OfficeBuilding",
              "description": "部门管理",
              "pid": 2,
              "pagePath": "system/Dept",
              "children": null,
              "sortNum": 4,
              "lang": "zhCn"
            }
          ],
          "sortNum": 2,
          "lang": "zhCn"
        }
      ];
      
      localStorage.setItem("menus", JSON.stringify(menus));
      this.menus = menus;
    },

    /**
     * 构建菜单树结构
     * @param {Array} menuData 菜单数据数组
     * @returns {Array} 树形菜单结构
     */
    buildMenuTree(menuData) {
      const menuMap = new Map();
      const rootMenus = [];
      
      // 创建菜单映射
      menuData.forEach(menu => {
        menuMap.set(menu.menu_id, {
          id: menu.menu_id,
          name: menu.menu_name,
          path: menu.path,
          icon: menu.icon,
          description: menu.remark,
          pid: menu.parent_id,
          children: []
        });
      });
      
      // 构建树形结构
      menuMap.forEach(menu => {
        if (menu.pid === 0 || menu.pid === null) {
          rootMenus.push(menu);
        } else {
          const parent = menuMap.get(menu.pid);
          if (parent) {
            parent.children.push(menu);
          }
        }
      });
      
      return rootMenus;
    }
  }
};
</script>

<style lang="scss" scoped>
.el-menu {
  border-right: none;
}
</style>