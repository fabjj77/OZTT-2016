DROP TABLE IF EXISTS `t_powder_info`;
CREATE TABLE `t_powder_info` (
  `id` bigint(12) NOT NULL AUTO_INCREMENT,
  `powderNo` varchar(16) NOT NULL,
  `powderType` char(1) NOT NULL,
  `powderBrand` varchar(12) DEFAULT NULL,
  `powderSpec` varchar(6),
  `powderPrice` decimal(12, 2),
  `remarks` varchar(500) DEFAULT NULL,
  `status` char(1),
  `addTimestamp` timestamp NULL DEFAULT NULL,
  `addUserKey` varchar(40) DEFAULT NULL,
  `updTimestamp` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updUserKey` varchar(40) DEFAULT NULL,
  `updPgmId` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;