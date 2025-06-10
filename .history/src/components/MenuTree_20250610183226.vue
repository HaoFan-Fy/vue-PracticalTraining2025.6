<template>
  <template v-for="menu in menus">
    <el-menu-item 
      v-if="!menu.children || menu.children.length === 0" 
      :key="menu.menu_id" 
      :index="menu.path"
      @click="handleMenuClick(menu)"
    >
      <el-icon>
        <component :is="menu.icon" />
      </el-icon>
      <span>{{ menu.menu_name }}</span>
    </el-menu-item>
    <el-sub-menu v-else :key="`submenu-${menu.menu_id}`" :index="menu.menu_id.toString()">
      <template #title>
        <el-icon>
          <component :is="menu.icon" />
        </el-icon>
        <span>{{ menu.menu_name }}</span>
      </template>
      <MenuTree :menus="menu.children" />
    </el-sub-menu>
  </template>
</template>

<script>
/**
 * 递归菜单组件，支持多级菜单渲染
 * @param {Array} menus 菜单数据数组
 */
export default {
  name: 'MenuTree',
  props: {
    menus: {
      type: Array,
      required: true
    }
  },
  methods: {
    /**
     * 处理菜单点击事件
     * @param {Object} menu 菜单项数据
     */
    handleMenuClick(menu) {
      if (menu.path && menu.path !== this.$route.path) {
        console.log('菜单跳转:', menu.menu_name, '->', menu.path);
        this.$router.push(menu.path);
      }
    }
  }
};
</script>