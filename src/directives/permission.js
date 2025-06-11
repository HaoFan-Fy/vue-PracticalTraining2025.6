/**
 * 权限指令
 * 用法：v-permission="'system:user:list'" 或 v-permission="['system:user:list', 'system:user:add']"
 */

// 获取用户信息
function getUserInfo() {
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

// 检查权限
function checkPermission(el, binding) {
  const { value } = binding;
  
  if (!value) {
    return true;
  }
  
  const userInfo = getUserInfo();
  if (!userInfo || !userInfo.roles) {
    el.parentNode && el.parentNode.removeChild(el);
    return false;
  }
  
  // 超级管理员拥有所有权限
  if (userInfo.roles.some(role => role.role_key === 'admin')) {
    return true;
  }
  
  let permissions = [];
  if (Array.isArray(value)) {
    permissions = value;
  } else {
    permissions = [value];
  }
  
  // 检查用户是否有任意一个权限
  const hasPermission = permissions.some(permission => {
    return userInfo.permissions && userInfo.permissions.includes(permission);
  });
  
  if (!hasPermission) {
    el.parentNode && el.parentNode.removeChild(el);
    return false;
  }
  
  return true;
}

export default {
  mounted(el, binding) {
    checkPermission(el, binding);
  },
  updated(el, binding) {
    checkPermission(el, binding);
  }
};