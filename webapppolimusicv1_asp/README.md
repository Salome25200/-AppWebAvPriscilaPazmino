# PoliMusic — Classic ASP

Aplicación de biblioteca musical con dos roles y SQL Server, construida exclusivamente sobre las tablas de `BDD_PoliMusic.sql`.

## Puesta en marcha

1. Ejecuta `BDD_PoliMusic.sql` en SQL Server local. El script crea `BDD_PoliMusic` y el inicio SQL `usr_polimusic`.
2. Crea una aplicación en IIS apuntando a esta carpeta y activa **Classic ASP**.
3. Abre `login.asp` (o `index.asp`, que redirige al login si no hay sesión).

Las cuentas semilla son `userNormal / 12345678` y `userAdmin / 12345678`.

## Rutas

- `login.asp`: inicia sesión y guarda ID, nombre, foto y rol en `Session`.
- `index.asp`: Song List, mensaje de bienvenida, reproductor y contador de reproducciones.
- `admin.asp`: CRUD de canciones, artistas y álbumes, disponible sólo para `USER_TYPE = 1`.
- `logout.asp`: elimina la sesión.

Los recursos visuales y el MP3 se sirven directamente desde `SongFilesAndImages_resources`. La base entregada almacena contraseñas como texto; para una instalación fuera del ejercicio académico se debe migrar a hashes antes de exponerla.

El diseño usa Bootstrap 5.3.8 incluido localmente en `assets/vendor/bootstrap.min.css`, seguido por `assets/styles.css`. No requiere conexión a una CDN.
