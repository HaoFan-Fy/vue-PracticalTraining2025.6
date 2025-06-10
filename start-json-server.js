/**
 * JSON Server 启动脚本
 * 用于启动模拟后端API服务
 */
import jsonServer from 'json-server'
const server = jsonServer.create()
const router = jsonServer.router('db.json')
const middlewares = jsonServer.defaults()

// 设置默认中间件 (logger, static, cors and no-cache)
server.use(middlewares)

// 添加自定义路由
server.use(jsonServer.rewriter({
  '/api/*': '/$1',
  '/api/system/user': '/sys_user',
  '/api/system/role': '/sys_role',
  '/api/system/menu': '/sys_menu',
  '/api/system/dept': '/sys_dept',
  '/api/system/user-role': '/sys_user_role',
  '/api/system/role-menu': '/sys_role_menu',
  '/api/system/role-dept': '/sys_role_dept'
}))

// 添加自定义中间件
server.use((req, res, next) => {
  // 添加延迟模拟网络请求
  setTimeout(next, 100)
})

// 添加登录接口模拟
server.post('/api/login', (req, res) => {
  const { username, password } = req.body
  
  // 简单的登录验证
  if (username === 'admin' && password === 'admin123') {
    res.json({
      code: 200,
      msg: '登录成功',
      token: 'mock-jwt-token-admin',
      data: {
        user_id: 1,
        user_name: 'admin',
        nick_name: '管理员',
        email: 'admin@example.com',
        roles: ['admin']
      }
    })
  } else if (username === 'user' && password === 'user123') {
    res.json({
      code: 200,
      msg: '登录成功',
      token: 'mock-jwt-token-user',
      data: {
        user_id: 2,
        user_name: 'user',
        nick_name: '普通用户',
        email: 'user@example.com',
        roles: ['user']
      }
    })
  } else {
    res.status(401).json({
      code: 401,
      msg: '用户名或密码错误'
    })
  }
})

// 添加用户信息接口
server.get('/api/user/info', (req, res) => {
  const token = req.headers.authorization
  
  if (token === 'Bearer mock-jwt-token-admin') {
    res.json({
      code: 200,
      msg: '获取成功',
      data: {
        user_id: 1,
        user_name: 'admin',
        nick_name: '管理员',
        email: 'admin@example.com',
        roles: ['admin'],
        permissions: ['*:*:*']
      }
    })
  } else if (token === 'Bearer mock-jwt-token-user') {
    res.json({
      code: 200,
      msg: '获取成功',
      data: {
        user_id: 2,
        user_name: 'user',
        nick_name: '普通用户',
        email: 'user@example.com',
        roles: ['user'],
        permissions: ['system:user:query']
      }
    })
  } else {
    res.status(401).json({
      code: 401,
      msg: '未授权访问'
    })
  }
})

// 使用默认路由
server.use(router)

// 启动服务器
const PORT = process.env.PORT || 3000
server.listen(PORT, () => {
  console.log(`\n🚀 JSON Server 已启动!`)
  console.log(`📡 API 服务地址: http://localhost:${PORT}`)
  console.log(`📊 数据库文件: db.json`)
  console.log(`\n可用的API端点:`)
  console.log(`  GET    /api/system/user     - 获取用户列表`)
  console.log(`  GET    /api/system/role     - 获取角色列表`)
  console.log(`  GET    /api/system/menu     - 获取菜单列表`)
  console.log(`  GET    /api/system/dept     - 获取部门列表`)
  console.log(`  POST   /api/login           - 用户登录`)
  console.log(`  GET    /api/user/info       - 获取用户信息`)
  console.log(`\n测试账号:`)
  console.log(`  管理员: admin / admin123`)
  console.log(`  普通用户: user / user123`)
  console.log(`\n按 Ctrl+C 停止服务\n`)
})