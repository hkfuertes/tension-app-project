## Documentación del servidor _Tension App_
Servidor de la aplicacion de gestion de presion sanguinea y peso asi como de frecuencia cardiaca. 
Esta desarrollado en __*[Python](https://www.python.org/)*__, __*[Flask](https://www.palletsprojects.com/p/flask/)*__ y __*[SQLAlchemy](https://www.sqlalchemy.org/)*__.

> Aquí puedes encontrar el servidor: [https://github.com/hkfuertes/tension-app-server](https://github.com/hkfuertes/tension-app-server)

## Documentación de la API
La api usa tokens JWT para autenticar y autorizar todas las llamadas siguientes. Si el token queda invalido, tambien se provee un token de refesco para renovar el token de acceso.
Las llamadas son las siguientes.

Para obtener un token valido o refrescarlo, la llamada es la siguiente.

| Accion    | URL         | Método     | Header               | Body 
| --------- | -------     | ---------- | -------------------- |-----
| Login     | `/auth`     | **POST**   |                      |`{"username": <string>,"password":<string>}`
| Refresh   | `/refresh`  | **POST**   | Refresh JWT "Bearer" |

Las respuesta de login sera similar a esta, en caso de no error `200`:
```json
{
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1ODAxNTI2ODUsIm5iZiI6MTU4MDE1MjY4NSwianRpIjoiZTExMGY5MjYtZjlhNi00ODRlLWJiNDItNWQ3NTc4NmNhY2I5IiwiZXhwIjoxNTgwMTUzNTg1LCJpZGVudGl0eSI6ImhrZnVlcnRlc0BnbWFpbC5jb20iLCJmcmVzaCI6ZmFsc2UsInR5cGUiOiJhY2Nlc3MifQ.tnG5P7oCI4TvNgugnx9Cl2acCw0snE0MtwGm9vhYHKE",
    "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1ODAxNTI2ODUsIm5iZiI6MTU4MDE1MjY4NSwianRpIjoiNzg2N2QwMDQtNDI0YS00M2ZmLTg3YWUtMzMyMzhmOTVhNjIxIiwiZXhwIjoxNTgyNzQ0Njg1LCJpZGVudGl0eSI6ImhrZnVlcnRlc0BnbWFpbC5jb20iLCJ0eXBlIjoicmVmcmVzaCJ9.9hJ8v5j2KRyiA9vdus5UFQzCnGUJoh9FeJ_ayOpffcw"
}
```
La respuesta para refresh sera simiar a esta, en caso de no error `200`:
```json
{
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE1ODAxNTI3OTEsIm5iZiI6MTU4MDE1Mjc5MSwianRpIjoiYzFjZTFkMDYtNzE2YS00NWY3LThmMDMtMWQwOWExZDM3ZDc0IiwiZXhwIjoxNTgwMTUzNjkxLCJpZGVudGl0eSI6ImhrZnVlcnRlc0BnbWFpbC5jb20iLCJmcmVzaCI6ZmFsc2UsInR5cGUiOiJhY2Nlc3MifQ.M89-uHvKNGOqsTjkfpwT5MU-IBOfIFdMfuJvUpWpDOY"
}
```

### Endpoints relacionados con los médicos
Las llamadas a la api para obtener informacion sobre el doctor. 

>_Actualmente solo se usa el GET en la app._

| Accion            | URL               | Método     | Autenticación
| ----------------- | ----------------  | ---------- | -------------
| Crear Médico      | `/api/v1/doctor`  | **POST**   | Private Key "PSK" in Header
| Actualizar Médico | `/api/v1/doctor`  | **PUT**    | JWT in Header "Bearer"
| Borrar Médico     | `/api/v1/doctor`  | **DELETE** | JWT in Header "Bearer"
| Ver Médico        | `/api/v1/doctor`  | **GET**    | JWT in Header "Bearer"

### Endpoints relacionados con los pacientes
Las llamadas a la api para obtener informacion sobre el paciente. 

>_Actualmente solo se usa listar pacientes en la app._

| Accion                            | URL                    | Método   | Autenticación
| --------------------------------- | ---------------------  | -------- | -------------
| Pacientes para el doctor del `JWT`| `/api/v1/patients`     | **GET**  | JWT in Header "Bearer"
| Ver perfil del paciente `<id>`    | `/api/v1/patient/<id>` | **GET**  | JWT in Header "Bearer"
| Crear Paciente                    | `/api/v1/patient`      | **POST** | JWT in Header "Bearer"
| Actualizar Paciente `<id>`        | `/api/v1/patient/<id>` | **PUT**  | JWT in Header "Bearer"

### Endpoints relacionados con las medidas
Las llamadas a la api para obtener informacion sobre las medidas. 

| Accion                     | URL                             | Método   | Autenticación
| -------------------------- | ------------------------------  | -------- | -------------
| Enviar pulso para `<id>`   | `/api/v1/patient/<id>/pulse`    | **POST** | JWT in Header "Bearer"
| Enviar peso para `<id>`    | `/api/v1/patient/<id>/weight`   | **POST** | JWT in Header "Bearer"
| Enviar tensión para `<id>` | `/api/v1/patient/<id>/pressure` | **POST** | JWT in Header "Bearer"
| Ver pulso para `<id>`      | `/api/v1/patient/<id>/pulse`    | **GET**  | JWT in Header "Bearer"
| Ver peso para `<id>`       | `/api/v1/patient/<id>/weight`   | **GET**  | JWT in Header "Bearer"
| Ver tensión para `<id>`    | `/api/v1/patient/<id>/pressure` | **GET**  | JWT in Header "Bearer"

### Endpoints relacionados con las estadisticas
Las llamadas a la api para obtener las estadísticas, los datos de todos los pacientes, sin nombres ni informacion
>Puede ser interesante dejar estos endpoints abiertos en el futuro. 

| Accion            | URL                      | Método  | Autenticación
| ----------------- | -----------------------  | ------- | -------------
| Ver los pulsos    | `/api/v1/stats/pulse`    | **GET** | JWT in Header "Bearer"
| Ver los pesos     | `/api/v1/stats/weight`   | **GET** | JWT in Header "Bearer"
| Ver las tensiones | `/api/v1/stats/pressure` | **GET** | JWT in Header "Bearer"

### Respuestas
La respuesta estandar va a ser de esta forma:
- En caso de no error
  ```json
  {
      "data": { ... },
      "result": "success"
  }
  ```
- En caso de error
  ```json
  {
      "data": { ... },
      "result": "failed"
  }
  ```
### Los modelos de datos

- Doctor:
  ```json
  {
    "data": {
        "email": <email>,
        "lastName": <string>,
        "name": <string>
    },
    "result": "success"
  }
  ```
- Paciente:
  ```json
  {
    "data": {
        "birthday": "1994-06-04",
        "gender": "male",
        "height": 175,
        "id": 1,
        "lastName": "Fuertes",
        "name": "Javier"
    },
    "result": "success"
  }
  ```
- Pesos:
  ```json
  {
    "data": [
        {
            "timestamp": "2020-01-20 18:49:50",
            "weight": 120.6
        },
        {
            "timestamp": "2020-01-23 13:16:03",
            "weight": 120.0
        },
        ...
    ],
    "result": "success"
  }
  ```
- Pulsos:
  ```json
  {
    "data": [
        {
            "high": null,
            "low": null,
            "pulse": 100,
            "timestamp": "2020-01-21 18:35:12"
        },
        ...
    ],
    "result": "success"
  }
  ```
- Presión sanguinea:
  ```json
  {
    "data": [
        {
            "high": 140,
            "low": 80,
            "pulse": 101,
            "timestamp": "2020-01-24 22:57:10"
        },
        ...
    ],
    "result": "success"
  }
  ```
- Estadisticas de pulso:
  ```json
  {
    "data": [
        {
            "age": 25,
            "gender": "male",
            "height": 175,
            "pulse": 70,
            "timestamp": "2020-01-20 18:49:50"
        },
        ...
    ],
    "result": "success"
  }
  ```
- Estadisticas de peso:
  ```json
  {
    "data": [
        {
            "age": 25,
            "gender": "male",
            "height": 175,
            "timestamp": "2020-01-20 18:49:50",
            "weight": 120.6
        },
        ...
    ],
    "result": "success"
  }
  ```
- Estadisticas de presión sanguinea:
  ```json
  {
    "data": [
        {
            "age": 25,
            "gender": "male",
            "height": 175,
            "high": 120,
            "low": 90,
            "pulse": 70,
            "timestamp": "2020-01-20 18:49:50"
        },
        ...
    ],
    "result": "success"
  }
  ```
