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
        
        // Asegúrate de que la base de datos está configurada correctamente para pruebas
        $this->app['config']->set('database.connections.pgsql.host', 'localhost');
        $this->app['config']->set('database.connections.pgsql.port', '5433'); // Usa el puerto remapeado
    }
}