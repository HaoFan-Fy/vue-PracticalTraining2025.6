<template>
  <div>
    <el-container style="min-height: 100vh">
      <!--    侧边栏    -->
      <el-aside
        :width="sideWidth + 'px'"
        style="box-shadow: 2px 0 6px rgb(0 21 41 / 35%)"
      >
        <Aside :isCollapse="isCollapse" :logoTextShow="logoTextShow" />
      </el-aside>
      <!--    顶部栏    -->
      <el-container>
        <el-header style="border-bottom: 1px solid #ccc">
          <Header
            :collapseBtnClass="collapseBtnClass"
            @asideCollapse="collapse"
            :employee="employee"
          />
        </el-header>
        <!--主体-->
        <el-main>
          <router-view/>
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script>
import Aside from './Aside.vue'
import Header from './Header.vue'

export default {
  name: 'Layout',
  components: {
    Aside,
    Header
  },
  data() {
    return {
      isCollapse: false,
      sideWidth: 180,
      logoTextShow: true,
      employee: null
    };
  },
  computed: {
    /**
     * 计算侧边栏折叠按钮的样式类
     * @returns {string} 按钮样式类名
     */
    collapseBtnClass() {
      return this.isCollapse ? 'el-icon-s-unfold' : 'el-icon-s-fold';
    }
  },
  methods: {
    /**
     * 切换侧边栏折叠状态
     */
    collapse() {
      this.isCollapse = !this.isCollapse;
      this.sideWidth = this.isCollapse ? 64 : 180;
      this.logoTextShow = !this.isCollapse;
    }
  },
  mounted() {
    // 从localStorage获取用户信息
    const employeeData = localStorage.getItem('employee');
    if (employeeData) {
      this.employee = JSON.parse(employeeData);
    }
  }
};
</script>

<style>
.el-aside {
  color: #333;
}
</style>