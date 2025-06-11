<template>
  <div style="
      line-height: 40px;
      display: flex;
      justify-items: center;
      align-items: center;
    ">
    <!-- 左边部分 -->
    <div style="flex: 1; display: flex;">
      <div style="cursor: pointer; padding-top: 3px" @click="collapse">
        <el-icon size="20px" v-if="collapseBtnClass === 'el-icon-s-fold'">
          <ArrowLeft />
        </el-icon>
        <el-icon size="20px" v-else>
          <ArrowRight />
        </el-icon>
      </div>
      <span style="font-size: 18px; margin-left: 6px">{{ $t('header.currentTime') }}{{ nowDate }}</span>
    </div>

    <!-- 语言切换 -->
    <el-switch 
      v-model="langValue" 
      class="mx" 
      active-text="English" 
      inactive-text="中文" 
      @change="switchLang" 
      style="margin-right: 20px;"
    />

    <!-- 全屏按钮 -->
    <div id="full-screen" style="
        margin-right: 20px;
        cursor: pointer;
        display: flex;
        align-items: center;
      ">
      <el-icon :size="20" style="margin-right: 3px" @click="fullScreen()">
        <FullScreen />
      </el-icon>
      <span>{{ $t('header.fullScreen') }}</span>
    </div>

    <!-- 个人中心 -->
    <el-dropdown style="width: 100px; cursor: pointer" trigger="click">
      <span class="el-dropdown-link" style="display: flex; align-items: center">
        {{ employee?.employeename || $t('header.user') }}
        <el-icon :size="20" style="margin-left: 8px">
          <Setting />
        </el-icon>
      </span>
      <template #dropdown>
        <el-dropdown-menu style="padding-left: 8px; width: 100px; text-align: center">
          <el-dropdown-item style="font-size: 14px; padding: 5px 0">
            <span @click="person">{{ $t('header.personalCenter') }}</span>
          </el-dropdown-item>
          <el-dropdown-item style="font-size: 14px; padding: 5px 0">
            <span @click="updatePass">{{ $t('header.changePassword') }}</span>
          </el-dropdown-item>
          <el-dropdown-item style="font-size: 14px; padding: 5px 0">
            <span @click="logout">{{ $t('header.logout') }}</span>
          </el-dropdown-item>
        </el-dropdown-menu>
      </template>
    </el-dropdown>
  </div>
</template>

<script>
import dayjs from 'dayjs'
import screenfull from 'screenfull'

export default {
  name: 'Header',
  props: {
    collapseBtnClass: String,
    employee: Object
  },
  emits: ['asideCollapse'],
  data() {
    return {
      nowDate: '',
      langValue: false, // false表示中文，true表示英文
      timer: null
    };
  },
  mounted() {
    this.updateTime();
    // 每秒更新时间
    this.timer = setInterval(this.updateTime, 1000);
  },
  beforeUnmount() {
    if (this.timer) {
      clearInterval(this.timer);
    }
  },
  methods: {
    /**
     * 触发侧边栏折叠事件
     */
    collapse() {
      this.$emit('asideCollapse');
    },

    /**
     * 更新当前时间显示
     */
    updateTime() {
      this.nowDate = dayjs().format('YYYY-MM-DD HH:mm:ss');
    },

    /**
     * 切换语言
     * @param {boolean} value 语言切换值
     */
    switchLang(value) {
      const lang = value ? 'en' : 'zh';
      console.log('切换语言到:', lang);
      // 切换i18n语言
      this.$i18n.locale = lang;
      // 保存语言设置到本地存储
      localStorage.setItem('language', lang);
      this.$message.success(this.$t('messages.languageSwitched'));
    },

    /**
     * 全屏切换功能
     */
    fullScreen() {
      if (screenfull.isEnabled) {
        screenfull.toggle();
        const isFullscreen = screenfull.isFullscreen;
        this.$message.success(isFullscreen ? this.$t('messages.fullScreenEntered') : this.$t('messages.fullScreenExited'));
      } else {
        this.$message.warning(this.$t('messages.browserNotSupported'));
      }
    },

    /**
     * 个人中心
     */
    person() {
      this.$message.info('个人中心功能开发中...');
      // 这里可以跳转到个人中心页面
      // this.$router.push('/profile');
    },

    /**
     * 修改密码
     */
    updatePass() {
      this.$router.push('/change-password');
    },

    /**
     * 退出登录
     */
    logout() {
      this.$confirm('确定要退出登录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        // 清除本地存储的用户信息
        localStorage.removeItem('employee');
        localStorage.removeItem('token');
        localStorage.removeItem('menus');
        
        // 同时清除sessionStorage中的用户信息
        sessionStorage.removeItem('employee');
        sessionStorage.removeItem('token');
        sessionStorage.removeItem('menus');
        
        this.$message.success('退出登录成功');
        
        // 跳转到登录页面
        this.$router.push('/login');
      }).catch(() => {
        this.$message.info('已取消退出');
      });
    }
  }
};
</script>

<style scoped>
.el-dropdown-link {
  cursor: pointer;
  color: var(--el-color-primary);
  display: flex;
  align-items: center;
}

.mx {
  margin: 0 10px;
}
</style>