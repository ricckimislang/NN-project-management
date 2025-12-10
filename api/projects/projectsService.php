<?php
// business logics only
function getProjects() {
    global $pdo;

    $stmt = $pdo->query("SELECT p.*, e.name AS project_manager 
    FROM projects p LEFT JOIN project_assignments pa on p.id = pa.project_id AND pa.role_id = 1 
    LEFT JOIN employees e on pa.employee_id = e.id ");
    $projects = $stmt->fetchAll();
    
    // Remove underscore from status for each project
    foreach ($projects as &$project) {
        $project['status'] = removeUnderscore($project['status']);
    }

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

// remove _ in status
function removeUnderscore($status){
    return ucwords(str_replace('_',' ', $status));
}