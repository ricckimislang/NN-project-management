<?php
    


function showProject (int $projectId) {
    global $pdo;
    
    // Get project details with manager
    $stmt = $pdo->prepare("SELECT p.*, e.name AS project_manager FROM projects p LEFT JOIN project_assignments pa on p.id = pa.project_id LEFT JOIN employees e on pa.employee_id = e.id WHERE pa.role_id = 1 AND p.id = :id");
    $stmt->execute(['id' => $projectId]);
    $project = $stmt->fetch();
    
    if (!$project) {
        return ['status' => 'error', 'message' => 'Project not found'];
    }
    
    // Get workers assigned to this project
    $stmt = $pdo->prepare("SELECT e.id, e.name, e.contact, r.name as role FROM project_assignments pa 
                          JOIN employees e ON pa.employee_id = e.id 
                          JOIN roles r ON pa.role_id = r.id 
                          WHERE pa.project_id = :project_id AND r.name != 'Foreman'");
    $stmt->execute(['project_id' => $projectId]);
    $workers = $stmt->fetchAll();
    
    // Add workers to project data
    $project['workers'] = $workers;
    
    return [
        'status' => 'success',
        'data' => $project
    ];
}
function createProject () {
    return ['status' => 'success', 'data' => true];
}
function destroyProject(int $projectId) {
    global $pdo;
    // Add your delete logic here
    return ['status' => 'success', 'message' => 'Project deleted'];
}
function patchProject(int $projectId) {
    global $pdo;
    // Add your update logic here
    return ['status' => 'success', 'message' => 'Project updated'];
}

?>