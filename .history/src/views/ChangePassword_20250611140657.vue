<template>
  <div class="change-password-container">
    <el-card class="change-password-card">
      <template #header>
        <div class="card-header">
          <span>修改密码</span>
        </div>
      </template>
      
      <el-form
        ref="changePasswordForm"
        :model="formData"
        :rules="formRules"
        label-width="120px"
        class="change-password-form"
      >
        <el-form-item label="账号" prop="username">
          <el-input
            v-model="formData.username"
            placeholder="请输入账号"
          />
        </el-form-item>
        
        <el-form-item label="原密码" prop="oldPassword">
          <el-input
            v-model="formData.oldPassword"
            type="password"
            placeholder="请输入原密码"
            show-password
          />
        </el-form-item>
        
        <el-form-item label="新密码" prop="newPassword">
          <el-input
            v-model="formData.newPassword"
            type="password"
            placeholder="请输入新密码"
            show-password
          />
        </el-form-item>
        
        <el-form-item label="确认新密码" prop="confirmPassword">
          <el-input
            v-model="formData.confirmPassword"
            type="password"
            placeholder="请再次输入新密码"
            show-password
          />
        </el-form-item>
        
        <el-form-item label="验证码" prop="captcha">
          <div class="captcha-container">
            <el-input
              v-model="formData.captcha"
              placeholder="请输入验证码"
              style="width: 200px; margin-right: 10px;"
            />
            <div class="captcha-code" @click="generateCaptcha">
              {{ captchaCode }}
            </div>
            <el-button type="text" @click="generateCaptcha">刷新</el-button>
          </div>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="handleSubmit" :loading="loading">
            {{ loading ? '修改中...' : '确认修改' }}
          </el-button>
          <el-button @click="handleReset">重置</el-button>
          <el-button @click="handleCancel">取消</el-button>
        </el-form-item>
      </el-form>
    </el-card>
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
          { required: true, message: '账号不能为空', trigger: 'blur' }
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
    this.initUserInfo()
    this.generateCaptcha()
  },
  methods: {
    /**
     * 初始化用户信息
     */
    initUserInfo() {
      const userInfo = this.getUserInfo()
      if (userInfo) {
        this.formData.username = userInfo.username || ''
      }
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
     * 生成4位验证码（英文大小写数字组成）
     */
    generateCaptcha() {
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
      let result = ''
      for (let i = 0; i < 4; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length))
      }
      this.captchaCode = result
      // 清空验证码输入
      this.formData.captcha = ''
    },
    
    /**
     * 提交修改密码
     */
    async handleSubmit() {
      try {
        await this.$refs.changePasswordForm.validate()
        
        this.loading = true
        
        // 验证原密码
        const userInfo = this.getUserInfo()
        if (!userInfo) {
          ElMessage.error('用户信息获取失败，请重新登录')
          return
        }
        
        // 查询用户信息验证原密码
        const response = await this.$http.get(`/sys_user?username=${this.formData.username}`)
        const users = response.data || []
        const currentUser = users.find(user => user.username === this.formData.username)
        
        if (!currentUser) {
          ElMessage.error('用户不存在')
          return
        }
        
        if (currentUser.password !== this.formData.oldPassword) {
          ElMessage.error('原密码错误')
          return
        }
        
        // 更新密码
        await this.$http.put(`/sys_user/${currentUser.id}`, {
          ...currentUser,
          password: this.formData.newPassword,
          update_time: new Date().toISOString().slice(0, 19).replace('T', ' ')
        })
        
        ElMessage.success('密码修改成功，请重新登录')
        
        // 清除用户信息，跳转到登录页
        localStorage.removeItem('userInfo')
        sessionStorage.removeItem('userInfo')
        
        setTimeout(() => {
          this.$router.push('/login')
        }, 1500)
        
      } catch (error) {
        console.error('修改密码失败:', error)
        if (error !== 'validation failed') {
          ElMessage.error('修改密码失败，请稍后重试')
        }
      } finally {
        this.loading = false
      }
    },
    
    /**
     * 重置表单
     */
    handleReset() {
      this.$refs.changePasswordForm.resetFields()
      this.formData.oldPassword = ''
      this.formData.newPassword = ''
      this.formData.confirmPassword = ''
      this.formData.captcha = ''
      this.generateCaptcha()
    },
    
    /**
     * 取消修改
     */
    handleCancel() {
      this.$router.go(-1)
    }
  }
}
</script>

<style scoped>
.change-password-container {
  padding: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 120px);
}

.change-password-card {
  width: 100%;
  max-width: 500px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.card-header {
  text-align: center;
  font-size: 18px;
  font-weight: bold;
  color: #303133;
}

.change-password-form {
  padding: 20px;
}

.captcha-container {
  display: flex;
  align-items: center;
}

.captcha-code {
  display: inline-block;
  width: 80px;
  height: 32px;
  line-height: 32px;
  text-align: center;
  background: linear-gradient(45deg, #f0f0f0, #e0e0e0);
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
  font-weight: bold;
  font-size: 16px;
  color: #333;
  cursor: pointer;
  user-select: none;
  margin-right: 10px;
  letter-spacing: 2px;
}

.captcha-code:hover {
  background: linear-gradient(45deg, #e0e0e0, #d0d0d0);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .change-password-container {
    padding: 10px;
  }
  
  .change-password-card {
    margin: 0;
  }
  
  .change-password-form {
    padding: 10px;
  }
  
  .captcha-container {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .captcha-container .el-input {
    margin-bottom: 10px;
    width: 100% !important;
  }
  
  .captcha-code {
    margin-right: 0;
    margin-bottom: 10px;
  }
}
</style>