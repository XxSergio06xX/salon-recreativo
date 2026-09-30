MariaDB [arcade]> SHOW GRANTS;
+--------------------------------------------------------------------------------------------------------+
| Grants for jugador@%                                                                                   |
+--------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO `jugador`@`%` IDENTIFIED BY PASSWORD '*00A51F3F48415C7D4E8908980D443C29C69B60C9' |
| GRANT ALL PRIVILEGES ON `arcade`.* TO `jugador`@`%`                                                    |
+--------------------------------------------------------------------------------------------------------+
2 rows in set (0.000 sec)

¿Por qué no pasamos la contraseña de root al servicio web?
Por el principio de mínimo privilegio. Si la web sufre una vulnerabilidad, un atacante no tendrá permisos totales sobre todo el servidor MariaDB, solo sobre la base de datos arcade.

¿Sobre qué base de datos tiene permisos el usuario jugador? ¿Por qué no usamos root desde la aplicación?
Tiene permisos únicamente sobre la base de datos arcade. No se usa root para aislar la seguridad de la aplicación.

🪙 Moneda 1 obtenida

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
9 rows in set (0.001 sec)

🪙 MONEDA 2: ARC-Q9M2

