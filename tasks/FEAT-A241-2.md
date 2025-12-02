# FEAT-A241-2: Adaptar GatewayService para usar PurchaseDetails y Exponer Endpoint de Cupones Aplicables

## 1. DATOS GENERALES

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **ID de la Tarea**       | FEAT-A241-2                                                  |
| **Letra identificadora** | A                                                            |
| **Nombre de la Tarea**   | Adaptar GatewayService para usar PurchaseDetails y Exponer Endpoint de Cupones Aplicables |
| **Categoría**            | FEAT                                                         |
| **Dependencia Crítica**  | FEAT-E305-2                                                  |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **Objetivo de la Tarea** | Refactorizar el `GatewayService` para que su método `getPurchasePrice` retorne una nueva entidad `PurchaseDetails` que estructure el desglose del precio, y exponer un endpoint que permita consultar los cupones aplicables a una compra en tiempo real. |
| **Justificación**        | La estructura de datos que retorna actualmente `GatewayService::getPurchasePrice()` es un array, lo cual es propenso a errores y difícil de mantener. La introducción de `PurchaseDetails` proporcionará una estructura de datos clara y ordenada. Adicionalmente, el nuevo endpoint es crucial para que los frontends de los checkouts (feather y classic foods) puedan mostrar dinámicamente los descuentos disponibles y el total actualizado antes de que el usuario finalice la compra, mejorando la transparencia y la experiencia de usuario. |
| **Métricas de Éxito**    | - El método `GatewayService::getPurchasePrice()` retorna una instancia de `PurchaseDetails`.<br>- El 100% de los controladores de pago utilizan la nueva entidad `PurchaseDetails` para obtener el total.<br>- El nuevo endpoint de consulta de cupones responde correctamente con la lista de cupones aplicables y el total real de la compra. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Esta tarea es la continuación de `FEAT-E305-2` y se enfoca en mejorar la estructura de datos de la lógica de precios y exponerla para el frontend.

1.  **Refactorización del `GatewayService`:**
    Se debe adaptar el `GatewayService` para que utilice una nueva entidad o DTO (Data Transfer Object) llamada `PurchaseDetails`. Esta entidad encapsulará y ordenará el resultado del cálculo de precios que actualmente se retorna como un array desde `GatewayService::getPurchasePrice()`. El objetivo es que, en lugar de un array, el método devuelva un objeto `PurchaseDetails` con el desglose claro del precio (subtotal, descuento, envío, total, etc.).

2.  **Integración en Controladores de Pago:**
    Una vez refactorizado el servicio, se deben actualizar todos los controladores de las pasarelas de pago (`PayuController`, `MercadopagoController`, `AddiController`, `WompiController`, etc.) para que utilicen esta nueva entidad `PurchaseDetails` al momento de calcular el total a pagar.

3.  **Nuevo Endpoint de Consulta de Cupones:**
    Se debe implementar un nuevo endpoint de tipo GET que permita al frontend consultar, en tiempo real, qué cupones son aplicables a un carrito de compras específico. Este endpoint recibirá los datos de la compra y devolverá un listado en formato JSON con los cupones que el cliente podría aplicar y el impacto que tendría cada uno en el precio final. Esto es esencial para que las plantillas de checkout (feather y classic foods) puedan mostrar esta información al usuario.

### Criterios de Aceptación (Condiciones Verificables)

| Rol                     | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :---------------------- | :----------------------------------------------------------- |
| **Sistema**             | Cuando se invoca `GatewayService::getPurchasePrice()`, entonces el resultado es un objeto `PurchaseDetails` que contiene el subtotal, el cupón aplicado (si existe), el monto del descuento y el total final. |
| **Desarrollador**       | Cuando reviso los controladores de pago, entonces estos utilizan la nueva entidad `PurchaseDetails` para obtener los montos de la compra en lugar de acceder a un array. |
| **Frontend/Cliente**    | Cuando se realiza una petición `GET` al nuevo endpoint de consulta con los datos de un carrito, entonces la respuesta es un JSON que contiene una lista de cupones aplicables y el total final de la compra. |
| **Sistema**             | Cuando el nuevo endpoint es consultado, entonces este retorna un JSON con el listado de cupones y el total real de la compra. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                         |
| :----------------------- | :----------------------------------------------------------- |
| **Backend**              | - **Crear DTO:** Definir y crear una nueva clase `PurchaseDetails` (puede ser un DTO o una clase simple) que contenga propiedades como `subtotal`, `shippingCost`, `appliedCoupon`, `discountAmount`, `total`.<br>- **Refactorizar Servicio:** Modificar el método `GatewayService::getPurchasePrice` para que construya y retorne una instancia de `PurchaseDetails`.<br>- **Crear Endpoint:** Implementar un nuevo controlador y una ruta (ej: `GET /api/cart/applicable-coupons`) que utilice el `GatewayService` para obtener la información de precios y cupones y la devuelva como JSON.<br>- **Actualizar Controladores:** Refactorizar los controladores de las pasarelas de pago para que consuman el objeto `PurchaseDetails` en lugar del array anterior. |
| **Frontend**             | N/A. Esta tarea se enfoca en el backend, pero prepara los datos para el consumo del frontend. |
| **Bases de Datos**       | No se esperan cambios en el esquema de la base de datos. Las consultas se realizarán sobre las tablas existentes (`coupons`, etc.). |
| **APIs/Endpoints**       | - Se creará un nuevo endpoint: `GET /api/cart/applicable-coupons` (o una ruta similar) que será público y consumible por los checkouts. |
| **Lógica de Negocio**    | La lógica para determinar los cupones aplicables ya existe en `GatewayService`. Esta tarea se centra en estructurar la salida y exponerla a través de un nuevo endpoint. |
| **Seguridad/Validación** | El nuevo endpoint debe validar los parámetros de entrada para asegurar que los cálculos se basan en datos coherentes. |

### Detalles de implementación

**Clase `PurchaseDetails` (Ejemplo Conceptual):**
```php
namespace App\DTOs; // o una ubicación apropiada

class PurchaseDetails 
{
    public function __construct(
        public readonly float $subtotal,
        public readonly float $shippingCost,
        public readonly ?object $appliedCoupon, // Podría ser un DTO del cupón
        public readonly float $discountAmount,
        public readonly float $total
    ) {}
}
```

### Pasos a seguir sugeridos

1.  Crear la nueva clase o DTO `PurchaseDetails` para estandarizar la estructura de datos del precio de la compra.
2.  Refactorizar el método `GatewayService::getPurchasePrice` para que su valor de retorno sea una instancia de `PurchaseDetails`.
3.  Crear el nuevo controlador y la ruta para el endpoint `GET` que consultará los cupones aplicables.
4.  Implementar la lógica en el nuevo controlador para llamar al `GatewayService` y formatear la respuesta JSON.
5.  Actualizar todos los controladores de pasarelas de pago para que dejen de usar el array y en su lugar utilicen el objeto `PurchaseDetails`.
6.  Añadir pruebas unitarias o de feature para validar el comportamiento del `GatewayService` y del nuevo endpoint.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

* - [ ] Creación de la clase `PurchaseDetails`.
* - [ ] `GatewayService::getPurchasePrice` refactorizado para retornar una instancia de `PurchaseDetails`.
* - [ ] Nuevo endpoint GET para consulta de cupones aplicables implementado y funcional.
* - [ ] Controladores de las pasarelas de pago (`Addi`, `Payu`, `Mercadopago`, `Wompi`) refactorizados para usar `PurchaseDetails`.
* - [ ] Pruebas automatizadas para el nuevo endpoint y la lógica del servicio.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 1.5 días laborales (12 horas).

| Subtarea (FEAT-A241-2.x) | Estimado (Horas)    | Objetivo Específico                                      |
| :------------------------ | :------------------ | :------------------------------------------------------- |
| **FEAT-A241-2.1**          | 4                   | Creación de la clase `PurchaseDetails` y refactorización del `GatewayService`. |
| **FEAT-A241-2.2**          | 4                   | Implementación del nuevo endpoint de consulta de cupones. |
| **FEAT-A241-2.3**          | 4                   | Refactorización de los controladores de pago y pruebas de integración. |
| **Total Estimado**        | **12 Horas**        |                                                          |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

* **Contexto:** Esta tarea es una continuación directa de `FEAT-E305-2`, donde se implementó el `GatewayService`.

***

## 7. Lista de chequeo de logros e hitos a alcanzar 

* - [ ] La clase `PurchaseDetails` está definida y se utiliza en el `GatewayService`.
* - [ ] El `GatewayService` ya no devuelve un array, sino un objeto `PurchaseDetails`.
* - [ ] El endpoint `GET /api/cart/applicable-coupons` (o similar) está operativo.
* - [ ] La respuesta del endpoint incluye un listado de cupones y el total.
* - [ ] Los controladores de pago han sido refactorizados y funcionan correctamente con la nueva estructura de datos.
* - [ ] El flujo de pago completo no presenta regresiones.