# FEAT-E305-2: Implementar Servicio Gateway para Cálculo de Precios con Cupones

## 1. DATOS GENERALES

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **ID de la Tarea**       | FEAT-E305-2                                                  |
| **Letra identificadora** | E                                                            |
| **Nombre de la Tarea**   | Implementar Servicio Gateway para Cálculo de Precios con Cupones |
| **Categoría**            | FEAT                                                         |
| **Dependencia Crítica**  | FEAT-E305                                                    |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **Objetivo de la Tarea** | Centralizar la lógica de cálculo de precios de compras en un nuevo `GatewayService` e integrar la funcionalidad de aplicación de cupones de descuento sobre el total del carrito. |
| **Justificación**        | Actualmente, la lógica para calcular el total de una compra está duplicada en varios controladores de pasarelas de pago. Esta tarea busca refactorizar ese código en un único servicio reutilizable. Adicionalmente, se introduce la lógica de cupones de descuento, una funcionalidad clave para que las tiendas puedan realizar campañas de marketing e incentivar las ventas. |
| **Métricas de Éxito**    | - El 100% de los cálculos de precios en las pasarelas de pago utilizan el nuevo `GatewayService`.<br>- Los cupones de descuento (fijos y porcentuales) se aplican correctamente según los criterios definidos.<br>- La lógica de cálculo de precios anterior es eliminada de los controladores. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Como continuación de la tarea `FEAT-E305`, y existiendo la entidad `Coupons`, esta tarea introduce un servicio centralizado, `GatewayService`, para calcular el precio final de una compra.

Este servicio contendrá una función principal, `getPurchasePrice`, que se encargará de determinar el costo total de un carrito de compras o un link de pago. La función replicará la lógica de cálculo de items y envío que actualmente existe en el `AddiController`, pero con una adición clave: antes de sumar el costo de envío, se debe verificar y aplicar un cupón de descuento si corresponde.

La lógica para aplicar cupones es la siguiente:
1.  Buscar todos los cupones activos (`active = true`) que pertenezcan a la tienda (`store_id`).
2.  Ordenar los cupones encontrados de mayor a menor según su `criteria_value`.
3.  Evaluar el primer cupón de la lista. Si el total del carrito cumple con la condición del cupón (ej. `total >= criteria_value`), se aplica el descuento.
4.  El descuento puede ser de tipo `fixed` (un monto fijo) o `percentage` (un porcentaje sobre el subtotal).
5.  Una vez aplicado el descuento (o si no aplica ninguno), se suma el costo de envío para obtener el total final.

Finalmente, este nuevo servicio deberá ser utilizado en todos los controladores de pasarelas de pago (`PayuController`, `MercadopagoController`, `AddiController`, `WompiController`), reemplazando la lógica de cálculo de precios duplicada.

### Criterios de Aceptación (Condiciones Verificables)

| Rol                     | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :---------------------- | :----------------------------------------------------------- |
| **Sistema**             | Cuando se llama a `GatewayService::getPurchasePrice()` para un carrito que cumple el criterio de un cupón de descuento porcentual, entonces el servicio devuelve el precio total con el porcentaje descontado del subtotal. |
| **Sistema**             | Cuando se llama a `GatewayService::getPurchasePrice()` para un carrito que cumple el criterio de un cupón de descuento fijo, entonces el servicio devuelve el precio total con el monto fijo descontado del subtotal. |
| **Sistema**             | Cuando un carrito cumple con los criterios de múltiples cupones, entonces el sistema aplica únicamente el primer cupón válido según el ordenamiento (de mayor a menor `criteria_value`). |
| **Sistema**             | Cuando un cupón está inactivo (`active = false`), entonces el `GatewayService` no lo debe aplicar, incluso si el carrito cumple los criterios. |
| **Desarrollador**       | Cuando reviso los controladores `PayuController`, `MercadopagoController`, `AddiController` y `WompiController`, entonces estos utilizan `GatewayService::getPurchasePrice()` para calcular el total de la compra en lugar de lógica local. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                         |
| :----------------------- | :----------------------------------------------------------- |
| **Backend**              | - Crear una nueva clase de servicio: `app/Services/GatewayService.php`.<br>- Implementar el método estático `public static function getPurchasePrice(Request $request, ?PaymentLink $pmtLnk = null)`.<br>- Mover y adaptar la lógica de cálculo de subtotal existente en `AddiController` (líneas 292 a 341) a `getPurchasePrice`.<br>- Implementar la lógica para buscar y aplicar el cupón más apropiado. |
| **Frontend**             | N/A.                                                         |
| **Bases de Datos**       | - Se realizarán consultas a la tabla `coupons` para obtener los cupones activos de una tienda, ordenados por `criteria_value` de forma descendente. |
| **APIs/Endpoints**       | N/A. La lógica se encapsula en un servicio interno.          |
| **Lógica de Negocio**    | - La lógica de `getPurchasePrice` debe seguir este orden: 1. Calcular subtotal de items. 2. Aplicar descuento de cupón si corresponde. 3. Añadir costo de envío. <br> - La selección del cupón se basa en el primer cupón activo que cumple la condición `criteria_op` sobre el subtotal, después de ser ordenados por `criteria_value`. |
| **Seguridad/Validación** | N/A.                                                         |

### Detalles de implementación

**Estructura del `GatewayService`:**
```php
namespace App\Services;

use Illuminate\Http\Request;
use App\Models\PaymentLink; // Asegurarse que el namespace es correcto

class GatewayService 
{
    /**
     * Calcula el precio total de una compra (carrito o link de pago),
     * aplicando la lógica de cupones de descuento.
     *
     * @param Request $request
     * @param PaymentLink|null $pmtLnk
     * @return float
     */
    public static function getPurchasePrice(Request $request, ?PaymentLink $pmtLnk = null): float
    {
        // 1. Replicar la lógica de Addicontroller (líneas 292-341) para obtener el subtotal de los items.
        // ...

        // 2. Obtener la tienda (store) a partir del request o $pmtLnk.
        // ...

        // 3. Lógica para buscar y aplicar el cupón.
        $subtotal = /* ... */;
        $coupons = \App\Models\Coupon::where('store_id', $store->id)
                                    ->where('active', true)
                                    ->orderBy('criteria_value', 'desc')
                                    ->get();

        foreach ($coupons as $coupon) {
            // Evaluar si el subtotal cumple con $coupon->criteria_op y $coupon->criteria_value
            // ...
            
            // Si cumple, aplicar el descuento (fixed o percentage) y salir del bucle.
            // ...
            break; 
        }

        // 4. Sumar el costo de envío al subtotal (ya con el descuento si aplicó).
        // ...

        return $totalFinal;
    }
}
```

### Pasos a seguir sugeridos

1.  Crear el archivo `app/Services/GatewayService.php`.
2.  Implementar la función estática `getPurchasePrice` con la firma especificada.
3.  Migrar la lógica de cálculo de subtotal desde `AddiController` a `getPurchasePrice`.
4.  Implementar la consulta para obtener los cupones activos de la tienda, ordenados por `criteria_value`.
5.  Implementar el bucle que itera sobre los cupones y aplica el primero que cumpla la condición.
6.  Añadir la lógica para calcular el descuento según el `type` ('percentage' o 'fixed').
7.  Integrar el cálculo del costo de envío después de aplicar el posible descuento.
8.  Refactorizar los controladores `PayuController`, `MercadopagoController`, `AddiController` y `WompiController` para que invoquen a `GatewayService::getPurchasePrice()` en lugar de tener su propia lógica de cálculo.
9.  Realizar pruebas para verificar que el cálculo es correcto con y sin cupones, y en todas las pasarelas.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

* - [ ] Creación del `GatewayService` con el método `getPurchasePrice`.
* - [ ] Lógica de cálculo de subtotal portada desde `AddiController`.
* - [ ] Implementación de la lógica de búsqueda y selección de cupones.
* - [ ] Implementación del cálculo de descuento (fijo y porcentual).
* - [ ] `AddiController` refactorizado para usar el `GatewayService`.
* - [ ] `PayuController` refactorizado para usar el `GatewayService`.
* - [ ] `MercadopagoController` refactorizado para usar el `GatewayService`.
* - [ ] `WompiController` refactorizado para usar el `GatewayService`.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 1.5 días laborales (12 horas).

| Subtarea (FEAT-E305-2.x) | Estimado (Horas)    | Objetivo Específico                                      |
| :------------------------ | :------------------ | :------------------------------------------------------- |
| **FEAT-E305-2.1**          | 5                   | Creación del `GatewayService` e implementación de la lógica de cálculo de precios y cupones. |
| **FEAT-E305-2.2**          | 5                   | Refactorización de los 4 controladores de pasarelas de pago para que utilicen el nuevo servicio. |
| **FEAT-E305-2.3**          | 2                   | Pruebas unitarias y de integración para validar el correcto funcionamiento. |
| **Total Estimado**        | **12 Horas**        |                                                          |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

* **Entidad `Coupons`:**
  - `id`
  - `store_id`: fk
  - `title`
  - `details`
  - `type` ('percentage', 'fixed')
  - `value`
  - `criteria_op`: operator
  - `criteria_value`: value
  - `active`: boolean
  - `ts`

***

## 7. Lista de chequeo de logros e hitos a alcanzar

* - [ ] El `GatewayService` está creado y disponible en la aplicación.
* - [ ] La función `getPurchasePrice` calcula correctamente el subtotal de los productos.
* - [ ] La función `getPurchasePrice` busca y ordena los cupones aplicables correctamente.
* - [ ] El descuento de un cupón (fijo o porcentual) se aplica correctamente sobre el subtotal.
* - [ ] El costo de envío se suma correctamente después de aplicar el descuento.
* - [ ] Todos los controladores de pasarelas de pago objetivo han sido refactorizados y utilizan el `GatewayService`.
* - [ ] El flujo de pago funciona correctamente para compras con y sin cupones.
