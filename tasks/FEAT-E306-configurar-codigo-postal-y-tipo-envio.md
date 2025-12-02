# FEAT-E305: Implementar Configuración de Código Postal en Checkout y Valor por Defecto de Tipo de Envío

## 1. DATOS GENERALES

| Atributo                 | Valor                                                        |
| :----------------------- | :----------------------------------------------------------- |
| **ID de la Tarea**       | FEAT-E305                                                    |
| **Letra identificadora** | E                                                            |
| **Nombre de la Tarea**   | Implementar Configuración de Código Postal en Checkout y Valor por Defecto de Tipo de Envío |
| **Categoría**            | FEAT                                                         |
| **Dependencia Crítica**  | N/A                                                          |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor                                                        |
| :----------------------- | :----------------------------------------------------------- |
| **Objetivo de la Tarea** | Permitir a los administradores de tienda configurar la visibilidad del campo de código postal en el checkout y establecer un valor por defecto para el tipo de envío al registrar nuevos usuarios. |
| **Justificación**        | Esta funcionalidad ofrece flexibilidad a los dueños de tiendas para adaptar el proceso de checkout a sus necesidades específicas, lo que puede simplificar la experiencia del usuario en ciertas regiones. Además, agiliza el registro de nuevos usuarios al preseleccionar una opción de envío por defecto, mejorando la coherencia y la experiencia inicial del cliente. |
| **Métricas de Éxito**    | - La visibilidad del campo de código postal en el checkout se puede alternar desde el dashboard del administrador y se refleja correctamente en el frontend.<br>- Las nuevas cuentas de usuario registradas tienen automáticamente "My envio" como su tipo de envío por defecto. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Se requiere implementar dos funcionalidades clave:

1.  **Configuración de Visibilidad de Código Postal**: Se añadirá una opción en el dashboard del administrador, específicamente bajo la ruta `Configuración > General > apartado Envíos`, para habilitar o deshabilitar la visualización del campo de código postal en el checkout. Por defecto, esta opción estará habilitada. Si se deshabilita desde el panel de administración, el campo de código postal no se mostrará a los clientes durante el proceso de compra.

2.  **Valor por Defecto del Tipo de Envío**: Al registrarse un nuevo usuario en la plataforma, el tipo de envío preseleccionado por defecto en su perfil deberá ser "My envio". Esta asignación se realizará en el backend durante la creación de la cuenta de usuario.

### Criterios de Aceptación (Condiciones Verificables)

| Rol                     | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :---------------------- | :----------------------------------------------------------- |
| **Dueño de Tienda**     | Cuando accedo a `Configuración > General > apartado Envíos` en el dashboard, entonces puedo ver una opción para habilitar/deshabilitar el campo de código postal en el checkout. |
| **Cliente**             | Cuando la opción de código postal está deshabilitada en el dashboard por el administrador, entonces el campo de código postal NO es visible en el checkout. |
| **Cliente**             | Cuando la opción de código postal está habilitada en el dashboard por el administrador, entonces el campo de código postal SÍ es visible en el checkout. |
| **Sistema/Usuario**     | Cuando un nuevo usuario se registra en la plataforma, entonces su tipo de envío por defecto se establece automáticamente como "My envio". |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                         |
| :----------------------- | :----------------------------------------------------------- |
| **Backend**              | - **Configuración de Código Postal**: Añadir un campo de configuración en el modelo o tabla que gestione los ajustes de la tienda (ej. `store_settings` o `general_configs`) para `postal_code_enabled` (tipo boolean, con valor por defecto `true`). El controlador que gestiona la actualización de la configuración del dashboard debe ser modificado para manejar este nuevo campo.<br>- **Tipo de Envío por Defecto**: Modificar el proceso de registro de usuarios (generalmente un `RegisterController` o un servicio de `Auth`) para asignar el valor `"My envio"` al campo `default_shipping_type` (o un campo equivalente) en el registro del nuevo usuario. |
| **Frontend**             | - **Configuración de Código Postal**: En la vista del dashboard correspondiente a `Configuración > General > apartado Envíos`, añadir un control de interfaz (como un switch o checkbox) para `Habilitar/Deshabilitar Código Postal en Checkout`. En la interfaz de usuario del checkout, implementar una lógica condicional para mostrar u ocultar el campo de código postal basándose en el valor de configuración recuperado del backend. |
| **Bases de Datos**       | - **Configuración de Código Postal**: Crear una nueva migración si es necesario, para añadir una columna `postal_code_enabled` de tipo booleano con un valor por defecto `true` a la tabla que almacena la configuración general de la tienda.<br>- **Tipo de Envío por Defecto**: Asegurarse de que el modelo de usuario (`User` u equivalente) contenga un campo (`default_shipping_type`) de tipo cadena (`string`) que pueda almacenar el valor "My envio". |
| **APIs/Endpoints**       | - **Configuración de Código Postal**: El endpoint existente para actualizar la configuración general del dashboard (ej. `PUT /api/dashboard/settings/general`) debe ser modificado para aceptar y procesar el nuevo parámetro `postal_code_enabled`. El endpoint que proporciona los datos para el checkout (ej. `GET /api/checkout/config`) debe incluir el estado de `postal_code_enabled` en su respuesta. |
| **Lógica de Negocio**    | - La configuración `postal_code_enabled` debe ser `true` por defecto.<br>- El valor "My envio" debe ser el tipo de envío preestablecido para cualquier nuevo usuario que se registre en la plataforma. |
| **Seguridad/Validación** | - La opción de configuración en el dashboard debe estar protegida y ser accesible únicamente por usuarios con permisos de administración de tienda.<br>- Se debe implementar validación para asegurar que el valor recibido para `postal_code_enabled` sea un booleano válido. |

### Detalles de implementación

#### Configuración de Visibilidad de Código Postal

La implementación del toggle para el código postal implica:
1.  **Backend**: Un campo booleano (`postal_code_enabled`) en la tabla de configuración de la tienda. Los controladores de configuración gestionarán su valor.
2.  **Frontend**: Un control visual en el dashboard para cambiar este valor y lógica en el componente del checkout para ocultar o mostrar el campo `postal_code` basándose en el valor de `postal_code_enabled` obtenido de la API.

#### Valor por Defecto del Tipo de Envío

La implementación del tipo de envío por defecto "My envio" para nuevos usuarios implica:
1.  **Backend**: Una modificación en el servicio o controlador encargado del registro de usuarios para que, al crear un nuevo registro, el campo `default_shipping_type` del usuario se inicialice con el valor "My envio".

### Pasos a seguir sugeridos

1.  **Backend (Configuración Código Postal)**:
    *   Crear una migración para añadir el campo `postal_code_enabled` a la tabla de configuración de la tienda, con un valor por defecto `true`.
    *   Modificar el controlador de configuración del dashboard para permitir la actualización de este campo desde la interfaz.
2.  **Frontend (Configuración Código Postal)**:
    *   Añadir un control de interfaz (checkbox o switch) en la vista del dashboard, específicamente en `Configuración > General > apartado Envíos`, para gestionar `postal_code_enabled`.
    *   Implementar la lógica condicional en el componente del checkout para leer esta configuración y mostrar u ocultar el campo de código postal dinámicamente.
3.  **Backend (Tipo de Envío por Defecto)**:
    *   Identificar y modificar el controlador o servicio responsable del registro de nuevos usuarios en la aplicación.
    *   Implementar la lógica de creación de usuario para asignar automáticamente `default_shipping_type = "My envio"` al nuevo registro.
4.  **Pruebas**:
    *   Realizar pruebas exhaustivas para verificar que la activación y desactivación del campo de código postal funciona correctamente en el checkout.
    *   Registrar un nuevo usuario y confirmar que su tipo de envío por defecto se ha establecido correctamente como "My envio".
    *   Verificar que ninguna funcionalidad existente del checkout o del registro de usuarios ha sido afectada.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

*   - [ ] Campo `postal_code_enabled` añadido a la base de datos de configuración de la tienda, con valor por defecto `true`.
*   - [ ] Control de interfaz en el dashboard para gestionar `postal_code_enabled` implementado.
*   - [ ] Lógica en el frontend del checkout para mostrar/ocultar el campo de código postal según la configuración implementada.
*   - [ ] Lógica en el backend para establecer "My envio" como tipo de envío por defecto para nuevos usuarios implementada.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 1 día laboral (8 horas).

| Subtarea (FEAT-E305.x) | Estimado (Horas) | Objetivo Específico                                      |
| :--------------------- | :--------------- | :------------------------------------------------------- |
| **FEAT-E305.1**        | 3                | Implementación de la configuración de visibilidad del código postal (backend y frontend del dashboard). |
| **FEAT-E305.2**        | 3                | Implementación de la lógica de mostrar/ocultar el campo de código postal en el checkout. |
| **FEAT-E305.3**        | 2                | Modificación del proceso de registro de usuarios para el tipo de envío por defecto. |
| **Total Estimado**     | **8 Horas**      |                                                          |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

N/A

***

## 7. Lista de chequeo de logros e hitos a alcanzar

*   - [ ] El campo `postal_code_enabled` existe en la base de datos y su valor por defecto es `true`.
*   - [ ] Los administradores de tienda pueden alternar la visibilidad del campo de código postal desde el dashboard en `Configuración > General > apartado Envíos`.
*   - [ ] El campo de código postal en el checkout se muestra u oculta correctamente según la configuración activa en el dashboard.
*   - [ ] Los nuevos usuarios registrados tienen "My envio" como su tipo de envío por defecto, sin intervención manual.
*   - [ ] La funcionalidad existente del checkout y el proceso de registro de usuarios no presentan regresiones o efectos secundarios indeseados.