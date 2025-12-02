# FEAT-A001: Reconstruir Sistema de Paquetes y Asignación de Recursos (Backend)

## 1. DATOS GENERALES

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **ID de la Tarea**       | FEAT-A001                                                    |
| **Letra identificadora** | A                                                            |
| **Nombre de la Tarea**   | Reconstruir Sistema de Paquetes y Asignación de Recursos (Backend) |
| **Categoría**            | Feat                                                         |
| **Dependencia Crítica**  | N/A                                                          |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor (Completar)                                            |
| :----------------------- | :----------------------------------------------------------- |
| **Objetivo de la Tarea** | Implementar la infraestructura de backend (modelos, migraciones, relaciones) para un nuevo sistema de gestión de paquetes, recursos y suscripciones de usuarios en la plataforma Laravel. |
| **Justificación**        | El sistema actual es insuficiente. Se necesita un modelo más flexible y escalable que permita definir paquetes (Tiers), recursos asignables (consumables, toggleables, limited), y ofertas de addons, para monetizar y gestionar las funcionalidades de la plataforma de manera más eficiente. |
| **Métricas de Éxito**    | - Todas las migraciones se ejecutan y revierten correctamente.<br>- Los seeders populan la base de datos con datos iniciales consistentes.<br>- Los modelos tienen sus relaciones (Eloquent) correctamente definidas y pasan pruebas unitarias básicas de relación.<br>- Las factories generan datos de prueba válidos para todas las nuevas entidades. |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Esta tarea se enfoca exclusivamente en el backend. Se crearán las tablas de base de datos, los modelos de Eloquent y las relaciones necesarias para soportar el nuevo sistema de paquetes. Esto incluye entidades como `Resources`, `Tiers`, `AddonOffers`, y las tablas pivote para gestionar las asignaciones y suscripciones de los usuarios. No se implementará lógica de negocio ni endpoints de API en esta tarea.

### Criterios de Aceptación (Condiciones Verificables)

| Rol          | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*) |
| :----------- | :----------------------------------------------------------- |
| Sistema/DB   | Cuando se ejecutan las migraciones, entonces se crean en la base de datos las tablas: `resources`, `tiers`, `business_groups`, `tier_business_group`, `tier_resources`, `renewal_periods`, `tier_renewal_period`, `addon_offers`, `addon_offer_renewal_period`, `user_allocations`, `purchases_inapp`, `user_tier`. |
| Sistema/DB   | Cuando se ejecutan las migraciones, entonces todas las columnas (incluyendo tipos, `UUIDs`, `enums`, `nullable`, `unique`) coinciden con el esquema definido. |
| Sistema/DB   | Cuando se ejecutan los seeders, entonces la tabla `resources` contiene los recursos básicos del sistema mapeados desde la funcionalidad existente. |
| Sistema/DB   | Cuando se usan las factories, entonces se pueden generar instancias válidas y persistentes de todos los nuevos modelos (`Resource`, `Tier`, `AddonOffer`, etc.). |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                         |
| :----------------------- | :----------------------------------------------------------- |
| **Backend**              | **Modelos**: Crear modelos Eloquent para cada nueva tabla: `Resource`, `Tier`, `BusinessGroup`, `RenewalPeriod`, `AddonOffer`, `UserAllocation`, `PurchaseInApp`, `UserTier`.<br>**Relaciones**: Implementar las relaciones `BelongsToMany`, `HasMany`, `BelongsTo` en los modelos. Ej: `Tier` `belongsToMany` `Resource`. `User` `hasOne` `UserTier`.<br>Usar `UUIDs` como claves primarias para todos los nuevos modelos. Se puede usar un Trait para esto. |
| **Frontend**             | N/A                                                          |
| **Bases de Datos**       | **Migraciones**: Crear 13 archivos de migración, uno para cada tabla.<br>Usar `Schema::create` con los tipos de columna adecuados. Para los `enums` (`resource_type`, `period_type`, `allocation_type`), usar el método `enum()` de Laravel.<br>Las claves foráneas deben estar definidas con `foreignUuid('column')->constrained()`.<br>Las tablas pivote con claves compuestas (`tier_resources`, `tier_renewal_period`, etc.) deben definir sus claves primarias compuestas. |
| **APIs/Endpoints**       | N/A                                                          |
| **Lógica de Negocio**    | N/A                                                          |
| **Seguridad/Validación** | N/A                                                          |

### Pasos a seguir sugeridos

1.  Crear los 3 `enums` de PHP en `app/Enums/`.
2.  Generar los 13 archivos de migración usando `php artisan make:migration`.
3.  Definir la estructura de cada tabla en los archivos de migración, prestando especial atención a los `UUIDs`, `enums` y claves foráneas.
4.  Crear los modelos Eloquent correspondientes a las tablas principales.
5.  Implementar un Trait `HasUuid` para ser usado en los modelos y automatizar la generación de `UUIDs`.
6.  Definir las relaciones (`belongsToMany`, `hasMany`, etc.) en cada modelo.
7.  Crear las `Factories` para cada modelo, definiendo estados por defecto realistas.
8.  Crear un `DatabaseSeeder` principal que llame a seeders específicos.
9.  Crear un `ResourceSeeder` que inserte los recursos iniciales del sistema.
10. Ejecutar `php artisan migrate --seed` para verificar que todo funcione.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

* - [ ] Creación de 13 Migraciones (UUIDs/Pivotes Compuestos).
* - [ ] Creación de 3 Enums (resource_type, period_type, allocation_type).
* - [ ] Creación de los 8 Modelos Eloquent con Trait de UUID.
* - [ ] Implementación de relaciones en los modelos.
* - [ ] Creación de Factories para todos los modelos.
* - [ ] Creación de Seeder para `resources` y otros datos iniciales.
* - [ ] Verificación de `migrate --seed` exitosa.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 2 días laborales (16 horas).

| Subtarea (FEAT-A001.x) | Estimado (Horas) | Objetivo Específico                                       |
| :--------------------- | :--------------- | :-------------------------------------------------------- |
| **FEAT-A001.1**        | 5                | Diseño y creación de migraciones y Enums.                 |
| **FEAT-A001.2**        | 5                | Creación de modelos e implementación de relaciones.       |
| **FEAT-A001.3**        | 4                | Creación de Factories y Seeders para datos iniciales.     |
| **FEAT-A001.4**        | 2                | Pruebas, ajustes y documentación interna.                 |
| **Total Estimado**     | **16 Horas**     |                                                           |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

* **Esquema de Base de Datos:** Referirse al esquema proporcionado en el archivo `basetask.txt`.

***

## 7. Lista de chequeo de logros e hitos a alcanzar

* - [ ] Creación de 13 Migraciones (UUIDs/Pivotes Compuestos).
* - [ ] Creación de 3 Enums (resource_type, period_type, allocation_type).
* - [ ] Creación de los 8 Modelos Eloquent con Trait de UUID.
* - [ ] Implementación de relaciones en los modelos.
* - [ ] Creación de Factories para todos los modelos.
* - [ ] Creación de Seeder para `resources` y otros datos iniciales.
* - [ ] Verificación de `migrate --seed` exitosa.
