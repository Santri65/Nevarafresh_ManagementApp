# MER conceptual --- Plataforma operativa de empleados NevaraFresh

## 1. Entidades y atributos

-   **Tienda:** id_tienda, nombre, dirección, estado.
-   **Empleado:** id_empleado, nombre, correo, rol, estado.
-   **Producto:** id_producto, nombre, código_barras, categoría,
    unidad_medida.
-   **Inventario:** id_inventario, cantidad_disponible,
    cantidad_en_bodega, cantidad_en_exhibición, fecha_actualización.
-   **MovimientoInventario:** id_movimiento, tipo_movimiento, cantidad,
    fecha_hora, motivo, cantidad_anterior, cantidad_nueva.
-   **Tarea:** id_tarea, descripción, prioridad, estado,
    fecha_asignación, fecha_cierre.
-   **Novedad:** id_novedad, tipo_novedad, descripción,
    cantidad_afectada, fecha_hora, estado.
-   **RecepciónMercancía:** id_recepción, fecha_hora, estado,
    observaciones.

## 2. Relaciones y cardinalidad

-   **Tienda --- Empleado:** una tienda tiene varios empleados; cada
    empleado está asignado a una tienda. **(1:N)**
-   **Tienda --- Inventario:** una tienda mantiene varios registros de
    inventario; cada registro pertenece a una tienda. **(1:N)**
-   **Producto --- Inventario:** un producto puede estar registrado en
    el inventario de varias tiendas; cada registro corresponde a un
    producto. **(1:N)**
-   **Inventario --- MovimientoInventario:** un registro de inventario
    puede tener muchos movimientos; cada movimiento afecta un registro
    de inventario. **(1:N)**
-   **Empleado --- MovimientoInventario:** un empleado registra muchos
    movimientos; cada movimiento es registrado por un empleado.
    **(1:N)**
-   **Empleado --- Tarea:** un empleado puede tener asignadas varias
    tareas; cada tarea se asigna a un empleado. **(1:N)**
-   **Tienda --- Tarea:** una tienda puede tener varias tareas; cada
    tarea corresponde a una tienda. **(1:N)**
-   **Inventario --- Novedad:** un registro de inventario puede generar
    varias novedades; cada novedad se relaciona con un registro de
    inventario. **(1:N)**
-   **Empleado --- Novedad:** un empleado puede reportar varias
    novedades; cada novedad es reportada por un empleado. **(1:N)**
-   **Tienda --- RecepciónMercancía:** una tienda puede registrar varias
    recepciones; cada recepción ocurre en una tienda. **(1:N)**
-   **Empleado --- RecepciónMercancía:** un empleado puede registrar
    varias recepciones; cada recepción tiene un empleado responsable.
    **(1:N)**

## 3. Relaciones y cardinalidad (resumen)

-   **Tienda--Empleado:** 1:N
-   **Tienda--Inventario:** 1:N
-   **Producto--Inventario:** 1:N
-   **Inventario--MovimientoInventario:** 1:N
-   **Empleado--MovimientoInventario:** 1:N
-   **Empleado--Tarea:** 1:N
-   **Tienda--Tarea:** 1:N
-   **Inventario--Novedad:** 1:N
-   **Empleado--Novedad:** 1:N
-   **Tienda--RecepciónMercancía:** 1:N
-   **Empleado--RecepciónMercancía:** 1:N
