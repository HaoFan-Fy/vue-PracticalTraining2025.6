<template>
  <div class="user-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>用户管理</span>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>
            新增用户
          </el-button>
        </div>
      </template>
      
      <!-- 搜索区域 -->
      <div class="search-area">
        <el-form :model="searchForm" inline>
          <el-form-item label="用户名">
            <el-input
              v-model="searchForm.username"
              placeholder="请输入用户名"
              clearable
              style="width: 200px"
            />
          </el-form-item>
          <el-form-item label="状态">
            <el-select
              v-model="searchForm.status"
              placeholder="请选择状态"
              clearable
              style="width: 120px"
            >
              <el-option label="正常" value="0" />
              <el-option label="停用" value="1" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="handleSearch">
              <el-icon><Search /></el-icon>
              搜索
            </el-button>
            <el-button @click="handleReset">
              <el-icon><Refresh /></el-icon>
              重置
            </el-button>
          </el-form-item>
        </el-form>
      </div>
      
      <!-- 表格区域 -->
      <el-table
        v-loading="loading"
        :data="tableData"
        style="width: 100%"
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="user_id" label="用户ID" width="80" />
        <el-table-column prop="user_name" label="用户名" width="120" />
        <el-table-column prop="nick_name" label="昵称" width="120" />
        <el-table-column prop="email" label="邮箱" width="180" />
        <el-table-column prop="phonenumber" label="手机号" width="130" />
        <el-table-column prop="dept_name" label="部门" width="120" />
        <el-table-column prop="roles" label="角色" width="150">
          <template #default="scope">
            <el-tag
              v-for="role in scope.row.roles"
              :key="role.role_id"
              type="primary"
              size="small"
              style="margin-right: 5px; margin-bottom: 2px;"
            >
              {{ role.role_name }}
            </el-tag>
            <span v-if="!scope.row.roles || scope.row.roles.length === 0" style="color: #999;">
              未分配角色
            </span>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template #default="scope">
            <el-tag :type="scope.row.status === '0' ? 'success' : 'danger'">
              {{ scope.row.status === '0' ? '正常' : '停用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="create_time" label="创建时间" width="160" />
        <el-table-column label="操作" width="280" fixed="right">
          <template #default="scope">
            <el-button
              type="primary"
              size="small"
              @click="handleEdit(scope.row)"
            >
              编辑
            </el-button>
            <el-button
              type="success"
              size="small"
              @click="handleAssignRole(scope.row)"
            >
              分配角色
            </el-button>
            <el-button
              type="danger"
              size="small"
              @click="handleDelete(scope.row)"
            >
              删除
            </el-button>
            <el-button
              type="warning"
              size="small"
              @click="handleResetPassword(scope.row)"
            >
              重置密码
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="pagination.currentPage"
          v-model:page-size="pagination.pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="pagination.total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>
    
    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
      @close="handleDialogClose"
    >
      <el-form
        ref="userForm"
        :model="userForm"
        :rules="userRules"
        label-width="80px"
      >
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="用户名" prop="user_name">
              <el-input
                v-model="userForm.user_name"
                placeholder="请输入用户名"
                :disabled="isEdit"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="昵称" prop="nick_name">
              <el-input
                v-model="userForm.nick_name"
                placeholder="请输入昵称"
              />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="邮箱" prop="email">
              <el-input
                v-model="userForm.email"
                placeholder="请输入邮箱"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="手机号" prop="phonenumber">
              <el-input
                v-model="userForm.phonenumber"
                placeholder="请输入手机号"
              />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="部门" prop="dept_id">
              <el-select
                v-model="userForm.dept_id"
                placeholder="请选择部门"
                style="width: 100%"
              >
                <el-option
                  v-for="dept in deptList"
                  :key="dept.dept_id"
                  :label="dept.dept_name"
                  :value="dept.dept_id"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="userForm.status">
                <el-radio label="0">正常</el-radio>
                <el-radio label="1">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20" v-if="!isEdit">
          <el-col :span="12">
            <el-form-item label="密码" prop="password">
              <el-input
                v-model="userForm.password"
                type="password"
                placeholder="请输入密码"
                show-password
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="确认密码" prop="confirmPassword">
              <el-input
                v-model="userForm.confirmPassword"
                type="password"
                placeholder="请确认密码"
                show-password
              />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmit">确定</el-button>
        </span>
      </template>
    </el-dialog>
    
    <!-- 分配角色对话框 -->
    <el-dialog
      v-model="roleDialogVisible"
      title="分配角色"
      width="500px"
      @close="handleRoleDialogClose"
    >
      <div v-if="currentUser">
        <p style="margin-bottom: 15px; color: #666;">
          为用户 <strong>{{ currentUser.user_name }}</strong> ({{ currentUser.nick_name }}) 分配角色
        </p>
        
        <el-checkbox-group v-model="selectedRoles">
          <el-checkbox
            v-for="role in roleList"
            :key="role.role_id"
            :label="role.role_id"
            :disabled="role.status === '1'"
            style="display: block; margin-bottom: 10px;"
          >
            <span>{{ role.role_name }}</span>
            <el-tag
              v-if="role.status === '1'"
              type="danger"
              size="small"
              style="margin-left: 10px;"
            >
              已停用
            </el-tag>
            <span v-if="role.remark" style="color: #999; margin-left: 10px; font-size: 12px;">
              ({{ role.remark }})
            </span>
          </el-checkbox>
        </el-checkbox-group>
      </div>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="roleDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleRoleSubmit">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ElMessage, ElMessageBox } from 'element-plus'

export default {
  name: 'UserManagement',
  data() {
    // 确认密码验证
    const validateConfirmPassword = (rule, value, callback) => {
      if (value !== this.userForm.password) {
        callback(new Error('两次输入密码不一致'))
      } else {
        callback()
      }
    }
    
    return {
      loading: false,
      tableData: [],
      selectedRows: [],
      searchForm: {
        username: '',
        status: ''
      },
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0
      },
      dialogVisible: false,
      dialogTitle: '',
      isEdit: false,
      userForm: {
        id: null,
        user_id: null,
        user_name: '',
        nick_name: '',
        email: '',
        phonenumber: '',
        dept_id: null,
        status: '0',
        password: '',
        confirmPassword: ''
      },
      userRules: {
        user_name: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 2, max: 20, message: '用户名长度在 2 到 20 个字符', trigger: 'blur' }
        ],
        nick_name: [
          { required: true, message: '请输入昵称', trigger: 'blur' }
        ],
        email: [
          { required: true, message: '请输入邮箱', trigger: 'blur' },
          { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
        ],
        phonenumber: [
          { required: true, message: '请输入手机号', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
        ],
        dept_id: [
          { required: true, message: '请选择部门', trigger: 'change' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请确认密码', trigger: 'blur' },
          { validator: validateConfirmPassword, trigger: 'blur' }
        ]
      },
      deptList: [],
      roleList: [],
      // 分配角色对话框
      roleDialogVisible: false,
      currentUser: null,
      selectedRoles: [],
      userRoles: []
    }
  },
  mounted() {
    this.loadData()
    this.loadDeptList()
  },
  methods: {
    /**
     * 加载用户数据
     */
    async loadData() {
      this.loading = true
      try {
        const params = {
          _page: this.pagination.currentPage,
          _limit: this.pagination.pageSize
        }
        
        // 添加搜索条件
        if (this.searchForm.username) {
          params.user_name_like = this.searchForm.username
        }
        if (this.searchForm.status) {
          params.status = this.searchForm.status
        }
        
        const response = await this.$http.get('/sys_user', { params })
        this.tableData = response.data || []
        
        // 获取总数
        const countResponse = await this.$http.get('/sys_user')
        this.pagination.total = countResponse.data?.length || 0
        
        // 关联部门信息
        await this.loadDeptInfo()
      } catch (error) {
        console.error('加载用户数据失败:', error)
        ElMessage.error('加载数据失败')
      } finally {
        this.loading = false
      }
    },
    
    /**
     * 加载部门信息
     */
    async loadDeptInfo() {
      try {
        const response = await this.$http.get('/sys_dept')
        const deptData = response.data || []
        
        // 为用户数据添加部门名称
        this.tableData.forEach(user => {
          const dept = deptData.find(d => d.dept_id === user.dept_id)
          user.dept_name = dept ? dept.dept_name : '未分配'
        })
      } catch (error) {
        console.error('加载部门信息失败:', error)
      }
    },
    
    /**
     * 加载部门列表
     */
    async loadDeptList() {
      try {
        const response = await this.$http.get('/sys_dept')
        this.deptList = response.data || []
      } catch (error) {
        console.error('加载部门列表失败:', error)
      }
    },
    
    /**
     * 搜索
     */
    handleSearch() {
      this.pagination.currentPage = 1
      this.loadData()
    },
    
    /**
     * 重置搜索
     */
    handleReset() {
      this.searchForm = {
        username: '',
        status: ''
      }
      this.pagination.currentPage = 1
      this.loadData()
    },
    
    /**
     * 新增用户
     */
    handleAdd() {
      this.dialogTitle = '新增用户'
      this.isEdit = false
      this.userForm = {
        id: null,
        user_id: null,
        user_name: '',
        nick_name: '',
        email: '',
        phonenumber: '',
        dept_id: null,
        status: '0',
        password: '',
        confirmPassword: ''
      }
      this.dialogVisible = true
    },
    
    /**
     * 编辑用户
     */
    handleEdit(row) {
      this.dialogTitle = '编辑用户'
      this.isEdit = true
      this.userForm = {
        id: row.id,
        user_id: row.user_id,
        user_name: row.user_name,
        nick_name: row.nick_name,
        email: row.email,
        phonenumber: row.phonenumber,
        dept_id: row.dept_id,
        status: row.status,
        password: '',
        confirmPassword: ''
      }
      this.dialogVisible = true
    },
    
    /**
     * 删除用户
     */
    async handleDelete(row) {
      try {
        await ElMessageBox.confirm(
          `确定要删除用户 "${row.user_name}" 吗？`,
          '删除确认',
          {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }
        )
        
        await this.$http.delete(`/sys_user/${row.id}`)
        ElMessage.success('删除成功')
        this.loadData()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('删除用户失败:', error)
          ElMessage.error('删除失败')
        }
      }
    },
    
    /**
     * 重置密码
     */
    async handleResetPassword(row) {
      try {
        await ElMessageBox.confirm(
          `确定要重置用户 "${row.user_name}" 的密码吗？重置后密码为：123456`,
          '重置密码确认',
          {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }
        )
        
        await this.$http.put(`/sys_user/${row.id}`, {
          ...row,
          password: '123456'
        })
        ElMessage.success('密码重置成功，新密码为：123456')
      } catch (error) {
        if (error !== 'cancel') {
          console.error('重置密码失败:', error)
          ElMessage.error('重置密码失败')
        }
      }
    },
    
    /**
     * 提交表单
     */
    async handleSubmit() {
      try {
        await this.$refs.userForm.validate()
        
        const formData = { ...this.userForm }
        delete formData.confirmPassword
        
        if (this.isEdit) {
          // 编辑用户
          await this.$http.put(`/sys_user/${formData.id}`, formData)
          ElMessage.success('编辑成功')
        } else {
          // 新增用户
          // 生成新的数字类型 user_id 和 id
          const userResponse = await this.$http.get('/sys_user')
          const existingUsers = userResponse.data || []
          const maxUserId = existingUsers.length > 0 ? Math.max(...existingUsers.map(u => u.user_id || 0)) : 0
          const newId = maxUserId + 1
          formData.user_id = newId
          formData.id = newId
          formData.create_time = new Date().toISOString().slice(0, 19).replace('T', ' ')
          await this.$http.post('/sys_user', formData)
          ElMessage.success('新增成功')
        }
        
        this.dialogVisible = false
        this.loadData()
      } catch (error) {
        console.error('提交失败:', error)
        ElMessage.error('操作失败')
      }
    },
    
    /**
     * 关闭对话框
     */
    handleDialogClose() {
      this.$refs.userForm?.resetFields()
    },
    
    /**
     * 选择变化
     */
    handleSelectionChange(selection) {
      this.selectedRows = selection
    },
    
    /**
     * 分页大小变化
     */
    handleSizeChange(size) {
      this.pagination.pageSize = size
      this.pagination.currentPage = 1
      this.loadData()
    },
    
    /**
     * 当前页变化
     */
    handleCurrentChange(page) {
      this.pagination.currentPage = page
      this.loadData()
    }
  }
}
</script>

<style scoped>
.user-management {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.search-area {
  margin-bottom: 20px;
  padding: 20px;
  background-color: #f5f5f5;
  border-radius: 4px;
}

.pagination {
  margin-top: 20px;
  text-align: right;
}

.dialog-footer {
  text-align: right;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .search-area .el-form {
    display: block;
  }
  
  .search-area .el-form-item {
    margin-bottom: 10px;
  }
  
  .el-table {
    font-size: 12px;
  }
}
</style>