# FEAT-A241: Reconstrucción del Sistema de Paquetes y Asignación de Recursos (Backend)

## 1. DATOS GENERALES

| Atributo                 | Valor (Completar)                                                         |
|:------------------------ |:------------------------------------------------------------------------- |
| **ID de la Tarea**       | FEAT-A241                                                                 |
| **Letra identificadora** | A                                                                         |
| **Nombre de la Tarea**   | Reconstrucción del Sistema de Paquetes y Asignación de Recursos (Backend) |
| **Categoría**            | Feat                                                                      |
| **Dependencia Crítica**  | N/A                                                                       |

***

## 2. OBJETIVO Y JUSTIFICACIÓN

| Atributo                 | Valor (Completar)                                                                                                                                                                                                                                                                                          |
|:------------------------ |:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Objetivo de la Tarea** | Implementar la infraestructura de base de datos y la lógica de modelos necesaria para un nuevo sistema de gestión de paquetes, recursos y asignaciones a usuarios en el backend de Laravel.                                                                                                                |
| **Justificación**        | El sistema actual de paquetes es rígido y difícil de mantener. Este nuevo modelo proporcionará flexibilidad para crear diversos planes (Tiers), ofrecer recursos individuales (Addons) y gestionar las asignaciones de los usuarios de forma granular, sentando las bases para futuros modelos de negocio. |
| **Métricas de Éxito**    | El 100% de las nuevas tablas y relaciones son creadas correctamente tras la migración. Los seeders pueblan la base de datos con la información inicial de recursos sin errores.                                                                                                                            |

***

## 3. DESCRIPCIÓN FUNCIONAL Y CRITERIOS DE ACEPTACIÓN

### Descripción General (Flujo del Usuario/Sistema)

Esta tarea es puramente de backend y no tiene interacción directa con el usuario final. El objetivo es construir el esqueleto de la base de datos y la capa de acceso a datos (Modelos Eloquent) para un nuevo sistema de "Paquetes y Recursos". Se crearán las tablas para definir `Resources` (módulos/funcionalidades), `Tiers` (paquetes de suscripción), `Addons` (recursos comprables individualmente) y las tablas pivote y de asignación que conectan todo con los usuarios.

### Criterios de Aceptación (Condiciones Verificables)

| Rol                | Criterio de Aceptación (Fórmula: *Cuando [acción], entonces [resultado esperado]*)                                                                                                                                                                                                              |
|:------------------ |:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Sistema/DB**     | Cuando se ejecutan las migraciones, entonces las 13 tablas (`Resources`, `Tiers`, `Business_Groups`, `Renewal_Periods`, `Addon_Offers`, `user_allocations`, `purchases_inapp`, `user_tier` y sus pivotes) se crean en la base de datos con las columnas, tipos, índices y relaciones correctas. |
| **Sistema/DB**     | Cuando se ejecutan los seeders, entonces la tabla `Resources` se puebla con una lista predefinida de funcionalidades existentes en la plataforma y las tablas catálogo (`Renewal_Periods`, `Business_Groups`) contienen datos iniciales.                                                        |
| **Desarrollador**  | Cuando se utilizan los modelos Eloquent, entonces las relaciones (ej: `Tier` tiene muchos `Resources`, `User` tiene muchas `Allocations`) funcionan como se espera y devuelven los datos correctos.                                                                                             |
| **Desarrollador**  | Cuando se utilizan las factories, entonces se puede generar data de prueba válida para todos los nuevos modelos, facilitando la creación de pruebas unitarias y de integración.                                                                                                                 |
| **Sistema/Lógica** | Cuando se crea un nuevo registro en cualquier tabla, entonces el campo `id` se autocompleta con un UUID válido.                                                                                                                                                                                 |

***

## 4. CONSIDERACIONES TÉCNICAS (Diseño Técnico Propuesto)

| Área                     | Detalle de la Implementación Técnica                                                                                                                                                                                                                                                                                         |
|:------------------------ |:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Backend**              | Se crearán 13 Modelos Eloquent. Se recomienda crear un Trait `HasUuid` para manejar la generación automática de UUIDs en el evento `creating` de los modelos.                                                                                                                                                                |
| **Frontend**             | N/A.                                                                                                                                                                                                                                                                                                                         |
| **Bases de Datos**       | Se crearán 13 archivos de migración para las tablas definidas en el esquema. Se usarán `Enums` de PHP 8.1+ para los tipos `resource_type`, `period_type`, y `allocation_type`, con su respectivo *casting* en los modelos. Las claves primarias serán de tipo `uuid`. Las tablas pivote tendrán claves primarias compuestas. |
| **APIs/Endpoints**       | N/A.                                                                                                                                                                                                                                                                                                                         |
| **Lógica de Negocio**    | La lógica principal residirá en el Seeder `ResourcesTableSeeder`, que deberá mapear las funcionalidades actuales del sistema (identificadas a partir de la configuración de paquetes existente) a registros en la nueva tabla `Resources`.                                                                                   |
| **Seguridad/Validación** | N/A en esta fase.                                                                                                                                                                                                                                                                                                            |

### Detalles de implementación

El esquema de base de datos proporcionado será la única fuente de verdad para la creación de migraciones y modelos.

**Esquema DBML:**

```dbml
// New Package resources

Enum resource_type {
  consumable
  toggleable
  limited
}

Enum period_type {
  year
  quarter
  month
  week
  day
}

Enum allocation_type {
  package
  addon
}

// ---------------------------------

Table USER {
  id uuid [pk]
  //  ...
  created_at timestamp
  updated_at timestamp
}

Table Resources {
  note: 'Representing the existing modules with allocable, enabled or consumable resource'

  id uuid [pk]
  key varchar(100) [unique, not null, note: 'This is the representation about the "module.action"']
  type resource_type
  unit varchar(100)
  title varchar(100)
  description varchar(250)
  created_at timestamp
  updated_at timestamp
}

Table Tiers {
  note: "Representing the new 'packages'. Is a group of resources  with a subscription period and price"
  id uuid [pk]
  name varchar(150) [not null, unique, note: "Name of the tier like 'Negocios Basic'"] // 
  slug varchar(150) [not null, unique, note: "Generated from the mane, without spaces and use underscore"]
  active boolean  [note: 'If the tier is allowed to use']
  public boolean  [note: 'If the tier visible in the landing']
  created_at timestamp
  updated_at timestamp
}

Table Business_Groups {
  note: "Represent the categories of the Tiers to show it in the landing"
  id uuid [pk]
  name varchar(150) [not null, unique] // category for the tier like Menu or 
  created_at timestamp
  updated_at timestamp
}

Table Tier_Business_Group {
  tier_id uuid [ref: > Tiers.id]
  business_group_id uuid [ref: > Business_Groups.id]
}

Table Tier_Resources {
  tier_id uuid [pk, ref: > Tiers.id]
  resource_id uuid [pk, ref: > Resources.id]
  created_at timestamp
  updated_at timestamp
}

Table Renewal_Periods {
  note: 'Representing the possible periods assignable to tier or addon'
  id uuid [pk]
  name varchar(150) [not null]
  period_type period_type
  period_quantity int
  created_at timestamp
  updated_at timestamp
}

Table Tier_Renewal_Periods {
  tier_id uuid [pk, ref: > Tiers.id]
  renewal_period_id uuid [pk, ref: > Renewal_Periods.id]
  cop_price double(11,2)
  usd_price double(11,2)
  created_at timestamp
  updated_at timestamp
}

Table Addon_Offers {
  note: 'Representing offers of individual resource in a specific configuration, allowed to buy'
  id uuid [pk]
  resource_id uuid [ref: > Resources.id]
  name varchar(150) [not null, unique]
  amount bigint [note: 'Represent the quantity to assing; 0 and 1 for booleas']
  created_at timestamp
  updated_at timestamp
}

Table Addon_Offer_Renewal_Period {
  addon_offer_id uuid [pk, ref: > Addon_Offers.id]
  renewal_period_id uuid [pk, ref: > Renewal_Periods.id]
  coop_price double
  usd_price double
  created_at timestamp
  updated_at timestamp
}

Table user_allocations {
  note: 'Representing the user assigned resources in consumibles or aditionals'
  id uuid [pk]
  user_id uuid [ref: > USER.id]
  resource_id uuid [ref: > Resources.id]
  type allocation_type
  resource_value bigint [note: 'Save the rest of the resource assigned to the user']
  expiration_date date [null, note: "Is possible null cuase some resources don't have an expiration, like the consumables"]
  created_at timestamp
  updated_at timestamp
}

Table purchases_inapp {
  note: 'Representing the user assigned resources in consumibles or additional'
  id uuid [pk]
  user_id uuid [ref: > USER.id]
  purchase_type varchar(100) [note: 'The type of the purchase is like tier, addon, etc']
  purchase_name varchar(150) [note: 'Original name of the purchased, like the title of the tier or name of the addon']
  snapshot json [not null, note: 'Simple snapshot of the purchase to trace']
  payed_price double
  created_at timestamp
  updated_at timestamp
}

Table user_tier {
  note: 'Auxiliar table to represent the conexión 1 to 1 beetween Tier and user'
  user_id uuid [pk, ref: > USER.id]
  tier_id uuid [ref: > Tiers.id]
  expiration_date date
  created_at timestamp
  updated_at timestamp
}
```

### Pasos a seguir sugeridos

1. **Crear Migraciones:** Generar los 13 archivos de migración a partir del esquema DBML. Prestar especial atención a las claves foráneas, los tipos de columna (`uuid`, `enum`), y las claves primarias compuestas.
2. **Crear Modelos:** Generar los 13 modelos Eloquent. Implementar el trait `HasUuid`. Definir las relaciones (`belongsToMany`, `hasMany`, etc.) y los *casts* para los enums y campos JSON.
3. **Crear Factories:** Generar una factory por cada modelo para facilitar la siembra de datos y las pruebas.
4. **Crear Seeders:**
   * Crear un `DatabaseSeeder` que llame a los seeders específicos.
   * Crear un `ResourcesTableSeeder` que inserte los recursos base del sistema. Esto requiere un análisis previo de la lógica de paquetes actual para extraer la lista de funcionalidades.
   * Crear seeders para las tablas catálogo como `Renewal_Periods` y `Business_Groups`.
5. **Ejecutar y Verificar:** Correr `php artisan migrate --seed` y verificar que la base de datos se construya y pueble correctamente.

### Lista de Chequeo para Asignación (Hitos de Seguimiento)

* - [ ] Creación de 13 Migraciones (UUIDs, Enums, Pivotes Compuestos).
* - [ ] Creación de 13 Modelos con relaciones Eloquent, casts y trait de UUID.
* - [ ] Creación de Factories para todos los nuevos modelos.
* - [ ] Implementación de Seeders para poblar `Resources` y tablas catálogo.
* - [ ] Verificación de la correcta ejecución de `migrate --seed` sin errores.

***

## 5. TIEMPO DE IMPLEMENTACIÓN ESTIMADO Y DESGLOSE

**Estimación Total:** 2 Días (16 horas)

| Subtarea (FEAT-A241.x) | Estimado (Horas) | Objetivo Específico                                                                    |
|:---------------------- |:---------------- |:-------------------------------------------------------------------------------------- |
| **FEAT-A241.1**        | 4                | Creación y verificación de los 13 archivos de migración.                               |
| **FEAT-A241.2**        | 4                | Creación de los 13 modelos Eloquent con sus relaciones y casts.                        |
| **FEAT-A241.3**        | 3                | Creación de las factories para todos los nuevos modelos.                               |
| **FEAT-A241.4**        | 5                | Análisis del sistema actual y creación de los seeders para poblar los datos iniciales. |
| **Total Estimado**     | **16**           |                                                                                        |

***

## 6. ANEXOS Y RECURSOS ADICIONALES

* **Comentarios:** La tarea de "analizar el sistema actual" para el seeder de recursos es la más ambigua. Se debe investigar dónde se define la lógica de los paquetes actuales para poder replicarla como "recursos" en el nuevo sistema.

***

## 7. Lista de chequeo de logros e hitos a alcanzar

* [ ] Todas las migraciones han sido creadas y probadas.
* [ ] Todos los modelos Eloquent están definidos con sus relaciones correspondientes.
* [ ] Las factories generan datos consistentes para cada modelo.
* [ ] El seeder principal puebla correctamente la tabla `Resources` con los módulos existentes.
* [ ] El seeder principal puebla las tablas catálogo (`Renewal_Periods`, `Business_Groups`).
* [ ] El comando `php artisan migrate:fresh --seed` se completa exitosamente.
