<?php

namespace App\Http\Controllers;

use OpenApi\Attributes as OA;

#[
    OA\Info(version: "1.0.0", description: "School API Documentation", title: "School API Documentation"),
    OA\Server(url: 'http://127.0.0.1:8000/api', description: "local server"),
    OA\Server(url: 'https://laravel-sqlite-api-swagger-mze.azurewebsites.net/api', description: "production server"),
    OA\Server(url: 'https://laravel-sqlite-api-swagger-mze.azurewebsites.net/api', description: "staging server"),
    OA\SecurityScheme(securityScheme: 'bearerAuth', type: "http", name: "Authorization", in: "header"),
]
abstract class Controller
{
    //
}
