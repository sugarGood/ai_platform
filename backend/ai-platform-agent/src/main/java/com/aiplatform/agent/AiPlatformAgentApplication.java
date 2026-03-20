package com.aiplatform.agent;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

/**
 * Agent 网关模块启动入口。
 *
 * <p>负责启动运行时 AI 网关服务，并扫描网关模块使用的 MyBatis Mapper
 * 与配置属性。</p>
 */
@SpringBootApplication
@MapperScan("com.aiplatform.agent.gateway.mapper")
@ConfigurationPropertiesScan
public class AiPlatformAgentApplication {

    /**
     * 启动 Agent 网关应用。
     *
     * @param args 启动参数
     */
    public static void main(String[] args) {
        SpringApplication.run(AiPlatformAgentApplication.class, args);
    }
}
