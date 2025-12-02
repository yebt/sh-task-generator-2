# FEAT-I012.2: Reconstrucción del Flujo de Trabajo de Meseros para Órdenes de Comida

## 1. DATOS GENERALES

| Atributo | Valor (Completar) |
| :--- | :--- |
| **ID de la Tarea** | FEAT-I012.2 |
| **Letra identificadora** | I |
| **Nombre de la Tarea** | Reconstrucción del Flujo de Trabajo de Meseros para Órdenes de Comida |
| **Categoría** | Feat |
| **Dependencia Crítica** | FEAT-I012.1 |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo | Valor (Completar) |
| :--- | :--- |
| **Objetivo de la Tarea** | Actualizar la interfaz de toma de pedidos del mesero para que utilice las nuevas entidades (`food_bill`, `food_bill_batch`), reflejando un flujo de trabajo más realista donde se pueden añadir múltiples comandas a una misma cuenta de mesa. |
| **Justificación** | El flujo actual no permite añadir nuevos pedidos a una mesa que ya tiene una orden activa. Este cambio es crucial para que los meseros puedan gestionar las mesas de forma continua, añadiendo rondas de pedidos sin tener que cerrar y abrir una nueva cuenta cada vez. |
| **Métricas de Éxito** | - El 100% de las interacciones de los meseros en la vista de pedidos se realizan contra las nuevas entidades.<br>- El tiempo para añadir un nuevo `food_bill_batch` a una `food_bill` existente es inferior a 500ms. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

La vista de meseros (`/almacenzapatoreal/delegates-orders/{table-number}`) debe ser completamente refactorizada para abandonar el uso de la tabla `food_store` y sus entidades relacionadas. La interacción con las mesas cambiará de la siguiente manera:

1.  **Mesa Vacía:** Si un mesero accede a una mesa que no tiene ninguna `food_bill` con estado `pending`, la vista aparecerá vacía, lista para tomar un nuevo pedido.
2.  **Inicio de Pedido:** Al enviar el primer lote de productos, el sistema debe:
    *   Crear una nueva `food_bill` asociada a la mesa.
    *   Crear el primer `food_bill_batch` con los productos enviados.
3.  **Añadir a Pedido Existente:** Si el mesero accede a una mesa que ya tiene una `food_bill` activa (`pending`), la vista mostrará los lotes (`food_bill_batch`) ya pedidos. Al enviar un nuevo conjunto de productos, el sistema creará un nuevo `food_bill_batch` y lo asociará a la `food_bill` existente. Estos lotes no se agrupan, ya que representan comandas distintas en el tiempo.
4.  **Cierre de Mesa:** Una vez que la `food_bill` pasa a un estado final (`payed` o `canceled`), la mesa vuelve a aparecer como disponible y sin pedidos activos para el mesero.

### Criterios de Aceptación (Condiciones Verificables)

| Rol | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :--- | :--- |
| Mesero | Cuando accedo a una mesa sin pedido activo, entonces la vista de pedidos está vacía. |
| Mesero | Cuando envío el primer pedido para una mesa vacía, entonces se crea una `food_bill` y un `food_bill_batch`, y la vista se refresca mostrando el lote enviado como una entidad inmutable. |
| Mesero | Cuando accedo a una mesa con un pedido activo y envío un nuevo pedido, entonces se añade un nuevo `food_bill_batch` a la `food_bill` existente, y este nuevo lote aparece en la vista. |
| Mesero | Cuando una `food_bill` es marcada como pagada, entonces la mesa correspondiente aparece nuevamente como vacía en mi interfaz. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área | Detalle de la Implementación Técnica |
| :--- | :--- |
| **Backend** | - Modificar el controlador que gestiona la lógica de `/almacenzapatoreal/delegates-orders/{table-number}`.<br>- Crear un nuevo endpoint para que el mesero envíe un `food_bill_batch`. Este endpoint debe verificar si existe una `food_bill` activa para la mesa; si no, la crea. |
| **Frontend** | - Refactorizar completamente la vista del mesero para leer y mostrar los datos de `food_bill` y sus `food_bill_batch` asociados.<br>- La interfaz debe mostrar los lotes de pedidos de forma separada e inmutable una vez creados. |
| **Bases de Datos** | - No se requieren cambios de esquema, pero las consultas deben apuntar a las nuevas tablas. |
| **APIs/Endpoints** | - `GET /delegates-orders/{table-number}`: Devuelve la `food_bill` activa y sus `food_bill_batch` asociados.<br>- `POST /delegates-orders/{table-number}/batch`: Recibe los productos del nuevo lote, busca o crea la `food_bill` y crea el `food_bill_batch`. |
| **Lógica de Negocio** | - La lógica para determinar si una mesa tiene un pedido activo se basa en la existencia de una `food_bill` con `status = 'pending'`.<br>- La creación del `disher_info` con su hash único debe ser manejada en el backend al recibir un nuevo lote. |
| **Seguridad/Validación** | - Asegurar que el mesero (`delegate_id`) tenga permisos para actuar sobre la tienda (`user_id`) a la que pertenece la mesa. |

### Pasos a seguir sugeridos

1.  Identificar el controlador y la ruta actual que sirve la vista del mesero.
2.  Modificar el método del controlador que obtiene los datos de la mesa para que consulte `food_bills` y `food_bill_batches` en lugar de `food_orders`.
3.  Crear el nuevo endpoint `POST` para recibir nuevos lotes de pedidos.
4.  Implementar la lógica en este endpoint para manejar la creación de `food_bill` (si es el primer lote) y `food_bill_batch`.
5.  Refactorizar la vista Blade/Vue/React para renderizar la nueva estructura de datos. La vista debe ser capaz de mostrar una lista de lotes.
6.  Probar exhaustivamente el flujo completo: mesa vacía, primer pedido, pedidos subsecuentes y cierre de mesa.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

- [ ] Endpoint `GET /delegates-orders/{table-number}` modificado para usar las nuevas entidades.
- [ ] Endpoint `POST /delegates-orders/{table-number}/batch` creado y funcional.
- [ ] Lógica de creación de `food_bill` en el primer batch implementada.
- [ ] Lógica de adición de `food_bill_batch` a `food_bill` existente implementada.
- [ ] Vista del mesero completamente refactorizada para mostrar los lotes de pedidos.
- [ ] Flujo de trabajo completo probado y validado.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 2 días laborales / 16 horas.

| Subtarea (FEAT-I012.2.x) | Estimado (Horas) | Objetivo Específico |
| :--- | :--- | :--- |
| **FEAT-I012.2.1** | 8 | Desarrollo del backend (modificación de controlador y creación de nuevo endpoint). |
| **FEAT-I012.2.2** | 8 | Refactorización completa de la interfaz de usuario del mesero. |
| **Total Estimado** | **16** | |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

* **Comentarios:** Usar el código de la tarea en la rama a crear para facilitar la impresión. La rama debería llamarse `feat/I012-waiter-flow-refactor`.

***

## 7. Lista de chequeo de logros e hitos a alcanzar

- [ ] La vista del mesero ya no consume ninguna entidad relacionada con `food_store`.
- [ ] Al entrar a una mesa libre, la interfaz se muestra vacía.
- [ ] Al enviar un pedido a una mesa libre, se crea la `food_bill` y el primer `food_bill_batch`.
- [ ] Al enviar pedidos adicionales, solo se crean nuevos `food_bill_batch` bajo la misma `food_bill`.
- [ ] La vista del mesero lista correctamente todos los `food_bill_batch` de una orden activa.
- [ ] Después de que una orden es pagada, la mesa vuelve a estar libre.
