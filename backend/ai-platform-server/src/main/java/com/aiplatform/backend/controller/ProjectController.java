package com.aiplatform.backend.controller;

import com.aiplatform.backend.dto.CreateProjectRequest;
import com.aiplatform.backend.dto.ProjectResponse;
import com.aiplatform.backend.service.ProjectService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Exposes project management endpoints for the admin backend.
 */
@RestController
@RequestMapping("/api/projects")
public class ProjectController {

    private final ProjectService projectService;

    public ProjectController(ProjectService projectService) {
        this.projectService = projectService;
    }

    /**
     * Creates a new project and returns its persisted snapshot.
     */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProjectResponse create(@Valid @RequestBody CreateProjectRequest request) {
        return ProjectResponse.from(projectService.create(request));
    }

    /**
     * Lists projects in stable creation order for frontend rendering.
     */
    @GetMapping
    public List<ProjectResponse> list() {
        return projectService.list().stream()
                .map(ProjectResponse::from)
                .toList();
    }
}
