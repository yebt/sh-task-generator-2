# FEAT-E304: Agregar capacidad de pago por Transferencia Bancaria

## 1. DATOS GENERALES

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **ID de la Tarea**       | FEAT-E304                                                    |
| **Letra identificadora** | E                                                            |
| **Nombre de la Tarea**   | Agregar capacidad de pago por Transferencia Bancaria         |
| **Categoría**            | Feat                                                         |
| **Dependencia Crítica**  | N/A                                                          |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **Objetivo de la Tarea** | Agregar la capacidad de pagar las reservas por medio de "transferencia bancaria", implementando la lógica necesaria para procesar y gestionar este tipo de pago. |
| **Justificación**        | Ofrecer "transferencia bancaria" como método de pago amplía las opciones para los clientes, lo que puede incrementar la tasa de conversión al incluir a usuarios que prefieren o solo pueden usar este método. |
| **Métricas de Éxito**    | - El 100% de las reservas pueden ser procesadas con el nuevo método de pago.<br>- El método "transferencia bancaria" aparece correctamente en el flujo de checkout.<br>- Las reservas pagadas por este medio se reflejan con un estado distintivo en el dashboard de administración. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Se requiere que el sistema de reservas permita a los clientes seleccionar "Transferencia Bancaria" como método de pago. Al seleccionarlo, el sistema debe presentar al usuario la información necesaria para realizar la transferencia (datos bancarios de la tienda). La reserva quedará en un estado "pendiente de pago" hasta que un administrador confirme manualmente la recepción de los fondos.

### Criterios de Aceptación (Condiciones Verificables)

| Rol                     | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :---------------------- | :----------------------------------------------------------- |
| **Cliente**             | Cuando estoy en el proceso de pago de una reserva, entonces puedo ver y seleccionar "Transferencia Bancaria" como una opción de pago. |
| **Cliente**             | Cuando selecciono "Transferencia Bancaria", entonces el sistema me muestra los datos de la cuenta bancaria para realizar el pago. |
| **Sistema**             | Cuando se finaliza una reserva con "Transferencia Bancaria", entonces la reserva se crea con un estado de "pendiente de pago" o similar. |
| **Administrador**       | Cuando reviso el listado de reservas en el dashboard, entonces puedo identificar fácilmente las que están pendientes de confirmación por transferencia y marcarlas como "pagadas". |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                         |
| :----------------------- | :----------------------------------------------------------- |
| **Backend**              | - Modificar el controlador de pagos para manejar un nuevo tipo: `bank_transfer`.<br>- La lógica no procesará un pago real, sino que cambiará el estado de la reserva a "pendiente de pago".<br>- Se necesita un nuevo endpoint o modificar uno existente para que el administrador pueda confirmar el pago manualmente. |
| **Frontend**             | - Actualizar el componente de checkout para mostrar la opción "Transferencia Bancaria".<br>- Crear un modal o una vista para mostrar la información de la cuenta bancaria de la tienda. |
| **Bases de Datos**       | - No se esperan cambios mayores. Podría ser necesario añadir un nuevo `enum` al estado de la reserva si no existe uno adecuado como "pendiente de pago". |
| **APIs/Endpoints**       | - El endpoint de creación de reserva/pago debe aceptar el nuevo método.<br>- Se requiere un endpoint `POST /dashboard/reservations/{id}/confirm-payment` para que el administrador confirme la transacción. |
| **Lógica de Negocio**    | - Una reserva con pago por transferencia no se considera confirmada hasta la aprobación manual.<br>- La información bancaria de la tienda debe ser configurable, probablemente en los ajustes de la tienda en el dashboard. |
| **Seguridad/Validación** | - El endpoint de confirmación de pago debe estar protegido y solo accesible para administradores de la tienda. |

### Detalles de implementación

El proyecto a intervenir es `shopindero-containers/php-app`. La tarea principal es integrar un flujo de pago "offline" dentro del sistema de reservas existente. Este tipo de reservas requieren un paso adicional de verificación, puesto que el pago de tipo transferencia bancaria no es aceptado hasta ser verificado manualmente.

**Flujo sugerido:**
1.  El cliente selecciona "Transferencia Bancaria".
2.  El frontend muestra los datos bancarios (que deben ser gestionables por el admin).
3.  El backend crea la reserva con estado `pending_payment`.
4.  El cliente realiza la transferencia por su cuenta.
5.  El administrador ve la reserva pendiente en el dashboard, verifica su cuenta bancaria y, si el pago fue recibido, usa un botón para confirmar el pago.
6.  Al confirmar, el estado de la reserva cambia a "confirmada" o "pagada".

### Pasos a seguir sugeridos

1.  **Backend:** Identificar el controlador de pagos (`app/Http/Controllers/Profile/Payment/BankController.php` puede ser un punto de partida) y añadir la lógica para el caso `bank_transfer`.
2.  **Backend:** Implementar el cambio de estado de la reserva.
3.  **Frontend:** Modificar la UI del checkout para añadir la nueva opción de pago.
4.  **Frontend:** Crear la vista o modal que muestra la información bancaria.
5.  **Backend/Frontend:** Implementar la sección en el dashboard para que el administrador gestione los datos de su cuenta bancaria.
6.  **Backend/Frontend:** Implementar el flujo de confirmación manual en el dashboard de reservas.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

* - [ ] Lógica del backend para manejar el método de pago `bank_transfer` implementada.
* - [ ] Frontend actualizado para mostrar la opción de "Transferencia Bancaria".
* - [ ] Vista con la información bancaria para el cliente finalizada.
* - [ ] Estado "pendiente de pago" correctamente asignado a las reservas.
* - [ ] Funcionalidad en el dashboard para que el administrador confirme el pago.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 2 días (16 horas).

| Subtarea (FEAT-E304.x) | Estimado (Horas) | Objetivo Específico                                      |
| :--------------------- | :--------------- | :------------------------------------------------------- |
| **FEAT-E304.1**        | 6                | Desarrollo del backend para la gestión del nuevo método de pago y estados. |
| **FEAT-E304.2**        | 6                | Desarrollo del frontend para el flujo del cliente (selección y visualización de datos). |
| **FEAT-E304.3**        | 4                | Implementación de la confirmación manual en el dashboard del administrador. |
| **Total Estimado**     | **16 Horas**     |                                                          |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

* **Proyecto afectado:** `shopindero-containers/php-app`

***

## 7. Lista de chequeo de logros e hitos a alcanzar

* - [ ] El método de pago "Transferencia Bancaria" es seleccionable en el checkout.
* - [ ] Al seleccionar el método, se muestran los datos bancarios correctos.
* - [ ] La reserva se crea con un estado que indica que el pago está pendiente.
* - [ ] El administrador puede ver las reservas pendientes en el dashboard.
* - [ ] El administrador puede marcar una reserva como pagada, cambiando su estado a confirmado.
* - [ ] El flujo de pago para otros métodos (tarjeta, etc.) no presenta regresiones.
