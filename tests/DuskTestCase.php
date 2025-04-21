<?php

namespace Tests;

use Illuminate\Support\Collection;
use Facebook\WebDriver\Chrome\ChromeOptions;
use Facebook\WebDriver\Remote\DesiredCapabilities;
use Facebook\WebDriver\Remote\RemoteWebDriver;
use Laravel\Dusk\TestCase as BaseTestCase;

abstract class DuskTestCase extends BaseTestCase
{
    use CreatesApplication;

    /**
     * Prepare for Dusk test execution.
     *
     * @beforeClass
     * @return void
     */
    public static function prepare()
    {
        if (! static::runningInContainer()) {
            static::startChromeDriver();
        }
    }

    /**
     * Determine whether the tests are running in a container.
     *
     * @return bool
     */
    protected static function runningInContainer()
    {
        return getenv('DUSK_DRIVER_URL') !== false;
    }

    /**
     * Create the RemoteWebDriver instance.
     *
     * @return \Facebook\WebDriver\Remote\RemoteWebDriver
     */
    protected function driver()
    {
        $options = (new ChromeOptions)->addArguments([
            '--disable-gpu',
            '--headless=new',          // ← Nuevo modo headless
            '--no-sandbox',
            '--disable-dev-shm-usage', // ← Evita errores de memoria en CI [[7]][[8]]
            '--window-size=1920,1080',
        ]);

        return RemoteWebDriver::create(
            'http://localhost:9515', // ← URL correcta para ChromeDriver [[8]]
            DesiredCapabilities::chrome()->setCapability(
                ChromeOptions::CAPABILITY, $options
            ),
            60000, // Timeout de conexión
            60000  // Timeout de solicitud
        );
    }
}