# Allprocar — MVP Android (Backend + Flutter)

Monorepo listo para subir a tu GitHub. Incluye:

- **backend/**: API REST en Node.js/Express con persistencia simple en JSON (migrable a Go sin romper contrato).
- **app_flutter/**: Base de app Flutter (Android) conectada a la API.

## Requisitos
- Node 18+ y npm
- Flutter 3.19+ (Dart 3)

## Ejecutar Backend
```bash
cd backend
cp .env.example .env
npm i
npm run dev
```
Healthcheck: `GET http://localhost:4000/api/health`

## Ejecutar App Flutter (Android)
```bash
cd app_flutter
flutter pub get
flutter run
```
En emulador Android el host `localhost` del PC es `10.0.2.2`. Ya está configurado como default en `lib/core/env.dart`.

## Build APK (release)
```bash
cd app_flutter
flutter build apk --release
```
Firma: crea keystore si no tenés y configura en `android/` (guía estándar de Flutter).

## Estructura
```
allprocar-mvp/
├─ backend/
└─ app_flutter/
```
