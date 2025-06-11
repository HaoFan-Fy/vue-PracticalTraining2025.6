/**
 * 权限控制混入
 * 提供权限检查相关的方法
 */
export default {
  methods: {
    /**
     * 检查用户是否有指定权限
     * @param {string} permission 权限标识
     * @returns {boolean} 是否有权限
     */
    hasPermission(permission) {
      if (!permission) return true;
      
      const userInfo = this.getUserInfo();
      if (!userInfo || !userInfo.roles) {
        return false;
      }
      
      // 超级管理员拥有所有权限
      if (userInfo.roles.some(role => role.role_key === 'admin')) {
        return true;
      }
      
      // 检查用户角色是否包含指定权限
      return userInfo.permissions && userInfo.permissions.includes(permission);
    },
    
    /**
     * 检查用户是否有指定角色
     * @param {string} roleKey 角色标识
     * @returns {boolean} 是否有角色
     */
    hasRole(roleKey) {
      if (!roleKey) return true;
      
      const userInfo = this.getUserInfo();
      if (!userInfo || !userInfo.roles) {
        return false;
      }
      
      return userInfo.roles.some(role => role.role_key === roleKey);
    },
    
    /**
     * 检查用户是否有任意一个指定角色
     * @param {Array} roleKeys 角色标识数组
     * @returns {boolean} 是否有任意角色
     */
    hasAnyRole(roleKeys) {
      if (!roleKeys || roleKeys.length === 0) return true;
      
      return roleKeys.some(roleKey => this.hasRole(roleKey));
    },
    
    /**
     * 获取用户信息
     * @returns {Object|null} 用户信息
     */
    getUserInfo() {
      try {
        let userInfo = localStorage.getItem('employee');
        if (!userInfo) {
          userInfo = sessionStorage.getItem('employee');
        }
        return userInfo ? JSON.parse(userInfo) : null;
      } catch (error) {
        console.error('获取用户信息失败:', error);
        return null;
      }
    }
  }
};