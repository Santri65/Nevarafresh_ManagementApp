# Contexto del proyecto --- NevaraFresh Empleados

## Qué es

NevaraFresh es una cadena de supermercados que comercializa productos
frescos. Este proyecto se enfoca exclusivamente en una **plataforma
multiplataforma para los empleados que trabajan físicamente en los
supermercados**, con el propósito de apoyar sus actividades operativas
cotidianas.

La aplicación no está enfocada en los clientes, domicilios ni en la
gestión administrativa desde oficinas. Busca que el personal de cada
tienda pueda consultar y registrar operaciones relacionadas con los
productos, el inventario y las actividades de la tienda.

La solución se desarrollará con **Flutter**, por lo que debe
considerarse una interfaz adaptable a distintos dispositivos y
plataformas. En esta etapa, el alcance funcional y el modelo de datos
son conceptuales y pueden evolucionar conforme se definan las reglas del
negocio.

## Objetivo

Facilitar la gestión operativa diaria de cada supermercado mediante el
registro y seguimiento de inventario, recepción y reposición de
mercancía, control de vencimientos y mermas, tareas de empleados y
novedades operativas. Las operaciones deben conservar información
suficiente para conocer qué ocurrió, cuándo, en qué tienda y quién fue
responsable.

## Funcionalidades contempladas

Estas funcionalidades representan el alcance conceptual inicial; no
implica que todas deban implementarse de inmediato.

-   **Inventario:** consultar existencias por tienda y producto,
    registrar entradas y salidas, conteos físicos y ajustes.
-   **Recepción de mercancía:** registrar mercancía recibida,
    cantidades, diferencias y responsable de la recepción.
-   **Vencimientos y mermas:** registrar productos próximos a vencer,
    vencidos, dañados o descartados, junto con cantidades y motivos.
-   **Reposición:** identificar productos que necesitan reposición y
    registrar actividades de reposición desde bodega hacia exhibición.
-   **Tareas operativas:** consultar tareas asignadas, su prioridad y
    estado, y registrar su cumplimiento.
-   **Novedades e incidentes:** reportar situaciones como diferencias de
    inventario, productos dañados o problemas con equipos de la tienda.
-   **Traslados entre tiendas:** posibilidad futura de solicitar,
    registrar y dar seguimiento al movimiento de productos entre
    supermercados.

## Usuarios y alcance

La aplicación está dirigida al personal de las tiendas. A nivel
conceptual se consideran perfiles como:

-   **Auxiliar de tienda:** realiza conteos, reposición y reportes
    operativos.
-   **Encargado de inventario:** registra o valida operaciones de
    inventario y recepción.
-   **Supervisor de tienda:** revisa actividades, gestiona tareas y
    puede aprobar operaciones que lo requieran.

Los perfiles son una propuesta conceptual. No se deben implementar
permisos o reglas de aprobación específicas hasta que estén definidos en
el modelo o en instrucciones posteriores.

La aplicación se centra en la operación de una tienda. La supervisión
corporativa integral, los procesos de domicilios y la administración
desde oficinas pertenecen a otros posibles sistemas y quedan fuera del
alcance actual.

## Modelo de datos

El modelo conceptual inicial se encuentra en `docs/modelo.md`. Sus
entidades propuestas son:

-   `Tienda`
-   `Empleado`
-   `Producto`
-   `Inventario`
-   `MovimientoInventario`
-   `Tarea`
-   `Novedad`
-   `RecepcionMercancia`

Las relaciones conceptuales principales incluyen:

-   Tienda--Empleado: uno a muchos.
-   Tienda--Inventario: uno a muchos.
-   Producto--Inventario: uno a muchos.
-   Inventario--MovimientoInventario: uno a muchos.
-   Empleado--MovimientoInventario: uno a muchos.
-   Empleado--Tarea: uno a muchos.
-   Tienda--Tarea: uno a muchos.
-   Inventario--Novedad: uno a muchos.
-   Empleado--Novedad: uno a muchos.
-   Tienda--RecepcionMercancia: uno a muchos.
-   Empleado--RecepcionMercancia: uno a muchos.

El modelo es conceptual y puede requerir ajustes al definir reglas de
negocio. Las pantallas y componentes no deben inventar atributos de
entidades que no estén documentados. Si una función necesita información
que no aparece en `docs/modelo.md`, señalar la necesidad antes de
incorporarla.

## Cómo se ejecuta y se revisa

-   Ejecutar en navegador Chrome: `flutter run -d chrome`
-   Revisar el proyecto: `flutter analyze`
-   No deben quedar errores de análisis en `lib/`.

Estos comandos corresponden al flujo de desarrollo inicial; otras
plataformas podrán habilitarse posteriormente.

## Estructura sugerida

-   `lib/main.dart`: punto de entrada de la aplicación y configuración
    de rutas.
-   `lib/screens/`: pantallas, una por archivo, con nombres `XxxScreen`.
-   `lib/components/`: componentes reutilizables, organizados en
    archivos individuales.
-   `docs/modelo.md`: modelo de datos conceptual del proyecto.

Antes de crear archivos o adoptar una estructura distinta, revisar la
estructura existente del repositorio y respetar las decisiones ya
tomadas.

## Convenciones de desarrollo sugeridas

-   Usar Flutter y Dart.
-   Cada pantalla debe organizar su contenido dentro de un `Scaffold`;
    considerar `SafeArea` para el contenido principal.
-   Reutilizar componentes cuando una interfaz o comportamiento se
    repita.
-   Revisar `lib/components/` antes de crear un componente nuevo.
-   Usar nombres de clases, variables y archivos en inglés; los textos
    visibles de la interfaz deben estar en español.
-   Mantener una separación clara entre pantallas, componentes
    reutilizables y lógica de datos.
-   Diseñar la interfaz considerando que puede utilizarse en celulares,
    tabletas y computadores.
-   No asumir que todos los usuarios tienen los mismos permisos.
-   No implementar persistencia, autenticación, integraciones con
    POS/ERP, códigos de barras, notificaciones ni servicios externos sin
    que se soliciten o se definan previamente.

## Reglas para el agente de desarrollo

-   Antes de implementar, leer este contexto y `docs/modelo.md`.
-   Mantener el enfoque en las operaciones cotidianas de empleados de
    supermercados.
-   No agregar funcionalidades de domicilios, clientes finales o
    administración corporativa de oficinas.
-   No inventar entidades, atributos, reglas de negocio ni permisos; si
    hacen falta, explicar la necesidad y proponerlos para revisión.
-   No agregar dependencias a `pubspec.yaml` sin autorización.
-   No modificar archivos fuera de `lib/` y `docs/` sin avisar
    previamente.
-   Evitar reemplazar o reestructurar código existente sin necesidad.
-   Al terminar una tarea, ejecutar `flutter analyze` y reportar
    brevemente los archivos creados o modificados, así como el resultado
    del análisis.
-   Si una decisión funcional no está clara, preguntar antes de
    asumirla.
