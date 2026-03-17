package com.aiplatform.backend.member.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

/**
 * 创建项目成员的请求 DTO。
 *
 * <p>用于接收 {@code POST /api/projects/{projectId}/members} 请求体，
 * 所有字段均为必填项，由 Jakarta Validation 注解进行校验。</p>
 *
 * @param name  成员姓名，不能为空白字符串（{@code @NotBlank}）
 * @param email 成员邮箱，不能为空且须符合邮箱格式（{@code @NotBlank @Email}）；
 *              同一项目内邮箱不可重复，重复时服务层会抛出异常
 * @param role  成员角色，不能为空且仅允许 {@code "OWNER"} 或 {@code "DEVELOPER"}
 *              （{@code @NotBlank @Pattern(regexp = "OWNER|DEVELOPER")}）
 */
public record CreateProjectMemberRequest(
        @NotBlank
        String name,
        @NotBlank
        @Email
        String email,
        @NotBlank
        @Pattern(regexp = "OWNER|DEVELOPER")
        String role
) {
}
