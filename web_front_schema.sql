/*
 Navicat Premium Dump SQL

 Source Server         : 课程设计
 Source Server Type    : MySQL
 Source Server Version : 80035 (8.0.35)
 Source Host           : 47.92.157.229:3306
 Source Schema         : itt

 Target Server Type    : MySQL
 Target Server Version : 80035 (8.0.35)
 File Encoding         : 65001

 Date: 10/06/2025 06:23:16
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 203 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_gl_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '帝豪娱乐', 0, '阿里克谢.马克西莫维奇', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-11-05 20:46:11', 'admin', '2024-11-17 21:03:56');
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-11-05 20:46:11', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-11-05 20:46:11', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-11-05 20:46:11', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-11-05 20:46:11', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-11-05 20:46:11', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-11-05 20:46:11', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-11-05 20:46:11', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-11-05 20:46:11', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2024-11-05 20:46:11', '', NULL);
INSERT INTO `sys_dept` VALUES (200, 100, '0,100', '大众公司', 3, '人民', '18616938206', 'man@163.com', '0', '0', 'admin', '2024-11-17 21:04:38', '', NULL);
INSERT INTO `sys_dept` VALUES (201, 200, '0,100,200', '普罗大众', 1, 'man', NULL, 'man@163.com', '0', '0', 'admin', '2024-11-17 21:05:24', '', NULL);
INSERT INTO `sys_dept` VALUES (202, 200, '0,100,200', '代理商', 2, 'agent', NULL, 'agent@163.com', '0', '0', 'admin', '2024-11-17 21:05:49', '', NULL);

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2076 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_gl_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2024-11-05 20:46:11', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 2, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2024-11-05 20:46:11', '', NULL, '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2024-11-05 20:46:11', '', NULL, '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'http://ruoyi.vip', NULL, '', '', 0, 0, 'M', '0', '0', '', 'guide', 'admin', '2024-11-05 20:46:11', '', NULL, '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2024-11-05 20:46:11', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2024-11-05 20:46:11', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2024-11-05 20:46:11', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2024-11-05 20:46:11', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2024-11-05 20:46:11', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2024-11-05 20:46:11', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2024-11-05 20:46:11', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2024-11-05 20:46:11', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2024-11-05 20:46:11', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2024-11-05 20:46:11', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2024-11-05 20:46:11', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2024-11-05 20:46:11', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2024-11-05 20:46:11', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2024-11-05 20:46:11', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2024-11-05 20:46:11', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2024-11-05 20:46:11', 'admin', '2024-11-05 22:12:15', '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2024-11-05 20:46:11', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2024-11-05 20:46:11', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2024-11-05 20:46:11', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2024-11-05 20:46:11', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1049, '任务查询', 110, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1050, '任务新增', 110, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1051, '任务修改', 110, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1052, '任务删除', 110, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1053, '状态修改', 110, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1054, '任务导出', 110, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2024-11-05 20:46:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2020, '视频管理', 2026, 1, 'xvideo', 'manage/xvideo/index', NULL, '', 1, 0, 'C', '0', '0', 'manage:xvideo:list', 'job', 'admin', '2024-11-10 22:01:45', 'admin', '2024-11-10 22:14:30', '视频管理菜单');
INSERT INTO `sys_menu` VALUES (2021, '视频管理查询', 2020, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:xvideo:query', '#', 'admin', '2024-11-10 22:01:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '视频管理新增', 2020, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:xvideo:add', '#', 'admin', '2024-11-10 22:01:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2023, '视频管理修改', 2020, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:xvideo:edit', '#', 'admin', '2024-11-10 22:01:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2024, '视频管理删除', 2020, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:xvideo:remove', '#', 'admin', '2024-11-10 22:01:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2025, '视频管理导出', 2020, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:xvideo:export', '#', 'admin', '2024-11-10 22:01:45', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2026, '短视频管理', 0, 8, 'videos', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'cascader', 'admin', '2024-11-10 22:14:07', 'admin', '2024-12-02 20:28:34', '');
INSERT INTO `sys_menu` VALUES (2027, '标签', 2026, 1, 'tags', 'manage/tags/index', NULL, '', 1, 0, 'C', '0', '0', 'manage:tags:list', 'checkbox', 'admin', '2024-11-16 05:52:32', 'admin', '2024-11-16 07:02:11', '标签菜单');
INSERT INTO `sys_menu` VALUES (2028, '标签查询', 2027, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:tags:query', '#', 'admin', '2024-11-16 05:52:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2029, '标签新增', 2027, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:tags:add', '#', 'admin', '2024-11-16 05:52:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, '标签修改', 2027, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:tags:edit', '#', 'admin', '2024-11-16 05:52:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2031, '标签删除', 2027, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:tags:remove', '#', 'admin', '2024-11-16 05:52:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2032, '标签导出', 2027, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:tags:export', '#', 'admin', '2024-11-16 05:52:32', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2033, '短视频管理', 2026, 1, 'svideo', 'manage/svideo/index', NULL, '', 1, 0, 'C', '0', '0', 'manage:svideo:list', '商品管理', 'admin', '2024-11-16 14:45:56', 'admin', '2024-11-17 16:37:28', '短视频管理菜单');
INSERT INTO `sys_menu` VALUES (2034, '短视频管理查询', 2033, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:svideo:query', '#', 'admin', '2024-11-16 14:45:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '短视频管理新增', 2033, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:svideo:add', '#', 'admin', '2024-11-16 14:45:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '短视频管理修改', 2033, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:svideo:edit', '#', 'admin', '2024-11-16 14:45:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2037, '短视频管理删除', 2033, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:svideo:remove', '#', 'admin', '2024-11-16 14:45:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2038, '短视频管理导出', 2033, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:svideo:export', '#', 'admin', '2024-11-16 14:45:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2039, '第10章 Element Plus', 0, 7, 'chapter10', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'build', 'admin', '2024-12-02 16:18:23', 'admin', '2024-12-02 20:28:21', '');
INSERT INTO `sys_menu` VALUES (2040, '基本组件', 2039, 1, 'basic', 'course/chapter10/HomeView', NULL, '', 1, 0, 'C', '0', '0', NULL, 'checkbox', 'admin', '2024-12-02 16:22:25', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2041, '标签例子', 2039, 2, 'label-tag', 'course/chapter10/LabelTag', NULL, '', 1, 0, 'C', '0', '0', NULL, 'number', 'admin', '2024-12-02 16:24:59', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '表单例子', 2039, 3, 'form-sample', 'course/chapter10/FormView', NULL, '', 1, 0, 'C', '0', '0', NULL, 'checkbox', 'admin', '2024-12-02 16:26:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2043, '警告例子', 2039, 4, 'alert-sample', 'course/chapter10/AlertView', NULL, '', 1, 0, 'C', '0', '0', NULL, 'wechat', 'admin', '2024-12-02 16:28:21', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2044, '滑块例子', 2039, 5, 'slider-sample', 'course/chapter10/SliderToggle', NULL, '', 1, 0, 'C', '0', '0', NULL, 'textarea', 'admin', '2024-12-02 16:30:01', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2045, '表格例子', 2039, 6, 'table-sample', 'course/chapter10/TableView', NULL, '', 1, 0, 'C', '0', '0', NULL, 'nested', 'admin', '2024-12-02 16:31:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2046, '学生管理', 2039, 7, 'stu-sample', 'course/chapter10/StudentMgr', NULL, '', 1, 0, 'C', '0', '0', NULL, 'peoples', 'admin', '2024-12-02 16:33:11', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2047, '第9章 网络请求', 0, 6, 'network', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'exit-fullscreen', 'admin', '2024-12-02 17:44:05', 'admin', '2024-12-02 20:28:09', '');
INSERT INTO `sys_menu` VALUES (2048, '天气测试', 2047, 1, 'weather', 'course/chapter09/WeatherView', NULL, '', 1, 0, 'C', '0', '0', '', 'download', 'admin', '2024-12-02 17:44:55', 'admin', '2024-12-02 18:02:37', '');
INSERT INTO `sys_menu` VALUES (2049, '天气案例', 2047, 2, 'query-wea', 'course/chapter09/WeatherQuery', NULL, '', 1, 0, 'C', '0', '0', NULL, 'tab', 'admin', '2024-12-02 18:00:47', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2050, '第8章 组件进阶', 0, 5, 'comp-sample', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'button', 'admin', '2024-12-02 19:29:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2051, '进阶例子', 2050, 1, 'jin-sample', 'course/chapter08/JinJie', NULL, '', 1, 0, 'C', '0', '0', NULL, 'clipboard', 'admin', '2024-12-02 19:31:28', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2052, '微贴', 2026, 1, 'microposts', 'manage/microposts/index', NULL, '', 1, 0, 'C', '0', '0', 'manage:microposts:list', 'skill', 'admin', '2024-12-14 08:23:30', 'admin', '2024-12-14 08:41:26', '微贴菜单');
INSERT INTO `sys_menu` VALUES (2053, '微贴查询', 2052, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:microposts:query', '#', 'admin', '2024-12-14 08:23:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2054, '微贴新增', 2052, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:microposts:add', '#', 'admin', '2024-12-14 08:23:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2055, '微贴修改', 2052, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:microposts:edit', '#', 'admin', '2024-12-14 08:23:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2056, '微贴删除', 2052, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:microposts:remove', '#', 'admin', '2024-12-14 08:23:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2057, '微贴导出', 2052, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:microposts:export', '#', 'admin', '2024-12-14 08:23:30', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2058, '广告图片', 2026, 1, 'banner', 'manage/banner/index', NULL, '', 1, 0, 'C', '0', '0', 'manage:banner:list', 'language', 'admin', '2024-12-27 06:37:08', 'admin', '2024-12-27 06:48:32', 'APP广告图片管理菜单');
INSERT INTO `sys_menu` VALUES (2059, 'APP广告图片管理查询', 2058, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:banner:query', '#', 'admin', '2024-12-27 06:37:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2060, 'APP广告图片管理新增', 2058, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:banner:add', '#', 'admin', '2024-12-27 06:37:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2061, 'APP广告图片管理修改', 2058, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:banner:edit', '#', 'admin', '2024-12-27 06:37:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2062, 'APP广告图片管理删除', 2058, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:banner:remove', '#', 'admin', '2024-12-27 06:37:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2063, 'APP广告图片管理导出', 2058, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:banner:export', '#', 'admin', '2024-12-27 06:37:08', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2064, '搜索词记录', 2026, 1, 'terms', 'manage/terms/index', NULL, '', 1, 0, 'C', '0', '0', 'manage:terms:list', 'log', 'admin', '2024-12-28 19:43:56', 'admin', '2024-12-28 19:50:15', '用户搜索词记录菜单');
INSERT INTO `sys_menu` VALUES (2065, '用户搜索词记录查询', 2064, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:terms:query', '#', 'admin', '2024-12-28 19:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2066, '用户搜索词记录新增', 2064, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:terms:add', '#', 'admin', '2024-12-28 19:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2067, '用户搜索词记录修改', 2064, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:terms:edit', '#', 'admin', '2024-12-28 19:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2068, '用户搜索词记录删除', 2064, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:terms:remove', '#', 'admin', '2024-12-28 19:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2069, '用户搜索词记录导出', 2064, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:terms:export', '#', 'admin', '2024-12-28 19:43:56', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2070, '关注', 2026, 1, 'follows', 'manage/follows/index', NULL, '', 1, 0, 'C', '0', '0', 'manage:follows:list', 'eye', 'admin', '2024-12-30 21:17:09', 'admin', '2024-12-30 21:21:26', '关注菜单');
INSERT INTO `sys_menu` VALUES (2071, '关注查询', 2070, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:follows:query', '#', 'admin', '2024-12-30 21:17:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2072, '关注新增', 2070, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:follows:add', '#', 'admin', '2024-12-30 21:17:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2073, '关注修改', 2070, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:follows:edit', '#', 'admin', '2024-12-30 21:17:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2074, '关注删除', 2070, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:follows:remove', '#', 'admin', '2024-12-30 21:17:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2075, '关注导出', 2070, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'manage:follows:export', '#', 'admin', '2024-12-30 21:17:09', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 102 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_gl_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2024-11-05 20:46:11', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2024-11-05 20:46:11', '', NULL, '普通角色');
INSERT INTO `sys_role` VALUES (100, '视频管理', 'videos', 3, '1', 1, 1, '0', '0', 'admin', '2024-11-17 21:02:23', 'admin', '2024-12-30 21:19:20', NULL);
INSERT INTO `sys_role` VALUES (101, '老师', 'teacher', 4, '1', 1, 1, '0', '0', 'admin', '2024-12-02 17:12:35', 'admin', '2024-12-02 18:58:19', NULL);

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_gl_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_gl_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 3);
INSERT INTO `sys_role_menu` VALUES (2, 4);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 115);
INSERT INTO `sys_role_menu` VALUES (2, 116);
INSERT INTO `sys_role_menu` VALUES (2, 117);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 1055);
INSERT INTO `sys_role_menu` VALUES (2, 1056);
INSERT INTO `sys_role_menu` VALUES (2, 1057);
INSERT INTO `sys_role_menu` VALUES (2, 1058);
INSERT INTO `sys_role_menu` VALUES (2, 1059);
INSERT INTO `sys_role_menu` VALUES (2, 1060);
INSERT INTO `sys_role_menu` VALUES (100, 1);
INSERT INTO `sys_role_menu` VALUES (100, 100);
INSERT INTO `sys_role_menu` VALUES (100, 1000);
INSERT INTO `sys_role_menu` VALUES (100, 1001);
INSERT INTO `sys_role_menu` VALUES (100, 1002);
INSERT INTO `sys_role_menu` VALUES (100, 1003);
INSERT INTO `sys_role_menu` VALUES (100, 1004);
INSERT INTO `sys_role_menu` VALUES (100, 1005);
INSERT INTO `sys_role_menu` VALUES (100, 1006);
INSERT INTO `sys_role_menu` VALUES (100, 2020);
INSERT INTO `sys_role_menu` VALUES (100, 2021);
INSERT INTO `sys_role_menu` VALUES (100, 2022);
INSERT INTO `sys_role_menu` VALUES (100, 2023);
INSERT INTO `sys_role_menu` VALUES (100, 2024);
INSERT INTO `sys_role_menu` VALUES (100, 2025);
INSERT INTO `sys_role_menu` VALUES (100, 2026);
INSERT INTO `sys_role_menu` VALUES (100, 2027);
INSERT INTO `sys_role_menu` VALUES (100, 2028);
INSERT INTO `sys_role_menu` VALUES (100, 2029);
INSERT INTO `sys_role_menu` VALUES (100, 2030);
INSERT INTO `sys_role_menu` VALUES (100, 2031);
INSERT INTO `sys_role_menu` VALUES (100, 2032);
INSERT INTO `sys_role_menu` VALUES (100, 2033);
INSERT INTO `sys_role_menu` VALUES (100, 2034);
INSERT INTO `sys_role_menu` VALUES (100, 2035);
INSERT INTO `sys_role_menu` VALUES (100, 2036);
INSERT INTO `sys_role_menu` VALUES (100, 2037);
INSERT INTO `sys_role_menu` VALUES (100, 2038);
INSERT INTO `sys_role_menu` VALUES (100, 2052);
INSERT INTO `sys_role_menu` VALUES (100, 2053);
INSERT INTO `sys_role_menu` VALUES (100, 2054);
INSERT INTO `sys_role_menu` VALUES (100, 2055);
INSERT INTO `sys_role_menu` VALUES (100, 2056);
INSERT INTO `sys_role_menu` VALUES (100, 2057);
INSERT INTO `sys_role_menu` VALUES (100, 2058);
INSERT INTO `sys_role_menu` VALUES (100, 2059);
INSERT INTO `sys_role_menu` VALUES (100, 2060);
INSERT INTO `sys_role_menu` VALUES (100, 2061);
INSERT INTO `sys_role_menu` VALUES (100, 2062);
INSERT INTO `sys_role_menu` VALUES (100, 2063);
INSERT INTO `sys_role_menu` VALUES (100, 2064);
INSERT INTO `sys_role_menu` VALUES (100, 2065);
INSERT INTO `sys_role_menu` VALUES (100, 2066);
INSERT INTO `sys_role_menu` VALUES (100, 2067);
INSERT INTO `sys_role_menu` VALUES (100, 2068);
INSERT INTO `sys_role_menu` VALUES (100, 2069);
INSERT INTO `sys_role_menu` VALUES (100, 2070);
INSERT INTO `sys_role_menu` VALUES (100, 2071);
INSERT INTO `sys_role_menu` VALUES (100, 2072);
INSERT INTO `sys_role_menu` VALUES (100, 2073);
INSERT INTO `sys_role_menu` VALUES (100, 2074);
INSERT INTO `sys_role_menu` VALUES (100, 2075);
INSERT INTO `sys_role_menu` VALUES (101, 1);
INSERT INTO `sys_role_menu` VALUES (101, 100);
INSERT INTO `sys_role_menu` VALUES (101, 101);
INSERT INTO `sys_role_menu` VALUES (101, 102);
INSERT INTO `sys_role_menu` VALUES (101, 103);
INSERT INTO `sys_role_menu` VALUES (101, 104);
INSERT INTO `sys_role_menu` VALUES (101, 105);
INSERT INTO `sys_role_menu` VALUES (101, 106);
INSERT INTO `sys_role_menu` VALUES (101, 107);
INSERT INTO `sys_role_menu` VALUES (101, 108);
INSERT INTO `sys_role_menu` VALUES (101, 500);
INSERT INTO `sys_role_menu` VALUES (101, 501);
INSERT INTO `sys_role_menu` VALUES (101, 1000);
INSERT INTO `sys_role_menu` VALUES (101, 1001);
INSERT INTO `sys_role_menu` VALUES (101, 1002);
INSERT INTO `sys_role_menu` VALUES (101, 1003);
INSERT INTO `sys_role_menu` VALUES (101, 1004);
INSERT INTO `sys_role_menu` VALUES (101, 1005);
INSERT INTO `sys_role_menu` VALUES (101, 1006);
INSERT INTO `sys_role_menu` VALUES (101, 1007);
INSERT INTO `sys_role_menu` VALUES (101, 1008);
INSERT INTO `sys_role_menu` VALUES (101, 1009);
INSERT INTO `sys_role_menu` VALUES (101, 1010);
INSERT INTO `sys_role_menu` VALUES (101, 1011);
INSERT INTO `sys_role_menu` VALUES (101, 1012);
INSERT INTO `sys_role_menu` VALUES (101, 1013);
INSERT INTO `sys_role_menu` VALUES (101, 1014);
INSERT INTO `sys_role_menu` VALUES (101, 1015);
INSERT INTO `sys_role_menu` VALUES (101, 1016);
INSERT INTO `sys_role_menu` VALUES (101, 1017);
INSERT INTO `sys_role_menu` VALUES (101, 1018);
INSERT INTO `sys_role_menu` VALUES (101, 1019);
INSERT INTO `sys_role_menu` VALUES (101, 1020);
INSERT INTO `sys_role_menu` VALUES (101, 1021);
INSERT INTO `sys_role_menu` VALUES (101, 1022);
INSERT INTO `sys_role_menu` VALUES (101, 1023);
INSERT INTO `sys_role_menu` VALUES (101, 1024);
INSERT INTO `sys_role_menu` VALUES (101, 1025);
INSERT INTO `sys_role_menu` VALUES (101, 1026);
INSERT INTO `sys_role_menu` VALUES (101, 1027);
INSERT INTO `sys_role_menu` VALUES (101, 1028);
INSERT INTO `sys_role_menu` VALUES (101, 1029);
INSERT INTO `sys_role_menu` VALUES (101, 1030);
INSERT INTO `sys_role_menu` VALUES (101, 1031);
INSERT INTO `sys_role_menu` VALUES (101, 1032);
INSERT INTO `sys_role_menu` VALUES (101, 1033);
INSERT INTO `sys_role_menu` VALUES (101, 1034);
INSERT INTO `sys_role_menu` VALUES (101, 1035);
INSERT INTO `sys_role_menu` VALUES (101, 1036);
INSERT INTO `sys_role_menu` VALUES (101, 1037);
INSERT INTO `sys_role_menu` VALUES (101, 1038);
INSERT INTO `sys_role_menu` VALUES (101, 1039);
INSERT INTO `sys_role_menu` VALUES (101, 1040);
INSERT INTO `sys_role_menu` VALUES (101, 1041);
INSERT INTO `sys_role_menu` VALUES (101, 1042);
INSERT INTO `sys_role_menu` VALUES (101, 1043);
INSERT INTO `sys_role_menu` VALUES (101, 1044);
INSERT INTO `sys_role_menu` VALUES (101, 1045);
INSERT INTO `sys_role_menu` VALUES (101, 2039);
INSERT INTO `sys_role_menu` VALUES (101, 2040);
INSERT INTO `sys_role_menu` VALUES (101, 2041);
INSERT INTO `sys_role_menu` VALUES (101, 2042);
INSERT INTO `sys_role_menu` VALUES (101, 2043);
INSERT INTO `sys_role_menu` VALUES (101, 2044);
INSERT INTO `sys_role_menu` VALUES (101, 2045);
INSERT INTO `sys_role_menu` VALUES (101, 2046);
INSERT INTO `sys_role_menu` VALUES (101, 2047);
INSERT INTO `sys_role_menu` VALUES (101, 2048);
INSERT INTO `sys_role_menu` VALUES (101, 2049);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NOT NULL COMMENT '密码',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱地址',
  `phonenumber` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号码',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `bio` text CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL COMMENT '个人简介',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '修改人',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL COMMENT '备注',
  `is_member` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否为会员（0: 非会员, 1: 会员）',
  `membership_expiration` datetime NULL DEFAULT NULL COMMENT '会员到期时间',
  `invitation_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '用户自己的邀请码',
  `invited_by_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '被邀请时使用的邀请码',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `nick_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_gl_0900_ai_ci NULL DEFAULT NULL COMMENT '用户昵称',
  `follower_count` int NOT NULL DEFAULT 0 COMMENT '粉丝数',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 76 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_gl_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'user1@example.com', '1234567890', NULL, NULL, '2024-11-05 20:46:11', '2025-04-23 20:47:36', 'admin', '', '管理员', 0, NULL, NULL, NULL, 103, '00', '1', '0', '0', '127.0.0.1', '2025-04-23 20:47:36', NULL, 1260);
INSERT INTO `sys_user` VALUES (2, 'ry', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', 'user2@example.com', '0987654321', NULL, NULL, '2024-11-05 20:46:11', '2025-01-05 10:10:00', 'admin', '', '测试员', 0, NULL, NULL, NULL, 105, '00', '1', '0', '0', '127.0.0.1', '2024-11-09 19:20:47', NULL, 458);
INSERT INTO `sys_user` VALUES (3, 'wxy', '123456', '1480973357@qq.com', '13190182856', NULL, NULL, '2024-11-05 21:42:27', '2024-11-13 17:58:44', NULL, NULL, NULL, 0, '2024-11-14 00:00:00', '1234', '7654', NULL, '00', '0', '0', '0', '', NULL, NULL, 7890);
INSERT INTO `sys_user` VALUES (4, 'lxm', '123456', 'thomas.x.wong@proton.me', '13355667890', NULL, NULL, '2024-11-05 22:03:57', '2024-11-13 17:58:47', NULL, NULL, NULL, 1, '2024-12-19 00:00:00', '2323', '2323', NULL, '00', '0', '0', '0', '', NULL, NULL, 560);
INSERT INTO `sys_user` VALUES (5, 'zjm', '432323', '4474372@163.com', '15566867890', NULL, NULL, '2024-11-05 22:07:56', '2024-11-05 22:07:56', NULL, NULL, NULL, 1, '2025-01-09 00:00:00', '1222', '2323', NULL, '00', '0', '0', '0', '', NULL, NULL, 0);
INSERT INTO `sys_user` VALUES (6, '王大勇', '$2a$10$sB2wwPRrz.kZy/Uh8WPn9uz2CPNCooJdLajJzBbdbj/j3hh3lIUI6', '4474372@sina.com', '13190182879', NULL, NULL, '2024-11-17 21:08:59', '2024-11-26 19:56:44', 'admin', NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '223.100.199.200', '2024-11-26 19:56:45', '测试1', 0);
INSERT INTO `sys_user` VALUES (7, '你是谁', '$2a$10$d22ZEYsXNXXBu8xzJKFH7OnlxP8.rOSd2WpaQgzORirIMVM6RM0yq', 'thomas.x.wong@qq.com', '13290182345', NULL, NULL, '2024-11-18 18:13:37', '2024-11-18 18:13:37', 'admin', NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '1', '0', '0', '', NULL, '龙大儿', 0);
INSERT INTO `sys_user` VALUES (17, 'thomas', '$2a$10$JddcA1RwJ2lPnpZVI3Hgz.S9mhpJs3y17TTdqG5UbCWq/ls20u0qq', 'thomas.x.wong@gmail.com', '13190182866', NULL, NULL, '2024-12-02 17:15:15', '2025-01-05 21:33:53', 'admin', NULL, NULL, 0, NULL, NULL, NULL, 100, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 21:33:53', '王老师', 0);
INSERT INTO `sys_user` VALUES (18, '0px0b0pAA2a46y', '$2a$10$XZj6p5hog6nwPeopT63K5O8uPU8rIym8eO2noDmyX9Xf8/jOTQPYS', 'uc6f890b212e1996f@itt.com', NULL, NULL, NULL, '2024-12-10 17:31:36', '2024-12-11 21:38:22', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '223.100.199.200', '2024-12-11 21:38:23', '0px0b0pAA2a46y', 0);
INSERT INTO `sys_user` VALUES (19, '5Hen', '$2a$10$Ah4OIZMRVXnvZRMPTi8bleukj98VWNG9kj5jDUz5J9TeugOdkNOKC', 'u2b97d1a4d21f7845@itt.com', NULL, NULL, NULL, '2024-12-12 13:22:35', '2025-01-20 08:05:37', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '42.228.229.38', '2025-01-20 08:05:37', '5Hen', 0);
INSERT INTO `sys_user` VALUES (45, '5QKBsFdQ11ur251zixT', '$2a$10$rZZJvatkoX3eRP/EwIBEPO67vqRmVgNKe5i/Xez68iWRo5EqUrlN.', 'u05a62a822ff9cd4a@itt.com', NULL, NULL, NULL, '2024-12-29 19:50:13', '2024-12-29 21:13:10', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.29.30', '2024-12-29 21:13:11', '覐镎謡荇聤', 0);
INSERT INTO `sys_user` VALUES (46, 'yaXEAHcVKL', '$2a$10$jWyUspTpDgJZgdHTEuHAdOBafY7cxz4rXWgFjb9j/7GSbYFRoxuJe', 'uc6f890b212e1996f@itt.com', NULL, NULL, NULL, '2024-12-30 09:21:50', '2025-01-02 06:40:24', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '223.100.199.200', '2025-01-02 06:40:25', '骥鐵蚐膶昭', 0);
INSERT INTO `sys_user` VALUES (47, 'uXp', '$2a$10$kTqzYlXeyEi/XbHxGwHHMO7Klln4NnrdQsDTphxWt/xSJGTkDyfJe', 'ue2a3ffd83b7b35e8@itt.com', NULL, NULL, NULL, '2025-01-03 18:28:59', '2025-01-03 18:29:00', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-03 18:29:00', '轹惮軺麤璅', 0);
INSERT INTO `sys_user` VALUES (48, 'eBWl', '$2a$10$whrUX0rguEok5SUyu507UOoClXtx8qsrj9wtm9sH4knEMxFqfqeZC', 'u05a62a822ff9cd4a@itt.com', NULL, NULL, NULL, '2025-01-03 18:53:35', '2025-01-03 20:38:29', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-03 20:38:30', '龔梋榉取趟', 0);
INSERT INTO `sys_user` VALUES (49, 'MfoP1f4d89fX0I46FPz', '$2a$10$sjWEAxOhXLqhvgjBtVv/pe5P53kitAMi8JwgTOBnDaYLcqkGNjSW.', 'u05a62a822ff9cd4a@itt.com', NULL, NULL, NULL, '2025-01-03 20:39:46', '2025-01-06 18:54:23', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '223.100.199.200', '2025-01-06 18:54:23', '嗃佮礰犵唲', 0);
INSERT INTO `sys_user` VALUES (50, '3GVLT5R1vLBzG8', '$2a$10$8ZKat31y7mQLWyUA0nF0r.q6PsGz4SGVRVU/hNpXItYAxMXkTbGcO', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 16:39:56', '2025-01-05 16:39:56', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 16:39:57', '瞭賲栘勪袬', 0);
INSERT INTO `sys_user` VALUES (51, 'fP', '$2a$10$1.zEE5k0mdQ2fFVTgsL2seVRhlckFpolWfCMGR7F8R4//9QoEkQv6', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 17:03:57', '2025-01-05 17:03:58', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 17:03:58', '绕櫴栬鶫衦', 0);
INSERT INTO `sys_user` VALUES (52, 'UUm', '$2a$10$O1FdXnlZUuopDIbmHtqV6e2/AZuE8VYWwzlplT3nFSsS8h/LgnJ5C', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 17:27:16', '2025-01-05 17:27:16', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 17:27:17', '郴杪鳘偷尌', 0);
INSERT INTO `sys_user` VALUES (53, 'plHbE0HmMq8xdpPUjnx', '$2a$10$ZdYPOrRKS5znTlZb/.jXAuTu2NRDAkyEcbduMgNjmANiGjjj7rjyO', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 17:37:26', '2025-01-05 17:37:26', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 17:37:27', '簌揟嚛菕镅', 0);
INSERT INTO `sys_user` VALUES (54, 'UhcFPPrBxCBkM', '$2a$10$.QPeMt.zTHDkJ5oImpzJ6uNkWiTB5OIl2uy3l51oqhdSr8dZh9OnG', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 17:44:56', '2025-01-05 17:44:57', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 17:44:57', '麷姬謅袮鞀', 0);
INSERT INTO `sys_user` VALUES (55, 'w7aLVQP2W', '$2a$10$21/AqJ9H.lYxZobQEGQiBub4LZxPH9zJKTQP17Qsop3/HGMA2lW7G', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 17:53:09', '2025-01-05 17:53:09', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 17:53:10', '焓讚吟狇坕', 0);
INSERT INTO `sys_user` VALUES (56, 'A6ZzV03', '$2a$10$ABd/BsnKR7VGqiPEKuAB5eiMQ0jvDU3HqJVj102od9I9rcWE95PDW', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 20:54:58', '2025-01-05 20:54:59', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 20:54:59', '嘊樓砘亪塞', 0);
INSERT INTO `sys_user` VALUES (57, 'zotFBquQDZSu6iAA', '$2a$10$Ea5A3CmHwM1EX8cZIneS9.VRhH6eFzm386oL2U8xZkIgxF02omSHe', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 21:03:24', '2025-01-05 21:03:25', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 21:03:25', '僶躜篧臊祘', 0);
INSERT INTO `sys_user` VALUES (58, 'frzx4snnVH182OJs7UEQ', '$2a$10$cAMmAwYucjoVXcwrddNFfeigVu4oy9RsPQLiV2Y5khOrlnlC.K/Im', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 21:11:11', '2025-01-05 21:11:12', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 21:11:12', '鯔枫襸途珐', 0);
INSERT INTO `sys_user` VALUES (59, 'NH1pAQ8S8yJztKeOJ', '$2a$10$8Qp0hLQGh6vf6aHL9i1UveBdToIvtZXlzBif2uf2gc/9QVIGtgIBa', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 21:16:33', '2025-01-05 21:16:33', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 21:16:34', '遞癒參蒵暽', 0);
INSERT INTO `sys_user` VALUES (60, 'iIZuXBqoeE', '$2a$10$to751r6rDX7BRKmHpwVUjeYwcH6towHfFLaLBnbyZwdNhq2mTkDoy', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 21:23:22', '2025-01-05 21:23:22', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 21:23:22', '釡僘聼蕾熷', 0);
INSERT INTO `sys_user` VALUES (61, 'AZedXThZv95hzL3Wy', '$2a$10$jiJDnIMBzYUKHE/gfRAfA.XaBJqdKjOw8OCsa2wH9BYoSHbCtkuPO', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 21:53:41', '2025-01-05 21:53:41', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 21:53:42', '皚銠蕭職喡', 0);
INSERT INTO `sys_user` VALUES (62, 'usY', '$2a$10$zL27PCDgRKwO09e.ZA4mWOgGco8oNwrzQywrQ2.8JpXz8kF..ByDy', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 21:57:27', '2025-01-05 21:57:28', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-05 21:57:28', '裧轄訚畇雇', 0);
INSERT INTO `sys_user` VALUES (63, 'iAPbhKGJucN4nZhmroX1', '$2a$10$WCnUmU4xTiJ8QlUaRpUPwOcP1XlT3Be2HpcqWjqCx10EMOFmohUJy', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-01-05 22:10:20', '2025-01-07 22:22:53', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '223.100.199.200', '2025-01-07 22:22:54', '塖慓奪劖渺', 0);
INSERT INTO `sys_user` VALUES (64, '24BIOHLn', '$2a$10$Du0jPJUWPmbLwYZBCasbYeTsa/OY42olKHY6HQR/LORpMT2mMgQum', 'uf7ad19490422a715@itt.com', NULL, NULL, NULL, '2025-01-06 20:07:57', '2025-01-10 10:12:49', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '223.100.199.200', '2025-01-10 10:12:49', '珂焊迲旙嬾', 0);
INSERT INTO `sys_user` VALUES (65, 'y3pDGrw', '$2a$10$Cg60QBJLUez0Fv2xO5hnGOJUK9VdZgr6Ts/a6GW3TCGznNQmaiqNq', 'uf5efb72ebfaeb9f1@itt.com', NULL, NULL, NULL, '2025-01-08 23:12:57', '2025-01-09 06:44:05', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '223.100.199.200', '2025-01-09 06:44:05', '历潏囐茥较', 0);
INSERT INTO `sys_user` VALUES (66, 'SKSZ4Y', '$2a$10$dD/8FBomyq1Z7suLFqyo7.QzpJEwZNdvZRODD5eaCjy6XA6ZC76rC', 'uf5efb72ebfaeb9f1@itt.com', NULL, NULL, NULL, '2025-01-09 17:54:10', '2025-01-09 17:54:11', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '223.100.199.200', '2025-01-09 17:54:12', '元就潹颩毒', 0);
INSERT INTO `sys_user` VALUES (67, 'Ce', '$2a$10$Af8JwWIMqDJh55qbJOhRBOUTRcKAXs3c0OX/24QBUc16J3E9eGfY2', 'uf5efb72ebfaeb9f1@itt.com', NULL, NULL, NULL, '2025-01-09 21:31:46', '2025-03-23 15:06:22', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.120', '2025-03-23 15:06:22', '浖萓菆是蠹', 0);
INSERT INTO `sys_user` VALUES (68, 'GmMpJULEDPHe', '$2a$10$IRZ95caUtUUDDWk7hT9CRe.pMGXJhu8yxtOE6ZpVLFIBO3BuQWBD2', 'u05a62a822ff9cd4a@itt.com', NULL, NULL, NULL, '2025-01-11 19:32:16', '2025-01-12 21:20:04', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.135', '2025-01-12 21:20:05', '憩畒随倧圀', 0);
INSERT INTO `sys_user` VALUES (69, '7PPLaRKGNcSpWjzBKQ', '$2a$10$iNqxDwJVT0mTtVsNt.eGc.nq7MZcwArv43hggqYMrYPYJriqp34Xa', 'uf7ad19490422a715@itt.com', NULL, NULL, NULL, '2025-01-13 19:17:06', '2025-01-15 06:37:39', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '223.100.199.200', '2025-01-15 06:37:40', '砓飘駇绛鷌', 0);
INSERT INTO `sys_user` VALUES (70, 'e9dVsyXXq0py', '$2a$10$ldSpSItLYXDg.DhypPDTGuZvOA3FV39RR.nauqXDbvUpjTCbwjlQu', 'u05a62a822ff9cd4a@itt.com', NULL, NULL, NULL, '2025-02-26 08:29:14', '2025-02-26 08:29:14', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.30.162', '2025-02-26 08:29:15', '牴査匿鰬齑', 0);
INSERT INTO `sys_user` VALUES (71, '0D8XZEkPPY1nWj8', '$2a$10$CiiyJBz/OZ.jKAqWlYbdMeFYkX4y/9yf/RNHVwa7Y8DyVQnc6eaj2', 'u05a62a822ff9cd4a@itt.com', NULL, NULL, NULL, '2025-02-27 10:12:50', '2025-03-06 21:23:03', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '39.144.55.81', '2025-03-06 21:23:04', '铇補嚹鮩例', 0);
INSERT INTO `sys_user` VALUES (72, 'j1a8NSP7Exi1xgimBOy', '$2a$10$P2./AvU2znE3EhQf4fIDG.AOeMMWzkIoP.yfL4qquR1.l8Pe70Rsi', 'u2b97d1a4d21f7845@itt.com', NULL, NULL, NULL, '2025-04-23 15:41:51', '2025-04-26 11:17:20', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '223.100.199.200', '2025-04-26 11:17:21', '攣铸宀桬晠', 0);
INSERT INTO `sys_user` VALUES (73, 'pRGpf8', '$2a$10$yn2W18s20dmv0nGWM/Y0t.0MU1hgmf/gtRSX9gxUiBw8fpha26Bgu', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-04-26 16:22:41', '2025-04-28 09:45:33', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.29.160', '2025-04-28 09:45:34', '嬝清废拣鄳', 0);
INSERT INTO `sys_user` VALUES (74, '3k', '$2a$10$7AFDawtG2oqhD3PqeY3Igey0z4UP48aWRrD3xXdE9zYc1bku7HjzO', 'ub56840eabcab2857@itt.com', NULL, NULL, NULL, '2025-04-28 10:21:00', '2025-05-20 05:15:14', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.29.120', '2025-05-20 05:15:14', '駉鐁脁潳埋', 0);
INSERT INTO `sys_user` VALUES (75, 'Hvxk0eU4moSye', '$2a$10$0GAgpOskWb78FLt.ogAIAu.zks6dlZPdQQes71IrtZNT2bk/njrKS', 'u05a62a822ff9cd4a@itt.com', NULL, NULL, NULL, '2025-04-28 10:43:20', '2025-05-08 21:24:29', NULL, NULL, NULL, 0, NULL, NULL, NULL, 201, '00', '0', '0', '0', '112.42.29.120', '2025-05-08 21:24:29', '辺卫屳丈萫', 0);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_gl_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (6, 100);
INSERT INTO `sys_user_role` VALUES (7, 100);
INSERT INTO `sys_user_role` VALUES (12, 100);
INSERT INTO `sys_user_role` VALUES (13, 100);
INSERT INTO `sys_user_role` VALUES (14, 100);
INSERT INTO `sys_user_role` VALUES (15, 100);
INSERT INTO `sys_user_role` VALUES (16, 100);
INSERT INTO `sys_user_role` VALUES (17, 101);
INSERT INTO `sys_user_role` VALUES (18, 100);
INSERT INTO `sys_user_role` VALUES (19, 100);
INSERT INTO `sys_user_role` VALUES (20, 100);
INSERT INTO `sys_user_role` VALUES (21, 100);
INSERT INTO `sys_user_role` VALUES (22, 100);
INSERT INTO `sys_user_role` VALUES (23, 100);
INSERT INTO `sys_user_role` VALUES (24, 100);
INSERT INTO `sys_user_role` VALUES (25, 100);
INSERT INTO `sys_user_role` VALUES (26, 100);
INSERT INTO `sys_user_role` VALUES (27, 100);
INSERT INTO `sys_user_role` VALUES (28, 100);
INSERT INTO `sys_user_role` VALUES (29, 100);
INSERT INTO `sys_user_role` VALUES (30, 100);
INSERT INTO `sys_user_role` VALUES (31, 100);
INSERT INTO `sys_user_role` VALUES (32, 100);
INSERT INTO `sys_user_role` VALUES (33, 100);
INSERT INTO `sys_user_role` VALUES (34, 100);
INSERT INTO `sys_user_role` VALUES (35, 100);
INSERT INTO `sys_user_role` VALUES (36, 100);
INSERT INTO `sys_user_role` VALUES (37, 100);
INSERT INTO `sys_user_role` VALUES (38, 100);
INSERT INTO `sys_user_role` VALUES (39, 100);
INSERT INTO `sys_user_role` VALUES (40, 100);
INSERT INTO `sys_user_role` VALUES (41, 100);
INSERT INTO `sys_user_role` VALUES (42, 100);
INSERT INTO `sys_user_role` VALUES (43, 100);
INSERT INTO `sys_user_role` VALUES (44, 100);
INSERT INTO `sys_user_role` VALUES (45, 100);
INSERT INTO `sys_user_role` VALUES (46, 100);
INSERT INTO `sys_user_role` VALUES (47, 100);
INSERT INTO `sys_user_role` VALUES (48, 100);
INSERT INTO `sys_user_role` VALUES (49, 100);
INSERT INTO `sys_user_role` VALUES (50, 100);
INSERT INTO `sys_user_role` VALUES (51, 100);
INSERT INTO `sys_user_role` VALUES (52, 100);
INSERT INTO `sys_user_role` VALUES (53, 100);
INSERT INTO `sys_user_role` VALUES (54, 100);
INSERT INTO `sys_user_role` VALUES (55, 100);
INSERT INTO `sys_user_role` VALUES (56, 100);
INSERT INTO `sys_user_role` VALUES (57, 100);
INSERT INTO `sys_user_role` VALUES (58, 100);
INSERT INTO `sys_user_role` VALUES (59, 100);
INSERT INTO `sys_user_role` VALUES (60, 100);
INSERT INTO `sys_user_role` VALUES (61, 100);
INSERT INTO `sys_user_role` VALUES (62, 100);
INSERT INTO `sys_user_role` VALUES (63, 100);
INSERT INTO `sys_user_role` VALUES (64, 100);
INSERT INTO `sys_user_role` VALUES (65, 100);
INSERT INTO `sys_user_role` VALUES (66, 100);
INSERT INTO `sys_user_role` VALUES (67, 100);
INSERT INTO `sys_user_role` VALUES (68, 100);
INSERT INTO `sys_user_role` VALUES (69, 100);
INSERT INTO `sys_user_role` VALUES (70, 100);
INSERT INTO `sys_user_role` VALUES (71, 100);
INSERT INTO `sys_user_role` VALUES (72, 100);
INSERT INTO `sys_user_role` VALUES (73, 100);
INSERT INTO `sys_user_role` VALUES (74, 100);
INSERT INTO `sys_user_role` VALUES (75, 100);

SET FOREIGN_KEY_CHECKS = 1;
