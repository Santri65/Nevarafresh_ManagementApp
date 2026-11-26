# Architectural Spine — NevaraFresh Empleados

> Estado: lineamientos iniciales  
> Este documento fija restricciones y principios técnicos conocidos. No pretende definir una arquitectura de backend que todavía no ha sido acordada.

## 1. Propósito

Mantener un conjunto pequeño de decisiones e invariantes técnicos que orienten la implementación de las funcionalidades descritas en `specs/`.

## 2. Stack conocido

- Framework de interfaz: Flutter.
- Lenguaje de implementación: Dart.
- Plataforma de ejecución y validación de desarrollo: navegador Chrome mediante `flutter run -d chrome`.
- Herramienta de análisis estático: `flutter analyze`.

No se fija aquí una base de datos, proveedor de autenticación, API, backend, estrategia de despliegue ni mecanismo de sincronización. Esas decisiones requieren definición explícita.

## 3. Estructura de código esperada

La organización debe respetar la estructura existente del repositorio. Como orientación:

```text
lib/
├── main.dart
├── screens/
│   └── xxx_screen.dart
└── components/
    └── reusable_component.dart

docs/
specs/
```

- `lib/main.dart`: punto de entrada y configuración de navegación de la aplicación.
- `lib/screens/`: pantallas; cada pantalla principal debe tener su archivo y una clase `XxxScreen`.
- `lib/components/`: componentes reutilizables, separados por archivo.
- `docs/`: documentación general del producto, requisitos, arquitectura y modelo.
- `specs/`: especificaciones funcionales y sus escenarios verificables.

La estructura es una guía, no una autorización para reorganizar archivos existentes sin revisar primero el repositorio.

## 4. Invariantes y reglas de trabajo

1. Leer `AGENTS.md`, `docs/prd.md`, `docs/requisitos.md`, `docs/architectural_spine.md` y `docs/modelo.md` antes de implementar cambios relevantes.
2. Leer la Spec de la funcionalidad antes de modificar código relacionado.
3. No inventar reglas de negocio, atributos, permisos, estados ni aprobaciones.
4. Si una funcionalidad requiere una entidad o relación ausente en `modelo.md`, registrar la necesidad y solicitar definición antes de incorporarla.
5. Mantener los textos de interfaz en español y los identificadores del código en inglés.
6. Separar presentación, componentes reutilizables y lógica de datos.
7. No agregar paquetes o dependencias sin autorización.
8. No modificar archivos fuera de `lib/` y `docs/` sin advertirlo y justificarlo previamente, salvo que una tarea aprobada requiera expresamente otra ubicación (por ejemplo, una Spec).
9. No declarar una funcionalidad terminada si sus criterios de aceptación no han sido comprobados.

## 5. Validación mínima

Para los cambios de Flutter:

```bash
flutter analyze
flutter run -d chrome
```

- `flutter analyze` no debe reportar errores en `lib/`.
- La aplicación debe iniciar en Chrome cuando el entorno de desarrollo esté disponible.
- La validación funcional debe comprobar los criterios de aceptación de la Spec correspondiente.

## 6. Decisiones arquitectónicas pendientes

No se consideran decididos todavía:

- Arquitectura de backend y contratos de API.
- Motor y esquema físico de persistencia.
- Autenticación y autorización.
- Gestión de estado en Flutter.
- Estrategia de caché, funcionamiento sin conexión y sincronización.
- Observabilidad, registro de errores y despliegue.

Cuando se tome una decisión, debe documentarse aquí con su contexto, alternativas consideradas, decisión y consecuencias. No se debe presentar una opción técnica como existente solo porque sea habitual en proyectos Flutter.

## 7. Relación con las Specs

Las Specs describen el comportamiento observable esperado. Este documento establece límites técnicos comunes. Si una Spec parece exigir algo que contradice un invariante, se debe resolver la contradicción antes de implementar.
