<?php
// business logics only
function getProjects() {
    global $pdo;

    $stmt = $pdo->query("SELECT p.*, e.name AS project_manager FROM projects p LEFT JOIN project_assignments pa on p.id = pa.project_id LEFT JOIN employees e on pa.employee_id = e.id WHERE pa.role_id = 1");
    $projects = $stmt->fetchAll();

    return [
        'status' => 'success',
        'data' => $projects
    ];
}

function createProject($input) {
    global $pdo;

    $stmt = $pdo->prepare("INSERT INTO projects (name) VALUES (:name)");
    $stmt->execute(['name' => $input['name']]);

    return ['status' => 'success'];
}

function updateProject($input) {
    return ['status' => 'success'];
}

function deleteProject($input) {
    return ['status' => 'success'];
}
