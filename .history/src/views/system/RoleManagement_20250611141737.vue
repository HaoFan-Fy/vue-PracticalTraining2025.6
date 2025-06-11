<template>
  <div class="role-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>角色管理</span>
          <el-button v-if="hasRole('admin')" type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>
            新增角色
          </el-button>
        </div>
      </template>
      
      <!-- 搜索区域 -->
      <div class="search-area">
        <el-form :model="searchForm" inline>
          <el-form-item label="角色名称">
            <el-input
              v-model="searchForm.roleName"
              placeholder="请输入角色名称"
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
        <el-table-column prop="role_id" label="角色ID" width="80" />
        <el-table-column prop="role_name" label="角色名称" width="150" />
        <el-table-column prop="role_key" label="权限字符" width="150" />
        <el-table-column prop="role_sort" label="显示顺序" width="100" />
        <el-table-column prop="status" label="状态" width="80">
          <template #default="scope">
            <el-tag :type="scope.row.status === '0' ? 'success' : 'danger'">
              {{ scope.row.status === '0' ? '正常' : '停用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" min-width="200" show-overflow-tooltip />
        <el-table-column prop="create_time" label="创建时间" width="160" />
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="scope">
            <el-button
              type="primary"
              size="small"
              @click="handleEdit(scope.row)"
            >
              编辑
            </el-button>
            <el-button
              type="warning"
              size="small"
              @click="handlePermission(scope.row)"
            >
              权限
            </el-button>
            <el-button
              type="danger"
              size="small"
              @click="handleDelete(scope.row)"
            >
              删除
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
        ref="roleForm"
        :model="roleForm"
        :rules="roleRules"
        label-width="100px"
      >
        <el-form-item label="角色名称" prop="role_name">
          <el-input
            v-model="roleForm.role_name"
            placeholder="请输入角色名称"
          />
        </el-form-item>
        
        <el-form-item label="权限字符" prop="role_key">
          <el-input
            v-model="roleForm.role_key"
            placeholder="请输入权限字符"
          />
        </el-form-item>
        
        <el-form-item label="显示顺序" prop="role_sort">
          <el-input-number
            v-model="roleForm.role_sort"
            :min="0"
            :max="999"
            style="width: 100%"
          />
        </el-form-item>
        
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="roleForm.status">
            <el-radio label="0">正常</el-radio>
            <el-radio label="1">停用</el-radio>
          </el-radio-group>
        </el-form-item>
        
        <el-form-item label="备注">
          <el-input
            v-model="roleForm.remark"
            type="textarea"
            :rows="3"
            placeholder="请输入备注"
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmit">确定</el-button>
        </span>
      </template>
    </el-dialog>
    
    <!-- 权限分配对话框 -->
    <el-dialog
      v-model="permissionDialogVisible"
      title="分配权限"
      width="400px"
    >
      <div class="permission-content">
        <div class="role-info">
          <span>角色：{{ currentRole.role_name }}</span>
        </div>
        <el-tree
          ref="permissionTree"
          :data="menuTreeData"
          :props="treeProps"
          show-checkbox
          node-key="menu_id"
          :default-checked-keys="checkedMenuIds"
          :default-expand-all="true"
        />
      </div>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="permissionDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSavePermission">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ElMessage, ElMessageBox } from 'element-plus'
import permissionMixin from '@/mixins/permission'

export default {
  name: 'RoleManagement',
  mixins: [permissionMixin],
  data() {
    return {
      loading: false,
      tableData: [],
      selectedRows: [],
      searchForm: {
        roleName: '',
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
      roleForm: {
        id: null,
        role_id: null,
        role_name: '',
        role_key: '',
        role_sort: 0,
        status: '0',
        remark: ''
      },
      roleRules: {
        role_name: [
          { required: true, message: '请输入角色名称', trigger: 'blur' },
          { min: 2, max: 20, message: '角色名称长度在 2 到 20 个字符', trigger: 'blur' }
        ],
        role_key: [
          { required: true, message: '请输入权限字符', trigger: 'blur' },
          { pattern: /^[a-zA-Z0-9_]+$/, message: '权限字符只能包含字母、数字和下划线', trigger: 'blur' }
        ],
        role_sort: [
          { required: true, message: '请输入显示顺序', trigger: 'blur' }
        ]
      },
      // 权限相关
      permissionDialogVisible: false,
      currentRole: {},
      menuTreeData: [],
      checkedMenuIds: [],
      treeProps: {
        children: 'children',
        label: 'menu_name'
      }
    }
  },
  mounted() {
    this.loadData()
    this.loadMenuTree()
  },
  methods: {
    /**
     * 加载角色数据
     */
    async loadData() {
      this.loading = true
      try {
        const params = {
          _page: this.pagination.currentPage,
          _limit: this.pagination.pageSize
        }
        
        // 添加搜索条件
        if (this.searchForm.roleName) {
          params.role_name_like = this.searchForm.roleName
        }
        if (this.searchForm.status) {
          params.status = this.searchForm.status
        }
        
        const response = await this.$http.get('/sys_role', { params })
        this.tableData = response.data || []
        
        // 获取总数
        const countResponse = await this.$http.get('/sys_role')
        this.pagination.total = countResponse.data?.length || 0
      } catch (error) {
        console.error('加载角色数据失败:', error)
        ElMessage.error('加载数据失败')
      } finally {
        this.loading = false
      }
    },
    
    /**
     * 加载菜单树数据
     */
    async loadMenuTree() {
      try {
        const response = await this.$http.get('/sys_menu')
        const menuData = response.data || []
        this.menuTreeData = this.buildMenuTree(menuData)
      } catch (error) {
        console.error('加载菜单数据失败:', error)
      }
    },
    
    /**
     * 构建菜单树
     */
    buildMenuTree(menuData) {
      const tree = []
      const map = {}
      
      // 创建映射
      menuData.forEach(item => {
        map[item.menu_id] = { ...item, children: [] }
      })
      
      // 构建树结构
      menuData.forEach(item => {
        if (item.parent_id === 0 || item.parent_id === null) {
          tree.push(map[item.menu_id])
        } else {
          if (map[item.parent_id]) {
            map[item.parent_id].children.push(map[item.menu_id])
          }
        }
      })
      
      return tree
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
        roleName: '',
        status: ''
      }
      this.pagination.currentPage = 1
      this.loadData()
    },
    
    /**
     * 新增角色
     */
    handleAdd() {
      this.dialogTitle = '新增角色'
      this.isEdit = false
      this.roleForm = {
        id: null,
        role_id: null,
        role_name: '',
        role_key: '',
        role_sort: 0,
        status: '0',
        remark: ''
      }
      this.dialogVisible = true
    },
    
    /**
     * 编辑角色
     */
    handleEdit(row) {
      this.dialogTitle = '编辑角色'
      this.isEdit = true
      this.roleForm = {
        id: row.id,
        role_id: row.role_id,
        role_name: row.role_name,
        role_key: row.role_key,
        role_sort: row.role_sort,
        status: row.status,
        remark: row.remark || ''
      }
      this.dialogVisible = true
    },
    
    /**
     * 删除角色
     */
    async handleDelete(row) {
      try {
        await ElMessageBox.confirm(
          `确定要删除角色 "${row.role_name}" 吗？`,
          '删除确认',
          {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }
        )
        
        await this.$http.delete(`/sys_role/${row.id}`)
        ElMessage.success('删除成功')
        this.loadData()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('删除角色失败:', error)
          ElMessage.error('删除失败')
        }
      }
    },
    
    /**
     * 分配权限
     */
    async handlePermission(row) {
      this.currentRole = row
      
      // 加载角色已有权限
      try {
        const response = await this.$http.get(`/sys_role_menu?role_id=${row.role_id}`)
        const roleMenus = response.data || []
        this.checkedMenuIds = roleMenus.map(item => item.menu_id)
      } catch (error) {
        console.error('加载角色权限失败:', error)
        this.checkedMenuIds = []
      }
      
      // 打开对话框
      this.permissionDialogVisible = true
      
      // 等待DOM更新后设置选中状态
      this.$nextTick(() => {
        if (this.$refs.permissionTree) {
          this.$refs.permissionTree.setCheckedKeys(this.checkedMenuIds)
        }
      })
    },
    
    /**
     * 保存权限分配
     */
    async handleSavePermission() {
      try {
        const checkedKeys = this.$refs.permissionTree.getCheckedKeys()
        const halfCheckedKeys = this.$refs.permissionTree.getHalfCheckedKeys()
        const allCheckedKeys = [...checkedKeys, ...halfCheckedKeys]
        
        // 先删除原有权限
        const existingResponse = await this.$http.get(`/sys_role_menu?role_id=${this.currentRole.role_id}`)
        const existingRoleMenus = existingResponse.data || []
        
        // 删除现有权限记录
        for (const roleMenu of existingRoleMenus) {
          await this.$http.delete(`/sys_role_menu/${roleMenu.id}`)
        }
        
        // 添加新权限
        for (const menuId of allCheckedKeys) {
          // 生成唯一ID
          const uniqueId = Math.random().toString(36).substr(2, 4)
          await this.$http.post('/sys_role_menu', {
            id: uniqueId,
            role_id: this.currentRole.role_id,
            menu_id: menuId
          })
        }
        
        ElMessage.success('权限分配成功')
        this.permissionDialogVisible = false
      } catch (error) {
        console.error('保存权限失败:', error)
        ElMessage.error('保存权限失败')
      }
    },
    
    /**
     * 提交表单
     */
    async handleSubmit() {
      try {
        await this.$refs.roleForm.validate()
        
        const formData = { ...this.roleForm }
        
        if (this.isEdit) {
          // 编辑角色
          await this.$http.put(`/sys_role/${formData.id}`, formData)
          ElMessage.success('编辑成功')
        } else {
          // 新增角色
          // 生成新的角色ID
          const response = await this.$http.get('/sys_role')
          const existingRoles = response.data || []
          const maxRoleId = existingRoles.length > 0 ? Math.max(...existingRoles.map(r => r.role_id || 0)) : 0
          
          formData.role_id = maxRoleId + 1
          formData.id = Date.now().toString()
          formData.create_time = new Date().toISOString().slice(0, 19).replace('T', ' ')
          await this.$http.post('/sys_role', formData)
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
      this.$refs.roleForm?.resetFields()
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
.role-management {
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

.permission-content {
  max-height: 400px;
  overflow-y: auto;
}

.role-info {
  margin-bottom: 15px;
  padding: 10px;
  background-color: #f0f9ff;
  border-radius: 4px;
  font-weight: bold;
  color: #1890ff;
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