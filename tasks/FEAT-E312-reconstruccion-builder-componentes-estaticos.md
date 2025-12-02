# FEAT-E312: Reconstrucción de Builder para Componentes Estáticos (Landing de Producto Único)

## 1. DATOS GENERALES

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **ID de la Tarea**       | FEAT-E312                                                    |
| **Letra identificadora** | E                                                            |
| **Nombre de la Tarea**   | Reconstrucción de Builder para Componentes Estáticos (Landing de Producto Único) |
| **Categoría**            | FEAT                                                         |
| **Dependencia Crítica**  | N/A                                                          |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **Objetivo de la Tarea** | Realizar una reconstrucción del constructor visual para componentes estáticos, específicamente para cambiar el modo en que se trabajan actualmente las landing pages de un solo producto, y agregarlo a la nueva dashboard. |
| **Justificación**        | La implementación de un constructor visual permitirá una gestión más flexible y dinámica de las landing pages de producto único, mejorando la autonomía en la creación y edición de contenido sin necesidad de intervención de desarrollo para cambios menores. Esto agiliza el proceso de marketing y actualización de productos. |
| **Métricas de Éxito**    | - El 100% de los elementos disponibles en el panel de componentes pueden ser arrastrados y soltados en el área del "Builder".<br>- Los cambios realizados en el "Builder" se reflejan en tiempo real en el "Live Preview" con una latencia inferior a 500ms.<br>- La nueva vista del constructor se carga sin elementos de navegación (navbar, footer, sidebar). |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

El trabajo consiste en la reconstrucción de un builder visual para componentes estáticos, diseñado para modificar la forma actual de gestionar las landing pages de un solo producto. La idea es integrar este builder en la nueva dashboard, proporcionando una vista especial que prescinde de elementos de navegación estándar como la navbar, el footer y el sidebar, e incluye un botón de "ir atrás" que temporalmente redirige a la dashboard principal.

La interfaz del constructor visual se divide en tres áreas principales:

1.  **Panel izquierdo: “Components”**
    Este panel contiene una lista de elementos que el usuario puede arrastrar y soltar al área central del constructor. Los componentes disponibles incluyen:
    *   Title
    *   Paragraph
    *   Imagen
    *   Video
    *   Link
    *   Button
    *   Section
    También se incluye un selector de paleta de colores con varias muestras, permitiendo la personalización visual de los componentes.

2.  **Panel central: “Builder”**
    Esta es la zona principal donde el usuario organiza los bloques que ha agregado. Cada bloque arrastrado se representa visualmente dentro de un contenedor resaltado en naranja, mostrando información relevante como el tipo de componente (por ejemplo, TITLE), su contenido y sus propiedades. La estructura inicial muestra un bloque de encabezado ("HEADING") y dos contenedores vacíos adicionales, listos para recibir contenido. Cada bloque arrastrado genera un elemento propio en la vista previa, y sus propiedades se adaptan dinámicamente según el tipo de bloque.

3.  **Panel derecho: “Live Preview”**
    Este panel muestra una vista previa en tiempo real del resultado final de la página que se está construyendo. Refleja visualmente todos los cambios realizados en el "Builder" con un área sombreada que simula cómo se verá el contenido publicado.

La interfaz combina de forma interactiva la capacidad de arrastrar componentes, editar sus propiedades y visualizar los resultados instantáneamente, funcionando como un editor modular para construir páginas o secciones de contenido de manera intuitiva. Este builder se integrará y operará sobre la estructura base de `dashboard_lightweight/base`.

### Criterios de Aceptación (Condiciones Verificables)

| Rol                     | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :---------------------- | :----------------------------------------------------------- |
| **Usuario (Editor)**    | Cuando accedo a la vista del constructor visual, entonces no veo la navbar, el footer ni el sidebar, y hay un botón "ir atrás". |
| **Usuario (Editor)**    | Cuando arrastro un componente del panel "Components" al panel "Builder", entonces el componente se añade correctamente y se visualiza en el panel "Live Preview". |
| **Usuario (Editor)**    | Cuando selecciono un bloque en el panel "Builder" y edito sus propiedades (ej. texto de un Title, URL de una Imagen), entonces los cambios se reflejan inmediatamente en el panel "Live Preview". |
| **Sistema**             | Cuando un bloque de tipo "Section" es arrastrado al "Builder", entonces permite anidar otros componentes dentro de él. |
| **Sistema**             | Cuando utilizo el selector de paleta de colores, entonces los componentes visuales en el "Builder" y "Live Preview" adoptan el color seleccionado. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                         |
| :----------------------- | :----------------------------------------------------------- |
| **Backend**              | - Se necesitarán endpoints para guardar la estructura de la landing page generada por el builder (posiblemente como un JSON o HTML en la base de datos).<br>- Endpoints para cargar la estructura existente de una landing page para su edición.<br>- Considerar la serialización/deserialización de los componentes y sus propiedades. |
| **Frontend**             | - Desarrollo de una nueva vista para el builder en `dashboard_lightweight/base` (o un path similar).<br>- Implementación de la funcionalidad de "drag and drop" para los componentes del panel izquierdo al panel central.<br>- Creación de componentes Vue/React/Blade (según el stack existente) para cada tipo de elemento arrastrable (Title, Paragraph, Image, etc.).<br>- Desarrollo de un sistema de edición de propiedades para cada tipo de componente seleccionado.<br>- Implementación de la visualización en tiempo real en el panel "Live Preview".<br>- Manejo del estado del constructor (qué componentes están en el builder, sus propiedades, etc.). |
| **Bases de Datos**       | - Se podría requerir una tabla `landing_pages` o similar para almacenar la estructura de los componentes y sus datos. Un campo de tipo `JSON` o `TEXT` sería adecuado para guardar la configuración del builder.<br>- Relación con el producto al que pertenece la landing page. |
| **APIs/Endpoints**       | - `GET /dashboard/landing-pages/{id}/builder-data`: Para obtener la configuración de una landing page.<br>- `POST /dashboard/landing-pages/{id}/save-builder-data`: Para guardar la configuración de una landing page.<br>- `GET /dashboard/landing-pages/{id}/preview`: Para obtener una vista previa renderizada, o simplemente que el frontend construya la preview. |
| **Lógica de Negocio**    | - Los tipos de componentes disponibles y sus propiedades editables.<br>- La lógica de arrastrar y soltar debe permitir reordenar y anidar componentes (especialmente "Section").<br>- Persistencia de la configuración del constructor en la base de datos. |
| **Seguridad/Validación** | - Asegurar que solo usuarios autorizados (administradores de tienda) puedan acceder al builder y guardar configuraciones.<br>- Validación de los datos de entrada al guardar la configuración del builder para prevenir inyecciones o datos malformados. |

### Detalles de implementación

El proyecto a usar se basa en 'shopindero-laravel-monolito'. El builder deberá integrarse en la estructura de `dashboard_lightweight/base`.

**Estructura del Builder (Conceptual):**

```
+-------------------------------------------------------------------------------------------------+
|                                                                                                 |
| [ Botón Volver a Dashboard ]                                                                    |
|                                                                                                 |
+-------------------------------------------------------------------------------------------------+
|                                                                                                 |
|   +-------------------+  +---------------------------------------+  +-------------------------+
|   |   Components      |  |           Builder                     |  |   Live Preview          |
|   |                   |  |                                       |  |                         |
|   | - Title           |  | +-----------------------------------+ |  | +---------------------+ |
|   | - Paragraph       |  | |   HEADING (configurable)          | |  | |                     | |
|   | - Imagen          |  | +-----------------------------------+ |  | | (Renderizado en     | |
|   | - Video           |  |                                       | |  | | tiempo real)        | |
|   | - Link            |  | +-----------------------------------+ |  | |                     | |
|   | - Button          |  | |   Contenedor vacío 1              | |  | +---------------------+ |
|   | - Section         |  | +-----------------------------------+ |  |                         |
|   |                   |  |                                       | |  | +---------------------+ |
|   | [Color Palette]   |  | +-----------------------------------+ |  | |                     | |
|   |                   |  | |   Contenedor vacío 2              | |  | |                     | |
|   +-------------------+  | +-----------------------------------+ |  | +---------------------+ |
|                          |                                       | |  |                         |
|                          +---------------------------------------+  +-------------------------+
|                                                                                                 |
+-------------------------------------------------------------------------------------------------+
```

**Manejo de Propiedades de Componentes:**
Cada componente arrastrado en el "Builder" tendrá un panel de propiedades contextual que se activa al seleccionarlo. Por ejemplo:
*   **Title/Paragraph:** Texto, tamaño de fuente, color, alineación.
*   **Imagen:** URL de la imagen, `alt text`, ancho, alto.
*   **Link/Button:** Texto, URL de destino, color.
*   **Section:** Fondo (color/imagen), padding, margen.

### Pasos a seguir sugeridos

1.  **Diseño de Datos (Backend):** Definir el esquema JSON para almacenar la estructura de los componentes de la landing page.
2.  **Desarrollo de Endpoints (Backend):** Crear o modificar los endpoints para guardar y cargar las configuraciones de las landing pages.
3.  **Estructura de la Vista (Frontend):** Crear la nueva vista en `dashboard_lightweight/base` que albergará los tres paneles del builder. Asegurarse de que no cargue los elementos de navegación estándar.
4.  **Implementación del Panel "Components" (Frontend):**
    *   Listar los componentes arrastrables (Title, Paragraph, etc.).
    *   Integrar un selector de paleta de colores.
5.  **Implementación del Panel "Builder" (Frontend):**
    *   Desarrollar la funcionalidad de drag and drop para recibir componentes.
    *   Renderizar dinámicamente los componentes arrastrados, incluyendo sus contenedores resaltados.
    *   Implementar la lógica para seleccionar un componente y mostrar su panel de propiedades.
    *   Manejar la reordenación y anidamiento de componentes.
6.  **Implementación del Panel "Live Preview" (Frontend):**
    *   Crear la lógica para renderizar los componentes del "Builder" en tiempo real, de manera fiel a cómo se verán en la página final.
7.  **Desarrollo del Editor de Propiedades (Frontend):**
    *   Crear un componente de edición de propiedades genérico o específico para cada tipo de bloque.
8.  **Integración de Datos (Frontend/Backend):** Conectar el frontend con los endpoints del backend para guardar y cargar la configuración de la landing page.
9.  **Pruebas:** Realizar pruebas exhaustivas de la funcionalidad de arrastrar y soltar, edición de propiedades, vista previa en tiempo real y persistencia de datos.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

*   - [ ] Definición del esquema JSON para la estructura de la landing page.
*   - [ ] Implementación de endpoints de guardado y carga de configuraciones.
*   - [ ] Creación de la vista del constructor (sin navbar, footer, sidebar) en la dashboard.
*   - [ ] Funcionalidad de Drag and Drop del panel de componentes al panel Builder.
*   - [ ] Renderizado dinámico de componentes en el panel "Builder" y "Live Preview".
*   - [ ] Editor de propiedades para los tipos de componentes implementado.
*   - [ ] Persistencia de la estructura de la landing page en la base de datos verificada.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 5 días laborales (40 horas).

| Subtarea (FEAT-E312.x) | Estimado (Horas) | Objetivo Específico                                      |
| :------------------------ | :------------------ | :------------------------------------------------------- |
| **FEAT-E312.1**          | 4                   | Diseño del esquema de datos y desarrollo de endpoints de guardado/carga. |
| **FEAT-E312.2**          | 8                   | Creación de la estructura de la vista del builder y paneles. |
| **FEAT-E312.3**          | 12                  | Implementación de la lógica de Drag and Drop y renderizado dinámico de componentes. |
| **FEAT-E312.4**          | 8                   | Desarrollo del editor de propiedades contextual y el selector de colores. |
| **FEAT-E312.5**          | 8                   | Implementación del "Live Preview", integración final y pruebas. |
| **Total Estimado**        | **40 Horas**        |                                                          |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

*   **Proyecto Afectado:** El builder trabajará sobre la base `dashboard_lightweight/base`.

***

## 7. Lista de chequeo de logros e hitos a alcanzar 

*   - [ ] La nueva vista del constructor se accede desde la dashboard y no muestra elementos de navegación principales.
*   - [ ] Todos los tipos de componentes listados (Title, Paragraph, Imagen, Video, Link, Button, Section) son arrastrables.
*   - [ ] Los componentes arrastrados se añaden al "Builder" y se pueden seleccionar.
*   - [ ] Al seleccionar un componente en el "Builder", se muestra una interfaz para editar sus propiedades.
*   - [ ] Los cambios en las propiedades de un componente se reflejan de inmediato en el "Live Preview".
*   - [ ] El selector de paleta de colores permite cambiar el color de los componentes visuales.
*   - [ ] El estado del builder (componentes en el lienzo, sus propiedades) se puede guardar y cargar correctamente.
*   - [ ] Los componentes de "Section" permiten arrastrar y anidar otros componentes dentro de ellos.
*   - [ ] Se puede navegar de vuelta a la dashboard principal desde el constructor.
