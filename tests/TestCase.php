<?php

namespace Tests;

use Illuminate\Foundation\Testing\TestCase as BaseTestCase;
use Illuminate\Support\Facades\Artisan;

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
        
        // Configura SQLite en memoria
        $this->app['config']->set('database.default', 'sqlite');
        $this->app['config']->set('database.connections.sqlite', [
            'driver' => 'sqlite',
            'database' => ':memory:',
            'prefix' => '',
        ]);
        
        // Ejecuta las migraciones
        Artisan::call('migrate');
    }
}