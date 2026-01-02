# Conteo de Camiones - Android Nativo

Aplicación nativa Android para conteo de camiones multi-obra.

## Stack Tecnológico

- **Lenguaje:** Kotlin
- **UI:** Jetpack Compose
- **Arquitectura:** MVVM + Clean Architecture
- **Backend:** Supabase Android SDK
- **DI:** Hilt
- **Base de datos local:** Room
- **Async:** Coroutines + Flow

## Estructura del Proyecto

```
app/
├── src/main/
│   ├── java/com/conteo/camiones/
│   │   ├── di/                    # Dependency Injection
│   │   ├── data/                  # Repositorios y fuentes de datos
│   │   ├── domain/                # Modelos y casos de uso
│   │   └── presentation/          # UI con Compose
│   └── res/                       # Recursos
└── build.gradle.kts
```

## Configuración

1. Abrir proyecto en Android Studio
2. Sincronizar Gradle
3. Configurar credenciales de Supabase en `local.properties`
4. Ejecutar en emulador o dispositivo

## Credenciales Supabase

```properties
# local.properties
supabase.url=https://yyjriphylwdfsbiwyrxk.supabase.co
supabase.key=sb_publishable_A1IJXRTWDHH_-Uvykm5Irg_iSwSy4X7
```

## Compilar

```bash
./gradlew assembleDebug
```

## Ejecutar

```bash
./gradlew installDebug
```
