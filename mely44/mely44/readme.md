# Guía Completa para Desplegar un Proyecto Django

## Índice

1. [Preparación del Entorno](#1-preparación-del-entorno)
2. [Configuración del Proyecto Django](#2-configuración-del-proyecto-django)
3. [Configuración de la Base de Datos](#3-configuración-de-la-base-de-datos)
4. [Configuración del Servidor Web](#4-configuración-del-servidor-web)
5. [Seguridad](#5-seguridad)
6. [Monitoreo y Mantenimiento](#6-monitoreo-y-mantenimiento)
7. [Escalabilidad](#7-escalabilidad)
8. [Resolución de Problemas Comunes](#8-resolución-de-problemas-comunes)

## 1. Preparación del Entorno

### Requisitos del Sistema
- Python 3.8 o superior
- Pip (administrador de paquetes de Python)
- Virtualenv o Pipenv
- Git
- Base de datos (PostgreSQL recomendado para producción)
- Servidor web (Nginx o Apache)
- Sistema operativo: Linux (Ubuntu/Debian recomendado)

### Instalación de Dependencias en Ubuntu/Debian

```bash
# Actualizar el sistema
sudo apt update
sudo apt upgrade -y

# Instalar Python y herramientas relacionadas
sudo apt install python3 python3-pip python3-venv git -y

# Instalar dependencias para PostgreSQL
sudo apt install postgresql postgresql-contrib libpq-dev -y

# Instalar Nginx
sudo apt install nginx -y

# Instalar Supervisor para gestionar procesos
sudo apt install supervisor -y
```

## 2. Configuración del Proyecto Django

### Configuración del Entorno Virtual

```bash
# Crear un directorio para el proyecto
mkdir -p /var/www/miproyecto
cd /var/www/miproyecto

# Crear entorno virtual
python3 -m venv venv
source venv/bin/activate

# Clonar el repositorio (si existe)
git clone https://github.com/usuario/miproyecto.git src
cd src

# Instalar dependencias
pip install -r requirements.txt

# Si no tienes un archivo requirements.txt, al menos instala:
pip install django gunicorn psycopg2-binary
```

### Configuración de settings.py para Producción

Crea un archivo `settings_prod.py` o modifica tu `settings.py`:

```python
# settings_prod.py
from .settings import *

# Configuración de seguridad
DEBUG = False
ALLOWED_HOSTS = ['tudominio.com', 'www.tudominio.com', 'IP_DEL_SERVIDOR']

# Configuración de la base de datos
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'nombre_bd',
        'USER': 'usuario_bd',
        'PASSWORD': 'contraseña_bd',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}

# Configuración de archivos estáticos
STATIC_URL = '/static/'
STATIC_ROOT = '/var/www/miproyecto/static/'
MEDIA_URL = '/media/'
MEDIA_ROOT = '/var/www/miproyecto/media/'

# Configuración de seguridad adicional
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = 'DENY'

# Configuración de caché (opcional)
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '127.0.0.1:11211',
    }
}

# Configuración de logging
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file': {
            'level': 'ERROR',
            'class': 'logging.FileHandler',
            'filename': '/var/www/miproyecto/logs/django_error.log',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'level': 'ERROR',
            'propagate': True,
        },
    },
}
```

### Recolección de Archivos Estáticos

```bash
# Crear directorios necesarios
mkdir -p /var/www/miproyecto/static
mkdir -p /var/www/miproyecto/media
mkdir -p /var/www/miproyecto/logs

# Recolectar archivos estáticos
python manage.py collectstatic --settings=miproyecto.settings_prod
```

## 3. Configuración de la Base de Datos

### Configuración de PostgreSQL

```bash
# Acceder a PostgreSQL
sudo -u postgres psql

# Crear usuario y base de datos
CREATE USER usuario_bd WITH PASSWORD 'contraseña_bd';
CREATE DATABASE nombre_bd OWNER usuario_bd;
ALTER ROLE usuario_bd SET client_encoding TO 'utf8';
ALTER ROLE usuario_bd SET default_transaction_isolation TO 'read committed';
ALTER ROLE usuario_bd SET timezone TO 'UTC';
\q

# Migrar la base de datos
python manage.py migrate --settings=miproyecto.settings_prod
```

## 4. Configuración del Servidor Web

### Configuración de Gunicorn

Crea un archivo `gunicorn_start.sh` en el directorio del proyecto:

```bash
#!/bin/bash

NAME="miproyecto"
DJANGODIR=/var/www/miproyecto/src
USER=www-data
GROUP=www-data
WORKERS=3
BIND=unix:/var/www/miproyecto/run/gunicorn.sock
DJANGO_SETTINGS_MODULE=miproyecto.settings_prod
DJANGO_WSGI_MODULE=miproyecto.wsgi
LOG_LEVEL=error

cd $DJANGODIR
source ../venv/bin/activate

# Crear directorio para el socket si no existe
mkdir -p /var/www/miproyecto/run/

# Iniciar Gunicorn
exec ../venv/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $WORKERS \
  --user=$USER \
  --group=$GROUP \
  --bind=$BIND \
  --log-level=$LOG_LEVEL \
  --log-file=-
```

Haz el script ejecutable:

```bash
chmod +x gunicorn_start.sh
```

### Configuración de Supervisor

Crea un archivo de configuración para Supervisor:

```bash
sudo nano /etc/supervisor/conf.d/miproyecto.conf
```

Añade el siguiente contenido:

```ini
[program:miproyecto]
command=/var/www/miproyecto/src/gunicorn_start.sh
user=www-data
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=/var/www/miproyecto/logs/gunicorn-error.log
```

Inicia el servicio:

```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl status miproyecto
```

### Configuración de Nginx

Crea un archivo de configuración para Nginx:

```bash
sudo nano /etc/nginx/sites-available/miproyecto
```

Añade el siguiente contenido:

```nginx
server {
    listen 80;
    server_name tudominio.com www.tudominio.com;

    # Redirección a HTTPS (después de configurar SSL)
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name tudominio.com www.tudominio.com;

    ssl_certificate /etc/letsencrypt/live/tudominio.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/tudominio.com/privkey.pem;
    
    # Configuraciones SSL recomendadas
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
    
    client_max_body_size 10M;

    location = /favicon.ico { 
        access_log off; 
        log_not_found off; 
    }

    location /static/ {
        alias /var/www/miproyecto/static/;
    }

    location /media/ {
        alias /var/www/miproyecto/media/;
    }

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass http://unix:/var/www/miproyecto/run/gunicorn.sock;
    }
}
```

Habilita la configuración y reinicia Nginx:

```bash
sudo ln -s /etc/nginx/sites-available/miproyecto /etc/nginx/sites-enabled/
sudo nginx -t  # Verifica la configuración
sudo systemctl restart nginx
```

### Configuración de SSL con Let's Encrypt

```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obtener certificado SSL
sudo certbot --nginx -d tudominio.com -d www.tudominio.com

# Renovación automática
sudo certbot renew --dry-run
```

## 5. Seguridad

### Firewall (UFW)

```bash
# Instalar y configurar UFW
sudo apt install ufw -y
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw enable
sudo ufw status
```

### Configuración de Permisos

```bash
# Establecer permisos adecuados
sudo chown -R www-data:www-data /var/www/miproyecto
sudo chmod -R 755 /var/www/miproyecto
```

### Variables de Entorno para Secretos

Usa un archivo `.env` para almacenar secretos y variables sensibles:

```bash
# Instalar django-environ
pip install django-environ

# Crear archivo .env
echo "SECRET_KEY='tu_clave_secreta'" > /var/www/miproyecto/src/.env
echo "DB_PASSWORD='contraseña_bd'" >> /var/www/miproyecto/src/.env
```

Y actualiza `settings_prod.py`:

```python
import environ

env = environ.Env()
environ.Env.read_env()  # Lee el archivo .env

SECRET_KEY = env('SECRET_KEY')
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'nombre_bd',
        'USER': 'usuario_bd',
        'PASSWORD': env('DB_PASSWORD'),
        'HOST': 'localhost',
        'PORT': '5432',
    }
}
```

## 6. Monitoreo y Mantenimiento

### Configuración de Backups

Crea un script de respaldo (`backup_db.sh`):

```bash
#!/bin/bash
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="/var/backups/miproyecto"

# Crear directorio de respaldo si no existe
mkdir -p $BACKUP_DIR

# Respaldo de la base de datos
pg_dump -U usuario_bd nombre_bd > $BACKUP_DIR/db_$DATE.sql

# Respaldo de archivos de medios
tar -czf $BACKUP_DIR/media_$DATE.tar.gz /var/www/miproyecto/media

# Eliminar respaldos antiguos (mantener los últimos 7 días)
find $BACKUP_DIR -name "db_*" -type f -mtime +7 -delete
find $BACKUP_DIR -name "media_*" -type f -mtime +7 -delete
```

Programa el script con cron:

```bash
chmod +x backup_db.sh
sudo crontab -e

# Añadir esta línea para ejecutar el respaldo diario a las 2 AM
0 2 * * * /var/www/miproyecto/backup_db.sh
```

### Actualización de la Aplicación

Crea un script para actualizar la aplicación (`update_app.sh`):

```bash
#!/bin/bash
cd /var/www/miproyecto/src
source ../venv/bin/activate

# Obtener cambios del repositorio
git pull

# Instalar dependencias
pip install -r requirements.txt

# Migrar la base de datos
python manage.py migrate --settings=miproyecto.settings_prod

# Recolectar archivos estáticos
python manage.py collectstatic --noinput --settings=miproyecto.settings_prod

# Reiniciar servicios
sudo supervisorctl restart miproyecto
```

## 7. Escalabilidad

### Configuración de Caché con Redis

```bash
# Instalar Redis
sudo apt install redis-server -y

# Configurar Redis para iniciar con el sistema
sudo systemctl enable redis-server

# Instalar librería de Python para Redis
pip install django-redis
```

Actualiza `settings_prod.py`:

```python
# Configuración de caché con Redis
CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://127.0.0.1:6379/1",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        }
    }
}

# Configuración de sesiones con Redis
SESSION_ENGINE = "django.contrib.sessions.backends.cache"
SESSION_CACHE_ALIAS = "default"
```

### Configuración de Colas con Celery

```bash
# Instalar Celery
pip install celery
```

Crea un archivo `celery.py` en tu directorio de proyecto:

```python
# miproyecto/celery.py
import os
from celery import Celery

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'miproyecto.settings_prod')

app = Celery('miproyecto')
app.config_from_object('django.conf:settings', namespace='CELERY')
app.autodiscover_tasks()
```

Actualiza `__init__.py` en tu directorio de proyecto:

```python
# miproyecto/__init__.py
from .celery import app as celery_app

__all__ = ('celery_app',)
```

Añade configuración a `settings_prod.py`:

```python
# Configuración de Celery
CELERY_BROKER_URL = 'redis://localhost:6379/0'
CELERY_RESULT_BACKEND = 'redis://localhost:6379/0'
CELERY_ACCEPT_CONTENT = ['application/json']
CELERY_TASK_SERIALIZER = 'json'
CELERY_RESULT_SERIALIZER = 'json'
CELERY_TIMEZONE = 'UTC'
```

Configura Supervisor para Celery:

```bash
sudo nano /etc/supervisor/conf.d/celery.conf
```

```ini
[program:celery]
command=/var/www/miproyecto/venv/bin/celery -A miproyecto worker -l info
directory=/var/www/miproyecto/src
user=www-data
autostart=true
autorestart=true
stderr_logfile=/var/www/miproyecto/logs/celery.err.log
stdout_logfile=/var/www/miproyecto/logs/celery.out.log
```

```bash
sudo supervisorctl reread
sudo supervisorctl update
```

## 8. Resolución de Problemas Comunes

### Verificar Logs

```bash
# Logs de Django
tail -f /var/www/miproyecto/logs/django_error.log

# Logs de Gunicorn
tail -f /var/www/miproyecto/logs/gunicorn-error.log

# Logs de Nginx
tail -f /var/log/nginx/error.log
tail -f /var/log/nginx/access.log

# Logs de Supervisor
tail -f /var/log/supervisor/supervisord.log
```

### Comprobación de Estado de Servicios

```bash
# Estado de Nginx
sudo systemctl status nginx

# Estado de PostgreSQL
sudo systemctl status postgresql

# Estado de Redis
sudo systemctl status redis-server

# Estado de Supervisor
sudo supervisorctl status
```

### Problemas de Permisos

```bash
# Si hay problemas de permisos, verifica y corrige
sudo find /var/www/miproyecto -type d -exec chmod 755 {} \;
sudo find /var/www/miproyecto -type f -exec chmod 644 {} \;
sudo chown -R www-data:www-data /var/www/miproyecto
```

### Problema: La aplicación no carga

1. Verifica que Gunicorn esté funcionando:
   ```bash
   sudo supervisorctl status miproyecto
   ```

2. Verifica los logs:
   ```bash
   sudo tail -f /var/www/miproyecto/logs/gunicorn-error.log
   ```

3. Prueba Gunicorn manualmente:
   ```bash
   cd /var/www/miproyecto/src
   source ../venv/bin/activate
   gunicorn miproyecto.wsgi:application
   ```

### Problema: Error de conexión a la base de datos

1. Verifica que PostgreSQL esté funcionando:
   ```bash
   sudo systemctl status postgresql
   ```

2. Prueba la conexión a la base de datos:
   ```bash
   psql -U usuario_bd -h localhost -d nombre_bd
   ```

3. Verifica la configuración en `settings_prod.py`.

### Problema: Archivos estáticos no se cargan

1. Verifica que hayas ejecutado `collectstatic`:
   ```bash
   python manage.py collectstatic --settings=miproyecto.settings_prod
   ```

2. Verifica los permisos:
   ```bash
   sudo chown -R www-data:www-data /var/www/miproyecto/static
   ```

3. Verifica la configuración de Nginx.

### Reiniciar Todo el Sistema

En caso de problemas persistentes, a veces reiniciar todos los servicios puede ayudar:

```bash
sudo systemctl restart nginx
sudo systemctl restart postgresql
sudo supervisorctl restart all
sudo systemctl restart redis-server  # Si estás usando Redis
```

---

Este documento ofrece una guía completa para desplegar un proyecto Django en producción. Recuerda adaptar las configuraciones según tus necesidades específicas y mantener actualizado el sistema con las últimas actualizaciones de seguridad.