<?php
// business logics only
function getProjects() {
    global $pdo;

    $stmt = $pdo->query("SELECT * FROM projects");
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
