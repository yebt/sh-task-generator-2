# TECH-J002.1: Creación y Estructuración del Directorio `core`

## 1. DATOS GENERALES

| Atributo | Valor (Completar) |
| :--- | :--- |
| **ID de la Tarea** | TECH-J002.1 |
| **Letra identificadora** | J |
| **Nombre de la Tarea** | Creación y Estructuración del Directorio `core` |
| **Categoría** | TECH |
| **Dependencia Crítica** | N/A |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo | Valor (Completar) |
| :--- | :--- |
| **Objetivo de la Tarea** | Crear y configurar el directorio `core/` para albergar la lógica de la aplicación que se carga una sola vez y es esencial para el funcionamiento global. |
| **Justificación** | Centralizar los servicios singleton, guards, e interceptors mejora la mantenibilidad y claridad del código, estableciendo una base sólida para la arquitectura del proyecto y evitando la duplicación de instancias. |
| **Métricas de Éxito** | El 100% de los servicios singleton, guards, e interceptors existentes han sido migrados al directorio `core/`. La aplicación compila y se ejecuta sin errores de inyección de dependencias relacionados con estos módulos. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Esta tarea es puramente técnica y no tiene un impacto directo en el flujo del usuario. El objetivo es refactorizar la estructura del proyecto para mejorar la organización del código. Se creará un directorio `src/app/core` que contendrá la lógica de la aplicación que debe ser instanciada una sola vez a nivel global.

Esto incluye:
- **Servicios Singleton:** Servicios que deben existir como una instancia única en toda la aplicación (ej. `AuthService`, `NotificationService`).
- **Guards & Interceptors:** Lógica para proteger rutas (`AuthGuard`) o para modificar peticiones y respuestas HTTP (`AuthInterceptor`).
- **Modelos Base:** Modelos de datos transversales que son utilizados por múltiples features (ej. `UserSession`).

### Criterios de Aceptación (Condiciones Verificables)

| Rol | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :--- | :--- |
| **Desarrollador** | Cuando se crea el directorio `core/`, entonces este debe contener las subcarpetas `auth/`, `services/` y `models/`. |
| **Sistema** | Cuando se mueven los servicios singleton, guards e interceptors al directorio `core/`, entonces la aplicación debe compilar sin errores y los servicios deben seguir funcionando como una única instancia. |
| **Lógica** | Cuando se referencia un servicio del `core` desde otro módulo, entonces no deben existir errores de dependencias circulares. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área | Detalle de la Implementación Técnica |
| :--- | :--- |
| **Backend** | N/A |
| **Frontend** | Crear la estructura de carpetas `src/app/core`. Mover los archivos correspondientes a servicios singleton, guards, interceptors y modelos base a sus nuevas ubicaciones dentro de `core/`. Actualizar las rutas de importación en toda la aplicación para que apunten a la nueva ubicación. |
| **Bases de Datos** | N/A |
| **APIs/Endpoints** | N/A |
| **Lógica de Negocio** | La lógica de los servicios y guards no se modifica, solo su ubicación en el proyecto. |
| **Seguridad/Validación** | Los guards e interceptors de seguridad serán centralizados en `core/`. |

### Detalles de implementación

La estructura propuesta para el directorio `core/` es la siguiente:

```
src/app/
└── core/
    ├── auth/
    │   ├── auth.service.ts
    │   └── auth.interceptor.ts
    ├── services/
    │   └── notification.service.ts
    └── models/
        └── user-session.model.ts
```

Es crucial que los servicios definidos en este directorio se provean en el `root` de la aplicación para garantizar que sean singletons. Esto generalmente se logra con el decorador `@Injectable({ providedIn: 'root' })`.

### Pasos a seguir sugeridos

1.  Crear la carpeta `core` dentro de `src/app`.
2.  Dentro de `core`, crear las subcarpetas `auth`, `services` y `models`.
3.  Identificar los servicios, guards, interceptors y modelos que son de naturaleza "singleton" o base en el proyecto actual.
4.  Mover los archivos identificados a las carpetas correspondientes dentro de `core`.
5.  Realizar una búsqueda global en el proyecto para actualizar todas las rutas de importación que hacían referencia a las ubicaciones antiguas de estos archivos.
6.  Compilar y ejecutar la aplicación para verificar que no haya errores de compilación ni de ejecución.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

*   - [ ] Creación de la estructura de directorios `src/app/core` con sus subcarpetas (`auth`, `services`, `models`).
*   - [ ] Migración de `AuthService` y `AuthInterceptor` (o equivalentes) a `core/auth`.
*   - [ ] Migración de otros servicios singleton (como `NotificationService`) a `core/services`.
*   - [ ] Migración de modelos de datos base (como `UserSession`) a `core/models`.
*   - [ ] Actualización de todas las importaciones en el proyecto para reflejar la nueva estructura.
*   - [ ] Verificación de que la aplicación compila y se ejecuta correctamente.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 4 horas.

| Subtarea (TECH-J002.1.x) | Estimado (Horas) | Objetivo Específico |
| :--- | :--- | :--- |
| **TECH-J002.1.1** | 1 | Creación de la estructura de carpetas y subcarpetas. |
| **TECH-J002.1.2** | 2 | Mover archivos y actualizar todas las rutas de importación. |
| **TECH-J002.1.3** | 1 | Pruebas y verificación de la compilación y ejecución de la aplicación. |
| **Total Estimado** | **4** | |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

N/A

***

## 7. Lista de chequeo de logros e hitos a alcanzar

*   [ ] Directorio `core` creado en `src/app`.
*   [ ] Subdirectorios `auth`, `services` y `models` creados dentro de `core`.
*   [ ] Servicios y lógica de autenticación migrados.
*   [ ] Otros servicios singleton migrados.
*   [ ] Modelos base migrados.
*   [ ] Rutas de importación actualizadas en todo el proyecto.
*   [ ] Aplicación compilando y funcionando sin errores post-refactor.