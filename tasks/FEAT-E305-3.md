# FEAT-E305-3: Adaptar GatewayService para usar PurchaseDetails y Exponer Endpoint de Cupones

## 1. DATOS GENERALES

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **ID de la Tarea**       | FEAT-E305-3                                                  |
| **Letra identificadora** | E                                                            |
| **Nombre de la Tarea**   | Adaptar GatewayService para usar PurchaseDetails y Exponer Endpoint de Cupones |
| **Categoría**            | FEAT                                                         |
| **Dependencia Crítica**  | FEAT-E305-2                                                  |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **Objetivo de la Tarea** | Refactorizar el `GatewayService` para que su método `getPurchasePrice` retorne una nueva entidad `PurchaseDetails` y exponer un endpoint que permita a los frontends consultar los cupones aplicables a una compra. |
| **Justificación**        | Actualmente, el `GatewayService` devuelve un array desestructurado, lo cual dificulta su consumo y mantenimiento. La introducción de una entidad `PurchaseDetails` proporcionará un contrato de datos claro y ordenado. El nuevo endpoint es crucial para que los checkouts (plantillas "feather" y "classic-foods") puedan mostrar dinámicamente los descuentos disponibles y el total real, mejorando la transparencia y la experiencia del usuario antes de pagar. |
| **Métricas de Éxito**    | - El método `GatewayService::getPurchasePrice()` retorna una instancia de `PurchaseDetails`.<br>- El 100% de los controladores de pago relevantes usan la nueva entidad para obtener el total.<br>- El nuevo endpoint de consulta de cupones responde correctamente con la lista de cupones aplicables y el total. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Como continuación de la tarea `FEAT-E305-2`, esta tarea se centra en mejorar la estructura de datos de la lógica de precios y exponerla para el consumo del frontend.

1.  **Refactorización del `GatewayService` con `PurchaseDetails`:**
    Se debe adaptar el `GatewayService` para que utilice una nueva entidad o DTO (Data Transfer Object) llamada `PurchaseDetails`. Esta entidad servirá como un contenedor estructurado para el resultado del cálculo de precios que actualmente se retorna como un array desde `GatewayService::getPurchasePrice()`. En lugar de un array, el método devolverá un objeto `PurchaseDetails` con el desglose claro del precio (subtotal, descuento, envío, total, etc.), proporcionando orden y claridad.

2.  **Integración en Controladores de Pago:**
    Una vez refactorizado el servicio, se deben actualizar todos los controladores de las pasarelas de pago (`PayuController`, `MercadopagoController`, `AddiController`, `WompiController`, etc.) para que utilicen esta nueva entidad `PurchaseDetails` al momento de calcular el total a pagar.

3.  **Nuevo Endpoint de Consulta de Cupones:**
    Se debe implementar un nuevo endpoint de tipo GET que permita al frontend consultar en tiempo real qué cupones son aplicables a un carrito de compras específico. Este endpoint recibirá los datos de la compra y devolverá un listado en formato JSON con los cupones que el cliente podría aplicar y el impacto que tendría cada uno en el precio final. Esta funcionalidad es esencial para los checkouts de las plantillas "feather" y "classic foods".

### Criterios de Aceptación (Condiciones Verificables)

| Rol                     | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :---------------------- | :----------------------------------------------------------- |
| **Sistema**             | Cuando se invoca `GatewayService::getPurchasePrice()`, entonces el resultado es un objeto `PurchaseDetails` que contiene el subtotal, el cupón aplicado (si existe), el monto del descuento y el total final. |
| **Desarrollador**       | Cuando reviso los controladores de pago, entonces estos utilizan la nueva entidad `PurchaseDetails` para obtener los montos de la compra en lugar de acceder a un array. |
| **Frontend/API**        | Cuando se realiza una petición GET al nuevo endpoint de consulta con los datos de un carrito, entonces la respuesta es un JSON que contiene una lista de cupones aplicables y el total real de la compra. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                         |
| :----------------------- | :----------------------------------------------------------- |
| **Backend**              | - **Crear DTO:** Definir y crear una nueva clase `PurchaseDetails` (puede ser un DTO) que contenga propiedades como `subtotal`, `shippingCost`, `appliedCoupon`, `discountAmount`, `total`.<br>- **Refactorizar Servicio:** Modificar el método `GatewayService::getPurchasePrice` para que construya y retorne una instancia de `PurchaseDetails`.<br>- **Crear Endpoint:** Implementar un nuevo controlador y una ruta (ej: `GET /api/cart/applicable-coupons`) que utilice el `GatewayService` para obtener la información de precios y cupones y la devuelva como JSON.<br>- **Actualizar Controladores:** Refactorizar los controladores de las pasarelas de pago para que consuman el objeto `PurchaseDetails`. |
| **Frontend**             | N/A. Esta tarea prepara el backend para ser consumido por el frontend. |
| **Bases de Datos**       | No se esperan cambios en el esquema de la base de datos.     |
| **APIs/Endpoints**       | - Se creará un nuevo endpoint público: `GET /api/cart/applicable-coupons`. |
| **Lógica de Negocio**    | La lógica para determinar los cupones aplicables ya existe en `GatewayService`. Esta tarea se enfoca en estructurar la salida y exponerla a través de un nuevo endpoint. |
| **Seguridad/Validación** | El nuevo endpoint debe validar los parámetros de entrada del carrito para asegurar que los cálculos sean correctos. |

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

1.  Crear la nueva clase o DTO `PurchaseDetails` para estandarizar la estructura de datos del precio.
2.  Refactorizar el método `GatewayService::getPurchasePrice` para que su valor de retorno sea una instancia de `PurchaseDetails`.
3.  Crear el nuevo controlador y la ruta para el endpoint `GET` que consultará los cupones aplicables.
4.  Implementar la lógica en el nuevo controlador para llamar al `GatewayService` y formatear la respuesta JSON.
5.  Actualizar los controladores de las pasarelas de pago para que dejen de usar el array y en su lugar utilicen el objeto `PurchaseDetails`.
6.  Añadir pruebas (unitarias o de feature) para validar el comportamiento del `GatewayService` y del nuevo endpoint.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

* - [ ] Creación de la clase `PurchaseDetails`.
* - [ ] `GatewayService::getPurchasePrice` refactorizado para retornar una instancia de `PurchaseDetails`.
* - [ ] Nuevo endpoint GET para consulta de cupones implementado y funcional.
* - [ ] Controladores de pago refactorizados para usar `PurchaseDetails`.
* - [ ] Pruebas automatizadas cubriendo la nueva lógica.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 1.5 días laborales (12 horas).

| Subtarea (FEAT-E305-3.x) | Estimado (Horas)    | Objetivo Específico                                      |
| :------------------------ | :------------------ | :------------------------------------------------------- |
| **FEAT-E305-3.1**          | 4                   | Creación de la clase `PurchaseDetails` y refactorización del `GatewayService`. |
| **FEAT-E305-3.2**          | 4                   | Implementación del nuevo endpoint de consulta de cupones. |
| **FEAT-E305-3.3**          | 4                   | Refactorización de controladores de pago y pruebas de integración. |
| **Total Estimado**        | **12 Horas**        |                                                          |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

N/A

***

## 7. Lista de chequeo de logros e hitos a alcanzar 

* - [ ] La clase `PurchaseDetails` está definida y se utiliza en el `GatewayService`.
* - [ ] El método `getPurchasePrice` ya no devuelve un array, sino un objeto `PurchaseDetails`.
* - [ ] El endpoint `GET /api/cart/applicable-coupons` (o similar) está operativo y devuelve un JSON válido.
* - [ ] La respuesta del endpoint incluye una lista de cupones y el total.
* - [ ] Los controladores de pago han sido refactorizados y funcionan correctamente con `PurchaseDetails`.
* - [ ] El flujo de pago completo no presenta regresiones.