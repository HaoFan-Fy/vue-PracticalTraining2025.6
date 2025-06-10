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
    
        <el-menu-item
          v-for="menu in menus"
          :key="menu.menu_id"
          :index="menu.path"
          v-if="!menu.children || menu.children.length === 0"
        >
          <el-icon><component :is="menu.icon" /></el-icon>
          <span>{{ menu.menu_name }}</span>
        </el-menu-item>
        
        <el-sub-menu
          v-for="menu in menus"
          :key="menu.menu_id"
          :index="menu.menu_id.toString()"
          v-if="menu.children && menu.children.length > 0"
        >
          <template #title>
            <el-icon><component :is="menu.icon" /></el-icon>
            <span>{{ menu.menu_name }}</span>
          </template>
          <el-menu-item
            v-for="child in menu.children"
            :key="child.menu_id"
            :index="child.path"
          >
            <el-icon><component :is="child.icon" /></el-icon>
            <span>{{ child.menu_name }}</span>
          </el-menu-item>
        </el-sub-menu>
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
      // 本地测试数据
      const testMenuData = [
        {
          menu_id: 1,
          menu_name: '首页',
          path: '/home',
          icon: 'House',
          parent_id: 0,
          menu_type: 'C'
        },
        {
          menu_id: 2,
          menu_name: '系统管理',
          path: '/system',
          icon: 'Setting',
          parent_id: 0,
          menu_type: 'M',
          children: [
            {
              menu_id: 21,
              menu_name: '用户管理',
              path: '/system/user',
              icon: 'User',
              parent_id: 2,
              menu_type: 'C'
            },
            {
              menu_id: 22,
              menu_name: '角色管理',
              path: '/system/role',
              icon: 'UserFilled',
              parent_id: 2,
              menu_type: 'C'
            },
            {
              menu_id: 23,
              menu_name: '菜单管理',
              path: '/system/menu',
              icon: 'Menu',
              parent_id: 2,
              menu_type: 'C'
            },
            {
              menu_id: 24,
              menu_name: '部门管理',
              path: '/system/dept',
              icon: 'OfficeBuilding',
              parent_id: 2,
              menu_type: 'C'
            }
          ]
        },
        {
          menu_id: 3,
          menu_name: '测试页面',
          path: '/test',
          icon: 'Document',
          parent_id: 0,
          menu_type: 'C'
        }
      ];
      
      this.menus = this.buildMenuTree(testMenuData);
    },

    /**
     * 构建菜单树结构
     * @param {Array} menuData 菜单数据数组
     * @returns {Array} 树形菜单结构
     */
    // buildMenuTree(menuData) {
    //   // 如果数据已经是树结构，直接返回
    //   if (menuData.some(item => item.children)) {
    //     return menuData
    //   }
      
    //   const menuMap = new Map();
    //   const rootMenus = [];
      
    //   // 创建菜单映射
    //   menuData.forEach(menu => {
    //     menuMap.set(menu.menu_id, {
    //       id: menu.menu_id,
    //       name: menu.menu_name,
    //       path: menu.path,
    //       icon: menu.icon,
    //       description: menu.remark,
    //       pid: menu.parent_id,
    //       children: []
    //     });
    //   });
      
    //   // 构建树形结构
    //   menuMap.forEach(menu => {
    //     if (menu.pid === 0 || menu.pid === null) {
    //       rootMenus.push(menu);
    //     } else {
    //       const parent = menuMap.get(menu.pid);
    //       if (parent) {
    //         parent.children.push(menu);
    //       }
    //     }
    //   });
      
    //   return rootMenus;
    // }
    
  }
};
</script>

<style lang="scss" scoped>
.el-menu {
  border-right: none;
}
</style>