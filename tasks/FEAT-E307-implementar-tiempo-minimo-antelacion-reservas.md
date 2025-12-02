# FEAT-E307: Implementar Tiempo Mínimo de Antelación para Reservas de Alimentos

## 1. DATOS GENERALES

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **ID de la Tarea**       | FEAT-E307                                                    |
| **Letra identificadora** | E                                                            |
| **Nombre de la Tarea**   | Implementar Tiempo Mínimo de Antelación para Reservas de Alimentos |
| **Categoría**            | FEAT                                                         |
| **Dependencia Crítica**  | N/A                                                          |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **Objetivo de la Tarea** | Permitir a los dueños de tiendas de alimentos configurar un tiempo mínimo de antelación requerido para que los clientes puedan realizar una reserva, optimizando así la gestión de la cocina y la disponibilidad de mesas. |
| **Justificación**        | Esta funcionalidad previene que se realicen reservas de último minuto que la cocina no pueda atender, otorgando al restaurante un margen de tiempo configurable para su preparación. Esto mejora la planificación operativa y la experiencia del cliente, al asegurar que su reserva pueda ser atendida adecuadamente. |
| **Métricas de Éxito**    | - El 100% de las tiendas de alimentos pueden configurar y guardar el tiempo mínimo de antelación.<br>- El endpoint que devuelve las franjas horarias disponibles filtra correctamente aquellas que no cumplen con el tiempo mínimo configurado. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Se añadirá una nueva opción en la configuración del módulo de "Alimentos" que permitirá al dueño de la tienda definir un valor en minutos (ej. 45 minutos). Este valor representa el tiempo mínimo que debe transcurrir entre la hora actual y el inicio de la franja horaria que un cliente desea reservar. El sistema utilizará esta configuración para filtrar y mostrar al cliente únicamente las franjas horarias que cumplan con esta condición.

**Ejemplo de funcionamiento:**
- **Franjas horarias disponibles (ej. cada hora):** [9:00, 10:00, 11:00, 12:00, 13:00, 14:00, ...]
- **Configuración de la tienda:** 45 minutos de antelación mínima.
- **Hora actual:** 12:30 PM.
- **Cálculo:** La reserva más temprana posible debe ser después de las 13:15 PM (12:30 + 45 min).
- **Resultado:** Las franjas de las 9:00, 10:00, 11:00, 12:00 y 13:00 no estarán disponibles para el cliente. La primera franja disponible será la de las 14:00.

### Criterios de Aceptación (Condiciones Verificables)

| Rol                     | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :---------------------- | :----------------------------------------------------------- |
| **Dueño de Tienda**     | Cuando ingreso "45" en el campo "Tiempo mínimo de antelación para reservar (minutos)" de mi dashboard y guardo, entonces el sistema almacena este valor para mi tienda. |
| **Cliente**             | Cuando son las 12:30 PM y la tienda tiene configurado un mínimo de 30 minutos de antelación, entonces al intentar reservar, la franja horaria de la 1:00 PM (13:00) NO está disponible. |
| **Sistema**             | Cuando el backend recibe una solicitud de franjas horarias, entonces debe filtrar y excluir todas aquellas cuyo tiempo de inicio sea menor a `HORA_ACTUAL + tiempo_minimo_configurado`. |
| **Sistema**             | Si el valor de antelación no está configurado para una tienda, entonces el sistema no aplica ningún filtro de tiempo y muestra todas las franjas horarias futuras disponibles. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                         |
| :----------------------- | :----------------------------------------------------------- |
| **Backend**              | - **Modelo:** Actualizar el modelo que gestiona la configuración de la tienda de alimentos (ej. `FoodStore`) para incluir el nuevo campo `min_booking_time_buffer`.<br>- **Controlador (Dashboard):** Modificar el método `update` para validar y guardar el nuevo valor `min_booking_time_buffer`.<br>- **Controlador (API Cliente):** Alterar el método que devuelve las franjas horarias disponibles para que aplique el filtro de tiempo si el valor `min_booking_time_buffer` está configurado. |
| **Frontend**             | - **Dashboard:** En el formulario de configuración de la tienda de alimentos, añadir un campo de tipo `number` para que el administrador ingrese el valor en minutos. |
| **Bases de Datos**       | - **Migración:** Crear una nueva migración para añadir una columna `min_booking_time_buffer` de tipo `integer` (nullable, unsigned) a la tabla correspondiente (ej. `food_stores`). |
| **APIs/Endpoints**       | - El endpoint que actualiza la configuración de la tienda debe aceptar el nuevo campo.<br>- El endpoint que devuelve las franjas horarias (`available_slots` o similar) verá su lógica modificada, pero no necesariamente su signatura. |
| **Lógica de Negocio**    | - La lógica de filtrado en el backend debe usar el `now()` del servidor y el valor guardado en minutos para calcular la hora límite. `Carbon::now()->addMinutes($store->min_booking_time_buffer)`. |
| **Seguridad/Validación** | - Validar que el valor introducido en el backend sea un entero no negativo. |

### Pasos a seguir sugeridos

1.  **Crear la Migración:** Ejecutar `php artisan make:migration add_min_booking_time_buffer_to_food_stores_table` (o la tabla que corresponda) y definir la nueva columna.
2.  **Actualizar el Modelo:** Añadir `min_booking_time_buffer` al array `$fillable` del modelo correspondiente.
3.  **Modificar UI del Dashboard:** Agregar el campo numérico en la vista Blade/Vue del formulario de configuración de la tienda.
4.  **Actualizar Controlador del Dashboard:** Modificar el método `update` para que reciba y guarde el nuevo valor.
5.  **Implementar Lógica de Filtrado:** Localizar el controlador/servicio que retorna las franjas horarias al cliente y añadir la condición de filtrado usando Carbon para comparar tiempos.
6.  **Probar:** Validar ambos flujos: con y sin un valor configurado.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

* - [ ] Migración para añadir la columna `min_booking_time_buffer` creada.
* - [ ] Campo numérico para la configuración añadido al formulario del dashboard.
* - [ ] Lógica del backend para guardar el valor desde el dashboard implementada.
* - [ ] Lógica de filtrado de franjas horarias en el backend implementada y funcionando.
* - [ ] Verificación de que el sistema se comporta como antes si no se establece un valor.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 6 horas.

| Subtarea (FEAT-E307.x) | Estimado (Horas) | Objetivo Específico                                      |
| :--------------------- | :--------------- | :------------------------------------------------------- |
| **FEAT-E307.1**        | 2                | Backend: Creación de migración, actualización de modelo y lógica de guardado. |
| **FEAT-E307.2**        | 2                | Frontend: Añadir el campo de configuración en la UI del dashboard. |
| **FEAT-E307.3**        | 2                | Backend: Implementar la lógica de filtrado en la API de horarios y realizar pruebas integrales. |
| **Total Estimado**     | **6 Horas**      |                                                          |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

* **Proyecto afectado:** `shopindero-containers/php-app`

***

## 7. Lista de chequeo de logros e hitos a alcanzar 

* - [ ] La migración se ha ejecutado y la nueva columna existe en la base de datos.
* - [ ] El dueño de la tienda puede ver, editar y guardar el valor de "tiempo mínimo de antelación" en el dashboard.
* - [ ] La API de disponibilidad de horarios excluye correctamente las franjas que no cumplen con la antelación mínima configurada.
* - [ ] La funcionalidad de reserva no presenta regresiones y funciona como se espera cuando no hay un tiempo mínimo configurado.
* - [ ] Las pruebas validan que con una hora de 12:40 y 30 mins de antelación, la franja de las 13:00 no es visible.
