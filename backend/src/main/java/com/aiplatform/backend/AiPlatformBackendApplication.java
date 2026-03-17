package com.aiplatform.backend;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * AI 中台后端服务的 Spring Boot 启动类。
 *
 * <p>作为整个应用程序的入口点，负责引导 Spring 容器的初始化与自动配置。
 * 通过 {@code @MapperScan} 注解扫描 {@code com.aiplatform.backend} 包及其子包下
 * 所有 MyBatis Mapper 接口，将其注册为 Spring Bean，从而无需在每个 Mapper
 * 接口上单独添加 {@code @Mapper} 注解。
 *
 * @see org.springframework.boot.autoconfigure.SpringBootApplication
 * @see org.mybatis.spring.annotation.MapperScan
 */
@SpringBootApplication
@MapperScan("com.aiplatform.backend")
public class AiPlatformBackendApplication {

    /**
     * 应用程序主入口方法，启动 Spring Boot 嵌入式容器。
     *
     * @param args 命令行参数，可用于覆盖应用配置（如 {@code --server.port=8081}）
     */
    public static void main(String[] args) {
        SpringApplication.run(AiPlatformBackendApplication.class, args);
    }
}
