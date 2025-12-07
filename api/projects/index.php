<?php
declare(strict_types=1);

require '../db_con.php';
require 'projectsService.php';
require '../api_headers.php';

handlePreflight();

$method = $_SERVER['REQUEST_METHOD'];
$input = json_decode(file_get_contents('php://input'), true) ?? [];

switch ($method) {
    case 'GET':
        $response = getProjects();
        break;
    case 'POST':
        $response = createProject($input);
        break;
    case 'PUT':
        $response = updateProject($input);
        break;
    case 'DELETE':
        $response = deleteProject($input);
        break;
    default:
        http_response_code(405);
        $response = ['status' => 'error', 'message' => 'Method Not Allowed'];
}

echo json_encode($response);
