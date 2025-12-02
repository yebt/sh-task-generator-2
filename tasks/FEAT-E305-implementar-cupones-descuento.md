# FEAT-E305: Implementar Cupones de Descuento en la Tienda

## 1. DATOS GENERALES

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **ID de la Tarea**       | FEAT-E305                                                    |
| **Letra identificadora** | E                                                            |
| **Nombre de la Tarea**   | Implementar Cupones de Descuento en la Tienda                |
| **Categoría**            | FEAT                                                         |
| **Dependencia Crítica**  | N/A                                                          |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **Objetivo de la Tarea** | Dotar a la plataforma de la capacidad de gestionar y aplicar cupones de descuento, desde su creación en el panel de administrador de la tienda hasta su aplicación en el carrito de compras del cliente. |
| **Justificación**        | La implementación de cupones de descuento es una estrategia de marketing fundamental para incentivar las ventas, fidelizar clientes y atraer nuevos compradores. Esta funcionalidad aporta un valor directo al negocio de las tiendas. |
| **Métricas de Éxito**    | - El 100% de los cupones creados por los dueños de tienda pueden ser gestionados (CRUD).<br>- El descuento de un cupón válido se calcula y aplica correctamente en el total del carrito.<br>- Los clientes pueden aplicar cupones en el flujo de compra. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Esta tarea se divide en tres fases principales para implementar un sistema completo de cupones de descuento:

1.  **Fase 1: Infraestructura de Backend:** Se creará la tabla en la base de datos y el modelo de Eloquent necesarios para almacenar la información de los cupones.
2.  **Fase 2: Gestión de Cupones (Dashboard):** Se implementará una interfaz de usuario (CRUD) en el dashboard del dueño de la tienda para que pueda crear, ver, editar y eliminar sus cupones de descuento.
3.  **Fase 3: Aplicación en el Carrito (Cliente Final):** Se modificará el servicio de cálculo de precios del carrito para que los clientes puedan introducir un código de cupón y recibir el descuento correspondiente en su compra.

### Criterios de Aceptación (Condiciones Verificables)

| Rol                     | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :---------------------- | :----------------------------------------------------------- |
| **Dueño de Tienda**     | Cuando creo un nuevo cupón de descuento desde mi dashboard, entonces este se guarda en la base de datos y aparece en mi listado de cupones. |
| **Cliente**             | Cuando ingreso un código de cupón válido en mi carrito de compras, entonces el descuento se aplica correctamente al total de mi orden. |
| **Sistema**             | Cuando un cupón de tipo `percentage` es aplicado, entonces el sistema calcula el descuento como un porcentaje del subtotal. |
| **Sistema**             | Cuando un cupón de tipo `fixed` es aplicado, entonces el sistema resta el valor fijo del cupón del subtotal. |
| **Sistema**             | Cuando un cupón no cumple con los criterios definidos (si los tiene), entonces el sistema informa al usuario que el cupón no es válido para su compra. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                         |
| :----------------------- | :----------------------------------------------------------- |
| **Backend**              | - Crear el modelo `Coupon` y su migración correspondiente.<br>- Desarrollar un `CouponController` para manejar las operaciones CRUD desde el dashboard.<br>- Modificar el servicio encargado de la lógica del carrito (`CartService` o similar) para añadir métodos que validen y apliquen los cupones. |
| **Frontend**             | - Construir una nueva sección en el dashboard de la tienda para la gestión de cupones (listado, formulario de creación/edición).<br>- Añadir un campo de texto y un botón en la vista del carrito/checkout para que el cliente pueda aplicar un cupón. |
| **Bases de Datos**       | - Crear una nueva tabla `coupons` con la siguiente estructura:<br>  - `id` (PK)<br>  - `store_id` (FK a `users`)<br>  - `title` (string)<br>  - `details` (text, nullable)<br>  - `type` (enum: 'percentage', 'fixed')<br>  - `value` (decimal 10,2)<br>  - `criteria_op` (varchar 10, ej: 'min_total')<br>  - `criteria_value` (varchar)<br>  - `active` (boolean)<br>  - `timestamps` |
| **APIs/Endpoints**       | - Endpoints para el CRUD de cupones en el dashboard (ej: `GET, POST, PUT, DELETE /dashboard/coupons`).<br>- Endpoint para que el cliente aplique un cupón (ej: `POST /cart/apply-coupon`). |
| **Lógica de Negocio**    | - Implementar la lógica de validación de cupones: ¿está activo?, ¿cumple con el criterio `criteria_op` y `criteria_value` (ej: total del carrito mayor a X)?<br>- Lógica de cálculo de descuento según el tipo de cupón. |
| **Seguridad/Validación** | - Asegurar que los endpoints del dashboard solo sean accesibles por el dueño de la tienda autenticado.<br>- Validar los datos de entrada al crear/editar un cupón. |

### Pasos a seguir sugeridos

1.  **Fase 1 (Backend Core):**
    *   Crear la migración para la tabla `coupons` usando `php artisan make:migration`.
    *   Definir el esquema de la tabla en el archivo de migración.
    *   Crear el modelo `Coupon` usando `php artisan make:model`.
    *   Definir las relaciones y propiedades en el modelo.
2.  **Fase 2 (Dashboard CRUD):**
    *   Crear el controlador `CouponController` para el dashboard.
    *   Implementar los métodos `index`, `create`, `store`, `edit`, `update`, `destroy`.
    *   Crear las rutas correspondientes en `routes/web.php`.
    *   Diseñar y desarrollar las vistas en Blade/Vue/React para listar y gestionar los cupones.
3.  **Fase 3 (Integración con Carrito):**
    *   Identificar el servicio o controlador que maneja la lógica del carrito.
    *   Añadir un método `applyCoupon(string $code)` a este servicio.
    *   Implementar la lógica de validación y cálculo del descuento dentro de este método.
    *   Crear el endpoint que el frontend consumirá para aplicar el cupón.
    *   Modificar la UI del carrito para añadir el campo de texto y el botón para aplicar el cupón.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

* - [ ] Migración y modelo `Coupon` creados.
* - [ ] Endpoints del CRUD de cupones para el dashboard implementados.
* - [ ] Interfaz de usuario del CRUD de cupones en el dashboard finalizada.
* - [ ] Lógica de aplicación de cupones en el servicio del carrito implementada.
* - [ ] Endpoint para aplicar cupón desde el frontend creado.
* - [ ] UI del carrito actualizada para permitir la aplicación de cupones.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 2 días laborales (16 horas).

| Subtarea (FEAT-E305.x) | Estimado (Horas) | Objetivo Específico                                      |
| :--------------------- | :--------------- | :------------------------------------------------------- |
| **FEAT-E305.1**        | 4                | Fase 1: Creación de la migración y el modelo `Coupon`.   |
| **FEAT-E305.2**        | 8                | Fase 2: Implementación del CRUD completo en el dashboard (backend y frontend). |
| **FEAT-E305.3**        | 4                | Fase 3: Integración de la lógica de aplicación de cupones en el carrito. |
| **Total Estimado**     | **16 Horas**     |                                                          |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

* **Proyecto afectado:** `shopindero-containers/php-app`

***

## 7. Lista de chequeo de logros e hitos a alcanzar

* - [ ] La tabla `coupons` existe en la base de datos con la estructura correcta.
* - [ ] El dueño de una tienda puede crear, ver, editar y desactivar cupones.
* - [ ] Un cliente puede introducir un código de cupón en la vista del carrito.
* - [ ] Si el cupón es válido, el descuento se refleja en el total de la compra.
* - [ ] Si el cupón no es válido o no cumple los criterios, se notifica al cliente.
* - [ ] El flujo de compra sin cupón no presenta regresiones.
