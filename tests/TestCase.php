<?php

namespace Tests;

use Illuminate\Foundation\Testing\TestCase as BaseTestCase;

abstract class TestCase extends BaseTestCase
{
    use CreatesApplication;
    
    protected function setUp(): void
    {
        parent::setUp();
        
        // Carga el helper para manejar Vite en pruebas
        if (file_exists(__DIR__ . '/../bootstrap/testing.php')) {
            require_once __DIR__ . '/../bootstrap/testing.php';
        }
    }
}