# FEAT-I012.1: Desintegración y Reconstrucción del Módulo de Órdenes de Comida

## 1. DATOS GENERALES

| Atributo | Valor (Completar) |
| :--- | :--- |
| **ID de la Tarea** | FEAT-I012.1 |
| **Letra identificadora** | I |
| **Nombre de la Tarea** | Desintegración y Reconstrucción del Módulo de Órdenes de Comida |
| **Categoría** | Feat |
| **Dependencia Crítica** | N/A |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo | Valor (Completar) |
| :--- | :--- |
| **Objetivo de la Tarea** | Refactorizar el modelo de datos `food_orders` para soportar un seguimiento detallado de los cambios en los pedidos, mejorar la gestión de pagos y permitir la impresión de comandas por lotes. |
| **Justificación** | El modelo actual es monolítico y no permite un seguimiento granular de las interacciones en una mesa (múltiples pedidos, cambios de mesero, etc.). Esta reestructuración es fundamental para implementar la impresión automática de comandas y proporcionar un historial de pedidos más robusto. |
| **Métricas de Éxito** | - El 100% de las nuevas órdenes de comida se gestionan a través de las nuevas entidades (`food_bill`, `food_bill_batch`).<br>- La latencia en la creación de un nuevo lote de pedido (`food_bill_batch`) es inferior a 300ms. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Se requiere que para el módulo de órdenes de comida, se solicita añadir una nueva funcionalidad para lograr la impresión de las comandas de forma automática. Para ello, es necesario cambiar el modelo utilizado para el manejo de las órdenes de comida 'food_orders', para que soporten ahora la capacidad de detectar distintos cambios a lo largo del tiempo.

De este modo, una 'food_order' ahora, se va a desintegrar en las siguientes entidades:

- **`food_payment_methods`**: Representa los métodos de pago creados por una tienda de tipo alimentos.
- **`food_bill`**: Representa la orden o pedido general de la comida asociada a una mesa. No contiene los productos directamente, sino que agrupa los lotes de pedidos.
- **`food_bill_batch`**: Representa una agrupación o lote de alimentos solicitados en una interacción específica del mesero con la mesa. Cada lote es una comanda individual que se puede imprimir.

### Criterios de Aceptación (Condiciones Verificables)

| Rol | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :--- | :--- |
| Administrador de Tienda | Cuando creo un nuevo método de pago en el dashboard, entonces este queda disponible para ser asociado a una `food_bill`. |
| Administrador de Tienda | Cuando intento crear un método de pago con un nombre que ya existe para mi tienda, entonces el sistema muestra un error de validación. |
| Sistema/DB | Cuando se crea un nuevo pedido en una mesa, entonces se genera una nueva `food_bill` con estado `pending` y al menos un `food_bill_batch` asociado. |
| Sistema/DB | Cuando se archiva una `food_bill`, entonces su estado debe ser `payed`. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área | Detalle de la Implementación Técnica |
| :--- | :--- |
| **Backend** | - Crear Modelos de Eloquent: `FoodPaymentMethod`, `FoodBill`, `FoodBillBatch`.<br>- Crear un controlador para el CRUD de `FoodPaymentMethod` en el dashboard.<br>- Implementar las relaciones correspondientes entre los modelos. |
| **Frontend** | - Crear una nueva sección en el dashboard de "Configuración de tienda de alimentos" para gestionar los métodos de pago (CRUD completo). |
| **Bases de Datos** | - Crear las migraciones para las nuevas tablas: `food_payment_methods`, `food_bills`, `food_bill_batches`. |
| **APIs/Endpoints** | - Crear los endpoints necesarios para el CRUD de `food_payment_methods`. |
| **Lógica de Negocio** | - Una tienda (`user_id`) no puede tener dos métodos de pago con el mismo `name`.<br>- Una `food_bill` solo puede ser archivada si su estado es `payed`. |
| **Seguridad/Validación** | - Validar que el `user_id` en `food_payment_methods` corresponda al usuario autenticado.<br>- Validar los ENUMs para los campos de estado. |

### Detalles de implementación

#### `food_payment_methods`
- `id`: PK
- `user_id`: ID de la tienda a la que pertenece.
- `name`: String (Ej: Efectivo, Nequi). Único por `user_id`.
- `timestamps`: Timestamps de Laravel.

#### `food_bill`
- `id`: UUID.
- `user_id`: ID de la tienda dueña del pedido.
- `delegate_id`: ID del mesero que inicialmente atiende la mesa.
- `table_number`: Número de la mesa.
- `customer_name`: String, opcional.
- `status`: ENUM('pending', 'canceled', 'payed').
- `archived`: Boolean.
- `food_payment_method_id`: Foreign key a `food_payment_methods` (nullable).
- `order_method`: ENUM('delivery', 'pickup', 'dine_in').
- `order_method_info`: JSON para información adicional (dirección, etc.).

#### `food_bill_batch`
- `id`: UUID.
- `food_bill_id`: Foreign key a `food_bills`.
- `delegate_id`: ID del mesero que toma este lote específico.
- `disher_info`: JSON. Representa el listado de platos solicitados. La clave de cada producto se genera a partir de sus características para agrupar items idénticos.
  - **Formato de la clave:** `"<id_producto>-[O<id_of_options>*]-[E<id_of_extras>*]-[V<id_of_variations>*]"`
  - **Snapshot del producto:** El JSON debe incluir `quantity`, `options`, `extras`, `variations`, `title` y `price` para evitar problemas si el producto se edita a futuro.
- `status`: ENUM('pending', 'taked', 'done').
- `archived`: Boolean.
- `timestamps`: Timestamps de Laravel.

**Ejemplo de `disher_info` JSON:**
```json
{
  "32-O472": {
    "quantity": 2,
    "options": [{"id": "472", "name": "Talla: 39"}],
    "extras": [],
    "variations": [],
    "title": "Botas Winner Negra",
    "price": "150000"
  },
  "3710-O2685-E314-V876": {
    "quantity": 2,
    "options": [{"id": "2685", "name": "Color: azul"}],
    "extras": [{"id": "314", "name": "EX2", "price": 200}],
    "variations": [{"id": "876", "name": "Derivado: Base"}],
    "title": "Test Product",
    "price": "3200"
  }
}
```

### Pasos a seguir sugeridos

1.  Crear las migraciones para las tres nuevas tablas.
2.  Definir los modelos de Eloquent con sus relaciones (`hasMany`, `belongsTo`).
3.  Implementar el CRUD para `FoodPaymentMethod` en el backend.
4.  Construir la interfaz de usuario en el dashboard para gestionar los métodos de pago.
5.  Asegurar que las validaciones y reglas de negocio se implementen correctamente.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

- [ ] Creación de las 3 migraciones para las nuevas tablas.
- [ ] Modelos `FoodPaymentMethod`, `FoodBill`, y `FoodBillBatch` creados con sus relaciones.
- [ ] Implementado el controlador y las rutas para el CRUD de `FoodPaymentMethod`.
- [ ] Interfaz de usuario para la gestión de métodos de pago en el dashboard finalizada.
- [ ] Reglas de negocio (nombre único de método de pago, archivado de `food_bill`) validadas con pruebas.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 2 días laborales / 16 horas.

| Subtarea (FEAT-I012.1.x) | Estimado (Horas) | Objetivo Específico |
| :--- | :--- | :--- |
| **FEAT-I012.1.1** | 6 | Creación de migraciones y modelos de base de datos. |
| **FEAT-I012.1.2** | 6 | Desarrollo del backend para el CRUD de `FoodPaymentMethod`. |
| **FEAT-I012.1.3** | 4 | Desarrollo del frontend para el CRUD de `FoodPaymentMethod`. |
| **Total Estimado** | **16** | |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

* **Comentarios:** Usar el código de la tarea en la rama a crear para facilitar la impresión. La rama debería llamarse `feat/I012-food-orders-refactor`.

***

## 7. Lista de chequeo de logros e hitos a alcanzar

- [ ] Migración de `food_payment_methods` creada y funcional.
- [ ] Migración de `food_bills` creada y funcional.
- [ ] Migración de `food_bill_batches` creada y funcional.
- [ ] Modelo `FoodPaymentMethod` con sus validaciones.
- [ ] Modelo `FoodBill` con sus relaciones y ENUMs.
- [ ] Modelo `FoodBillBatch` con la lógica de snapshot en `disher_info`.
- [ ] Endpoints para el CRUD de métodos de pago implementados y probados.
- [ ] Vista del dashboard para administrar métodos de pago completada.
