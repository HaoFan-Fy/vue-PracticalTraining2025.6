<template>
  <div class="menu-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>菜单管理</span>
          <el-button type="primary" @click="handleAdd">
            <el-icon><Plus /></el-icon>
            新增菜单
          </el-button>
        </div>
      </template>
      
      <!-- 搜索区域 -->
      <div class="search-area">
        <el-form :model="searchForm" inline>
          <el-form-item label="菜单名称">
            <el-input
              v-model="searchForm.menuName"
              placeholder="请输入菜单名称"
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
        row-key="menu_id"
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
        :default-expand-all="isExpanded"
      >
        <el-table-column prop="menu_name" label="菜单名称" min-width="200">
          <template #default="scope">
            <el-icon v-if="scope.row.icon" style="margin-right: 5px;">
              <component :is="scope.row.icon" />
            </el-icon>
            {{ scope.row.menu_name }}
          </template>
        </el-table-column>
        <el-table-column prop="menu_type" label="类型" width="80">
          <template #default="scope">
            <el-tag
              :type="scope.row.menu_type === 'M' ? 'primary' : scope.row.menu_type === 'C' ? 'success' : 'warning'"
            >
              {{ getMenuTypeText(scope.row.menu_type) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="order_num" label="排序" width="80" />
        <el-table-column prop="perms" label="权限标识" min-width="150" show-overflow-tooltip />
        <el-table-column prop="component" label="组件路径" min-width="150" show-overflow-tooltip />
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
              type="primary"
              size="small"
              @click="handleEdit(scope.row)"
            >
              编辑
            </el-button>
            <el-button
              type="success"
              size="small"
              @click="handleAddChild(scope.row)"
              v-if="scope.row.menu_type !== 'F'"
            >
              新增
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
    </el-card>
    
    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="700px"
      @close="handleDialogClose"
    >
      <el-form
        ref="menuForm"
        :model="menuForm"
        :rules="menuRules"
        label-width="100px"
      >
        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="上级菜单">
              <el-tree-select
                v-model="menuForm.parent_id"
                :data="menuTreeOptions"
                :props="treeSelectProps"
                placeholder="选择上级菜单"
                check-strictly
                :render-after-expand="false"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="菜单类型" prop="menu_type">
              <el-radio-group v-model="menuForm.menu_type" @change="handleMenuTypeChange">
                <el-radio label="M">目录</el-radio>
                <el-radio label="C">菜单</el-radio>
                <el-radio label="F">按钮</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="菜单名称" prop="menu_name">
              <el-input
                v-model="menuForm.menu_name"
                placeholder="请输入菜单名称"
              />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="显示排序" prop="order_num">
              <el-input-number
                v-model="menuForm.order_num"
                :min="0"
                :max="999"
                style="width: 100%"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="menuForm.menu_type !== 'F'">
            <el-form-item label="菜单图标">
              <el-input
                v-model="menuForm.icon"
                placeholder="请输入图标名称"
              >
                <template #prefix>
                  <el-icon v-if="menuForm.icon">
                    <component :is="menuForm.icon" />
                  </el-icon>
                </template>
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20" v-if="menuForm.menu_type !== 'F'">
          <el-col :span="12">
            <el-form-item label="路由地址" prop="path">
              <el-input
                v-model="menuForm.path"
                placeholder="请输入路由地址"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="menuForm.menu_type === 'C'">
            <el-form-item label="组件路径" prop="component">
              <el-input
                v-model="menuForm.component"
                placeholder="请输入组件路径"
              />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="权限标识">
              <el-input
                v-model="menuForm.perms"
                placeholder="请输入权限标识"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="菜单状态">
              <el-radio-group v-model="menuForm.status">
                <el-radio label="0">正常</el-radio>
                <el-radio label="1">停用</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20" v-if="menuForm.menu_type !== 'F'">
          <el-col :span="12">
            <el-form-item label="显示状态">
              <el-radio-group v-model="menuForm.visible">
                <el-radio label="0">显示</el-radio>
                <el-radio label="1">隐藏</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
          <el-col :span="12" v-if="menuForm.menu_type === 'C'">
            <el-form-item label="是否缓存">
              <el-radio-group v-model="menuForm.is_cache">
                <el-radio label="0">缓存</el-radio>
                <el-radio label="1">不缓存</el-radio>
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

export default {
  name: 'MenuManagement',
  data() {
    return {
      loading: false,
      tableData: [],
      isExpanded: false,
      searchForm: {
        menuName: '',
        status: ''
      },
      dialogVisible: false,
      dialogTitle: '',
      isEdit: false,
      menuForm: {
        menu_id: null,
        parent_id: 0,
        menu_name: '',
        menu_type: 'M',
        order_num: 0,
        path: '',
        component: '',
        perms: '',
        icon: '',
        status: '0',
        visible: '0',
        is_cache: '0'
      },
      menuRules: {
        menu_name: [
          { required: true, message: '请输入菜单名称', trigger: 'blur' },
          { min: 2, max: 20, message: '菜单名称长度在 2 到 20 个字符', trigger: 'blur' }
        ],
        menu_type: [
          { required: true, message: '请选择菜单类型', trigger: 'change' }
        ],
        order_num: [
          { required: true, message: '请输入显示排序', trigger: 'blur' }
        ],
        path: [
          { required: true, message: '请输入路由地址', trigger: 'blur' }
        ],
        component: [
          { required: true, message: '请输入组件路径', trigger: 'blur' }
        ]
      },
      menuTreeOptions: [],
      treeSelectProps: {
        value: 'menu_id',
        label: 'menu_name',
        children: 'children'
      }
    }
  },
  mounted() {
    this.loadData()
  },
  methods: {
    /**
     * 加载菜单数据
     */
    async loadData() {
      this.loading = true
      try {
        const response = await this.$http.get('/sys_menu')
        const menuData = response.data || []
        
        // 过滤搜索条件
        let filteredData = menuData
        if (this.searchForm.menuName) {
          filteredData = filteredData.filter(item => 
            item.menu_name.includes(this.searchForm.menuName)
          )
        }
        if (this.searchForm.status) {
          filteredData = filteredData.filter(item => 
            item.status === this.searchForm.status
          )
        }
        
        this.tableData = this.buildMenuTree(filteredData)
        this.buildMenuTreeOptions(menuData)
      } catch (error) {
        console.error('加载菜单数据失败:', error)
        ElMessage.error('加载数据失败')
      } finally {
        this.loading = false
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
        if (item.parent_id === 0) {
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
     * 构建菜单树选项
     */
    buildMenuTreeOptions(menuData) {
      const options = [{
        menu_id: 0,
        menu_name: '主类目',
        children: []
      }]
      
      const tree = this.buildMenuTree(menuData.filter(item => item.menu_type !== 'F'))
      options[0].children = tree
      this.menuTreeOptions = options
    },
    
    /**
     * 获取菜单类型文本
     */
    getMenuTypeText(type) {
      const typeMap = {
        'M': '目录',
        'C': '菜单',
        'F': '按钮'
      }
      return typeMap[type] || '未知'
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
        menuName: '',
        status: ''
      }
      this.loadData()
    },
    
    /**
     * 新增菜单
     */
    handleAdd() {
      this.dialogTitle = '新增菜单'
      this.isEdit = false
      this.menuForm = {
        menu_id: null,
        parent_id: 0,
        menu_name: '',
        menu_type: 'M',
        order_num: 0,
        path: '',
        component: '',
        perms: '',
        icon: '',
        status: '0',
        visible: '0',
        is_cache: '0'
      }
      this.dialogVisible = true
    },
    
    /**
     * 新增子菜单
     */
    handleAddChild(row) {
      this.dialogTitle = '新增子菜单'
      this.isEdit = false
      this.menuForm = {
        menu_id: null,
        parent_id: row.menu_id,
        menu_name: '',
        menu_type: row.menu_type === 'M' ? 'C' : 'F',
        order_num: 0,
        path: '',
        component: '',
        perms: '',
        icon: '',
        status: '0',
        visible: '0',
        is_cache: '0'
      }
      this.dialogVisible = true
    },
    
    /**
     * 编辑菜单
     */
    handleEdit(row) {
      this.dialogTitle = '编辑菜单'
      this.isEdit = true
      this.menuForm = {
        menu_id: row.menu_id,
        parent_id: row.parent_id,
        menu_name: row.menu_name,
        menu_type: row.menu_type,
        order_num: row.order_num,
        path: row.path || '',
        component: row.component || '',
        perms: row.perms || '',
        icon: row.icon || '',
        status: row.status,
        visible: row.visible || '0',
        is_cache: row.is_cache || '0'
      }
      this.dialogVisible = true
    },
    
    /**
     * 删除菜单
     */
    async handleDelete(row) {
      try {
        await ElMessageBox.confirm(
          `确定要删除菜单 "${row.menu_name}" 吗？`,
          '删除确认',
          {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
          }
        )
        
        await this.$http.delete(`/sys_menu/${row.id}`)
        ElMessage.success('删除成功')
        this.loadData()
      } catch (error) {
        if (error !== 'cancel') {
          console.error('删除菜单失败:', error)
          ElMessage.error('删除失败')
        }
      }
    },
    
    /**
     * 菜单类型变化
     */
    handleMenuTypeChange(value) {
      // 清空相关字段
      if (value === 'F') {
        this.menuForm.path = ''
        this.menuForm.component = ''
        this.menuForm.icon = ''
        this.menuForm.visible = '0'
        this.menuForm.is_cache = '0'
      }
    },
    
    /**
     * 提交表单
     */
    async handleSubmit() {
      try {
        await this.$refs.menuForm.validate()
        
        const formData = { ...this.menuForm }
        
        if (this.isEdit) {
          // 编辑菜单
          await this.$http.put(`/sys_menu/${formData.menu_id}`, formData)
          ElMessage.success('编辑成功')
        } else {
          // 新增菜单
          delete formData.menu_id
          formData.create_time = new Date().toISOString().slice(0, 19).replace('T', ' ')
          await this.$http.post('/sys_menu', formData)
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
      this.$refs.menuForm?.resetFields()
    }
  }
}
</script>

<style scoped>
.menu-management {
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