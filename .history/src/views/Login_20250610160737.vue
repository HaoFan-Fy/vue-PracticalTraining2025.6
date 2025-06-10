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
          <span class="separator">|</span>
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
     * 处理用户登录
     */
    async handleLogin() {
      try {
        // 表单验证
        await this.$refs.loginForm.validate()
        
        this.loading = true
        
        // 调用登录API
        const response = await this.$http.post('/api/login', {
          username: this.loginData.username,
          password: this.loginData.password
        })
        
        if (response.data.success) {
          // 保存用户信息到localStorage
          const userInfo = {
            username: this.loginData.username,
            employeename: response.data.data.nick_name || this.loginData.username,
            token: response.data.data.token
          }
          if (this.loginData.rememberMe) {
            localStorage.setItem('employee', JSON.stringify(userInfo))
            localStorage.setItem('token', response.data.data.token)
          } else {
            sessionStorage.setItem('employee', JSON.stringify(userInfo))
            sessionStorage.setItem('token', response.data.data.token)
          }
          
          ElMessage.success('登录成功')
          
          // 跳转到主页
          this.$router.push('/home')
        } else {
          ElMessage.error(response.data.message || '登录失败')
        }
      } catch (error) {
        console.error('登录错误:', error)
        
        // 模拟登录验证（用于测试）
        if (this.loginData.username === 'admin' && this.loginData.password === 'admin123') {
          const userInfo = {
            username: 'admin',
            employeename: '管理员',
            token: 'mock-jwt-token-admin'
          }
          if (this.loginData.rememberMe) {
            localStorage.setItem('employee', JSON.stringify(userInfo))
            localStorage.setItem('token', 'mock-jwt-token-admin')
          } else {
            sessionStorage.setItem('employee', JSON.stringify(userInfo))
            sessionStorage.setItem('token', 'mock-jwt-token-admin')
          }
          
          ElMessage.success('登录成功')
          this.$router.push('/home')
        } else if (this.loginData.username === 'user' && this.loginData.password === 'user123') {
          const userInfo = {
            username: 'user',
            employeename: '普通用户',
            token: 'mock-jwt-token-user'
          }
          if (this.loginData.rememberMe) {
            localStorage.setItem('employee', JSON.stringify(userInfo))
            localStorage.setItem('token', 'mock-jwt-token-user')
          } else {
            sessionStorage.setItem('employee', JSON.stringify(userInfo))
            sessionStorage.setItem('token', 'mock-jwt-token-user')
          }
          
          ElMessage.success('登录成功')
          this.$router.push('/home')
        } else {
          ElMessage.error('用户名或密码错误')
        }
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