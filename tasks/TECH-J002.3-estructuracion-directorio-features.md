# TECH-J002.3: Estructuración del Directorio `features`

## 1. DATOS GENERALES

| Atributo | Valor (Completar) |
| :--- | :--- |
| **ID de la Tarea** | TECH-J002.3 |
| **Letra identificadora** | J |
| **Nombre de la Tarea** | Estructuración del Directorio `features` |
| **Categoría** | TECH |
| **Dependencia Crítica** | TECH-J002.1, TECH-J002.2 |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo | Valor (Completar) |
| :--- | :--- |
| **Objetivo de la Tarea** | Crear el directorio `features/` y estructurar los dominios de negocio de la aplicación en "vertical slices" o módulos independientes. |
| **Justificación** | Organizar el código por funcionalidades de negocio en lugar de por tipo de archivo (ej. todos los componentes juntos) mejora drásticamente la escalabilidad y mantenibilidad. Permite a los equipos trabajar en dominios aislados con menor riesgo de conflictos y facilita la carga perezosa (`lazy loading`). |
| **Métricas de Éxito** | Al menos un dominio de negocio (ej. `authentication`) ha sido completamente refactorizado dentro de `features/`. Las rutas de esta feature se cargan de forma perezosa. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Esta tarea establece el núcleo de la arquitectura por features. Se creará un directorio `src/app/features`, y cada subdirectorio representará un dominio de negocio autocontenido (ej. `products`, `users`, `authentication`).

**Principio Clave:** El código dentro de una feature (ej. `features/products/`) debe ser agnóstico y no depender de lo que ocurre en otra (ej. `features/users/`). La comunicación entre features debe realizarse a través de servicios del `core` o el router de Angular.

Cada feature tendrá su propia estructura interna, separando la presentación de la lógica de datos:
- **`components/`**: Componentes específicos de la feature, que no se reutilizan en otros dominios.
- **`pages/`**: Componentes "inteligentes" o "contenedores" que representan rutas y orquestan la lógica de la feature.
- **`services/`**: Servicios con la lógica de negocio y comunicación con la API específicos de esa feature.
- **`models/`**: Modelos de datos que solo pertenecen a esa feature.
- **`*.routes.ts`**: Archivo que define las rutas de la feature, diseñado para ser cargado con `lazy loading`.

### Criterios de Aceptación (Condiciones Verificables)

| Rol | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :--- | :--- |
| **Desarrollador** | Cuando se crea el directorio `features/`, entonces se debe crear al menos una subcarpeta para un dominio de negocio (ej. `authentication`). |
| **Sistema** | Cuando se navega a una ruta perteneciente a una feature, entonces el módulo de rutas de esa feature debe cargarse de forma perezosa (`lazy loading`). |
| **Lógica** | El código dentro de `features/products/` NO debe importar directamente ningún archivo de `features/users/` (o cualquier otra feature). |
| **Lógica** | Una feature puede importar y utilizar código de los directorios `core/` y `shared/`. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área | Detalle de la Implementación Técnica |
| :--- | :--- |
| **Backend** | N/A |
| **Frontend** | Crear el directorio `src/app/features`. Seleccionar un dominio de negocio existente (ej. autenticación) y mover todos sus componentes, servicios y modelos a una nueva carpeta `src/app/features/authentication`. Crear un archivo `authentication.routes.ts` para definir las rutas de login, registro, etc. y configurarlo para `lazy loading` en el router principal. |
| **Bases de Datos** | N/A |
| **APIs/Endpoints** | N/A |
| **Lógica de Negocio** | La lógica de negocio se encapsulará dentro de los servicios de cada feature. |
| **Seguridad/Validación** | N/A |

### Detalles de implementación

Ejemplo de la estructura interna de una feature:

```
src/app/
└── features/
    └── products/
        ├── components/
        │   └── product-form/
        │       └── product-form.component.ts
        ├── pages/
        │   ├── list/
        │   │   └── product-list.component.ts
        │   └── detail/
        │       └── product-detail.component.ts
        ├── services/
        │   └── products.service.ts
        ├── models/
        │   └── product.model.ts
        └── products.routes.ts  <-- Definición de rutas para Lazy Loading
```

### Pasos a seguir sugeridos

1.  Crear la carpeta `features` dentro de `src/app`.
2.  Elegir una funcionalidad existente para refactorizar (ej. `authentication`).
3.  Crear la carpeta `features/authentication` y dentro de ella, las subcarpetas `pages`, `components`, `services` y `models`.
4.  Mover los archivos correspondientes de la funcionalidad de autenticación a la nueva estructura.
5.  Crear el archivo `authentication.routes.ts` y definir en él las rutas para el login, registro, etc.
6.  En el archivo de rutas principal de la aplicación (`app.routes.ts`), configurar la carga perezosa para el módulo de autenticación. Ejemplo: `{ path: 'auth', loadChildren: () => import('./features/authentication/authentication.routes').then(m => m.AUTH_ROUTES) }`.
7.  Verificar que la navegación a las rutas de autenticación funciona y que los archivos de la feature se cargan solo cuando es necesario.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

*   - [ ] Creación del directorio `src/app/features`.
*   - [ ] Creación de la estructura de carpetas para una feature de ejemplo (ej. `authentication`).
*   - [ ] Migración de los componentes, servicios y modelos de esa feature a su nuevo directorio.
*   - [ ] Creación de un archivo de rutas (`*.routes.ts`) para la feature.
*   - [ ] Configuración de `lazy loading` para la feature en el enrutador principal.
*   - [ ] Verificación de que la feature funciona de forma aislada y se carga correctamente.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 8 horas.

| Subtarea (TECH-J002.3.x) | Estimado (Horas) | Objetivo Específico |
| :--- | :--- | :--- |
| **TECH-J002.3.1** | 2 | Creación de la estructura de carpetas y migración de archivos de la feature. |
| **TECH-J002.3.2** | 3 | Creación y configuración del archivo de rutas y el `lazy loading`. |
| **TECH-J002.3.3** | 3 | Refactorización de dependencias y pruebas para asegurar el correcto funcionamiento. |
| **Total Estimado** | **8** | |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

N/A

***

## 7. Lista de chequeo de logros e hitos a alcanzar

*   [ ] Directorio `features` creado en `src/app`.
*   [ ] Primera feature (`authentication` o similar) creada con su estructura interna.
*   [ ] Archivos de la feature migrados.
*   [ ] Archivo de rutas para la feature creado.
*   [ ] `Lazy loading` configurado y funcionando para la feature.
*   [ ] Verificación de que la feature no tiene dependencias con otras features.