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
    <div style="height: 60px; line-height: 60px; text-align: center" @click="goToHome">
      <img src="../assets/logo.svg" alt="" style="width: 20px; position: relative; top: 5px; margin-right: 5px" />
      <b style="color: #fff; cursor: pointer" v-show="logoTextShow">后台管理系统</b>
    </div>
    <!-- 菜单内容 -->
    <template v-if="!loading && menus.length > 0">
      <MenuTree :menus="menus" />
    </template>
    <template v-else-if="loading">
      <div style="padding: 20px; text-align: center; color: #fff;">
        {{ $t('common.loading') }}...
      </div>
    </template>
    <template v-else>
      <div style="padding: 20px; text-align: center; color: #fff;">
        {{ $t('common.noData') }}
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
     * 加载菜单数据：根据用户角色权限过滤菜单
     */
    async loadMenuData() {
      try {
        // 获取用户信息
        const userInfo = this.getUserInfo();
        if (!userInfo || !userInfo.roles || userInfo.roles.length === 0) {
          console.warn('用户未登录或无角色信息');
          this.menus = [];
          this.loading = false;
          return;
        }

        // 获取所有菜单数据
        const menuResponse = await axios.get('http://localhost:3000/sys_menu');
        if (!menuResponse.data || !Array.isArray(menuResponse.data)) {
          this.menus = [];
          this.loading = false;
          return;
        }

        // 获取用户角色对应的菜单权限
        const userMenuIds = await this.getUserMenuIds(userInfo.roles);
        
        // 过滤用户有权限的菜单
        const authorizedMenus = menuResponse.data.filter(menu => {
          return menu && 
                 menu.visible === '0' && 
                 menu.status === '0' && 
                 userMenuIds.includes(menu.menu_id);
        });
        
        // 构建菜单树
        this.menus = this.buildMenuTree(authorizedMenus);
      } catch (error) {
        console.error('加载菜单数据失败:', error);
        // 使用本地菜单数据作为备选
        this.menus = this.getLocalMenuData();
      } finally {
        this.loading = false;
      }
    },

    /**
     * 获取用户信息
     */
    getUserInfo() {
      try {
        let userInfo = localStorage.getItem('employee');
        if (!userInfo) {
          userInfo = sessionStorage.getItem('employee');
        }
        return userInfo ? JSON.parse(userInfo) : null;
      } catch (error) {
        console.error('获取用户信息失败:', error);
        return null;
      }
    },

    /**
     * 获取用户角色对应的菜单ID列表
     */
    async getUserMenuIds(roles) {
      try {
        const menuIds = new Set();
        
        // 遍历用户的所有角色
        for (const role of roles) {
          const roleMenuResponse = await axios.get(`http://localhost:3000/sys_role_menu?role_id=${role.role_id}`);
          if (roleMenuResponse.data && Array.isArray(roleMenuResponse.data)) {
            roleMenuResponse.data.forEach(roleMenu => {
              if (roleMenu && roleMenu.menu_id) {
                menuIds.add(roleMenu.menu_id);
              }
            });
          }
        }
        
        return Array.from(menuIds);
      } catch (error) {
        console.error('获取用户菜单权限失败:', error);
        return [];
      }
    },

    /**
     * 获取本地测试菜单数据（备用方案）
     */
    getLocalMenuData() {
      return [
        { menu_id: 1, menu_name: '后台管理系统', path: '/home', icon: 'HomeFilled', parent_id: 0, menu_type: 'C' },
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

    /**
     * 点击管理后台标题跳转到首页
     */
    goToHome() {
      this.$router.push('/home');
    },
  }
};
</script>

<style lang="scss" scoped>
.el-menu {
  border-right: none;
}
</style>