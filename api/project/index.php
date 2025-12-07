<?php
declare(strict_types=1);

require '../db_con.php';
require 'projectService.php';
require '../api_headers.php';

handlePreflight();

$method = $_SERVER['REQUEST_METHOD'];
$input = json_decode(file_get_contents('php://input'), true) ?? [];

switch ($method) {
    case 'GET':
        // Get project ID from URL parameter
        $projectId = $_GET['id'] ?? null;
        if (!$projectId) {
            http_response_code(400);
            $response = ['status' => 'error', 'message' => 'Project ID required'];
        } else {
            $response = showProject((int)$projectId);
        }
        break;
    case 'POST':
        $response = createProject();
        break;
    case 'DELETE':
        // Get project ID from URL parameter
        $projectId = $_GET['id'] ?? null;
        if (!$projectId) {
            http_response_code(400);
            $response = ['status' => 'error', 'message' => 'Project ID required'];
        } else {
            $response = destroyProject((int)$projectId);
        }
        break;
    case 'PATCH':
        // Get project ID from URL parameter
        $projectId = $_GET['id'] ?? null;
        if (!$projectId) {
            http_response_code(400);
            $response = ['status' => 'error', 'message' => 'Project ID required'];
        } else {
            $response = patchProject((int)$projectId);
        }
        break;
    default:
        http_response_code(405);
        $response = ['status' => 'error', 'message' => 'method Not Allowed'];
        break;
}
echo json_encode($response);