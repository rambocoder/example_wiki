CREATE DATABASE example_wiki;

USE example_wiki;

CREATE TABLE IF NOT EXISTS `pages` (
  `id` bigint(11) unsigned NOT NULL AUTO_INCREMENT,
  `page_title` varchar(32) NOT NULL,
  `page_text` varchar(1024) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;
