# TECH-J002.4: Integración y Refactorización de la Nueva Estructura

## 1. DATOS GENERALES

| Atributo | Valor (Completar) |
| :--- | :--- |
| **ID de la Tarea** | TECH-J002.4 |
| **Letra identificadora** | J |
| **Nombre de la Tarea** | Integración y Refactorización de la Nueva Estructura |
| **Categoría** | TECH |
| **Dependencia Crítica** | TECH-J002.1, TECH-J002.2, TECH-J002.3 |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo | Valor (Completar) |
| :--- | :--- |
| **Objetivo de la Tarea** | Integrar y validar la nueva estructura de directorios (`core`, `shared`, `features`) en la aplicación, asegurando que el flujo de dependencias se respete y que la aplicación funcione correctamente. |
| **Justificación** | Esta tarea final es crucial para consolidar la refactorización arquitectónica. Asegura que la nueva estructura no solo esté en su lugar, sino que esté correctamente interconectada, validando las reglas de dependencia y garantizando que la aplicación sea más robusta y escalable. |
| **Métricas de Éxito** | La aplicación compila y se ejecuta sin errores. Las herramientas de análisis estático (linter) no reportan violaciones de dependencias entre `features` o desde `core`/`shared` hacia `features`. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Tras haber creado las nuevas estructuras de directorios, esta tarea se centra en la integración final y la limpieza. Se debe asegurar que el `app.config.ts` (o `app.module.ts`) y otros archivos raíz estén correctamente configurados para trabajar con la nueva arquitectura.

El punto más importante es validar el **flujo de dependencia recomendado**:
-   ✅ **`features`** pueden usar código de **`core`** y **`shared`**.
-   ❌ **`core`** y **`shared`** NO deben depender de ninguna **`feature`**.

Se realizarán ajustes finales en los archivos de configuración principales y se ejecutarán pruebas para garantizar que toda la aplicación siga funcionando como se esperaba.

### Criterios de Aceptación (Condiciones Verificables)

| Rol | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :--- | :--- |
| **Sistema** | Cuando se compila el proyecto, entonces no debe haber errores relacionados con rutas de importación o dependencias circulares. |
| **Lógica** | Cuando se analiza el código, entonces no debe existir ninguna sentencia `import` en `core` o `shared` que apunte a un archivo dentro de `features`. |
| **Desarrollador** | Cuando se revisa el `app.routes.ts`, entonces las rutas de las `features` deben estar configuradas para `lazy loading`. |
| **Sistema** | Cuando se ejecuta la aplicación y se navega por ella, entonces todas las funcionalidades (las refactorizadas y las que no) deben operar sin errores en tiempo de ejecución. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área | Detalle de la Implementación Técnica |
| :--- | :--- |
| **Backend** | N/A |
| **Frontend** | Revisar y refactorizar `app.config.ts`, `app.routes.ts` y `main.ts` para asegurar que las importaciones y proveedores de servicios estén alineados con la nueva estructura. Es un buen momento para configurar reglas en el linter (ej. `eslint` o `tslint`) para prohibir importaciones incorrectas entre los directorios. |
| **Bases de Datos** | N/A |
| **APIs/Endpoints** | N/A |
| **Lógica de Negocio** | N/A |
| **Seguridad/Validación** | N/A |

### Detalles de implementación

**Flujo de Dependencia a Validar:**

| Directorio | Contiene | Dependencias Permitidas |
| :--- | :--- | :--- |
| **Features** (`products/`) | Vistas, lógica de negocio específica. | `core/`, `shared/` |
| **Core** (`core/`) | Servicios Singleton, lógica de seguridad. | Ninguna (solo de librerías externas) |
| **Shared** (`shared/`) | Componentes UI sin lógica, pipes. | Ninguna (solo de librerías externas) |

Se puede usar `nx` o `eslint-plugin-import` para configurar reglas que impidan, por ejemplo, que un archivo en `shared` importe algo de `features`.

### Pasos a seguir sugeridos

1.  Revisar el archivo `app.routes.ts` para confirmar que todas las `features` refactorizadas usan `loadChildren`.
2.  Revisar el `app.config.ts` para asegurarse de que los `providers` globales (si los hay) provienen del directorio `core`.
3.  Realizar una revisión manual o automática (con linter) para detectar cualquier importación que viole las reglas de dependencia.
    -   Buscar `import ... from '.../features/...'` dentro de los directorios `core` y `shared`.
4.  Corregir cualquier importación incorrecta encontrada. Esto puede implicar mover lógica de una `feature` a `shared` o `core` si se descubre que es necesaria en múltiples lugares.
5.  Ejecutar una compilación de producción (`ng build --configuration production`) para detectar posibles errores que no aparecen en el modo de desarrollo.
6.  Realizar una prueba de humo completa de la aplicación, navegando por todas las páginas principales para asegurar que no haya regresiones.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

*   - [ ] Revisión y limpieza del `app.config.ts` y `app.routes.ts`.
*   - [ ] Verificación de que todas las `features` migradas utilizan `lazy loading`.
*   - [ ] Implementación de reglas de linter (opcional pero recomendado) para controlar las dependencias.
*   - [ ] Corrección de todas las violaciones de dependencia encontradas.
*   - [ ] Compilación exitosa del proyecto en modo de producción.
*   - [ ] Pruebas de regresión funcionales para asegurar que la aplicación sigue siendo estable.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 6 horas.

| Subtarea (TECH-J002.4.x) | Estimado (Horas) | Objetivo Específico |
| :--- | :--- | :--- |
| **TECH-J002.4.1** | 2 | Revisión y refactorización de los archivos de configuración raíz. |
| **TECH-J002.4.2** | 2 | Búsqueda y corrección de violaciones de dependencia. |
| **TECH-J002.4.3** | 2 | Compilación en producción y pruebas de humo completas. |
| **Total Estimado** | **6** | |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

N/A

***

## 7. Lista de chequeo de logros e hitos a alcanzar

*   [ ] Archivos de configuración raíz (`app.config.ts`, `app.routes.ts`) limpios y actualizados.
*   [ ] Reglas de dependencia validadas (manual o automáticamente).
*   [ ] No existen importaciones desde `core` o `shared` hacia `features`.
*   [ ] No existen importaciones entre `features`.
*   [ ] El build de producción se completa sin errores.
*   [ ] La aplicación es completamente funcional después de la refactorización.