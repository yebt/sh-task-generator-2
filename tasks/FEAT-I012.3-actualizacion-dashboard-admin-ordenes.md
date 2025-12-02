# FEAT-I012.3: Actualización del Dashboard de Administrador para Órdenes de Comida

## 1. DATOS GENERALES

| Atributo | Valor (Completar) |
| :--- | :--- |
| **ID de la Tarea** | FEAT-I012.3 |
| **Letra identificadora** | I |
| **Nombre de la Tarea** | Actualización del Dashboard de Administrador para Órdenes de Comida |
| **Categoría** | Feat |
| **Dependencia Crítica** | FEAT-I012.2 |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo | Valor (Completar) |
| :--- | :--- |
| **Objetivo de la Tarea** | Modernizar el dashboard de "Órdenes de alimentos" para que muestre las comandas (`food_bill_batch`) en tiempo real, optimizando la consulta de nuevos pedidos y actualizando las acciones de impresión y gestión. |
| **Justificación** | El sistema actual de polling es ineficiente y puede sobrecargar el servidor. Un enfoque basado en punteros (timestamp) reducirá la carga, mejorará la sincronización entre múltiples clientes y proporcionará una experiencia más fluida al personal de cocina/caja. |
| **Métricas de Éxito** | - El uso de CPU del servidor atribuible al polling de órdenes se reduce en un 50%.<br>- Las nuevas comandas aparecen en todos los clientes del dashboard en menos de 5 segundos desde su creación.<br>- Las acciones de impresión generan los documentos correctos (comanda vs. factura). |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

La vista del administrador en `{APP_URL}/dashboard/food-orders` debe ser actualizada para funcionar con un nuevo sistema de obtención de datos y para reflejar la nueva estructura de entidades.

1.  **Nuevo Mecanismo de Fetching:**
    *   Al cargar la página, se obtienen todas las comandas (`food_bill_batch`) no archivadas y se almacena el `created_at` del último registro como un "puntero" en el cliente.
    *   Periódicamente, el cliente (ver `fetchNewOrders` en `food-orders.blade.php`) llamará a un nuevo endpoint, enviando su puntero (`created_at`) actual.
    *   El backend responderá con todas las `food_bill_batch` creadas después de ese timestamp y el cliente actualizará su puntero con el `created_at` más reciente de la respuesta.
    *   Se debe implementar caché en el backend para esta consulta, dependiente de la tienda y el tiempo, para optimizar respuestas a múltiples clientes.

2.  **Actualización de Acciones:**
    *   En la vista lateral de "detalles de la orden":
        *   La acción **"Imprimir Comanda"** debe ahora imprimir únicamente el `food_bill_batch` seleccionado.
        *   La acción **"Imprimir Factura"** debe imprimir un resumen de toda la `food_bill` asociada, agrupando todos los productos de todos sus lotes para simplificar la vista.
    *   Se debe añadir un botón más visible y claro en la interfaz para **"Marcar como Completada"** una orden (`food_bill_batch`).

### Criterios de Aceptación (Condiciones Verificables)

| Rol | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :--- | :--- |
| Admin/Cocinero | Cuando se crea una nueva comanda desde la vista del mesero, entonces esta aparece automáticamente en mi dashboard sin necesidad de recargar la página. |
| Admin/Cajero | Cuando hago clic en "Imprimir Comanda" en un lote específico, entonces se genera un ticket de impresión solo con los productos de ese lote. |
| Admin/Cajero | Cuando hago clic en "Imprimir Factura" en un lote, entonces se genera un ticket con el resumen completo y agrupado de todos los productos de la `food_bill` a la que pertenece ese lote. |
| Sistema | Cuando el endpoint de fetching recibe una solicitud con un `created_at`, entonces devuelve solo los `food_bill_batch` más recientes y la respuesta es cacheada. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área | Detalle de la Implementación Técnica |
| :--- | :--- |
| **Backend** | - Crear un nuevo controlador o método para el endpoint de fetching basado en timestamp.<br>- Implementar `Cache::remember` o una estrategia similar, usando una clave que combine el `user_id` y el puntero de tiempo.<br>- Modificar los métodos existentes para la impresión para que distingan entre imprimir un `food_bill_batch` y una `food_bill` completa. |
| **Frontend** | - Refactorizar el archivo `resources/views/dashboard_lightweight/pages/food_store/food-orders.blade.php`.<br>- Modificar la función `fetchNewOrders` para que envíe el puntero `created_at` y actualice su valor con cada respuesta.<br>- Actualizar la lógica de `printOrderTicket` para que llame a los endpoints correctos.<br>- Añadir el nuevo botón "Marcar como Completada". |
| **Bases de Datos** | - Asegurarse de que la columna `created_at` en `food_bill_batches` tenga un índice para optimizar las consultas. |
| **APIs/Endpoints** | - `POST /dashboard/food-orders/fetch-new`: Recibe `{ last_timestamp: 'YYYY-MM-DD HH:MM:SS' }` y devuelve los nuevos `food_bill_batch`.<br>- `GET /dashboard/food-orders/print-batch/{batch_id}`: Endpoint para imprimir una comanda.<br>- `GET /dashboard/food-orders/print-bill/{bill_id}`: Endpoint para imprimir una factura. |
| **Lógica de Negocio** | - La lógica de agrupación de productos para la factura debe consolidar items idénticos de diferentes lotes en una sola línea con la cantidad total. |
| **Seguridad/Validación** | - Validar que el usuario autenticado tenga permiso para acceder a las órdenes de la tienda solicitada. |

### Pasos a seguir sugeridos

1.  Crear el nuevo endpoint en `api.php` o `web.php` para `fetch-new`.
2.  Implementar la lógica del controlador para este endpoint, incluyendo la consulta a la base de datos con la cláusula `where('created_at', '>', $last_timestamp)` y el cacheo de la respuesta.
3.  En el frontend, modificar `fetchNewOrders` para que almacene y envíe el timestamp.
4.  Crear los dos nuevos endpoints para impresión (`print-batch` y `print-bill`).
5.  Implementar la lógica en el backend para generar las vistas de impresión correctas para cada caso.
6.  Añadir el botón "Marcar como Completada" y conectar su funcionalidad.
7.  Realizar pruebas de estrés simulando múltiples clientes para verificar la efectividad del caché.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

- [ ] Nuevo endpoint `fetch-new` con lógica de puntero de timestamp implementado.
- [ ] Sistema de caché para el endpoint `fetch-new` funcionando correctamente.
- [ ] Frontend (`food-orders.blade.php`) modificado para usar el nuevo sistema de fetching.
- [ ] Acción "Imprimir Comanda" funcionando para `food_bill_batch`.
- [ ] Acción "Imprimir Factura" funcionando para `food_bill` con agrupación de productos.
- [ ] Botón "Marcar como Completada" añadido y funcional.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 2.5 días laborales / 20 horas.

| Subtarea (FEAT-I012.3.x) | Estimado (Horas) | Objetivo Específico |
| :--- | :--- | :--- |
| **FEAT-I012.3.1** | 8 | Desarrollo del backend para el fetching optimizado con caché. |
| **FEAT-I012.3.2** | 8 | Refactorización del frontend para el nuevo sistema de polling y actualización de la UI. |
| **FEAT-I012.3.3** | 4 | Implementación de las nuevas lógicas de impresión (comanda y factura). |
| **Total Estimado** | **20** | |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

* **Archivos Relevantes:** `resources/views/dashboard_lightweight/pages/food_store/food-orders.blade.php`
* **Comentarios:** Usar el código de la tarea en la rama a crear para facilitar la impresión. La rama debería llamarse `feat/I012-admin-dashboard-refactor`.

***

## 7. Lista de chequeo de logros e hitos a alcanzar

- [ ] El dashboard carga las comandas iniciales y guarda el último timestamp.
- [ ] Las llamadas periódicas al backend envían el timestamp y reciben solo datos nuevos.
- [ ] La respuesta del endpoint de fetching está cacheada por tienda y tiempo.
- [ ] El botón de imprimir comanda genera un ticket para un solo `food_bill_batch`.
- [ ] El botón de imprimir factura genera un ticket para la `food_bill` completa, con items agrupados.
- [ ] El botón para completar una orden funciona y actualiza el estado del `food_bill_batch`.
