# README

#  The Turtle Foundation — Despliegue en Servidor

Stack: **Ruby on Rails + PostgreSQL + Nginx + SSL**

Todo corre en Docker. En el servidor solo hace falta instalar Docker y hacer `docker compose up -d`.

---

##  Requisitos previos

- Servidor Ubuntu 22.04+ con acceso SSH
- Archivo `turtle.pem` para conectarse al servidor
- Dominio `fundacionlatortuga.com` apuntando a la IP del servidor
- Puertos 80 y 443 abiertos en el firewall

---

##  Conectarse al servidor

```bash
# Dar permisos correctos al .pem (solo la primera vez)
chmod 400 /home/cifra/Descargas/turtle.pem

# Conectarse
ssh -i /home/cifra/Descargas/turtle.pem ubuntu@44.213.233.211
```

---

##  1. Instalar Docker en el servidor

Conectado por SSH, ejecutar:

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Habilitar Docker al arranque
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker
```

---

##  2. Subir el proyecto al servidor

Desde tu PC local:

```bash
scp -i /home/cifra/Descargas/turtle.pem -r /home/cifra/Prueba2/theturtlefoundation ubuntu@44.213.233.211:/home/ubuntu/
```

Subir también los certificados SSL:

```bash
scp -i /home/cifra/Descargas/turtle.pem /home/cifra/Descargas/ssl-dhparams.pem ubuntu@44.213.233.211:/home/ubuntu/theturtlefoundation/nginx/ssl/
```

---

##  3. Configurar variables de entorno

En el servidor:

```bash
cd /home/ubuntu/theturtlefoundation
nano .env
```

Contenido del `.env`:

```env
SECRET_KEY_BASE=<resultado de: openssl rand -hex 64>
DB_NAME=mibase
DB_USER=aitor
DB_PASSWORD=Santander2021
```

Generar el SECRET_KEY_BASE con:

```bash
openssl rand -hex 64
```

---

##  4. Arrancar todo

```bash
cd /home/ubuntu/theturtlefoundation
docker compose up -d
```

Al arrancar automáticamente:
- PostgreSQL se inicializa
- Rails espera a la DB, crea las tablas y aplica migraciones
- Nginx sirve la web en HTTP y HTTPS

---

##  5. Importar la base de datos real

Subir el dump desde tu PC local:

```bash
scp -i /home/cifra/Descargas/turtle.pem /home/cifra/Prueba2/theturtlefoundation/backup_postgres_2024_amazon.dump.sql ubuntu@44.213.233.211:/home/ubuntu/theturtlefoundation/
```

En el servidor, parar todo, limpiar la DB e importar:

```bash
cd /home/ubuntu/theturtlefoundation
docker compose down
docker compose up -d db
sleep 10
docker compose exec db psql -U aitor -d postgres -c "DROP DATABASE mibase;"
docker compose exec db psql -U aitor -d postgres -c "CREATE DATABASE mibase;"
docker compose exec -T db psql -U aitor -d mibase < backup_postgres_2024_amazon.dump.sql
docker compose up -d
```

---

##  6. Acceder a la web

```
http://44.213.233.211
https://fundacionlatortuga.com   ← cuando el DNS esté apuntando a la IP correcta
```

---

##  Arranque automático

Docker arranca solo cuando enciende el servidor gracias a `sudo systemctl enable docker`.
Los contenedores se levantan solos gracias al `restart: unless-stopped` del compose.

No hay que hacer nada manual al reiniciar el servidor.

---

##  Comandos útiles

```bash
# Ver estado de los contenedores
docker compose ps

# Ver logs en tiempo real
docker compose logs -f app
docker compose logs -f nginx

# Reiniciar solo la app
docker compose restart app

# Parar todo
docker compose down

# Arrancar todo
docker compose up -d

# Rebuild completo (tras cambios en el código)
docker compose down
docker compose build --no-cache
docker compose up -d

# Entrar al contenedor de Rails
docker compose exec app bash

# Entrar a la DB
docker compose exec db psql -U aitor -d mibase
```

---

##  Estructura del proyecto

```
theturtlefoundation/
├── Dockerfile                            ← imagen de Rails
├── docker-compose.yml                    ← orquestación de contenedores
├── docker-entrypoint.sh                  ← espera DB, migra y arranca
├── .dockerignore                         ← archivos ignorados en el build
├── .env                                  ← variables de entorno (NO subir a git)
├── .env.example                          ← plantilla del .env
├── backup_postgres_2024_amazon.dump.sql  ← dump de la DB real
└── nginx/
    ├── nginx.conf                        ← config de nginx con SSL
    └── ssl/
        ├── fullchain.pem                 ← certificado SSL
        ├── privkey.pem                   ← clave privada SSL
        └── ssl-dhparams.pem              ← parámetros Diffie-Hellman
```

---

##  Troubleshooting

**La app no arranca:**
```bash
docker compose logs app --tail=50
```

**Nginx da error 502:**
```bash
# La app Rails no está lista aún, espera y mira los logs
docker compose logs app -f
```

**El puerto 80/443 no es accesible:**
```bash
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

**Resetear la DB (⚠️ borra todos los datos):**
```bash
docker compose down -v
docker compose up -d
```

**Ver cuántos datos tiene la DB:**
```bash
docker compose exec db psql -U aitor -d mibase -c "SELECT COUNT(*) FROM posts;"
```