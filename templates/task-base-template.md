# <CATEGORY\>-<ID OF \> [(optional context)]: <Name of the task\>



## 1. DATOS GENERALES

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **ID de la Tarea**       | [ID ÚNICO, Ej: FEAT-019, TECH-007, EPIC-002]                 |
| **Letra identificadora** | [I,L,M,N,etc; depende del frente de trabajo, normalmente se pasa la letra, de no pasarse junto a la tarea,  generar cualquiera dependiendo la acción] |
| **Nombre de la Tarea**   | [Título claro y conciso que describa la acción (Verbo + Objeto).] |
| **Categoría**            | [Ej: Feat, TECH, BUG, VIDEO]                                 |
| **Dependencia Crítica**  | [ID de la tarea que debe completarse primero. Si no aplica, dejar N/A.] |

***



## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **Objetivo de la Tarea** | [Describe el propósito central de la tarea en una o dos frases.] |
| **Justificación**        | [Explica por qué es importante esta tarea. ¿Qué valor aporta al usuario o al negocio?] |
| **Métricas de Éxito**    | [Define **criterios medibles** para saber si la tarea fue exitosa. (Ej: El 95% de los nuevos documentos creados en el último mes incluyen una fecha de vencimiento. El *endpoint* responde en < 200ms).] |

***



## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

[Explica la funcionalidad desde la perspectiva del usuario o el mecanismo técnico a implementar.]

### Criterios de Aceptación (Condiciones Verificables)

| Rol                     | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :---------------------- | :----------------------------------------------------------- |
| [Ej: Usuario de Tienda] | [Criterio 1.]                                                |
| [Ej: Sistema/DB]        | [Criterio 2.]                                                |
| [Ej: Seguridad/Lógica]  | [Criterio 3.]                                                |

***



## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                         |
| :----------------------- | :----------------------------------------------------------- |
| **Backend**              | [Controlador, *Service*, Modelo a crear/modificar. Especificar *middlewares*, validaciones, o *scopes*.] |
| **Frontend**             | [Componente, Vista, o script JS afectado. Estilos y arquitectura.] |
| **Bases de Datos**       | [Esquemas, Tablas, campos, relaciones a crear/modificar. Especificar tipo de columna, índices, *casting* de JSON.] |
| **APIs/Endpoints**       | [Rutas, métodos y parámetros exactos a desarrollar o modificar. Especificar autenticación.] |
| **Lógica de Negocio**    | [Reglas específicas a implementar.]                          |
| **Seguridad/Validación** | [Permisos de usuario, *middleware* de autorización, *hashing*, sanitización de datos.] |

### Detalles de implementación


Esta sección, también incluye, las descripciones a nivel de código, esquemas, estructuras, gráficos y diagramas necesarios para el entendimiento de la tarea. 

Todo ese contenido anexo a lo técnico y en base al código, como:

- Snippets de ejemplo (si aplica).
- Criterios de codificación (si aplica).
- Posibles problemáticas (si aplica).
- Patrones a aplicar (si aplica).
- Sugerencias de diseño arquitectónico (si aplica).



### Pasos a seguir sugeridos

Usando la redacción de la tarea, se debe sugerir un modo de proceder y atacar la tarea.



### Lista de Chequeo para Asignación (Hitos de Seguimiento)

Esta lista resume los pasos esenciales para completar la tarea.

* - [ ] [Hito técnico o funcional 1]
* - [ ] [Hito técnico o funcional 2]
* - [ ] [Hito técnico o funcional 3]

***



## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** [Indicar tiempo total estimado (Ej: 3 días laborales / 24 horas).]

| Subtarea ([ID Tarea].[x]) | Estimado (Horas)    | Objetivo Específico             |
| :------------------------ | :------------------ | :------------------------------ |
| **[ID Tarea].1**          | [Horas]             | [Descripción de la subtarea 1.] |
| **[ID Tarea].2**          | [Horas]             | [Descripción de la subtarea 2.] |
| **[ID Tarea].3**          | [Horas]             | [Descripción de la subtarea 3.] |
| **Total Estimado**        | **[Suma de Horas]** |                                 |

***



## 6. ANEXOS Y RECURSOS ADICIONALES

Omitibles si no poseen contenido

* **Mocks/Prototipos:** [Enlaces a diseños de UI/UX, maquetas o prototipos.]
* **Casos de Uso/Diagramas de Flujo:** [Diagramas que ilustran el flujo del usuario o del sistema.]
* **Comentarios:** [Espacio para notas, preguntas o aclaraciones.]

***



## 7. Lista de chequeo de logros e hitos a alcanzar 

Esta lista contiene los hitos técnicos para seguimiento del progreso de la tarea.
El listado debe de estar correctamente distribuido en los puntos a alcanzar, siendo estos verificables en la base de desarrollo y progreso

