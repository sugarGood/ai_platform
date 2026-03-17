package com.aiplatform.backend.aikey.service;

import com.aiplatform.backend.aikey.dto.CreateProjectAiKeyRequest;
import com.aiplatform.backend.aikey.dto.ProjectAiKeyUsageResponse;
import com.aiplatform.backend.aikey.entity.ProjectAiKey;
import com.aiplatform.backend.aikey.mapper.ProjectAiKeyMapper;
import com.aiplatform.backend.common.exception.InvalidAiKeyQuotaException;
import com.aiplatform.backend.common.exception.ProjectAiKeyAlreadyExistsException;
import com.aiplatform.backend.common.exception.ProjectNotFoundException;
import com.aiplatform.backend.project.mapper.ProjectMapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 项目 AI 密钥业务服务层。
 *
 * <p>负责密钥的创建（含重名校验、配额合法性校验、密钥脱敏）、列表查询、
 * 以及用量汇总统计（配额聚合、使用率计算、按状态/告警分类计数）。</p>
 *
 * @see ProjectAiKeyMapper
 * @see com.aiplatform.backend.aikey.controller.ProjectAiKeyController
 */
@Service
public class ProjectAiKeyService {

    /** 当前唯一支持的 AI 服务提供商常量 */
    private static final String PROVIDER_CODEX = "CODEX";

    private final ProjectAiKeyMapper projectAiKeyMapper;
    private final ProjectMapper projectMapper;

    public ProjectAiKeyService(ProjectAiKeyMapper projectAiKeyMapper, ProjectMapper projectMapper) {
        this.projectAiKeyMapper = projectAiKeyMapper;
        this.projectMapper = projectMapper;
    }

    /**
     * 创建项目 AI 密钥。
     *
     * <p>创建流程：
     * <ol>
     *   <li>校验项目是否存在，不存在则抛出 {@link ProjectNotFoundException}</li>
     *   <li>校验已用量不得超过月度配额，否则抛出 {@link InvalidAiKeyQuotaException}</li>
     *   <li>检查同一项目下是否已存在同名密钥，重名则抛出 {@link ProjectAiKeyAlreadyExistsException}</li>
     *   <li>生成脱敏密钥（{@link #maskSecretKey(String)}），设置初始状态为 {@code "ACTIVE"}</li>
     *   <li>插入数据库并返回含自增 ID 的实体</li>
     * </ol>
     * </p>
     *
     * @param projectId 项目 ID
     * @param request   创建请求 DTO
     * @return 创建成功的密钥实体（含数据库自增 ID）
     * @throws ProjectNotFoundException          项目不存在
     * @throws InvalidAiKeyQuotaException        usedQuota 大于 monthlyQuota
     * @throws ProjectAiKeyAlreadyExistsException 同项目下密钥名称重复
     */
    public ProjectAiKey create(Long projectId, CreateProjectAiKeyRequest request) {
        assertProjectExists(projectId);
        assertQuotaIsValid(request.monthlyQuota(), request.usedQuota());

        // 同一项目内密钥名称唯一性检查
        ProjectAiKey existing = projectAiKeyMapper.selectOne(Wrappers.<ProjectAiKey>lambdaQuery()
                .eq(ProjectAiKey::getProjectId, projectId)
                .eq(ProjectAiKey::getName, request.name()));
        if (existing != null) {
            throw new ProjectAiKeyAlreadyExistsException(projectId, request.name());
        }

        ProjectAiKey projectAiKey = new ProjectAiKey();
        projectAiKey.setProjectId(projectId);
        projectAiKey.setName(request.name());
        projectAiKey.setProvider(request.provider());
        projectAiKey.setSecretKey(request.secretKey());
        // 生成脱敏展示值，前端仅看到此字段
        projectAiKey.setMaskedKey(maskSecretKey(request.secretKey()));
        projectAiKey.setMonthlyQuota(request.monthlyQuota());
        projectAiKey.setUsedQuota(request.usedQuota());
        projectAiKey.setAlertThresholdPercent(request.alertThresholdPercent());
        // 新建密钥默认为启用状态
        projectAiKey.setStatus("ACTIVE");
        projectAiKeyMapper.insert(projectAiKey);
        return projectAiKey;
    }

    /**
     * 查询指定项目下的所有 AI 密钥列表，按 ID 升序排列。
     *
     * @param projectId 项目 ID
     * @return 该项目下所有密钥实体列表，可能为空
     * @throws ProjectNotFoundException 项目不存在
     */
    public List<ProjectAiKey> listByProjectId(Long projectId) {
        assertProjectExists(projectId);
        return projectAiKeyMapper.selectList(Wrappers.<ProjectAiKey>lambdaQuery()
                .eq(ProjectAiKey::getProjectId, projectId)
                .orderByAsc(ProjectAiKey::getId));
    }

    /**
     * 生成指定项目的 AI 密钥用量汇总报告。
     *
     * <p>聚合逻辑：
     * <ul>
     *   <li><b>totalMonthlyQuota</b>：所有密钥的 monthlyQuota 之和</li>
     *   <li><b>totalUsedQuota</b>：所有密钥的 usedQuota 之和</li>
     *   <li><b>remainingQuota</b>：总配额减去总已用量，最小为 0（防止负值）</li>
     *   <li><b>usageRatePercent</b>：总已用量占总配额的百分比（整数截断）；总配额为 0 时返回 0</li>
     *   <li><b>activeKeyCount / disabledKeyCount</b>：按 status 字段统计</li>
     *   <li><b>alertingKeyCount</b>：使用率已达告警阈值但尚未耗尽的密钥数</li>
     *   <li><b>exhaustedKeyCount</b>：usedQuota >= monthlyQuota 的密钥数</li>
     * </ul>
     * </p>
     *
     * @param projectId 项目 ID
     * @return 用量汇总响应 DTO
     * @throws ProjectNotFoundException 项目不存在
     */
    public ProjectAiKeyUsageResponse usageSummary(Long projectId) {
        List<ProjectAiKey> keys = listByProjectId(projectId);

        // 汇总所有密钥的月度配额
        long totalMonthlyQuota = keys.stream()
                .mapToLong(ProjectAiKey::getMonthlyQuota)
                .sum();
        // 汇总所有密钥的已使用量
        long totalUsedQuota = keys.stream()
                .mapToLong(ProjectAiKey::getUsedQuota)
                .sum();
        // 剩余配额不允许出现负值
        long remainingQuota = Math.max(totalMonthlyQuota - totalUsedQuota, 0L);
        // 使用率采用整数截断（非四舍五入），配额为 0 时避免除零异常
        int usageRatePercent = totalMonthlyQuota == 0
                ? 0
                : (int) ((totalUsedQuota * 100) / totalMonthlyQuota);
        int activeKeyCount = (int) keys.stream()
                .filter(key -> "ACTIVE".equals(key.getStatus()))
                .count();
        int disabledKeyCount = (int) keys.stream()
                .filter(key -> "DISABLED".equals(key.getStatus()))
                .count();
        int alertingKeyCount = (int) keys.stream()
                .filter(this::isAlerting)
                .count();
        int exhaustedKeyCount = (int) keys.stream()
                .filter(this::isExhausted)
                .count();

        return new ProjectAiKeyUsageResponse(
                projectId,
                PROVIDER_CODEX,
                totalMonthlyQuota,
                totalUsedQuota,
                remainingQuota,
                usageRatePercent,
                activeKeyCount,
                disabledKeyCount,
                alertingKeyCount,
                exhaustedKeyCount
        );
    }

    /**
     * 校验项目是否存在，不存在则抛出异常。
     *
     * @param projectId 项目 ID
     * @throws ProjectNotFoundException 项目不存在
     */
    private void assertProjectExists(Long projectId) {
        if (projectMapper.selectById(projectId) == null) {
            throw new ProjectNotFoundException(projectId);
        }
    }

    /**
     * 校验配额合法性：已使用量不得大于月度配额。
     *
     * @param monthlyQuota 月度配额
     * @param usedQuota    已使用量
     * @throws InvalidAiKeyQuotaException usedQuota > monthlyQuota
     */
    private void assertQuotaIsValid(Long monthlyQuota, Long usedQuota) {
        if (usedQuota > monthlyQuota) {
            throw new InvalidAiKeyQuotaException(monthlyQuota, usedQuota);
        }
    }

    /**
     * 对原始密钥进行脱敏处理，生成安全的展示值。
     *
     * <p>脱敏规则：
     * <ul>
     *   <li>密钥长度 <= 6：直接返回 {@code "****"}</li>
     *   <li>密钥长度 > 6：保留前 3 位 + {@code "****"} + 保留后 4 位（如 {@code "sk-****abcd"}）</li>
     * </ul>
     * </p>
     *
     * @param secretKey 原始密钥字符串
     * @return 脱敏后的密钥字符串
     */
    private String maskSecretKey(String secretKey) {
        if (secretKey.length() <= 6) {
            return "****";
        }
        return secretKey.substring(0, 3) + "****" + secretKey.substring(secretKey.length() - 4);
    }

    /**
     * 判断密钥是否处于告警状态。
     *
     * <p>告警条件（需同时满足）：
     * <ol>
     *   <li>密钥尚未耗尽（即 {@link #isExhausted(ProjectAiKey)} 返回 false）</li>
     *   <li>月度配额大于 0（避免除零）</li>
     *   <li>使用率百分比 >= 告警阈值：{@code usedQuota * 100 >= monthlyQuota * alertThresholdPercent}</li>
     * </ol>
     * 注意：采用乘法比较而非除法，避免浮点精度问题。
     * </p>
     *
     * @param key 密钥实体
     * @return 是否处于告警状态
     */
    private boolean isAlerting(ProjectAiKey key) {
        return !isExhausted(key)
                && key.getMonthlyQuota() > 0
                && key.getUsedQuota() * 100 >= (long) key.getMonthlyQuota() * key.getAlertThresholdPercent();
    }

    /**
     * 判断密钥配额是否已耗尽。
     *
     * <p>耗尽条件：{@code usedQuota >= monthlyQuota}。
     * 耗尽的密钥不再计入告警（{@link #isAlerting(ProjectAiKey)} 会排除已耗尽的密钥）。</p>
     *
     * @param key 密钥实体
     * @return 配额是否已耗尽
     */
    private boolean isExhausted(ProjectAiKey key) {
        return key.getUsedQuota() >= key.getMonthlyQuota();
    }
}
