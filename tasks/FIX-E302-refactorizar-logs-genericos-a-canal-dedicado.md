# FIX-E302: Refactorizar Logs Genéricos a Canal Dedicado

## 1. DATOS GENERALES

| Atributo | Valor (Completar) |
| :--- | :--- |
| **ID de la Tarea** | FIX-E302 |
| **Letra identificadora** | E |
| **Nombre de la Tarea** | Refactorizar Logs Genéricos a Canal Dedicado |
| **Categoría** | FIX |
| **Dependencia Crítica** | N/A |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo | Valor (Completar) |
| :--- | :--- |
| **Objetivo de la Tarea** | Centralizar todos los registros de log no especializados en un canal dedicado para mejorar la trazabilidad y separar la información de depuración general de los logs críticos de la aplicación. |
| **Justificación** | Actualmente, las llamadas genéricas como `Log::info()` o `Log::debug()` escriben en el archivo de log por defecto, mezclando mensajes de depuración con registros importantes (errores, transacciones, etc.). Esto dificulta el monitoreo y la depuración. Un canal dedicado limpiará el log principal y facilitará el seguimiento de flujos específicos. |
| **Métricas de Éxito** | - El archivo `storage/logs/laravel.log` muestra una reducción significativa de mensajes genéricos (`info`, `debug`, `warning`).<br>- El nuevo archivo `storage/logs/custom_debug.log` contiene las entradas de log que antes eran genéricas.<br>- Los canales de log especializados existentes (ej: `payments`, `sentry`) no se ven afectados. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Esta es una tarea de refactorización técnica sin impacto en la funcionalidad del usuario final. El cambio se centra en cómo se gestionan los logs a nivel interno. Todas las llamadas al facade `Log` que no especifican un canal (`Log::info`, `Log::debug`, etc.) serán modificadas para que escriban en un nuevo canal de logging llamado `custom_debug`.

### Criterios de Aceptación (Condiciones Verificables)

| Rol | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :--- | :--- |
| **Sistema/DB** | Cuando el código ejecuta una llamada genérica como `Log::info('Mensaje de prueba')`, entonces el mensaje se escribe exclusivamente en el archivo `storage/logs/custom_debug.log`. |
| **Sistema/DB** | Cuando el código ejecuta una llamada a un canal específico como `Log::channel('payments')->info('Pago procesado')`, entonces el mensaje se escribe en el destino configurado para el canal `payments` y no en `custom_debug.log`. |
| **Seguridad/Lógica** | Cuando ocurre un error o excepción manejado por Laravel, entonces se sigue registrando en su destino estándar (ej: `laravel.log` o `sentry`) sin ser desviado al canal `custom_debug`. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área | Detalle de la Implementación Técnica |
| :--- | :--- |
| **Backend** | **1. Configuración de Logging:**<br>- En `config/logging.php`, añadir un nuevo canal en el array `channels` llamado `custom_debug`.<br>- Este canal utilizará el driver `single` y su `path` apuntará a `storage_path('logs/custom_debug.log')`.<br><br>**2. Refactorización de Código:**<br>- Realizar una búsqueda global en el proyecto (`../shopindero-containers/php-app`) de las siguientes ocurrencias: `Log::info(`, `Log::debug(`, `Log::warning(`, `Log::notice(`, `Log::error(`.<br>- Se deben excluir las llamadas que ya utilizan un canal (`Log::channel(...)`).<br>- Reemplazar cada llamada genérica por su equivalente con el nuevo canal. Ejemplo: `Log::info(...)` se convierte en `Log::channel('custom_debug')->info(...)`. |
| **Bases de Datos** | N/A |
| **APIs/Endpoints** | N/A |
| **Lógica de Negocio** | La lógica de negocio no se ve alterada. Solo cambia el destino de los registros de depuración. |
| **Seguridad/Validación** | Las llamadas `Log::error` deben ser revisadas con especial atención. Aunque la tarea indica redirigir todos los logs sin canal, un `Log::error` podría ser intencionalmente dirigido al log principal de errores. Se procederá con el reemplazo, pero se requiere una validación manual posterior para asegurar que no se oculten errores críticos. |

### Detalles de implementación

A continuación se muestra un ejemplo de la configuración a añadir y el cambio en el código.

**Snippet de `config/logging.php`:**
```php
'channels' => [
    // ... otros canales

    'custom_debug' => [
        'driver' => 'single',
        'path' => storage_path('logs/custom_debug.log'),
        'level' => 'debug',
    ],
],
```

**Snippet de refactorización:**
```php
// Antes
Log::info('Este es un mensaje de depuración para el flujo X.');

// Después
Log::channel('custom_debug')->info('Este es un mensaje de depuración para el flujo X.');
```

### Pasos a seguir sugeridos

1.  **Configurar Canal:** Añadir el nuevo canal `custom_debug` en el archivo `config/logging.php`.
2.  **Búsqueda y Reemplazo:** Utilizar la función de búsqueda y reemplazo global del IDE para encontrar todas las instancias de `Log::` seguido de un nivel (`info`, `debug`, etc.) y reemplazarlo por `Log::channel('custom_debug')->...`.
3.  **Validación Manual:** Revisar los cambios, especialmente los `Log::error`, para confirmar que la redirección es correcta.
4.  **Pruebas:** Ejecutar flujos de la aplicación que se sepa que generan logs genéricos y verificar que los mensajes aparecen en `storage/logs/custom_debug.log`.
5.  **Regresión:** Asegurarse de que los logs de canales especializados y los logs de errores de Laravel sigan funcionando como se espera.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

Esta lista resume los pasos esenciales para completar la tarea.

* - [ ] Nuevo canal `custom_debug` creado y configurado en `config/logging.php`.
* - [ ] Búsqueda global de llamadas a `Log::` genéricas completada.
* - [ ] Al menos 15-20 llamadas a `Log::info`, `Log::debug` y `Log::warning` han sido refactorizadas.
* - [ ] Se ha verificado que los nuevos logs aparecen correctamente en `storage/logs/custom_debug.log`.
* - [ ] Se ha confirmado que los logs de error y de canales especializados no han sido afectados.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 4 horas.

| Subtarea (FIX-E302.x) | Estimado (Horas) | Objetivo Específico |
| :--- | :--- | :--- |
| **FIX-E302.1** | 0.5 | Configurar el nuevo canal de logging `custom_debug`. |
| **FIX-E302.2** | 2.5 | Buscar y refactorizar todas las llamadas a logs genéricos en la base del código. |
| **FIX-E302.3** | 1 | Realizar pruebas funcionales y de regresión para validar la correcta segregación de logs. |
| **Total Estimado** | **4 Horas** | |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

*   **Comentarios:** Prestar especial atención a los reemplazos de `Log::error()` para no suprimir la visibilidad de errores importantes que deberían estar en el canal principal de errores.

***

## 7. Lista de chequeo de logros e hitos a alcanzar

Esta lista contiene los hitos técnicos para seguimiento del progreso de la tarea.
El listado debe de estar correctamente distribuido en los puntos a alcanzar, siendo estos verificables en la base de desarrollo y progreso

- [ ] Canal `custom_debug` configurado en `config/logging.php`.
- [ ] Todas las llamadas `Log::info()` genéricas refactorizadas.
- [ ] Todas las llamadas `Log::debug()` genéricas refactorizadas.
- [ ] Todas las llamadas `Log::warning()` genéricas refactorizadas.
- [ ] Verificación manual de que el archivo `custom_debug.log` recibe los logs.
- [ ] Verificación de que `laravel.log` ya no recibe logs de depuración genéricos.
- [ ] El set de pruebas automatizadas (si existe) pasa sin errores.
