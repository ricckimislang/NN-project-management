<?php

function handlePreflight() {
    header("Content-Type: application/json");
    header("Access-Control-Allow-Origin: http://localhost:5173 ");
    header("Access-Control-Allow-Credentials: true");
    header("Access-Control-Allow-Methods: *");
    header("Access-Control-Allow-Headers: *");

    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        http_response_code(204);
        exit();
    }
}
