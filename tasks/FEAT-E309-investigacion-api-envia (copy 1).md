# FEAT-E309: Investigar Integración con API de Envíos de Envia.com

## 1. DATOS GENERALES

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **ID de la Tarea**       | FEAT-E309                                                    |
| **Letra identificadora** | E                                                            |
| **Nombre de la Tarea**   | Investigar y Documentar la Integración con la API de Envia.com |
| **Categoría**            | Feat                                                         |
| **Dependencia Crítica**  | N/A                                                          |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **Objetivo de la Tarea** | Analizar la documentación de la API de Envia.com y producir un documento técnico que detalle una estrategia de implementación factible para la plataforma Shopindero. |
| **Justificación**        | La integración con un proveedor de logística como Envia.com es un paso crucial para automatizar y escalar las operaciones de envío de las tiendas. Este análisis previo es necesario para entender la complejidad, estimar el esfuerzo real y garantizar que la futura implementación sea exitosa y se alinee con la arquitectura actual de la plataforma. |
| **Métricas de Éxito**    | - Se entrega un documento técnico que cubre los puntos clave de la integración (autenticación, cotización, generación de guías, tracking).<br>- El documento es lo suficientemente claro para que un desarrollador pueda estimar el tiempo de implementación de la integración completa. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Esta tarea no implica desarrollo de código, sino investigación y documentación. El responsable deberá estudiar a fondo la documentación de la API de Envia.com (`https://docs.envia.com/`) para determinar cómo se integraría con la plataforma Shopindero.

El análisis debe enfocarse en los siguientes flujos clave:
1.  **Autenticación:** Cómo obtener y gestionar las credenciales de la API.
2.  **Cotización de Envíos:** Cómo solicitar tarifas de envío para un paquete, considerando origen, destino, dimensiones y peso.
3.  **Generación de Guías:** El proceso para crear un envío, generar la guía (etiqueta) y obtener el número de seguimiento.
4.  **Tracking de Envíos:** Cómo consultar el estado de un envío a lo largo de su ciclo de vida.
5.  **Manejo de Errores:** Identificar los posibles errores de la API y cómo deberían ser manejados.

El resultado final será un documento técnico en formato Markdown que resuma los hallazgos y proponga un plan de acción claro para la implementación.

### Criterios de Aceptación (Condiciones Verificables)

| Rol                     | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :---------------------- | :----------------------------------------------------------- |
| **Desarrollador**       | Cuando leo el documento final, entonces entiendo claramente cómo autenticarme contra la API de Envia.com. |
| **Desarrollador**       | Cuando leo el documento final, entonces conozco los endpoints y parámetros necesarios para cotizar un envío. |
| **Desarrollador**       | Cuando leo el documento final, entonces comprendo el flujo para generar una guía y obtener el PDF o la información para imprimirla. |
| **Líder Técnico**       | Cuando reviso el documento, entonces este contiene una propuesta de cómo se podría estructurar el código en Shopindero (ej: un nuevo `EnviaService`) para manejar la lógica de la integración. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                         |
| :----------------------- | :----------------------------------------------------------- |
| **Backend**              | El documento debe proponer cómo encapsular la lógica. Por ejemplo, la creación de un `EnviaService` que contenga métodos como `getRates()`, `createShipment()`, `getTrackingStatus()`. Se debe investigar si es mejor un `Facade` o un servicio inyectable. |
| **Frontend**             | El análisis debe considerar qué cambios serían necesarios en el futuro en el frontend, como mostrar una lista de opciones de envío cotizadas en el checkout o una sección de "seguir mi pedido" en el perfil del usuario. |
| **Bases de Datos**       | Investigar qué información de los envíos debería almacenarse en la base de datos local (ej: `shipments` table con `tracking_number`, `provider`, `status`, `label_url`). |
| **APIs/Endpoints**       | El documento debe listar los endpoints de la API de Envia.com más importantes para la integración y un ejemplo de sus `request` y `response`. |
| **Lógica de Negocio**    | El análisis debe proponer cómo mapear los datos de una orden de Shopindero a los requerimientos de la API de Envia (direcciones, detalles del paquete, etc.). |
| **Seguridad/Validación** | Investigar cómo se deben almacenar de forma segura las credenciales de la API de Envia (API Key/Token) dentro de la aplicación. |

### Detalles de implementación

El entregable principal es un documento técnico. Este documento debe ser claro, conciso y práctico, sirviendo como una guía directa para la futura tarea de implementación.

**Estructura sugerida para el documento:**
1.  **Resumen de la API de Envia.com:** Breve descripción de sus capacidades.
2.  **Autenticación:** Mecanismo, manejo de tokens.
3.  **Flujo de Cotización:** Endpoints, parámetros requeridos, ejemplo de respuesta.
4.  **Flujo de Generación de Guía:** Endpoints, parámetros, manejo de la etiqueta de envío.
5.  **Flujo de Tracking:** Endpoints y cómo interpretar los estados.
6.  **Propuesta de Implementación en Shopindero:**
    -   Nuevos Servicios/Facades.
    -   Modificaciones a modelos y base de datos.
    -   Estrategia para el manejo de credenciales.
    -   Consideraciones para el frontend.
7.  **Conclusiones y Recomendaciones.**

### Pasos a seguir sugeridos

1.  Leer detenidamente la documentación oficial de la API de Envia.com.
2.  Utilizar una herramienta como Postman o Insomnia para realizar peticiones de prueba a los endpoints (si la API ofrece un entorno de sandbox o claves de prueba).
3.  Estructurar el documento técnico siguiendo el esquema propuesto.
4.  Redactar cada sección del documento, incluyendo ejemplos de código o de JSON de las peticiones/respuestas.
5.  Proponer una arquitectura de software para la integración dentro del proyecto Laravel.
6.  Revisar y refinar el documento para asegurar su claridad y completitud.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

* - [ ] Análisis de la documentación de autenticación completado.
* - [ ] Análisis de los endpoints de cotización y generación de guías completado.
* - [ ] Análisis del endpoint de tracking completado.
* - [ ] Borrador del documento técnico con la estructura propuesta.
* - [ ] Propuesta de arquitectura para la integración en Laravel definida.
* - [ ] Documento final revisado y listo para entregar.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 1 día laboral (8 horas).

| Subtarea (FEAT-E309.x) | Estimado (Horas) | Objetivo Específico                                      |
| :----------------------- | :--------------- | :------------------------------------------------------- |
| **FEAT-E309.1**          | 3                | Lectura de la documentación y pruebas iniciales de la API. |
| **FEAT-E309.2**          | 4                | Redacción del documento técnico y propuesta de arquitectura. |
| **FEAT-E309.3**          | 1                | Revisión y ajustes finales del documento.                |
| **Total Estimado**       | **8 Horas**      |                                                          |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

* **Documentación Oficial:** [https://docs.envia.com/](https://docs.envia.com/)

***

## 7. Lista de chequeo de logros e hitos a alcanzar 

* - [ ] El documento explica el método de autenticación con la API de Envia.com.
* - [ ] El documento lista y explica los endpoints clave para cotizar, generar y rastrear envíos.
* - [ ] El documento incluye una propuesta de qué datos guardar en la base de datos de Shopindero.
* - [ ] El documento propone una estructura de servicios (`EnviaService`) para organizar el código.
* - [ ] El documento es entregado en formato Markdown.