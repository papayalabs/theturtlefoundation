# 🐢 The Turtle Foundation — Despliegue en Servidor

Stack: **Ruby on Rails + PostgreSQL + Nginx + SSL (Let's Encrypt)**

Con solo 3 comandos en el servidor la web está viva con HTTPS. No cap.

---

## 🔑 Conectarse al servidor

```bash
chmod 400 turtle.pem
ssh -i turtle.pem ubuntu@<IP_DEL_SERVIDOR>
```

---

## 🖥️ 1. Instalar Docker

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
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker
```

---

## 📁 2. Clonar el proyecto

```bash
git clone https://github.com/AITORCIFRA/theturtlefoundation.git
cd theturtlefoundation
git checkout Docker
```

---

## 🚀 3. Arrancar todo

```bash
docker compose up -d
```

Automáticamente:
- PostgreSQL arranca ✅
- Rails espera la DB ✅
- DB vacía → importa dump automático ✅
- DB con datos → aplica migraciones ✅
- Web disponible en `http://<IP>` ✅

---

## 🔐 4. Activar HTTPS (solo una vez por servidor)

> ⚠️ El dominio debe apuntar a la IP del servidor antes de este paso

```bash
chmod +x init-ssl.sh
./init-ssl.sh admin@fundacionlatortuga.com
```

El script:
1. Arranca nginx en HTTP
2. Pide los certs a Let's Encrypt (gratis)
3. Activa nginx con HTTPS

Web disponible en `https://fundacionlatortuga.com` ✅

Los certs se renuevan automáticamente cada 12h gracias al contenedor certbot.

---

## 🔄 Arranque automático del servidor

Docker y los contenedores arrancan solos al encender el servidor. No hay que hacer nada manual.

---

## 📊 Comandos útiles

```bash
# Ver estado
docker compose ps

# Logs en tiempo real
docker compose logs -f app
docker compose logs -f nginx

# Reiniciar app
docker compose restart app

# Parar todo
docker compose down

# Arrancar todo
docker compose up -d

# Rebuild tras cambios en el código
docker compose down
docker compose build --no-cache
docker compose up -d

# Entrar al contenedor Rails
docker compose exec app bash

# Ver datos en la DB
docker compose exec db psql -U turtle_user -d theturtlefoundation -c "SELECT COUNT(*) FROM posts;"

# Resetear DB y reimportar dump (⚠️ borra datos)
docker compose down
docker compose up -d db
sleep 10
docker compose exec db psql -U turtle_user -d postgres -c "DROP DATABASE theturtlefoundation;"
docker compose up -d
```

---

## 📁 Estructura

```
theturtlefoundation/
├── Dockerfile                            ← imagen Rails
├── docker-compose.yml                    ← orquestación
├── docker-entrypoint.sh                  ← espera DB, importa dump y arranca
├── init-ssl.sh                           ← genera certs SSL (1 vez por servidor)
├── .dockerignore
├── backup_postgres_2024_amazon.dump.sql  ← dump DB (importa automático)
└── nginx/
    ├── nginx.conf                        ← config activa
    ├── nginx-http.conf                   ← config HTTP (usada por init-ssl.sh)
    └── nginx-ssl.conf                    ← config HTTPS (activada tras SSL)
```

---

## 🆘 Troubleshooting

**Nginx no encuentra los certificados:**
```bash
./init-ssl.sh admin@fundacionlatortuga.com
```

**La app no arranca:**
```bash
docker compose logs app --tail=50
```

**Puerto 80/443 no accesible:**
```bash
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

**Permission denied en carpeta ssl:**
```bash
sudo chown -R ubuntu:ubuntu nginx/ssl/
```