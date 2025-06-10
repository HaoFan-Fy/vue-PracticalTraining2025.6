<template>
  <el-menu
    style="min-height: 100%; overflow-x: hidden"
    background-color="#333744"
    text-color="#fff"
    active-text-color="#ffd04b"
    :collapse-transition="false"
    :collapse="isCollapse"
    :default-active="$route.path"
    router
  >
    <!-- Logo区域 -->
    <div style="height: 60px; line-height: 60px; text-align: center">
      <img src="../assets/logo.svg" alt="" style="width: 20px; position: relative; top: 5px; margin-right: 5px" />
      <b style="color: #fff; cursor: pointer" v-show="logoTextShow" @click="goToHome">管理后台</b>
    </div>
    <!-- 菜单内容 -->
    <template v-if="!loading && menus.length > 0">
      <MenuTree :menus="menus" />
    </template>
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
import cloneDeep from 'lodash.clonedeep';
import MenuTree from './MenuTree.vue';

export default {
  name: "Aside",
  components: { MenuTree },
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
     * 构建菜单树结构
     * @param {Array} menuData 菜单数据数组
     * @returns {Array} 树形结构的菜单数据
     */
    buildMenuTree(menuData) {
      if (!Array.isArray(menuData) || menuData.length === 0) {
        return [];
      }
      
      // 创建菜单映射表
      const menuMap = {};
      menuData.forEach(item => {
        if (!item) return;
        menuMap[item.menu_id] = {
          ...item,
          children: []
        };
      });
      
      // 构建树形结构
      const menuTree = [];
      menuData.forEach(item => {
        if (!item) return;
        
        const currentNode = menuMap[item.menu_id];
        if (item.parent_id && menuMap[item.parent_id]) {
          // 有父节点，添加到父节点的children中
          menuMap[item.parent_id].children.push(currentNode);
        } else {
          // 没有父节点或父节点不存在，作为根节点
          menuTree.push(currentNode);
        }
      });
      
      return menuTree.filter(Boolean);
    },

    /**
     * 加载菜单数据：优先从API获取，失败则使用本地数据
     */
    async loadMenuData() {
      try {
        const response = await axios.get('http://localhost:3000/sys_menu');
        console.log('API响应数据:', response.data);

        let tree = [];
        if (response.data && response.data.length > 0) {
          tree = this.buildMenuTree(response.data);
        } else {
          console.log('API返回空数据，使用本地测试菜单');
          tree = this.buildMenuTree(this.getLocalMenuData());
        }
        this.menus = cloneDeep(tree); // 使用深拷贝保证响应性
      } catch (error) {
        console.warn('无法从API获取菜单数据，使用本地数据:', error);
        const localTree = this.buildMenuTree(this.getLocalMenuData());
        this.menus = cloneDeep(localTree);
      } finally {
        this.loading = false;
      }
    },

    /**
     * 获取本地测试菜单数据（备用方案）
     */
    getLocalMenuData() {
      return [
        { menu_id: 1, menu_name: '首页', path: '/home', icon: 'House', parent_id: 0, menu_type: 'C' },
        { menu_id: 2, menu_name: '系统管理', path: '/system', icon: 'Setting', parent_id: 0, menu_type: 'M' },
        { menu_id: 21, menu_name: '用户管理', path: '/system/user', icon: 'User', parent_id: 2, menu_type: 'C' },
        { menu_id: 22, menu_name: '角色管理', path: '/system/role', icon: 'UserFilled', parent_id: 2, menu_type: 'C' },
        { menu_id: 23, menu_name: '菜单管理', path: '/system/menu', icon: 'Menu', parent_id: 2, menu_type: 'C' },
        { menu_id: 24, menu_name: '部门管理', path: '/system/dept', icon: 'OfficeBuilding', parent_id: 2, menu_type: 'C' },
        { menu_id: 25, menu_name: '系统监控', path: '/system/monitor', icon: 'Monitor', parent_id: 2, menu_type: 'C' },
        { menu_id: 26, menu_name: '系统工具', path: '/system/tool', icon: 'Tools', parent_id: 2, menu_type: 'C' },
        { menu_id: 3, menu_name: '测试页面', path: '/test', icon: 'Document', parent_id: 0, menu_type: 'C' }
      ];
    },
  }
};
</script>

<style lang="scss" scoped>
.el-menu {
  border-right: none;
}
</style>