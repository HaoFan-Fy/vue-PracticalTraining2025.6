<template>
  <div class="register-container">
    <div class="register-form">
      <div class="form-header">
        <h2>用户注册</h2>
        <p>创建您的账户</p>
      </div>
      
      <el-form
        ref="registerForm"
        :model="registerData"
        :rules="registerRules"
        label-width="0"
        size="large"
      >
        <el-form-item prop="username">
          <el-input
            v-model="registerData.username"
            placeholder="请输入用户名"
            prefix-icon="User"
          />
        </el-form-item>
        
        <el-form-item prop="email">
          <el-input
            v-model="registerData.email"
            placeholder="请输入邮箱"
            prefix-icon="Message"
          />
        </el-form-item>
        
        <el-form-item prop="phone">
          <el-input
            v-model="registerData.phone"
            placeholder="请输入手机号"
            prefix-icon="Phone"
          />
        </el-form-item>
        
        <el-form-item prop="password">
          <el-input
            v-model="registerData.password"
            type="password"
            placeholder="请输入密码"
            prefix-icon="Lock"
            show-password
          />
        </el-form-item>
        
        <el-form-item prop="confirmPassword">
          <el-input
            v-model="registerData.confirmPassword"
            type="password"
            placeholder="请确认密码"
            prefix-icon="Lock"
            show-password
          />
        </el-form-item>
        
        <el-form-item prop="agreement">
          <el-checkbox v-model="registerData.agreement">
            我已阅读并同意
            <el-link type="primary" @click="showAgreement">《用户协议》</el-link>
            和
            <el-link type="primary" @click="showPrivacy">《隐私政策》</el-link>
          </el-checkbox>
        </el-form-item>
        
        <el-form-item>
          <el-button
            type="primary"
            :loading="loading"
            @click="handleRegister"
            style="width: 100%"
          >
            注册
          </el-button>
        </el-form-item>
        
        <div class="form-footer">
          <span>已有账户？</span>
          <el-link type="primary" @click="goToLogin">立即登录</el-link>
        </div>
      </el-form>
    </div>
    
    <!-- 用户协议对话框 -->
    <el-dialog
      v-model="agreementVisible"
      title="用户协议"
      width="600px"
    >
      <div class="agreement-content">
        <h3>1. 服务条款</h3>
        <p>欢迎使用我们的管理系统。在使用本系统前，请仔细阅读以下条款。</p>
        
        <h3>2. 用户责任</h3>
        <p>用户应当妥善保管账户信息，不得将账户借给他人使用。</p>
        
        <h3>3. 隐私保护</h3>
        <p>我们承诺保护用户的个人信息安全，不会泄露给第三方。</p>
        
        <h3>4. 服务变更</h3>
        <p>我们保留随时修改或终止服务的权利。</p>
      </div>
      
      <template #footer>
        <el-button @click="agreementVisible = false">关闭</el-button>
      </template>
    </el-dialog>
    
    <!-- 隐私政策对话框 -->
    <el-dialog
      v-model="privacyVisible"
      title="隐私政策"
      width="600px"
    >
      <div class="privacy-content">
        <h3>1. 信息收集</h3>
        <p>我们只收集必要的用户信息，用于提供更好的服务。</p>
        
        <h3>2. 信息使用</h3>
        <p>收集的信息仅用于系统功能实现，不会用于其他商业目的。</p>
        
        <h3>3. 信息保护</h3>
        <p>我们采用先进的安全技术保护用户信息。</p>
        
        <h3>4. 信息共享</h3>
        <p>除法律要求外，我们不会与第三方共享用户信息。</p>
      </div>
      
      <template #footer>
        <el-button @click="privacyVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ElMessage } from 'element-plus'

export default {
  name: 'Register',
  data() {
    // 确认密码验证
    const validateConfirmPassword = (rule, value, callback) => {
      if (value !== this.registerData.password) {
        callback(new Error('两次输入密码不一致'))
      } else {
        callback()
      }
    }
    
    // 协议验证
    const validateAgreement = (rule, value, callback) => {
      if (!value) {
        callback(new Error('请先同意用户协议和隐私政策'))
      } else {
        callback()
      }
    }
    
    return {
      loading: false,
      agreementVisible: false,
      privacyVisible: false,
      registerData: {
        username: '',
        email: '',
        phone: '',
        password: '',
        confirmPassword: '',
        agreement: false
      },
      registerRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 2, max: 20, message: '用户名长度在 2 到 20 个字符', trigger: 'blur' },
          { pattern: /^[a-zA-Z0-9_\u4e00-\u9fa5]+$/, message: '用户名只能包含字母、数字、下划线和中文', trigger: 'blur' }
        ],
        email: [
          { required: true, message: '请输入邮箱', trigger: 'blur' },
          { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
        ],
        phone: [
          { required: true, message: '请输入手机号', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' },
          { pattern: /^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{6,}$/, message: '密码必须包含字母和数字', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请确认密码', trigger: 'blur' },
          { validator: validateConfirmPassword, trigger: 'blur' }
        ],
        agreement: [
          { validator: validateAgreement, trigger: 'change' }
        ]
      }
    }
  },
  methods: {
    /**
     * 处理注册
     */
    async handleRegister() {
      try {
        await this.$refs.registerForm.validate()
        
        this.loading = true
        
        // 检查用户名是否已存在
        const checkResponse = await this.$http.get(`/sys_user?user_name=${this.registerData.username}`)
        if (checkResponse.data && checkResponse.data.length > 0) {
          ElMessage.error('用户名已存在')
          return
        }
        
        // 检查邮箱是否已存在
        const emailCheckResponse = await this.$http.get(`/sys_user?email=${this.registerData.email}`)
        if (emailCheckResponse.data && emailCheckResponse.data.length > 0) {
          ElMessage.error('邮箱已被注册')
          return
        }
        
        // 检查手机号是否已存在
        const phoneCheckResponse = await this.$http.get(`/sys_user?phonenumber=${this.registerData.phone}`)
        if (phoneCheckResponse.data && phoneCheckResponse.data.length > 0) {
          ElMessage.error('手机号已被注册')
          return
        }
        
        // 创建用户数据
        const userData = {
          user_name: this.registerData.username,
          nick_name: this.registerData.username,
          email: this.registerData.email,
          phonenumber: this.registerData.phone,
          password: this.registerData.password,
          status: '0',
          dept_id: 1, // 默认部门
          create_time: new Date().toISOString().slice(0, 19).replace('T', ' ')
        }
        
        // 调用注册API
        const userResponse = await this.$http.post('/sys_user', userData)
        const newUserId = userResponse.data.id
        
        // 为新用户分配默认角色（普通角色，role_id: 2）
        await this.$http.post('/sys_user_role', {
          user_id: newUserId,
          role_id: 2
        })
        
        ElMessage.success('注册成功！请登录')
        
        // 跳转到登录页面
        this.$router.push('/login')
        
      } catch (error) {
        console.error('注册失败:', error)
        ElMessage.error('注册失败，请重试')
      } finally {
        this.loading = false
      }
    },
    
    /**
     * 跳转到登录页面
     */
    goToLogin() {
      this.$router.push('/login')
    },
    
    /**
     * 显示用户协议
     */
    showAgreement() {
      this.agreementVisible = true
    },
    
    /**
     * 显示隐私政策
     */
    showPrivacy() {
      this.privacyVisible = true
    }
  }
}
</script>

<style scoped>
.register-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
}

.register-form {
  width: 100%;
  max-width: 400px;
  background: white;
  border-radius: 10px;
  padding: 40px;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
}

.form-header {
  text-align: center;
  margin-bottom: 30px;
}

.form-header h2 {
  color: #333;
  margin-bottom: 10px;
  font-size: 28px;
  font-weight: 600;
}

.form-header p {
  color: #666;
  font-size: 14px;
  margin: 0;
}

.el-form-item {
  margin-bottom: 20px;
}

.form-footer {
  text-align: center;
  margin-top: 20px;
  color: #666;
  font-size: 14px;
}

.agreement-content,
.privacy-content {
  max-height: 400px;
  overflow-y: auto;
  line-height: 1.6;
}

.agreement-content h3,
.privacy-content h3 {
  color: #333;
  margin-top: 20px;
  margin-bottom: 10px;
}

.agreement-content p,
.privacy-content p {
  color: #666;
  margin-bottom: 15px;
}

/* 响应式设计 */
@media (max-width: 480px) {
  .register-form {
    padding: 30px 20px;
  }
  
  .form-header h2 {
    font-size: 24px;
  }
}
</style>