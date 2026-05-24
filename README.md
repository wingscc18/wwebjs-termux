# wwebjs-termux

Bot base de WhatsApp Web con `whatsapp-web.js`, preparado para Termux usando Chromium instalado por paquetes.

## Instalacion en Termux

```bash
chmod +x setup-wa-termux.sh
./setup-wa-termux.sh
```

## Ejecucion

```bash
npm start
```

El script instala dependencias, bloquea la descarga automatica de Chromium/Puppeteer, detecta la ruta de Chromium y genera `config.js` con las rutas reales del dispositivo.
