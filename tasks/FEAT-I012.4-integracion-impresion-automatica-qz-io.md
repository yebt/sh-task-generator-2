# FEAT-I012.4: Integración de Impresión Automática de Comandas con QZ.io

## 1. DATOS GENERALES

| Atributo | Valor (Completar) |
| :--- | :--- |
| **ID de la Tarea** | FEAT-I012.4 |
| **Letra identificadora** | I |
| **Nombre de la Tarea** | Integración de Impresión Automática de Comandas con QZ.io |
| **Categoría** | Feat |
| **Dependencia Crítica** | FEAT-I012.3 |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo | Valor (Completar) |
| :--- | :--- |
| **Objetivo de la Tarea** | Implementar un sistema de impresión automática para las nuevas comandas (`food_bill_batch`) utilizando la librería QZ.io, permitiendo que los pedidos se impriman en la cocina o barra sin intervención manual. |
| **Justificación** | La impresión manual de comandas es un cuello de botella en entornos de alta demanda. La automatización de este proceso agiliza la preparación de pedidos, reduce errores humanos y mejora drásticamente la eficiencia del flujo de trabajo entre el salón y la cocina. |
| **Métricas de Éxito** | - El 99% de las nuevas comandas se imprimen automáticamente en la impresora configurada en menos de 10 segundos desde su creación.<br>- El sistema detecta correctamente si QZ Tray está activo en el equipo cliente.<br>- La configuración de impresoras por categoría de producto funciona según lo especificado. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Esta tarea se centra en integrar la solución de impresión [QZ Tray](https://qz.io/) en el dashboard del administrador para que las comandas se impriman automáticamente a medida que llegan.

1.  **Detección y Configuración de QZ.io:**
    *   El dashboard (`/dashboard/food-orders`) debe detectar si el software QZ Tray está instalado y en ejecución en la máquina del cliente.
    *   Se debe crear una nueva sección de configuración (puede ser un modal o una página aparte) donde el administrador pueda:
        *   Ver una lista de las impresoras detectadas por QZ.io.
        *   Asignar impresoras a diferentes categorías de productos. Por ejemplo, la categoría "Bebidas" se imprime en la "EPSON-BARRA", mientras que "Platos Fuertes" se imprime en la "BIXOLON-COCINA".
    *   Esta configuración debe guardarse (preferiblemente en `localStorage` o en el perfil del usuario en la base deatos) para persistir entre sesiones.

2.  **Impresión Automática:**
    *   Una vez que el sistema de fetching (definido en `FEAT-I012.3`) detecta un nuevo `food_bill_batch`, en lugar de solo mostrarlo en la pantalla, debe disparar una solicitud de impresión a través de QZ.io.
    *   La lógica de impresión debe consultar la configuración guardada para determinar a qué impresora enviar la comanda, basándose en las categorías de los productos que contiene.
    *   Si un lote contiene productos de múltiples categorías con diferentes impresoras asignadas, se deben generar trabajos de impresión separados para cada impresora correspondiente.

### Criterios de Aceptación (Condiciones Verificables)

| Rol | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :--- | :--- |
| Administrador | Cuando abro el dashboard de órdenes, entonces el sistema me notifica si QZ Tray está conectado o no. |
| Administrador | Cuando accedo a la configuración de impresión, entonces puedo ver una lista de mis impresoras y asignar la categoría "Jugos" a la impresora "EPSON-TM-T20". |
| Sistema | Cuando llega una nueva comanda con un producto de la categoría "Jugos", entonces se envía un trabajo de impresión automáticamente a la impresora "EPSON-TM-T20". |
| Sistema | Si una comanda contiene una pizza ("Cocina") y una gaseosa ("Barra"), entonces se envían dos trabajos de impresión a las impresoras configuradas para cada categoría respectivamente. |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área | Detalle de la Implementación Técnica |
| :--- | :--- |
| **Backend** | - El backend principalmente servirá el HTML/JS necesario. La lógica de impresión es del lado del cliente.<br>- Podría ser necesario un endpoint para obtener las categorías de productos de la tienda. |
| **Frontend** | - Integrar el cliente Javascript de QZ.io en la vista `food-orders.blade.php`.<br>- Implementar la lógica de conexión y detección de QZ Tray.<br>- Desarrollar la UI para la configuración de impresoras (listar impresoras, listar categorías, guardar mapeo).<br>- Modificar la función `fetchNewOrders` para que, al recibir nuevos lotes, itere sobre ellos, determine la impresora correcta según el contenido y envíe los datos a QZ.io para la impresión. |
| **Bases de Datos** | - Considerar si la configuración de impresoras por categoría debe guardarse en la base de datos (más robusto) o en `localStorage` (más simple). Se recomienda en BD, en una tabla como `user_printer_configurations`. |
| **APIs/Endpoints** | - `qz.websocket.connect()`: Conexión al cliente QZ Tray.<br>- `qz.printers.find()`: Para obtener la lista de impresoras.<br>- `qz.print()`: Para enviar el trabajo de impresión. |
| **Lógica de Negocio** | - La lógica de mapeo de `producto -> categoría -> impresora` es el núcleo de esta tarea.<br>- Se debe manejar el caso de que un producto no tenga categoría o una categoría no tenga impresora asignada (¿imprimir en una por defecto o no imprimir?). |
| **Seguridad/Validación** | - QZ.io requiere la firma de certificados para funcionar en producción. Para el desarrollo, se puede usar el modo de desarrollo sin firma, pero se debe dejar documentado el proceso para producción. |

### Pasos a seguir sugeridos

1.  Incluir la librería cliente de QZ.io en el proyecto.
2.  Implementar la lógica de conexión a QZ Tray en el Javascript del dashboard, mostrando el estado de la conexión en la UI.
3.  Crear la interfaz de configuración: un botón que abra un modal donde se listen las impresoras (`qz.printers.find()`) y las categorías de productos de la tienda.
4.  Implementar la lógica para guardar la asociación entre categorías e impresoras.
5.  Modificar el callback de `fetchNewOrders`. Cuando lleguen nuevos `food_bill_batch`, procesarlos:
    a. Agrupar los productos del lote por la impresora que les corresponde.
    b. Para cada impresora, construir el ticket (HTML, ZPL, ESC/P, etc.).
    c. Enviar cada ticket a la impresora correcta usando `qz.print()`.
6.  Documentar cómo firmar los applets de QZ.io para el despliegue en producción.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

- [ ] Librería de QZ.io integrada y conexión con QZ Tray establecida.
- [ ] Interfaz de configuración de impresoras por categoría creada y funcional.
- [ ] La configuración de impresoras se guarda y se carga correctamente.
- [ ] La lógica de impresión automática al recibir un nuevo `food_bill_batch` está implementada.
- [ ] El sistema puede enviar trabajos de impresión a diferentes impresoras según la categoría del producto.
- [ ] Documentación para la firma de certificados de QZ.io creada.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 3 días laborales / 24 horas.

| Subtarea (FEAT-I012.4.x) | Estimado (Horas) | Objetivo Específico |
| :--- | :--- | :--- |
| **FEAT-I012.4.1** | 6 | Integración inicial de QZ.io y detección de impresoras. |
| **FEAT-I012.4.2** | 8 | Desarrollo de la interfaz de configuración de impresoras por categoría. |
| **FEAT-I012.4.3** | 10 | Implementación de la lógica de impresión automática y enrutamiento por categoría. |
| **Total Estimado** | **24** | |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

* **Recursos:** [Documentación de QZ.io](https://qz.io/docs/)
* **Comentarios:** Usar el código de la tarea en la rama a crear para facilitar la impresión. La rama debería llamarse `feat/I012-qz-io-integration`.

***

## 7. Lista de chequeo de logros e hitos a alcanzar

- [ ] El dashboard muestra un indicador visual del estado de conexión de QZ Tray.
- [ ] El modal de configuración lista correctamente las impresoras disponibles en el sistema.
- [ ] Se pueden asignar categorías de productos a impresoras y guardar la configuración.
- [ ] Al llegar una nueva comanda, se dispara una llamada a `qz.print()`.
- [ ] Si una comanda tiene items de "cocina" y "barra", se generan dos trabajos de impresión distintos.
- [ ] La impresión se realiza en segundo plano sin bloquear la interfaz de usuario.
