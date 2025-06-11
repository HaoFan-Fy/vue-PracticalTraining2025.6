<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h2>管理后台系统</h2>
        <p>欢迎登录</p>
      </div>
      
      <el-form
        ref="loginForm"
        :model="loginData"
        :rules="loginRules"
        class="login-form"
        @keyup.enter="handleLogin"
      >
        <el-form-item prop="username">
          <el-input
            v-model="loginData.username"
            placeholder="请输入用户名"
            prefix-icon="User"
            size="large"
          />
        </el-form-item>
        
        <el-form-item prop="password">
          <el-input
            v-model="loginData.password"
            type="password"
            placeholder="请输入密码"
            prefix-icon="Lock"
            size="large"
            show-password
          />
        </el-form-item>
        
        <el-form-item>
          <el-checkbox v-model="loginData.rememberMe">记住我</el-checkbox>
        </el-form-item>
        <el-form-item>
          <el-button
            type="primary"
            size="large"
            class="login-btn"
            :loading="loading"
            @click="handleLogin"
          >
            {{ loading ? '登录中...' : '登录' }}
          </el-button>
        </el-form-item>
      </el-form>
      
      <div class="form-footer">
        <div class="footer-links">
          <el-link type="primary" @click="forgotPassword">忘记密码？</el-link>
          <span class="separator">| </span>
          <el-link type="primary" @click="goToChangePassword">修改密码</el-link>
          <span class="separator">| </span>
          <el-link type="primary" @click="goToRegister">立即注册</el-link>
        </div>
      </div>
      
      <!-- <div class="login-footer">
        <p>测试账号：admin / admin123</p>
        <p>普通用户：user / user123</p>
      </div> -->
    </div>
  </div>
</template>

<script>
import { ElMessage } from 'element-plus'

export default {
  name: 'Login',
  data() {
    return {
      loading: false,
      loginData: {
        username: '',
        password: '',
        rememberMe: true // 记住我，默认勾选
      },
      loginRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 2, max: 20, message: '用户名长度在 2 到 20 个字符', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    /**
     * 忘记密码跳转
     */
    forgotPassword() {
      this.$message.info('请联系管理员重置密码');
    },
    /**
     * 跳转到修改密码页面
     */
    goToChangePassword() {
      this.$router.push('/change-password');
    },
    /**
     * 跳转到注册页面
     */
    goToRegister() {
      this.$router.push('/register');
    },
    /**
     * 处理用户登录
     */
    async handleLogin() {
      try {
        // 表单验证
        await this.$refs.loginForm.validate()
        
        this.loading = true
        
        // 从数据库查找用户
        const userResponse = await this.$http.get(`/sys_user?user_name=${this.loginData.username}`)
        
        if (!userResponse.data || userResponse.data.length === 0) {
          ElMessage.error('用户名不存在')
          return
        }
        
        const user = userResponse.data[0]
        
        // 验证密码（直接比较数据库中的密码）
        // 数据库中的密码是明文存储的，直接比较
        if (this.loginData.password !== user.password) {
          ElMessage.error('密码错误')
          return
        }
        
        // 检查用户状态
        if (user.status !== '0') {
          ElMessage.error('账户已被禁用')
          return
        }
        
        // 获取用户角色信息
        const userRoleResponse = await this.$http.get(`/sys_user_role?user_id=${user.user_id}`)
        let userRoles = []
        let roleNames = []
        let userPermissions = []
        
        if (userRoleResponse.data && userRoleResponse.data.length > 0) {
          // 获取角色详细信息和权限
          for (const userRole of userRoleResponse.data) {
            const roleResponse = await this.$http.get(`/sys_role?role_id=${userRole.role_id}`)
            if (roleResponse.data && roleResponse.data.length > 0) {
              userRoles.push(roleResponse.data[0])
              roleNames.push(roleResponse.data[0].role_name)
              
              // 获取角色对应的菜单权限
              const roleMenuResponse = await this.$http.get(`/sys_role_menu?role_id=${userRole.role_id}`)
              if (roleMenuResponse.data && roleMenuResponse.data.length > 0) {
                for (const roleMenu of roleMenuResponse.data) {
                  const menuResponse = await this.$http.get(`/sys_menu?menu_id=${roleMenu.menu_id}`)
                  if (menuResponse.data && menuResponse.data.length > 0) {
                    const menu = menuResponse.data[0]
                    if (menu.perms) {
                      userPermissions.push(menu.perms)
                    }
                  }
                }
              }
            }
          }
        }
        
        // 去重权限
        userPermissions = [...new Set(userPermissions)]
        
        // 生成token（实际项目中应该由后端生成）
        const token = `jwt-token-${user.user_id}-${Date.now()}`
        
        // 保存用户信息到localStorage或sessionStorage
        const userInfo = {
          userId: user.user_id,
          username: user.user_name,
          employeename: user.nick_name || user.user_name,
          email: user.email,
          phone: user.phonenumber,
          deptId: user.dept_id,
          roles: userRoles,
          roleNames: roleNames,
          permissions: userPermissions,
          token: token
        }
        
        if (this.loginData.rememberMe) {
          localStorage.setItem('employee', JSON.stringify(userInfo))
          localStorage.setItem('token', token)
        } else {
          sessionStorage.setItem('employee', JSON.stringify(userInfo))
          sessionStorage.setItem('token', token)
        }
        
        ElMessage.success(`登录成功！欢迎您，${user.nick_name || user.user_name}${roleNames.length > 0 ? '（' + roleNames.join('、') + '）' : ''}`)
        
        // 跳转到主页
        this.$router.push('/home')
        
      } catch (error) {
        console.error('登录错误:', error)
        ElMessage.error('登录失败，请检查网络连接')
      } finally {
        this.loading = false
      }
    }
  }
}
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.login-box {
  width: 400px;
  background: white;
  border-radius: 10px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
  padding: 40px;
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
}

.login-header h2 {
  color: #333;
  margin-bottom: 10px;
  font-size: 28px;
  font-weight: 600;
}

.login-header p {
  color: #666;
  font-size: 16px;
  margin: 0;
}

.login-form {
  margin-bottom: 20px;
}

.login-form .el-form-item {
  margin-bottom: 20px;
}

.login-btn {
  width: 100%;
  height: 45px;
  font-size: 16px;
  font-weight: 600;
}

.login-footer {
  text-align: center;
  color: #999;
  font-size: 14px;
  line-height: 1.5;
}

.login-footer p {
  margin: 5px 0;
}

/* 响应式设计 */
@media (max-width: 480px) {
  .login-box {
    width: 100%;
    padding: 30px 20px;
  }
  
  .login-header h2 {
    font-size: 24px;
  }
}
</style>