# wwebjs-termux

Bot base de WhatsApp Web con `whatsapp-web.js`, preparado para Termux usando Chromium instalado por paquetes.

## Instalacion en Termux

```bash
pkg update -y
pkg install git nodejs-lts -y
git clone https://github.com/wingscc18/wwebjs-termux.git
cd wwebjs-termux
chmod +x setup-wa-termux.sh
./setup-wa-termux.sh
npm start
```

El script instala dependencias, bloquea la descarga automatica de Chromium/Puppeteer, detecta la ruta de Chromium y genera `config.js` con las rutas reales del dispositivo.

El bloqueo de descarga de Puppeteer queda guardado en `.npmrc` y `.puppeteerrc.cjs`, asi que despues puedes instalar mas librerias con `npm install paquete` sin que Puppeteer intente descargar Chromium.

Tambien puedes instalar solo las utilidades base con:

```bash
chmod +x utils/install-base.sh
./utils/install-base.sh
```
