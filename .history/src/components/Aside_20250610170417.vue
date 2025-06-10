<template>
  <el-menu style="min-height: 100%;overflow-x: hidden" background-color="#333744" text-color="#fff"
    active-text-color="#ffd04b" :collapse-transition="false" :collapse="isCollapse" :default-active="$route.path" router>
    
    <!-- Logo区域 -->
    <div style="height: 60px;line-height: 60px;text-align: center">
      <img src="../assets/logo.svg" alt="" style="width: 20px;position: relative;top: 5px;margin-right: 5px">
      <b style="color: #fff" v-show="logoTextShow">管理后台</b>
    </div>

    <!-- 菜单内容 -->
    <template v-if="!loading && menus.length > 0">
      <el-menu-item v-for="menu in menus" :key="menu.menu_id" :index="menu.path"
        v-if="!menu.children || menu.children.length === 0">
        <el-icon>
          <component :is="menu.icon" />
        </el-icon>
        <span>{{ menu.menu_name }}</span>
      </el-menu-item>

      <el-sub-menu v-for="menu in menus" :key="menu.menu_id" :index="menu.menu_id.toString()"
        v-if="menu.children && menu.children.length > 0">
        <template #title>
          <el-icon>
            <component :is="menu.icon" />
          </el-icon>
          <span>{{ menu.menu_name }}</span>
        </template>
        <el-menu-item v-for="child in menu.children" :key="child.menu_id" :index="child.path">
          <el-icon>
            <component :is="child.icon" />
          </el-icon>
          <span>{{ child.menu_name }}</span>
        </el-menu-item>
      </el-sub-menu>
    </template>

    <!-- 加载中或无数据提示 -->
    <template v-else-if="loading">
      <div style="padding: 20px; text-align: center; color: #fff;">
        菜单加载中...
      </div>
    </template>

    <template v-else>
      <div style="padding: 20px; text-align: center; color: #fff;">
        暂无菜单数据
      </div>
    </template>

  </el-menu>
</template>

<script>
import axios from 'axios';
import cloneDeep from 'lodash.clonedeep'; // 引入深拷贝库确保响应性

export default {
  name: "Aside",
  props: {
    isCollapse: Boolean,
    logoTextShow: Boolean
  },
  data() {
    return {
      menus: [],
      loading: true
    };
  },
  async mounted() {
    await this.loadMenuData();
    console.log('最终 menus 数据:', this.menus);
  },
  methods: {
    /**
     * 确保每个节点都有 children 数组
     */
    ensureChildrenArray(nodes) {
      if (!Array.isArray(nodes)) return;
      nodes.forEach(node => {
        if (!Array.isArray(node.children)) {
          node.children = [];
        }
        this.ensureChildrenArray(node.children);
      });
    },

    /**
     * 加载菜单数据：优先从API获取，失败则使用本地数据
     */
    async loadMenuData() {
      try {
        const response = await axios.get('http://localhost:3000/sys_menu');
        console.log('API响应数据:', response.data);

        if (response.data && response.data.length > 0) {
          const tree = this.buildMenuTree(response.data);
          this.ensureChildrenArray(tree);
          this.menus = cloneDeep(tree); // 使用深拷贝保证响应性
        } else {
          console.log('API返回空数据，使用本地测试菜单');
          this.loadLocalMenuData();
        }
      } catch (error) {
        console.warn('无法从API获取菜单数据，使用本地数据:', error);
        this.loadLocalMenuData();
      } finally {
        this.loading = false;
      }
    },

    /**
     * 加载本地测试菜单数据（备用方案）
     */
    loadLocalMenuData() {
      const testMenuData = [
        {
          menu_id: 1, menu_name: '首页', path: '/home', icon: 'House', parent_id: 0, menu_type: 'C', children: []
        },
        {
          menu_id: 2, menu_name: '系统管理', path: '/system', icon: 'Setting', parent_id: 0, menu_type: 'M', children: [
            { menu_id: 21, menu_name: '用户管理', path: '/system/user', icon: 'User', parent_id: 2, menu_type: 'C' },
            { menu_id: 22, menu_name: '角色管理', path: '/system/role', icon: 'UserFilled', parent_id: 2, menu_type: 'C' },
            { menu_id: 23, menu_name: '菜单管理', path: '/system/menu', icon: 'Menu', parent_id: 2, menu_type: 'C' },
            { menu_id: 24, menu_name: '部门管理', path: '/system/dept', icon: 'OfficeBuilding', parent_id: 2, menu_type: 'C' }
          ]
        },
        {
          menu_id: 3, menu_name: '测试页面', path: '/test', icon: 'Document', parent_id: 0, menu_type: 'C', children: []
        }
      ];

      const tree = this.buildMenuTree(testMenuData);
      this.ensureChildrenArray(tree);
      this.menus = cloneDeep(tree);
      console.log('本地菜单数据加载完成:', this.menus);
      this.loading = false;
    },

    /**
     * 构建菜单树结构
     */
    buildMenuTree(menuData) {
      const menuMap = {};
      menuData.forEach(item => {
        menuMap[item.menu_id] = {
          ...item,
          children: Array.isArray(item.children) ? [...item.children] : []
        };
      });

      const menuTree = [];

      menuData.forEach(item => {
        const parent = menuMap[item.parent_id];
        if (parent) {
          parent.children.push(menuMap[item.menu_id]);
        } else {
          menuTree.push(menuMap[item.menu_id]);
        }
      });

      return menuTree;
    }
  }
};
</script>

<style lang="scss" scoped>
.el-menu {
  border-right: none;
}
</style>