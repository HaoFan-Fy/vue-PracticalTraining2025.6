<template>
  <div class="dept-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>部门管理</span>
          <el-button v-if="hasRole('admin') || hasRole('common')" type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>
            新增部门
          </el-button>
        </div>
      </template>
      
      <!-- 搜索区域 -->
      <div class="search-area">
        <el-form :model="searchForm" inline>
          <el-form-item label="部门名称">
            <el-input
              v-model="searchForm.deptName"
              placeholder="请输入部门名称"
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
            <el-button @click="toggleExpand">
              <el-icon><Operation /></el-icon>
              {{ isExpanded ? '折叠' : '展开' }}
            </el-button>
          </el-form-item>
        </el-form>
      </div>
      
      <!-- 表格区域 -->
      <el-table
        v-loading="loading"
        :data="tableData"
        style="width: 100%"
        row-key="dept_id"
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
        :default-expand-all="isExpanded"
      >
        <el-table-column prop="dept_name" label="部门名称" min-width="200" />
        <el-table-column prop="order_num" label="排序" width="80" />
        <el-table-column prop="leader" label="负责人" width="120" />
        <el-table-column prop="phone" label="联系电话" width="130" />
        <el-table-column prop="email" label="邮箱" width="180" show-overflow-tooltip />
        <el-table-column prop="status" label="状态" width="80">
          <template #default="scope">
            <el-tag :type="scope.row.status === '0' ? 'success' : 'danger'">
              {{ scope.row.status === '0' ? '正常' : '停用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="create_time" label="创建时间" width="160" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="scope">
            <el-button
              v-if="hasRole('admin') || hasRole('common')"
              type="primary"
              size="small"
              @click="handleEdit(scope.row)"
            >
              编辑
            </el-button>
            <el-button
              v-if="hasRole('admin') || hasRole('common')"
              type="success"
              size="small"
              @click="handleAddChild(scope.row)"
            >
              新增
            </el-button>
            <el-button
              v-if="hasRole('admin') || hasRole('common')"
              type="danger"
              size="small"
              @click="handleDelete(scope.row)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    
    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
      @close="handleDialogClose"
    >
      <el-form
        ref="deptForm"
        :model="deptForm"
        :rules="deptRules"
        label-width="100px"
      >
        <el-form-item label="上级部门">
          <el-tree-select
            v-model="deptForm.parent_id"
            :data="deptTreeOptions"
            :props="treeSelectProps"
            placeholder="选择上级部门"
            check-strictly
            :render-after-expand="false"
            style="width: 100%"
          />
        </el-form-item>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="部门名称" prop="dept_name">
              <el-input
                v-model="deptForm.dept_name"
                placeholder="请输入部门名称"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="显示排序" prop="order_num">
              <el-input-number
                v-model="deptForm.order_num"
                :min="0"
                :max="999"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="负责人">
              <el-input
                v-model="deptForm.leader"
                placeholder="请输入负责人"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话">
              <el-input
                v-model="deptForm.phone"
                placeholder="请输入联系电话"
              />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="邮箱">
              <el-input
                v-model="deptForm.email"
                placeholder="请输入邮箱"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="部门状态">
              <el-radio-group v-model="deptForm.status">
                <el-radio label="0">正常</el-radio>
                <el-radio label="1">停用</el-radio>
              </el-radio-group>
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
  </div>
</template>

<script>
import { ElMessage, ElMessageBox } from 'element-plus'
import permissionMixin from '@/mixins/permission'

export default {
  name: 'DeptManagement',
  mixins: [permissionMixin],
  data() {
    return {
      loading: false,
      tableData: [],
      isExpanded: false,
      searchForm: {
        deptName: '',
        status: ''
      },
      dialogVisible: false,
      dialogTitle: '',
      isEdit: false,
      deptForm: {
        id: null,
        dept_id: null,
        parent_id: 0,
        dept_name: '',
        order_num: 0,
        leader: '',
        phone: '',
        email: '',
        status: '0'
      },
      deptRules: {
        dept_name: [
          { required: true, message: '请输入部门名称', trigger: 'blur' },
          { min: 2, max: 30, message: '部门名称长度在 2 到 30 个字符', trigger: 'blur' }
        ],
        order_num: [
          { required: true, message: '请输入显示排序', trigger: 'blur' }
        ],
        phone: [
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
        ],
        email: [
          { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
        ]
      },
      deptTreeOptions: [],
      treeSelectProps: {
        value: 'dept_id',
        label: 'dept_name',
        children: 'children'
      }
    }
  },
  mounted() {
    this.loadData()
  },
  methods: {
    /**
     * 加载部门数据
     */
    async loadData() {
      this.loading = true
      try {
        const response = await this.$http.get('/sys_dept')
        const deptData = response.data || []
        
        // 过滤搜索条件
        let filteredData = deptData
        if (this.searchForm.deptName) {
          filteredData = filteredData.filter(item => 
            item.dept_name.includes(this.searchForm.deptName)
          )
        }
        if (this.searchForm.status) {
          filteredData = filteredData.filter(item => 
            item.status === this.searchForm.status
          )
        }
        
        this.tableData = this.buildDeptTree(filteredData)
        this.buildDeptTreeOptions(deptData)
      } catch (error) {
        console.error('加载部门数据失败:', error)
        ElMessage.error('加载数据失败')
      } finally {
        this.loading = false
      }
    },
    
    /**
     * 构建部门树
     */
    buildDeptTree(deptData) {
      const tree = []
      const map = {}
      
      // 创建映射
      deptData.forEach(item => {
        map[item.dept_id] = { ...item, children: [] }
      })
      
      // 构建树结构
      deptData.forEach(item => {
        if (item.parent_id === 0) {
          tree.push(map[item.dept_id])
        } else {
          if (map[item.parent_id]) {
            map[item.parent_id].children.push(map[item.dept_id])
          }
        }
      })
      
      return tree
    },
    
    /**
     * 构建部门树选项
     */
    buildDeptTreeOptions(deptData) {
      const options = [{
        dept_id: 0,
        dept_name: '主类目',
        children: []
      }]
      
      const tree = this.buildDeptTree(deptData)
      options[0].children = tree
      this.deptTreeOptions = options
    },
    
    /**
     * 切换展开/折叠
     */
    toggleExpand() {
      this.isExpanded = !this.isExpanded
    },
    
    /**
     * 搜索
     */
    handleSearch() {
      this.loadData()
    },
    
    /**
     * 重置搜索
     */
    handleReset() {
      this.searchForm = {
        deptName: '',
        status: ''
      }
      this.loadData()
    },
    
    /**
     * 新增部门
     */
    handleAdd() {
      this.dialogTitle = '新增部门'
      this.isEdit = false
      this.deptForm = {
        id: null,
        dept_id: null,
        parent_id: 0,
        dept_name: '',
        order_num: 0,
        leader: '',
        phone: '',
        email: '',
        status: '0'
      }
      this.dialogVisible = true
    },
    
    /**
     * 新增子部门
     */
    handleAddChild(row) {
      this.dialogTitle = '新增子部门'
      this.isEdit = false
      this.deptForm = {
        id: null,
        dept_id: null,
        parent_id: row.dept_id,
        dept_name: '',
        order_num: 0,
        leader: '',
        phone: '',
        email: '',
        status: '0'
      }
      this.dialogVisible = true
    },
    
    /**
     * 编辑部门
     */
    handleEdit(row) {
      this.dialogTitle = '编辑部门'
      this.isEdit = true
      this.deptForm = {
        id: row.id || row.dept_id,
        dept_id: row.dept_id,
        parent_id: row.parent_id,
        dept_name: row.dept_name,
        order_num: row.order_num,
        leader: row.leader || '',
        phone: row.phone || '',
        email: row.email || '',
        status: row.status
      }
      this.dialogVisible = true
    },
    
    /**
     * 删除部门
     */
    async handleDelete(row) {
      try {
        // 检查是否有子部门
        const response = await this.$http.get('/sys_dept')
        const allDepts = response.data || []
        const hasChildren = allDepts.some(dept => dept.parent_id === row.dept_id)
        
        if (hasChildren) {
          ElMessage.warning('该部门存在子部门，不能删除')
          return
        }
        
        // 检查是否有用户
        const userResponse = await this.$http.get(`/sys_user?dept_id=${row.dept_id}`)
        const users = userResponse.data || []
        
        if (users.length > 0) {
          ElMessage.warning('该部门存在用户，不能删除')
          return
        }
        
        await ElMessageBox.confirm(
          `确定要删除部门 "${row.dept_name}" 吗？`,
          '删除确认',
          {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }
        )
        
        await this.$http.delete(`/sys_dept/${row.id}`)
        ElMessage.success('删除成功')
        this.loadData()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('删除部门失败:', error)
          ElMessage.error('删除失败')
        }
      }
    },
    
    /**
     * 提交表单
     */
    async handleSubmit() {
      try {
        await this.$refs.deptForm.validate()
        
        const formData = { ...this.deptForm }
        
        // 检查部门名称是否重复
        const response = await this.$http.get('/sys_dept')
        const allDepts = response.data || []
        const nameExists = allDepts.some(dept => 
          dept.dept_name === formData.dept_name && 
          dept.dept_id !== formData.dept_id
        )
        
        if (nameExists) {
          ElMessage.warning('部门名称已存在')
          return
        }
        
        if (this.isEdit) {
          // 编辑部门
          await this.$http.put(`/sys_dept/${formData.id}`, formData)
          ElMessage.success('编辑成功')
        } else {
          // 新增部门
          delete formData.dept_id
          // 生成id字段
          formData.id = formData.dept_id || Date.now()
          formData.create_time = new Date().toISOString().slice(0, 19).replace('T', ' ')
          await this.$http.post('/sys_dept', formData)
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
      this.$refs.deptForm?.resetFields()
    }
  }
}
</script>

<style scoped>
.dept-management {
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