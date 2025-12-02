# FIX-Y501: Evitar envío de email de confirmación para pagos de Addi con estado "Abandoned"

## 1. DATOS GENERALES

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **ID de la Tarea**       | FIX-Y501                                                     |
| **Letra identificadora** | Y                                                            |
| **Nombre de la Tarea**   | Evitar envío de email de confirmación para pagos de Addi con estado "Abandoned" |
| **Categoría**            | FIX                                                          |
| **Dependencia Crítica**  | N/A                                                          |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **Objetivo de la Tarea** | Corregir el flujo de notificación de compra para que no se envíen correos de confirmación a los clientes cuando el estado de un pago de Addi es "Abandoned". |
| **Justificación**        | Actualmente, el sistema envía un correo de confirmación de compra incluso cuando Addi reporta el pago como "Abandoned". Esto confunde al cliente, haciéndole creer que su compra fue exitosa cuando no lo fue, y genera una mala experiencia de usuario y posible soporte innecesario. |
| **Métricas de Éxito**    | El 100% de las transacciones de Addi con estado "Abandoned" no deben generar un correo de confirmación de compra. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Se ha detectado un error en el flujo de pago con Addi. Cuando una transacción es reportada con el estado **"Abandoned"**, el sistema está enviando incorrectamente el correo de confirmación de compra al cliente, como si la transacción hubiera sido exitosa.

Esta tarea consiste en intervenir el proceso que gestiona las notificaciones de pago de Addi (probablemente un webhook) para verificar el estado de la transacción. Si el estado es "Abandoned", se debe impedir explícitamente el envío del correo electrónico de confirmación.

Es un requisito indispensable investigar los logs de producción de `shopindero.com` para analizar el comportamiento de la orden `shopindero_addi_cr419ee3cc-a1e5-4b35-bccc-fd1aafaaaca5` y entender el origen del problema.

### Criterios de Aceptación (Condiciones Verificables)

| Rol                     | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :---------------------- | :----------------------------------------------------------- |
| **Sistema**             | Cuando se recibe una notificación de Addi con `status: 'Abandoned'`, entonces NO se debe enviar el email de confirmación de compra. |
| **Sistema**             | Cuando se recibe una notificación de Addi con un estado de éxito (ej: `approved`), entonces el email de confirmación de compra SÍ se debe enviar correctamente. |
| **Desarrollador**       | Cuando se revisan los logs para una transacción "Abandoned", entonces no debe existir ningún registro del envío del correo de confirmación. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                         |
| :----------------------- | :----------------------------------------------------------- |
| **Backend**              | Identificar el controlador y método que maneja el webhook de Addi. La lógica debe ser modificada para añadir una condición que verifique el estado de la respuesta de Addi antes de encolar o enviar el `Mailable` de confirmación de compra. |
| **Frontend**             | N/A                                                          |
| **Bases de Datos**       | N/A                                                          |
| **APIs/Endpoints**       | La modificación se realizará en el endpoint existente que recibe las notificaciones de Addi. |
| **Lógica de Negocio**    | La regla de negocio es clara: si `payload.status === 'Abandoned'`, se debe abortar el flujo de notificación de compra exitosa. |
| **Seguridad/Validación** | N/A                                                          |

### Detalles de implementación

El núcleo de la tarea es añadir una guarda condicional en el manejador del webhook de Addi.

**Investigación previa:**
- **Proyecto:** `shopindero-containers/php-app`
- **Logs:** Analizar los logs de producción de `shopindero.com`.
- **Orden de referencia:** `shopindero_addi_cr419ee3cc-a1e5-4b35-bccc-fd1aafaaaca5`. Se debe buscar esta `orderID` en los logs para trazar el flujo exacto que resultó en el envío del correo.

**Ejemplo de lógica a implementar (conceptual):**

```php
// En el controlador que maneja el webhook de Addi

public function handleAddiWebhook(Request $request)
{
    $payload = $request->all();

    // ... lógica para encontrar la orden (AsyncTemporaryOrder) ...

    if ($payload['status'] === 'Abandoned') {
        // La transacción fue abandonada.
        // Posiblemente loggear este evento en un canal apropiado.
        // NO enviar el correo de confirmación.
        Log::channel('custom_debug')->info('Pago de Addi abandonado para la orden: ' . $order->id);
        return response()->json(['status' => 'ok', 'message' => 'Abandoned status handled']);
    }

    // ... resto de la lógica para pagos exitosos ...
    // Enviar correo de confirmación solo si el estado es de éxito.
}
```

### Pasos a seguir sugeridos

1.  **Investigación (Logs):** Acceder a los logs de producción de `shopindero.com` y buscar la `orderID` de ejemplo para entender el flujo actual.
2.  **Identificar Controlador:** Localizar el controlador y método responsable de procesar los webhooks de Addi en el proyecto `shopindero-containers/php-app`.
3.  **Implementar Fix:** Añadir la lógica condicional para verificar si el `status` es `Abandoned` y detener el envío del correo en ese caso.
4.  **Crear Pruebas:** Desarrollar una prueba automatizada (feature o unit test) que simule una petición de webhook de Addi con estado "Abandoned" y asegure que el `Mailable` de confirmación no se despacha.
5.  **Validación:** Probar el flujo en un entorno de staging para confirmar que el correo no se envía en casos de abandono y que SÍ se envía en casos de éxito.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

Esta lista resume los pasos esenciales para completar la tarea.

* - [ ] Análisis de logs de producción para la orden de ejemplo completado.
* - [ ] Controlador y método del webhook de Addi identificado en el código.
* - [ ] Lógica condicional para el estado "Abandoned" implementada correctamente.
* - [ ] Prueba automatizada creada que valide que el email no se envía en el caso "Abandoned".
* - [ ] Verificación de que el flujo de pago exitoso no se ve afectado y sigue enviando el correo.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 6 horas.

| Subtarea (FIX-Y501.x) | Estimado (Horas) | Objetivo Específico                                      |
| :-------------------- | :--------------- | :------------------------------------------------------- |
| **FIX-Y501.1**        | 2                | Investigación y análisis de logs de producción.          |
| **FIX-Y501.2**        | 2                | Implementación del fix en el controlador del webhook.    |
| **FIX-Y501.3**        | 2                | Creación de pruebas automatizadas y validación manual.   |
| **Total Estimado**    | **6 Horas**      |                                                          |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

* **Proyecto Afectado:** `shopindero-containers/php-app` (relativo al repositorio).
* **Orden de Ejemplo para Investigación:** `shopindero_addi_cr419ee3cc-a1e5-4b35-bccc-fd1aafaaaca5`.

***

## 7. Lista de chequeo de logros e hitos a alcanzar

Esta lista contiene los hitos técnicos para seguimiento del progreso de la tarea.

- [ ] El controlador del webhook de Addi ha sido identificado y modificado.
- [ ] Se ha añadido una condición que previene el envío de correo para el estado `Abandoned`.
- [ ] Se ha creado una prueba que simula el webhook de Addi con estado `Abandoned` y falla si se intenta enviar un correo.
- [ ] El flujo de pago exitoso ha sido probado y se confirma que no sufre regresiones.
- [ ] Los logs de la aplicación ahora reflejan correctamente el manejo de los pagos abandonados.
