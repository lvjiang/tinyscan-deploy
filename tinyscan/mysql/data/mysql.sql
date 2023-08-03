CREATE DATABASE `tinyscan` DEFAULT CHARACTER SET utf8mb4;
USE `tinyscan`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `item` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '菜单项',
  `role` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '所属角色',
  `parent` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '所属的父级菜单ID',
  `is_delete` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除，0：正常，1：删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (1, '用户管理', 1, 0, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (2, '新建用户', 1, 1, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (3, '用户列表', 1, 1, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (4, '报告管理', 1, 0, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (5, '报告配置', 1, 4, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (6, '任务管理', 1, 0, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (7, '固件检测', 1, 6, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (8, 'APP检测', 1, 6, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (9, '任务列表', 1, 6, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (10, '任务管理', 0, 0, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (11, '固件检测', 0, 10, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (12, 'APP检测', 0, 10, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (13, '任务列表', 0, 10, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (14, '系统管理', 2, 0, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (15, '页面配置', 2, 14, 0);
INSERT INTO `menu` (`id`, `item`, `role`, `parent`, `is_delete`) VALUES (16, '管理员配置', 2, 14, 0);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `gid` int(10) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'GID',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '用户名',
  `password` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '密码串',
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'openToken',
  `email` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '邮箱',
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '手机号码',
  `role` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '角色，0：普通用户，1：管理员用户，2：运维员用户',
  `is_delete` tinyint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT '是否删除，0：正常，1：删除',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` (`id`, `gid`, `name`, `password`, `token`, `email`, `phone`, `role`, `is_delete`) VALUES (1, 0, 'operator', 'GFkwdhZrbca1UHf04hmUsA==', '', '', '', 2, 0);

SET FOREIGN_KEY_CHECKS = 1;
