# FIX-E301: Corrección de imagen default en el selector de paquetes adicionales de self booking

## 1. DATOS GENERALES

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **ID de la Tarea**       | FIX-E301                                                     |
| **Letra identificadora** | E                                                            |
| **Nombre de la Tarea**   | Corrección de imagen default en el selector de paquetes adicionales de self booking |
| **Categoría**            | FIX                                                          |
| **Dependencia Crítica**  | N/A                                                          |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **Objetivo de la Tarea** | Corregir la imagen que se muestra por defecto en el selector de paquetes adicionales del flujo de auto-reserva (self-booking), reemplazando el placeholder actual por el logo de la tienda. |
| **Justificación**        | Actualmente, cuando un paquete adicional no tiene una imagen asignada, se muestra una imagen genérica (placeholder). Esto afecta negativamente la presentación visual y la identidad de marca de la tienda. Usar el logo de la tienda como fallback mejora la coherencia visual y la experiencia del cliente. |
| **Métricas de Éxito**    | El 100% de los paquetes adicionales sin imagen propia muestran el logo de la tienda en el selector de self-booking. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Se debe ajustar el manejo de la imagen por defecto que sale en el selector de paquetes adicionales a incluir en la reserva por parte del cliente.

Durante el proceso de reserva de mesa por parte de un cliente (self-booking), al llegar al paso de seleccionar paquetes adicionales, el sistema debe verificar si cada paquete tiene una imagen personalizada. Si un paquete no tiene una imagen definida, el sistema deberá mostrar el logo de la tienda correspondiente como imagen por defecto.

- Actualmente, se visualiza una imagen placeholder por default.
- Se debe poner el logo de la tienda como imagen default para cuando no se carguen imágenes a los paquetes.

### Criterios de Aceptación (Condiciones Verificables)

| Rol                     | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :---------------------- | :----------------------------------------------------------- |
| **Cliente**             | Cuando selecciono paquetes adicionales para mi reserva y un paquete no tiene imagen, entonces veo el logo de la tienda en su lugar. |
| **Sistema/Frontend**    | Cuando un paquete adicional tiene su propia imagen, entonces se muestra esa imagen específica. |
| **Sistema/Frontend**    | Cuando un paquete adicional NO tiene su propia imagen, entonces el sistema obtiene y muestra la URL del logo de la tienda. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                         |
| :----------------------- | :----------------------------------------------------------- |
| **Backend**              | El endpoint que devuelve la lista de paquetes adicionales para el self-booking debe incluir la URL del logo de la tienda como un campo adicional en la respuesta, para que el frontend pueda usarlo como fallback. |
| **Frontend**             | En el componente del selector de paquetes, se debe implementar la lógica para mostrar la imagen del paquete, y si esta no existe, usar la URL del logo de la tienda provista por el backend. |
| **Bases de Datos**       | N/A                                                          |
| **APIs/Endpoints**       | Modificar el endpoint existente que lista los paquetes adicionales para incluir la URL del logo de la tienda. |
| **Lógica de Negocio**    | La lógica de fallback es simple: si 'package.image_url' es nula o vacía, usar 'store.logo_url'. |
| **Seguridad/Validación** | N/A                                                          |

### Detalles de implementación

La tarea consiste en ajustar el manejo de la imagen por defecto en el selector de paquetes adicionales del sistema de auto-reserva de mesas. Actualmente, se muestra una imagen placeholder genérica cuando un paquete no tiene una imagen específica cargada. El requisito es cambiar este comportamiento para que, en ausencia de una imagen de paquete, se muestre el logo de la tienda. Esto mejora la consistencia de la marca y la experiencia visual del cliente final.

### Pasos a seguir sugeridos

1.  Identificar el controlador y el método del backend que provee los paquetes adicionales al flujo de self-booking.
2.  Modificar la consulta o el Resource de la API para que, además de los datos de los paquetes, se incluya la URL del logo de la tienda en la respuesta.
3.  En el frontend, localizar el componente (Vue/Blade/React) que renderiza el selector de paquetes.
4.  Ajustar la lógica de renderizado de la imagen para que verifique la existencia de la imagen del paquete. Si no existe, debe utilizar la URL del logo de la tienda obtenida de la API.
5.  Realizar pruebas para ambos casos: paquetes con imagen propia y paquetes sin imagen.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

* - [ ] Backend modificado para enviar la URL del logo de la tienda.
* - [ ] Frontend modificado para usar la URL del logo como fallback.
* - [ ] Verificación de que los paquetes con imagen propia no se ven afectados.
* - [ ] Verificación de que los paquetes sin imagen muestran el logo de la tienda.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 4 horas.

| Subtarea (FIX-E301.x) | Estimado (Horas) | Objetivo Específico             |
| :-------------------- | :--------------- | :------------------------------ |
| **FIX-E301.1**        | 2                | Modificación del backend y API. |
| **FIX-E301.2**        | 2                | Ajuste del frontend y pruebas.  |
| **Total Estimado**    | **4 Horas**      |                                 |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

N/A

***

## 7. Lista de chequeo de logros e hitos a alcanzar

* - [ ] El endpoint de paquetes adicionales devuelve la URL del logo de la tienda.
* - [ ] El componente del selector de paquetes implementa la lógica de fallback.
* - [ ] La imagen del logo se muestra correctamente para paquetes sin imagen.
* - [ ] La imagen específica del paquete se muestra correctamente cuando está definida.
