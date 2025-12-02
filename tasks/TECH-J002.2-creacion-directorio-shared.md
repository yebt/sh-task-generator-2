# TECH-J002.2: Creación y Estructuración del Directorio `shared`

## 1. DATOS GENERALES

| Atributo | Valor (Completar) |
| :--- | :--- |
| **ID de la Tarea** | TECH-J002.2 |
| **Letra identificadora** | J |
| **Nombre de la Tarea** | Creación y Estructuración del Directorio `shared` |
| **Categoría** | TECH |
| **Dependencia Crítica** | N/A |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo | Valor (Completar) |
| :--- | :--- |
| **Objetivo de la Tarea** | Crear y configurar el directorio `shared/` para albergar componentes, pipes y directivas reutilizables que no dependen de un dominio de negocio específico. |
| **Justificación** | Centralizar los elementos de UI y utilidades comunes en un solo lugar fomenta la reutilización, reduce la duplicación de código y facilita la consistencia visual y funcional a lo largo de toda la aplicación. |
| **Métricas de Éxito** | El 100% de los componentes de UI reutilizables, pipes y directivas han sido migrados al directorio `shared/`. Las `features` que los utilizan los importan correctamente. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Esta tarea consiste en la creación de un directorio `src/app/shared` para contener elementos que pueden ser utilizados por cualquier "feature" de la aplicación. Estos elementos deben ser agnósticos a la lógica de negocio.

El directorio `shared` incluirá:
- **Componentes UI:** Componentes de presentación puramente visuales y reutilizables, como botones, tarjetas, spinners, o inputs de formulario. Idealmente, estos serán componentes `standalone`.
- **Pipes y Directivas:** Elementos de utilidad para la manipulación de datos en las plantillas (ej. `CurrencyFormatPipe`) o para interactuar con el DOM.
- **Módulos de Terceros:** Si se usan librerías de componentes como Angular Material o NG-ZORRO, se pueden crear módulos que agrupen y exporten los componentes más utilizados.
- **Utilidades:** Funciones de utilidad, como validadores de formularios personalizados.

### Criterios de Aceptación (Condiciones Verificables)

| Rol | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :--- | :--- |
| **Desarrollador** | Cuando se crea el directorio `shared/`, entonces este debe contener las subcarpetas `components/`, `pipes/` y `util/`. |
| **Sistema** | Cuando se mueve un componente reutilizable a `shared/components`, entonces cualquier `feature` que lo importe debe poder renderizarlo sin errores. |
| **Lógica** | Cuando se crea un pipe en `shared/pipes`, entonces este debe poder ser utilizado en la plantilla de cualquier componente de una `feature`. |
| **Lógica** | El código dentro del directorio `shared/` NO debe tener dependencias de ningún módulo o servicio que pertenezca a una `feature` específica. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área | Detalle de la Implementación Técnica |
| :--- | :--- |
| **Backend** | N/A |
| **Frontend** | Crear la estructura de carpetas `src/app/shared`. Mover los componentes, pipes, directivas y utilidades reutilizables a sus nuevas ubicaciones. Es fundamental que los componentes en `shared` sean `standalone` para poder importarlos individualmente donde se necesiten. |
| **Bases de Datos** | N/A |
| **APIs/Endpoints** | N/A |
| **Lógica de Negocio** | Los elementos en `shared` no deben contener lógica de negocio. Deben operar únicamente con los datos que reciben a través de `@Input()` y emitir eventos a través de `@Output()`. |
| **Seguridad/Validación** | N/A |

### Detalles de implementación

La estructura propuesta para el directorio `shared/` es la siguiente:

```
src/app/
└── shared/
    ├── components/
    │   ├── button/
    │   │   └── button.component.ts  <-- Componente Standalone
    │   └── card/
    │       └── card.component.ts
    ├── pipes/
    │   └── currency-format.pipe.ts
    └── util/
        └── form-validators.ts
```

### Pasos a seguir sugeridos

1.  Crear la carpeta `shared` dentro de `src/app`.
2.  Dentro de `shared`, crear las subcarpetas `components`, `pipes` y `util`.
3.  Identificar componentes de UI, pipes y directivas que se usen en más de un lugar y que no tengan lógica de negocio específica.
4.  Mover los archivos identificados a las carpetas correspondientes dentro de `shared`.
5.  Asegurarse de que los componentes movidos sean `standalone` o pertenezcan a un `NgModule` que pueda ser importado.
6.  Actualizar las importaciones en los módulos o componentes que usaban estos elementos.
7.  Compilar y ejecutar la aplicación para verificar que los componentes y utilidades compartidas funcionen correctamente en todos los lugares donde se utilizan.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

*   - [ ] Creación de la estructura de directorios `src/app/shared` con sus subcarpetas.
*   - [ ] Migración de componentes de UI reutilizables (botones, inputs, etc.) a `shared/components`.
*   - [ ] Migración de pipes y directivas comunes a `shared/pipes` y `shared/directives`.
*   - [ ] Migración de funciones de utilidad (ej. validadores) a `shared/util`.
*   - [ ] Actualización de las importaciones en los módulos de `features` que consumen estos elementos compartidos.
*   - [ ] Verificación de que la aplicación compila y los elementos compartidos se renderizan y funcionan correctamente.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 6 horas.

| Subtarea (TECH-J002.2.x) | Estimado (Horas) | Objetivo Específico |
| :--- | :--- | :--- |
| **TECH-J002.2.1** | 1 | Creación de la estructura de carpetas. |
| **TECH-J002.2.2** | 3 | Identificar y mover todos los elementos compartidos a la nueva estructura. |
| **TECH-J002.2.3** | 2 | Actualizar importaciones y realizar pruebas de regresión visual y funcional. |
| **Total Estimado** | **6** | |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

N/A

***

## 7. Lista de chequeo de logros e hitos a alcanzar

*   [ ] Directorio `shared` creado en `src/app`.
*   [ ] Subdirectorios `components`, `pipes` y `util` creados.
*   [ ] Componentes de UI genéricos migrados y funcionando.
*   [ ] Pipes y directivas comunes migradas y funcionando.
*   [ ] Funciones de utilidad migradas.
*   [ ] Importaciones actualizadas en toda la aplicación.
*   [ ] Verificación completa de que no hay dependencias desde `shared` hacia `features`.