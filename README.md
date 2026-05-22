# 🐢 Fundación La Tortuga — Despliegue en Servidor

Stack: **Ruby on Rails + MySQL + Nginx + SSL**

Todo corre en Docker. En el servidor solo hace falta instalar Docker, clonar el repo y hacer `docker compose up -d`. La base de datos se importa automática. No cap.

---

## 📋 Requisitos previos

- Servidor Ubuntu 22.04+ con acceso SSH
- Archivo `turtle.pem` para conectarse al servidor
- Docker instalado en el servidor
- Puertos 80 y 443 abiertos en el firewall

---

## 🔑 Crear y conectarse al servidor

Hace falta crear un servidor ubuntu con una IP y una llave(ej. 44.213.233.211 y turtle.pem) y apuntar los DNS
del domain fundacionlatortuga.com a ese IP

```bash
# Dar permisos correctos al .pem (solo la primera vez)
chmod 400 /ruta/a/turtle.pem

# Conectarse
ssh -i /ruta/a/turtle.pem ubuntu@44.213.233.211
```

---

## 🖥️ 1. Instalar Docker en el servidor

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

# Habilitar Docker al arranque del servidor
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker
```

---

## 📁 2. Clonar el proyecto

```bash
git clone https://github.com/papayalabs/theturtlefoundation.git
cd theturtlefoundation
```

---

## 🚀 3. Arrancar todo

```bash
docker compose up -d
```

Al arrancar automáticamente:
- MySQL se inicializa
- Rails espera a la DB
- Si la DB está vacía → importa el dump automáticamente
- Si ya tiene datos → aplica migraciones
- Nginx sirve la web en HTTP y HTTPS

**Eso es todo. No hay más pasos.**

---

## 🌐 Acceder a la web

```
https://fundacionlatortuga.com
```

---

## 🔄 Arranque automático

Docker arranca solo cuando enciende el servidor gracias a `sudo systemctl enable docker`.
Los contenedores se levantan solos gracias al `restart: unless-stopped` del compose.

No hay que hacer nada manual al reiniciar el servidor.

---

## 📊 Comandos útiles

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
docker compose exec db mysql -u turtle_user -p theturtlefoundation

# Ver cuántos posts tiene la DB
docker compose exec db mysql -u turtle_user -p theturtlefoundation -e "SELECT COUNT(*) FROM posts;"
```

---

## 📁 Estructura del proyecto

```
theturtlefoundation/
├── Dockerfile                            ← imagen de Rails
├── docker-compose.yml                    ← orquestación de contenedores
├── docker-entrypoint.sh                  ← espera DB, importa dump si vacía y arranca
├── .dockerignore                         ← archivos ignorados en el build
├── backup_mysql_2024_amazon.sql          ← dump de la DB real (se importa automático)
└── nginx/
    ├── nginx.conf                        ← config de nginx con SSL
    └── ssl/
        ├── fullchain.pem                 ← certificado SSL
        ├── privkey.pem                   ← clave privada SSL
        └── ssl-dhparams.pem              ← parámetros Diffie-Hellman
```

---

## 🆘 Troubleshooting

**La app no arranca:**
```bash
docker compose logs app --tail=50
```

**Nginx da error 502:**
```bash
docker compose logs app -f
```

**El puerto 80/443 no es accesible:**
```bash
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```
