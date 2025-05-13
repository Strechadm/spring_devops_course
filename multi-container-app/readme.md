## **Створення файлу docker-compose.yml**

```shell
mkdir multi-container-app
cd multi-container-app
```

```shell
mkdir web-data
nano web-data/index.html
```

### 

```html
<!DOCTYPE html>
<html>
<head>
  <title>My Docker App</title>
</head>
<body>
  <h1>Hello from Docker!</h1>
</body>
</html>
```

### 

### **Створення docker-compose.yml файлу**

```yaml
version: '3.8'
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./web-data:/usr/share/nginx/html:ro
    networks:
      - appnet
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydb
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - appnet
  cache:
    image: redis:latest
    networks:
      - appnet
volumes:
  db-data:
  web-data:
networks:
  appnet:
```

## **Запуск багатоконтейнерного застосунку**

### **Запуск сервісів у фоновому режимі:**

```shell
docker-compose up -d
```

![screen1](./screenshots/iScreen%20Shoter%20-%20Code%20-%20250513161542_1.jpg)


### **Перевірка стану контейнерів:**

```shell
docker-compose ps
```
![screen2](./screenshots/iScreen%20Shoter%20-%20Code%20-%20250513162331.jpg)
###  **Перевірка вебінтерфейсу:**

[**http://localhost:8080**](http://localhost:8080)
![screen3](./screenshots/HELLO.jpg)
## **Мережі та томи**

### **Список створених мереж:**

```shell
docker network ls
```
![screen4](./screenshots/network.jpg)
### **Список створених томів:**

```shell
docker volume ls
```
![screen5](./screenshots/volumes.jpg)

### **Підключення до PostgreSQL:**

Дізнаємось  ім’я контейнера:

```shell
docker-compose ps
```
![screen6](./screenshots/iScreen%20Shoter%20-%20Code%20-%20250513162727.jpg)

Підключіться до контейнера:

```shell
docker exec -it <db_container_name> psql -U user -d mydb
```
![screen7](./screenshots/postgres.jpg)
## **Масштабування вебсервера**

Спочатку додамо файл конфігурації для nginx так як буде помилка зайнятого порта 8080

Створиму папку **nginx** та файл **default.conf**

#### 

```yaml
upstream web_backend {
    server web:80;
}
server {
    listen 80;
    location / {
        proxy_pass http://web_backend;
    }
}
version: '3.8'
services:
  loadbalancer:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - web
    networks:
      - appnet
  web:
    image: nginx:latest
    volumes:
      - ./web-data:/usr/share/nginx/html:ro
    networks:
      - appnet
  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydb
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - appnet
  cache:
    image: redis:latest
    networks:
      - appnet
volumes:
  db-data:
networks:
  appnet:
```

### **Запуск маштабування** 

```shell
docker-compose up -d --scale web=3
```
![screen8](./screenshots/iScreen%20Shoter%20-%20Code%20-%20250513164917.jpg)
![screen9](./screenshots/iScreen%20Shoter%20-%20Code%20-%20250513165050.jpg)
### **Та перевірка**
http://localhost:8080

