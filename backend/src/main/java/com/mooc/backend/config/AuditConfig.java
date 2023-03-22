package com.mooc.backend.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

/**
 * JPA 审计配置
 */
@EnableJpaAuditing
@Configuration
public class AuditConfig {
}
