# wwebjs-termux

Bot base de WhatsApp Web con `whatsapp-web.js`, preparado para Termux usando Chromium instalado por paquetes.

## Instalacion en Termux

Copia y ejecuta estos comandos tal cual, en este orden:

```bash
pkg install git -y
git clone wingscc18/wwebjs-termux
cd wwebjs-termux
chmod +x setup-wa-termux.sh
./setup-wa-termux.sh
npm start
```

El script instala dependencias, bloquea la descarga automatica de Chromium/Puppeteer, detecta la ruta de Chromium y genera `config.js` con las rutas reales del dispositivo.

El bloqueo de descarga de Puppeteer queda guardado en `.puppeteerrc.cjs`, asi que despues puedes instalar mas librerias con `npm install paquete` sin que Puppeteer intente descargar Chromium.

## Configuracion

Para cambiar el prefijo de comandos, edita `prefix` en `config.js`:

```bash
micro config.js
```

Si `config.js` no existe, primero ejecuta:

```bash
./setup-wa-termux.sh
```

## Comandos

| Comando | Alias | Descripcion |
| --- | --- | --- |
| `!help` | `!h`, `!ayuda`, `!comandos` | Muestra la lista de comandos disponibles. |
| `!ping` | `!p` | Responde `pong`. |

## Editar archivos en Termux

Para editar archivos puedes usar `nano` o `micro`.

`micro` se instala por defecto durante `./setup-wa-termux.sh`.

Con `nano`:

```bash
nano commands/ping.js
```

Con `micro`:

```bash
micro commands/ping.js
```
