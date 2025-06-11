<template>
  <div class="change-password-container">
    <div class="change-password-box">
      <div class="change-password-header">
        <h2>修改密码</h2>
        <p>请输入相关信息修改您的密码</p>
      </div>
      
      <el-form
        ref="changePasswordForm"
        :model="formData"
        :rules="formRules"
        class="change-password-form"
        @keyup.enter="handleSubmit"
      >
        <el-form-item prop="username">
          <el-input
            v-model="formData.username"
            placeholder="请输入账号"
            prefix-icon="User"
            size="large"
          />
        </el-form-item>
        
        <el-form-item prop="oldPassword">
          <el-input
            v-model="formData.oldPassword"
            type="password"
            placeholder="请输入原密码"
            prefix-icon="Lock"
            size="large"
            show-password
          />
        </el-form-item>
        
        <el-form-item prop="newPassword">
          <el-input
            v-model="formData.newPassword"
            type="password"
            placeholder="请输入新密码"
            prefix-icon="Lock"
            size="large"
            show-password
          />
        </el-form-item>
        
        <el-form-item prop="confirmPassword">
          <el-input
            v-model="formData.confirmPassword"
            type="password"
            placeholder="请再次输入新密码"
            prefix-icon="Lock"
            size="large"
            show-password
          />
        </el-form-item>
        
        <el-form-item prop="captcha">
          <div class="captcha-container">
            <el-input
              v-model="formData.captcha"
              placeholder="请输入验证码"
              prefix-icon="Picture"
              size="large"
              style="flex: 1; margin-right: 10px;"
            />
            <div class="captcha-code" @click="generateCaptcha">
              {{ captchaCode }}
            </div>
          </div>
        </el-form-item>
        
        <el-form-item>
          <el-button
            type="primary"
            size="large"
            class="change-password-btn"
            :loading="loading"
            @click="handleSubmit"
          >
            {{ loading ? '修改中...' : '确认修改' }}
          </el-button>
        </el-form-item>
      </el-form>
      
      <div class="form-footer">
        <div class="footer-links">
          <el-link type="primary" @click="goToLogin">返回登录</el-link>
          <span class="separator">| </span>
          <el-link type="primary" @click="handleReset">重置表单</el-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ElMessage } from 'element-plus'

export default {
  name: 'ChangePassword',
  data() {
    // 自定义验证规则：确认密码
    const validateConfirmPassword = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请再次输入新密码'))
      } else if (value !== this.formData.newPassword) {
        callback(new Error('两次输入的密码不一致'))
      } else {
        callback()
      }
    }
    
    // 自定义验证规则：验证码
    const validateCaptcha = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请输入验证码'))
      } else if (value.toLowerCase() !== this.captchaCode.toLowerCase()) {
        callback(new Error('验证码错误'))
      } else {
        callback()
      }
    }
    
    return {
      loading: false,
      captchaCode: '',
      formData: {
        username: '',
        oldPassword: '',
        newPassword: '',
        confirmPassword: '',
        captcha: ''
      },
      formRules: {
        username: [
          { required: true, message: '请输入账号', trigger: 'blur' },
          { min: 2, max: 20, message: '账号长度在 2 到 20 个字符', trigger: 'blur' }
        ],
        oldPassword: [
          { required: true, message: '请输入原密码', trigger: 'blur' },
          { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
        ],
        newPassword: [
          { required: true, message: '请输入新密码', trigger: 'blur' },
          { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' },
          { pattern: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{6,}$/, message: '密码必须包含大小写字母和数字', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请再次输入新密码', trigger: 'blur' },
          { validator: validateConfirmPassword, trigger: 'blur' }
        ],
        captcha: [
          { required: true, message: '请输入验证码', trigger: 'blur' },
          { validator: validateCaptcha, trigger: 'blur' }
        ]
      }
    }
  },
  mounted() {
    this.generateCaptcha()
  },
  methods: {
    /**
     * 生成4位随机验证码（包含大小写字母和数字）
     */
    generateCaptcha() {
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
      let result = ''
      for (let i = 0; i < 4; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length))
      }
      this.captchaCode = result
    },
    
    /**
     * 获取用户信息
     */
    getUserInfo() {
      try {
        const userInfo = localStorage.getItem('userInfo') || sessionStorage.getItem('userInfo')
        return userInfo ? JSON.parse(userInfo) : null
      } catch (error) {
        console.error('获取用户信息失败:', error)
        return null
      }
    },
    
    /**
     * 提交修改密码表单
     */
    async handleSubmit() {
      try {
        // 表单验证
        await this.$refs.changePasswordForm.validate()
        
        this.loading = true
        
        // 模拟API调用
        await new Promise(resolve => setTimeout(resolve, 1500))
        
        // 获取所有用户数据
        const response = await fetch('http://localhost:3000/users')
        const users = await response.json()
        
        // 查找用户
        const user = users.find(u => u.username === this.formData.username)
        
        if (!user) {
          ElMessage.error('用户不存在')
          return
        }
        
        // 验证原密码
        if (user.password !== this.formData.oldPassword) {
          ElMessage.error('原密码错误')
          return
        }
        
        // 更新密码
        const updateResponse = await fetch(`http://localhost:3000/users/${user.id}`, {
          method: 'PATCH',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            password: this.formData.newPassword
          })
        })
        
        if (updateResponse.ok) {
          ElMessage.success('密码修改成功！')
          // 清空表单
          this.handleReset()
          // 3秒后跳转到登录页
          setTimeout(() => {
            this.goToLogin()
          }, 3000)
        } else {
          ElMessage.error('密码修改失败，请重试')
        }
        
      } catch (error) {
        console.error('修改密码失败:', error)
        ElMessage.error('修改密码失败，请检查网络连接')
      } finally {
        this.loading = false
      }
    },
    
    /**
     * 重置表单
     */
    handleReset() {
      this.$refs.changePasswordForm.resetFields()
      this.generateCaptcha()
    },
    
    /**
     * 返回登录页面
     */
    goToLogin() {
      this.$router.push('/login')
    }
  }
}
</script>

<style scoped>
.change-password-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.change-password-box {
  background: white;
  border-radius: 10px;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
  padding: 40px;
  width: 100%;
  max-width: 400px;
  position: relative;
}

.change-password-header {
  text-align: center;
  margin-bottom: 30px;
}

.change-password-header h2 {
  color: #333;
  font-size: 28px;
  font-weight: 600;
  margin: 0 0 10px 0;
}

.change-password-header p {
  color: #666;
  font-size: 14px;
  margin: 0;
}

.change-password-form {
  margin-bottom: 20px;
}

.change-password-form .el-form-item {
  margin-bottom: 20px;
}

.change-password-btn {
  width: 100%;
  height: 45px;
  font-size: 16px;
  font-weight: 500;
  border-radius: 6px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  transition: all 0.3s ease;
}

.change-password-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
}

.captcha-container {
  display: flex;
  align-items: center;
  width: 100%;
}

.captcha-code {
  width: 80px;
  height: 40px;
  background: #f5f7fa;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  font-weight: bold;
  color: #409eff;
  cursor: pointer;
  user-select: none;
  transition: all 0.3s ease;
}

.captcha-code:hover {
  background: #ecf5ff;
  border-color: #409eff;
}

.form-footer {
  text-align: center;
  margin-top: 20px;
}

.footer-links {
  font-size: 14px;
  color: #666;
}

.separator {
  margin: 0 8px;
  color: #ddd;
}

/* 响应式设计 */
@media (max-width: 480px) {
  .change-password-container {
    padding: 10px;
  }
  
  .change-password-box {
    padding: 30px 20px;
  }
  
  .change-password-header h2 {
    font-size: 24px;
  }
}
</style>