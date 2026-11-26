# NevaraFresh Empleados — Product Requirements Document

> Estado: borrador de documentación  
> Alcance: aplicación de operación para empleados de tiendas físicas  
> Última revisión: 2026-11-25

## 1. Visión del producto

NevaraFresh Empleados es una aplicación multiplataforma orientada a apoyar las operaciones cotidianas del personal de las tiendas físicas de NevaraFresh. Su propósito es ofrecer un punto de trabajo desde el cual los empleados puedan consultar y registrar información relacionada con la operación de su tienda.

La aplicación se desarrolla con Flutter y debe adaptar su interfaz a celulares, tabletas y computadores.

## 2. Problema que aborda

Las actividades diarias de una tienda requieren mantener información operativa sobre productos, existencias, movimientos, recepción de mercancía, tareas y novedades. La aplicación busca reunir y facilitar estas actividades en una herramienta de uso interno para los empleados.

Este producto se refiere exclusivamente a la operación de las tiendas físicas. No debe confundirse con la aplicación de domicilios dirigida a clientes ni con la solución corporativa de analítica e integración de datos de NevaraFresh.

## 3. Objetivos

- Facilitar la consulta de información del inventario de una tienda.
- Apoyar el registro y seguimiento de movimientos relacionados con el inventario.
- Apoyar actividades de recepción de mercancía.
- Facilitar el registro de vencimientos, mermas y novedades operativas.
- Apoyar actividades de reposición y gestión de tareas.
- Mantener una interfaz adaptable a distintos tamaños de pantalla.

Estos objetivos expresan capacidades esperadas del producto. El comportamiento detallado de cada capacidad debe definirse en su especificación funcional correspondiente.

## 4. Usuarios y contexto de uso

Se contemplan, como perfiles conceptuales de trabajo:

- Auxiliar de tienda.
- Encargado de inventario.
- Supervisor.

Estos perfiles ayudan a describir quiénes pueden participar en los procesos. No constituyen por sí mismos una definición de permisos, jerarquías, aprobaciones ni restricciones de acceso. Esas reglas deberán especificarse cuando exista una decisión de producto.

## 5. Alcance funcional

Las áreas funcionales contempladas son:

1. Inventario: consulta de existencias y operaciones relacionadas.
2. Movimientos de inventario: registro de cambios en las existencias.
3. Recepción de mercancía: apoyo al registro de mercancía recibida.
4. Vencimientos y mermas: registro de situaciones asociadas a productos.
5. Reposición: apoyo a las actividades de reposición en tienda.
6. Tareas: consulta y gestión de tareas operativas.
7. Novedades: reporte de situaciones o incidentes de la operación.

Los traslados entre tiendas se consideran una posibilidad futura y no forman parte del alcance inicial definido.

## 6. Fuera de alcance

- Aplicación de domicilios o experiencia de compra para clientes.
- Plataforma corporativa de integración, almacenamiento y analítica de datos.
- Pronósticos corporativos de demanda e inventario omnicanal.
- Automatización de decisiones operativas que no hayan sido definidas.
- Implementación de permisos, aprobaciones o jerarquías no acordadas.
- Traslados entre tiendas en la primera etapa.

## 7. Restricciones y lineamientos

- La tecnología de interfaz es Flutter.
- La aplicación debe contemplar celulares, tabletas y computadores.
- Los textos visibles para el usuario estarán en español.
- Los nombres de clases, variables y archivos de código seguirán la convención en inglés.
- Se debe respetar la separación entre pantallas, componentes reutilizables y lógica de datos.
- No se deben incorporar dependencias nuevas sin autorización.
- Antes de implementar una funcionalidad se debe revisar su especificación y el modelo de dominio.
- Las funcionalidades deben validarse contra sus criterios de aceptación.

## 8. Criterio de evolución

Este documento define la visión y los límites generales del producto. No reemplaza las especificaciones funcionales. Cuando una funcionalidad requiera reglas, datos o relaciones que todavía no estén definidos, la necesidad debe registrarse como pregunta abierta antes de asumir una solución.

## 9. Documentos relacionados

- `requisitos.md`: catálogo de capacidades y restricciones.
- `architectural_spine.md`: lineamientos técnicos e invariantes.
- `modelo.md`: entidades y relaciones del dominio.
- `../specs/README.md`: índice de especificaciones funcionales.
