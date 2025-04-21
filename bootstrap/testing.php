<?php

use Illuminate\Foundation\Vite;
use Illuminate\Support\Facades\Facade;

Facade::macro('viteManifestMock', function () {
    app()->singleton(\Illuminate\Foundation\Vite::class, function () {
        return new class extends Vite {
            public function __invoke($entrypoints, $buildDirectory = null)
            {
                return '';
            }
            
            public function asset($asset, $buildDirectory = null)
            {
                return $asset;
            }
            
            public function useHotFile($path) 
            {
                return $this;
            }
            
            public function useBuildDirectory($path) 
            {
                return $this;
            }
            
            public function useScriptTagAttributes($attributes) 
            {
                return $this;
            }
            
            public function useStyleTagAttributes($attributes) 
            {
                return $this;
            }
            
            public function withEntryPoints($entryPoints) 
            {
                return $this;
            }
        };
    });
});

Facade::viteManifestMock();