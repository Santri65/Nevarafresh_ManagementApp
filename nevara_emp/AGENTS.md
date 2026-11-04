# AGENTS.md — NevaraFresh Empleados (`nevara_emp`)

Guía e instrucciones operativas para agentes de inteligencia artificial y desarrolladores que trabajen en el proyecto **`nevara_emp`** (NevaraFresh Empleados).

---

## 1. Visión General del Proyecto

- **¿Qué es NevaraFresh?**: Es una cadena de supermercados enfocada en la venta y distribución de productos frescos.
- **Propósito de `nevara_emp`**: Es una aplicación multiplataforma construida con **Flutter** dirigida **exclusivamente a los empleados que trabajan físicamente en las tiendas/supermercados**, facilitando sus actividades operativas cotidianas.
- **Fuera de alcance (Out of Scope)**:
  - NO incluye módulos ni interfaces para clientes finales.
  - NO incluye servicios de domicilio o logística de entregas a clientes.
  - NO incluye administración corporativa o gerencial desde oficinas centrales.
  - La aplicación se centra estrictamente en la **operación interna de una tienda**.

---

## 2. Perfiles de Usuario (Alcance Conceptual)

La aplicación contempla preliminarmente tres perfiles en tienda (no implementar control de acceso restrictivo ni permisos rígidos hasta que sean definidos por reglas de negocio):
1. **Auxiliar de tienda**: Ejecuta conteos físicos, reposición de góndolas/estanterías y reportes operativos diarios.
2. **Encargado de inventario**: Registra y valida operaciones de entrada/salida de inventario y recepción de mercancía de proveedores.
3. **Supervisor de tienda**: Supervisa actividades, gestiona asignación de tareas operativas y aprueba operaciones críticas que lo requieran.

---

## 3. Alcance Funcional Contemplado

1. **Gestión de Inventario**:
   - Consulta de existencias por tienda y por producto.
   - Registro de entradas, salidas, conteos físicos y ajustes de stock.
2. **Recepción de Mercancía**:
   - Registro de mercancía recibida en tienda (cantidades recibidas, diferencias vs lo esperado y responsable).
3. **Vencimientos y Mermas**:
   - Registro de productos próximos a vencer, vencidos, dañados o descartados con cantidades y motivos detallados.
4. **Reposición**:
   - Detección de productos con necesidad de reposición.
   - Registro de movimientos de reposición desde bodega interna hacia exhibición en piso de venta.
5. **Tareas Operativas**:
   - Asignación, consulta y actualización de tareas (prioridad, estado y cumplimiento).
6. **Novedades e Incidentes**:
   - Reporte de inconsistencias de stock, productos averiados o problemas en equipos/infraestructura de la tienda.
7. **Traslados entre Tiendas (Futuro)**:
   - Registro y trazabilidad de solicitudes de productos entre supermercados.

---

## 4. Modelo de Datos Conceptual (MER)

Las pantallas y componentes **no deben inventar atributos ni entidades**. Todo desarrollo debe apegarse al MER conceptual definido en `docs/Modelo_MER.md`:

### Entidades y Atributos

| Entidad | Atributos Principales |
| :--- | :--- |
| **`Tienda`** | `id_tienda`, `nombre`, `dirección`, `estado` |
| **`Empleado`** | `id_empleado`, `nombre`, `correo`, `rol`, `estado` |
| **`Producto`** | `id_producto`, `nombre`, `código_barras`, `categoría`, `unidad_medida` |
| **`Inventario`** | `id_inventario`, `cantidad_disponible`, `cantidad_en_bodega`, `cantidad_en_exhibición`, `fecha_actualización` |
| **`MovimientoInventario`** | `id_movimiento`, `tipo_movimiento`, `cantidad`, `fecha_hora`, `motivo`, `cantidad_anterior`, `cantidad_nueva` |
| **`Tarea`** | `id_tarea`, `descripción`, `prioridad`, `estado`, `fecha_asignación`, `fecha_cierre` |
| **`Novedad`** | `id_novedad`, `tipo_novedad`, `descripción`, `cantidad_afectada`, `fecha_hora`, `estado` |
| **`RecepciónMercancía`** | `id_recepción`, `fecha_hora`, `estado`, `observaciones` |

### Relaciones y Cardinalidad (1:N)

- **`Tienda` (1) ─── (N) `Empleado`**: Cada empleado está asignado a una tienda.
- **`Tienda` (1) ─── (N) `Inventario`**: Cada registro de inventario pertenece a una tienda.
- **`Producto` (1) ─── (N) `Inventario`**: Un producto puede tener stock registrado en varias tiendas.
- **`Inventario` (1) ─── (N) `MovimientoInventario`**: Un inventario registra múltiples movimientos de stock.
- **`Empleado` (1) ─── (N) `MovimientoInventario`**: Un empleado es responsable de registrar movimientos.
- **`Empleado` (1) ─── (N) `Tarea`**: Un empleado tiene tareas asignadas.
- **`Tienda` (1) ─── (N) `Tarea`**: Una tarea corresponde a la operación de una tienda.
- **`Inventario` (1) ─── (N) `Novedad`**: Una novedad puede asociarse a un registro de inventario.
- **`Empleado` (1) ─── (N) `Novedad`**: Un empleado reporta novedades operativas.
- **`Tienda` (1) ─── (N) `RecepciónMercancía`**: Cada recepción ocurre en una tienda.
- **`Empleado` (1) ─── (N) `RecepciónMercancía`**: Un empleado es el responsable asignado a la recepción.

---

## 5. Estructura del Proyecto

El código fuente dentro de `nevara_emp/` se organiza según la convención:

```text
nevara_emp/
├── docs/
│   ├── AGENTS.md                  # Este documento de contexto para agentes
│   ├── Contexto_Nevarafresh.md    # Especificación conceptual del negocio
│   └── Modelo_MER.md              # Modelo conceptual Entidad-Relación
├── lib/
│   ├── main.dart                  # Punto de entrada y configuración de rutas
│   ├── screens/                   # Pantallas completas (1 archivo por pantalla, formato XxxScreen)
│   └── components/                # Componentes reutilizables e individuales
├── pubspec.yaml                   # Dependencias y configuración de Flutter
└── test/                          # Pruebas unitarias y de widgets
```

---

## 6. Convenciones de Desarrollo y Código

1. **Lenguaje y Tecnologías**:
   - Flutter y Dart con null-safety activado.
2. **Convenciones de Idioma**:
   - **Código en inglés**: Nombres de archivos (`snake_case`), clases (`PascalCase`), métodos y variables (`camelCase`).
   - **Interfaz gráfica en español**: Textos visibles, títulos, botones, mensajes de error y etiquetas deben estar en **español**.
3. **Diseño de Interfaz**:
   - Cada pantalla debe estructurarse dentro de un `Scaffold` y considerar `SafeArea`.
   - Diseño adaptable/responsive: debe funcionar adecuadamente en celulares, tabletas y navegadores web/escritorio.
4. **Modularidad**:
   - Mantener estricta separación entre pantallas (`screens/`), componentes reutilizables (`components/`) y lógica de datos.
   - Revisar siempre `lib/components/` antes de crear un nuevo componente para evitar duplicidad de código.
5. **Restricciones de Implementación**:
   - **NO** implementar persistencia compleja en BD local, autenticación con credenciales, integraciones con ERP/POS, lectores de hardware de código de barras ni push notifications hasta que sean explícitamente solicitadas y diseñadas.

---

## 7. Comandos de Ejecución y Calidad

Al trabajar en la aplicación, ejecute los comandos desde el directorio `nevara_emp/`:

- **Ejecución en desarrollo (Chrome)**:
  ```bash
  flutter run -d chrome
  ```
- **Análisis estático de código**:
  ```bash
  flutter analyze
  ```
  *Nota*: No deben quedar advertencias ni errores en `lib/`.

---

## 8. Reglas Obligatorias para el Agente (Rules for Agents)

1. **Revisión previa**: Antes de implementar o modificar código, consultar siempre `docs/Contexto_Nevarafresh.md` y `docs/Modelo_MER.md`.
2. **Fidelidad al dominio**: Mantener siempre el enfoque exclusivo en las tareas cotidianas del personal en tienda de supermercado.
3. **Respeto al modelo**: No inventar entidades, campos ni reglas de negocio. Si un requerimiento exige datos no presentes en el modelo, exponer la necesidad antes de crear código.
4. **Control de dependencias**: NO modificar `pubspec.yaml` ni añadir nuevas librerías sin autorización explícita.
5. **Alcance de archivos**: Limitar las modificaciones exclusivamente a las carpetas `lib/` y `docs/`. No alterar archivos de plataforma (`android/`, `ios/`, `web/`, `windows/`) sin solicitud expresa.
6. **Conservación de código**: Respetar el código existente y evitar reestructuraciones o refactorizaciones globales innecesarias.
7. **Verificación final**: Al completar cualquier tarea, ejecutar siempre `flutter analyze` y reportar un resumen de los archivos modificados junto con el resultado del análisis.
8. **Claridad sobre asunciones**: Ante cualquier ambigüedad en los requerimientos funcionales o reglas de negocio, consultar y aclarar con el usuario antes de proceder.
