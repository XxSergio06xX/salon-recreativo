# 🕹️ Práctica final RA1 · Salón recreativo

**Asignatura:** Implantación de Aplicaciones Web
**Curso:** 2º ASIR
**Alumno:** Sergio Sala Gómez

---

## 🪙 Monedas conseguidas

| Nivel | Origen | Código de Moneda |
| :--- | :--- | :--- |
| **Moneda 1** | `MONEDA-1: ARC-7X3K` |
| **Moneda 2** | `MONEDA 2: ARC-Q9M2` |
| **Moneda 3** | `MONEDA 3: ` |

---

## 🛠️ Descripción del stack y tecnologías

El despliegue está basado en una arquitectura multicontenedor orquestada con Docker Compose:

- **Servidor Web y Backend:** Contenedor basado en la imagen oficial `php:8.3-apache`. Integra el servidor web **Apache 2.4** y el intérprete **PHP 8.3**. Procesa la lógica de servidor en `index.php`, utiliza la extensión `mysqli` para realizar consultas a la base de datos y renderiza el HTML dinámicamente.
- **Servidor de Base de Datos (SGBD):** Contenedor basado en **MariaDB 10.11**. Aloja la base de datos `arcade` y la tabla `ranking`. Los datos persisten mediante un volumen nombrado de Docker (`db_data`).
- **Cliente:** Navegador web del usuario. Se encarga de interpretar la interfaz visual (HTML/CSS) y ejecutar la lógica de cliente en **JavaScript** para mostrar la hora local del dispositivo.

---

## 📐 Diagrama de arquitectura

mermaid
graph LR
    N[Navegador] -->|8080| W[Apache + PHP]
    W -->|red Docker| B[(MariaDB)]


**Comandos de despliegue**
**Despliegue en Entorno Local**

  1. Clonar el repositorio y situarse en la carpeta del proyecto:

  cd salon-recreativo

  2. Crear el fichero de configuración .env a partir de la plantilla y rellenar las contraseñas:

  cp .env.example .env

  3. Construir las imágenes y arrancar los contenedores en segundo plano:

  sudo docker compose up -d --build

  4. Acceder a la aplicación desde el navegador en: http://localhost:8080

  **Despliegue en Play with Docker (PWD)**

  1. Clonar el repositorio dentro de la terminal de PWD.

  2. Generar el fichero .env a partir de la plantilla:

  cp .env.example .env

  3. Construir y levantar el stack de contenedores:

  docker compose up -d --build

  4. Hacer clic sobre el puerto 8080 expuesto en la barra superior de la interfaz de PWD.

# 1. Gestión de versiones y seguridad de credenciales (.env y .gitignore)
mv .env .env.example
cp .env.example .env
git init
git add .
git commit -m "Commit inicial: Salón recreativo"
git ls-files
git ls-files | grep .env

# 2. Despliegue, construcción y control del ciclo de vida de los contenedores
sudo docker compose up -d
sudo docker compose up -d --build
sudo docker compose down
sudo docker compose down -v

# 3. Comprobaciones de conectividad, estado y seguridad
curl -I http://localhost:8080
sudo docker compose ps

**❓ Respuestas a las preguntas de los niveles 1 y 2**

**Nivel 1 · Variables de entorno y base de datos**

**¿Por qué no le pasamos al servicio web la contraseña de root (env_file: .env)?**

Por el principio de mínimo privilegio. Si la aplicación web se viera comprometida por una brecha de seguridad, el atacante no obtendría control total como administrador sobre el motor de MariaDB, ya que la aplicación solo opera bajo las restricciones del usuario limitado jugador.

**¿Sobre qué base de datos tiene permisos el usuario jugador? ¿Por qué no usamos root desde la aplicación?**

Tiene permisos exclusivamente sobre la base de datos arcade. No se emplea root para aislar y proteger el alcance de la aplicación ante posibles vulnerabilidades.

**Resultado del comando SHOW GRANTS; para el usuario jugador:**

MariaDB [arcade]> SHOW GRANTS;
+--------------------------------------------------------------------------------------------------------+
| Grants for jugador@%                                                                                   |
+--------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `jugador`@`%` IDENTIFIED BY PASSWORD '*00A51F3F48415C7D4E8908980D443C29C69B60C9' |
| GRANT ALL PRIVILEGES ON `arcade`.* TO `jugador`@`%`                                                    |
+--------------------------------------------------------------------------------------------------------+

**Contenido de la tabla ranking (Localización de la Moneda 1):**

MariaDB [arcade]> SELECT * FROM ranking;
+----+--------------------+----------------+--------+
| id | jugador            | juego          | puntos |
+----+--------------------+----------------+--------+
|  1 | PAC-ANA            | Pac-Man        |  48200 |
|  2 | MARIO_84           | Donkey Kong    |  35100 |
|  3 | LARA_C             | Tetris         |  61750 |
|  4 | NEO                | Space Invaders |  27900 |
|  5 | BIMBA_XL           | Pac-Man        |  52300 |
|  6 | ZELDA              | Tetris         |  58400 |
|  7 | R2D2               | Space Invaders |  31200 |
|  8 | TRON               | Donkey Kong    |  29800 |
|  9 | MONEDA-1: ARC-7X3K | secreto        |      0 |
+----+--------------------+----------------+--------+

**Nivel 2 · Ejecución en servidor vs cliente**

**¿Qué se ejecuta en el servidor y qué en el cliente?**

Servidor: El script PHP (index.php) se procesa en el backend, realiza la consulta SQL a MariaDB y genera la hora estática del servidor mediante la función date('H:i:s') antes de enviar la respuesta HTTP.

Cliente: El código JavaScript se ejecuta directamente en el navegador del usuario final para pintar de forma dinámica la hora local de su dispositivo mediante toLocaleTimeString().

**¿Por qué podrían no coincidir las dos horas?**

Porque la hora del servidor se calcula en base a la zona horaria del contenedor (por defecto UTC) en el preciso instante en que se genera la página, mientras que la del cliente refleja la zona horaria y la hora local real configurada en el ordenador del usuario.

**Comprobaciones de seguridad (Nivel 3)**

**Sin credenciales en el repositorio:**

git ls-files lista únicamente el fichero de plantilla .env.example, manteniendo oculto y protegido el fichero privado .env mediante el control de .gitignore. Asimismo, no existen rastros de contraseñas en el historial de commits.

**Puerto 3306 no publicado en el host (Comprobación con docker compose ps):**

Ejecutando el comando en la terminal:

sersalgom2@PC1325:~/Documents/salon-recreativo$ sudo docker compose ps
NAME         IMAGE                  COMMAND                  SERVICE   CREATED          STATUS                   PORTS
arcade_db    mariadb:10.11          "docker-entrypoint.s…"   db        24 minutes ago   Up 24 minutes (healthy)  3306/tcp
arcade_web   salon-recreativo-web   "docker-php-entrypoi…"   web       31 seconds ago   Up 29 seconds            0.00.00:8080->80/tcp

Se comprueba que MariaDB expone únicamente su puerto interno (3306/tcp) hacia la red de Docker, protegiéndolo de accesos externos directos.

**Ocultación de versiones en cabeceras HTTP (Comprobación con curl):**

sersalgom2@PC1325:~/Documents/salon-recreativo$ curl -I http://localhost:8080
HTTP/1.1 200 OK
Date: Wed, 30 Sep 2026 17:02:57 GMT
Server: Apache
Content-Type: text/html; charset=UTF-8

Devuelve únicamente Server: Apache sin mostrar versiones de software expuestas ni la cabecera X-Powered-By.

**Problemas que me encontré y cómo los resolví**

**Ausencia de la extensión mysqli en la imagen base de PHP:**

**Problema:** Al desplegar inicialmente la aplicación con la imagen estándar de PHP, la página web devolvía un error de ejecución indicando que PHP no disponía de la extensión necesaria para conectar con MariaDB.

**Solución:** Se creó un Dockerfile en la raíz del proyecto basado en php:8.3-apache y se añadió la instrucción RUN docker-php-ext-install mysqli. Además, se modificó el servicio web en el docker-compose.yml utilizando la directiva build: . para forzar la compilación correcta de la imagen.

**El script init.sql no aplicaba cambios tras modificar la base de datos:**

**Problema:** Al actualizar el contenido del fichero init.sql, el contenedor de la base de datos ignoraba las modificaciones al reiniciarse.

**Solución:** Se recordó que el directorio de inicialización de MariaDB solo se ejecuta cuando el volumen de datos está completamente vacío. Para solucionarlo, se destruyó el contenedor junto con su volumen ejecutando docker compose down -v y se volvió a levantar con docker compose up -d, permitiendo que la base de datos se inicializara de nuevo con los datos actualizados.
