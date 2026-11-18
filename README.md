# tareas-api

API REST en **Ruby on Rails** del Gestor de Tareas. Guarda las tareas en SQLite y responde en JSON.
La consume la aplicación web [`tareas-web`](../tareas-web).

## Requisitos

- Ruby 3.4
- Bundler (`gem install bundler`)

## Instalación

```bash
bundle install
bin/rails db:prepare
```

## Ejecutar

```bash
bin/rails server
```

La API queda disponible en http://localhost:9002.

## Endpoints

| Método | Ruta | Descripción | Respuestas |
|---|---|---|---|
| GET | `/tasks` | Lista las tareas, de la más nueva a la más antigua | 200 |
| GET | `/tasks?completed=true\|false` | Filtra por estado | 200 |
| GET | `/tasks/:id` | Muestra una tarea | 200, 404 |
| POST | `/tasks` | Crea una tarea | 201, 400, 422 |
| PATCH | `/tasks/:id` | Actualiza una tarea | 200, 404, 422 |
| DELETE | `/tasks/:id` | Elimina una tarea | 204, 404 |
| GET | `/up` | Health check | 200 |

Cuerpo para crear o actualizar:

```json
{ "task": { "title": "Comprar pan", "description": "En la esquina", "completed": false } }
```

Ejemplo:

```bash
curl -X POST http://localhost:9002/tasks \
  -H "Content-Type: application/json" \
  -d '{"task":{"title":"Comprar pan"}}'
```

## Tests y cobertura

```bash
bin/rails db:test:prepare test
```

`db:test:prepare` crea o actualiza la base de datos de test a partir de `db/schema.rb`. Es necesario en una copia recién clonada (por ejemplo, en el servidor de CI). Si no, los tests fallan con *"Migrations are pending"*.

El reporte de cobertura (SimpleCov) queda en `coverage/`: `index.html` para verlo en el navegador y `.resultset.json` para SonarQube.

## Ramas

- `main`: código estable (despliegues de producción desde `release/**`)
- `dev`: integración (desarrollo en ramas `feature/**`)
