<?php

function handlePreflight() {
    header("Content-Type: application/json");
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: *");
    header("Access-Control-Allow-Headers: *");

    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        exit();
    }
}
