CREATE DATABASE IF NOT EXISTS sentifi_lite_db
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE sentifi_lite_db;

CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS projects (
    id VARCHAR(36) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS posts (
    id VARCHAR(36) PRIMARY KEY,
    project_id VARCHAR(36) NOT NULL,
    post_url TEXT NOT NULL,
    post_url_hash CHAR(64) NOT NULL,
    author_name VARCHAR(255) NULL,
    content TEXT NULL,
    total_comments INT DEFAULT 0,
    tagged_comments INT DEFAULT 0,
    scraped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,
    UNIQUE KEY uq_project_post_hash (project_id, post_url_hash)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS comments (
    id VARCHAR(36) PRIMARY KEY,
    post_id VARCHAR(36) NOT NULL,
    parent_comment_id VARCHAR(36) NULL,
    author_name VARCHAR(255) NULL,
    comment_text TEXT NOT NULL,
    sentiment ENUM('POSITIVE', 'NEGATIVE', 'NEUTRAL', 'TROLL') NULL,
    scraped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_comment_id) REFERENCES comments(id) ON DELETE CASCADE,
    INDEX idx_post_id (post_id),
    INDEX idx_parent_id (parent_comment_id)
) ENGINE=InnoDB;