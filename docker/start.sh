#!/bin/bash

# Iniciar PHP-FPM y Nginx mediante Supervisor
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf