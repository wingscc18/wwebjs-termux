#!/data/data/com.termux/files/usr/bin/bash

set -e

RESET="\033[0m"
BOLD="\033[1m"
GREEN="\033[1;92m"
YELLOW="\033[1;93m"
RED="\033[1;91m"
CYAN="\033[1;96m"
MAGENTA="\033[1;95m"

YES_OPTS='-o Dpkg::Options::=--force-confnew'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${WA_BOT_PROJECT_DIR:-$SCRIPT_DIR}"

status() {
  echo -e "${GREEN}[OK]${RESET} ${CYAN}$1${RESET}"
}

warn() {
  echo -e "${YELLOW}[WARN]${RESET} $1"
}

error() {
  echo -e "${RED}[ERROR]${RESET} $1"
}

step() {
  echo ""
  echo -e "${MAGENTA}======================================${RESET}"
  echo -e "${YELLOW}$1${RESET}"
  echo -e "${MAGENTA}======================================${RESET}"
}

backup_file() {
  if [ -f "$1" ]; then
    cp "$1" "$1.backup.$(date +%Y%m%d-%H%M%S)"
    warn "$1 existente respaldado."
  fi
}

clear

echo -e "${CYAN}${BOLD}"
echo "======================================"
echo "       WhatsApp Bot Termux Setup"
echo "          Script by Joshua Dev"
echo "======================================"
echo -e "${RESET}"

step "[1/8] Actualizando paquetes..."
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y $YES_OPTS
status "Sistema actualizado."

step "[2/8] Instalando repo X11..."
if command -v pkg >/dev/null 2>&1; then
  if pkg install x11-repo -y; then
    status "Repo X11 instalado con pkg."
  else
    warn "No se pudo instalar x11-repo con pkg, probando con apt-get."
    DEBIAN_FRONTEND=noninteractive apt-get install -y x11-repo $YES_OPTS || warn "x11-repo no esta disponible en este entorno."
  fi
else
  DEBIAN_FRONTEND=noninteractive apt-get install -y x11-repo $YES_OPTS || warn "x11-repo no esta disponible en este entorno."
fi

apt-get update -y
status "Repositorios actualizados."

step "[3/8] Instalando dependencias principales..."
if ! DEBIAN_FRONTEND=noninteractive apt-get install -y \
    nodejs-lts \
    chromium \
    git \
    nano \
    micro \
    which \
    $YES_OPTS; then
  error "No se pudieron instalar las dependencias principales."
  echo ""
  echo -e "${YELLOW}Si falla Chromium, prueba cambiar el repo de Termux:${RESET}"
  echo "  termux-change-repo"
  echo "  pkg update -y"
  echo "  pkg install x11-repo -y"
  echo "  pkg install chromium -y"
  exit 1
fi

status "Node.js, Chromium y herramientas instaladas."

step "[4/8] Instalando dependencias extra si estan disponibles..."

for PKG in fontconfig freetype harfbuzz dbus ttf-dejavu; do
  if apt-cache show "$PKG" >/dev/null 2>&1; then
    DEBIAN_FRONTEND=noninteractive apt-get install -y "$PKG" $YES_OPTS
    status "$PKG instalado."
  else
    warn "$PKG no esta disponible en este repo, se omite."
  fi
done

step "[5/8] Bloqueando descarga automatica de Chromium/Puppeteer..."

export PUPPETEER_SKIP_DOWNLOAD=true
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

for SHELL_FILE in "$HOME/.bashrc" "$HOME/.profile"; do
  touch "$SHELL_FILE"
  grep -qxF 'export PUPPETEER_SKIP_DOWNLOAD=true' "$SHELL_FILE" || echo 'export PUPPETEER_SKIP_DOWNLOAD=true' >> "$SHELL_FILE"
  grep -qxF 'export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true' "$SHELL_FILE" || echo 'export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true' >> "$SHELL_FILE"
done

npm config delete puppeteer_skip_download >/dev/null 2>&1 || true
npm config delete puppeteer_skip_chromium_download >/dev/null 2>&1 || true

cat > "$PROJECT_DIR/.puppeteerrc.cjs" <<'APP'
module.exports = {
    skipDownload: true,
    chrome: {
        skipDownload: true
    },
    chromium: {
        skipDownload: true
    }
};
APP

status "Puppeteer configurado para no descargar Chromium."

step "[6/8] Capturando rutas del sistema..."

CHROMIUM_PATH=""
NODE_PATH="$(which node)"
NPM_PATH="$(which npm)"

if which chromium >/dev/null 2>&1; then
  CHROMIUM_PATH="$(which chromium)"
elif which chromium-browser >/dev/null 2>&1; then
  CHROMIUM_PATH="$(which chromium-browser)"
else
  error "No encontre chromium ni chromium-browser."
  echo ""
  echo -e "${YELLOW}Prueba manualmente:${RESET}"
  echo "  pkg install x11-repo -y"
  echo "  pkg update"
  echo "  pkg install chromium -y"
  exit 1
fi

export PUPPETEER_EXECUTABLE_PATH="$CHROMIUM_PATH"

for SHELL_FILE in "$HOME/.bashrc" "$HOME/.profile"; do
  grep -qxF "export PUPPETEER_EXECUTABLE_PATH=\"$CHROMIUM_PATH\"" "$SHELL_FILE" || echo "export PUPPETEER_EXECUTABLE_PATH=\"$CHROMIUM_PATH\"" >> "$SHELL_FILE"
done

status "Proyecto: $PROJECT_DIR"
status "Chromium: $CHROMIUM_PATH"
status "Node: $NODE_PATH"
status "NPM: $NPM_PATH"

step "[7/8] Instalando dependencias de Node en el proyecto..."

cd "$PROJECT_DIR"

if [ ! -f package.json ]; then
  error "No encontre package.json en $PROJECT_DIR."
  echo "Ejecuta este script desde la carpeta del proyecto."
  exit 1
fi

SETUP_WA_TERMUX=1 \
PUPPETEER_SKIP_DOWNLOAD=true \
PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
PUPPETEER_EXECUTABLE_PATH="$CHROMIUM_PATH" \
npm install whatsapp-web.js

status "whatsapp-web.js instalado."

SETUP_WA_TERMUX=1 \
PUPPETEER_SKIP_DOWNLOAD=true \
PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
PUPPETEER_EXECUTABLE_PATH="$CHROMIUM_PATH" \
npm install qrcode-terminal

status "qrcode-terminal instalado."

status "Dependencias de Node instaladas."

step "[8/8] Generando config.js con rutas de Termux..."

backup_file "config.js"

cat > config.js <<APP
module.exports = {
    prefix: '!',
    clientId: process.env.WHATSAPP_CLIENT_ID || 'termux-client',
    paths: {
        home: '$HOME',
        project: '$PROJECT_DIR',
        session: process.env.WHATSAPP_SESSION_PATH || '$PROJECT_DIR/.wwebjs_auth',
        chromium: process.env.PUPPETEER_EXECUTABLE_PATH || '$CHROMIUM_PATH',
        node: '$NODE_PATH',
        npm: '$NPM_PATH'
    },
    qr: {
        small: true
    },
    commands: {
        allowOwnMessages: true
    },
    puppeteer: {
        executablePath: process.env.PUPPETEER_EXECUTABLE_PATH || '$CHROMIUM_PATH',
        headless: true,
        handleSIGINT: false,
        handleSIGTERM: false,
        handleSIGHUP: false,
        args: [
            '--no-sandbox',
            '--disable-setuid-sandbox',
            '--disable-dev-shm-usage',
            '--disable-gpu',
            '--disable-extensions',
            '--disable-software-rasterizer',
            '--no-zygote',
            '--single-process',
            '--disable-features=site-per-process',
            '--disable-background-networking',
            '--disable-sync',
            '--metrics-recording-only',
            '--mute-audio'
        ]
    }
};
APP

node -c config.js
node -c index.js
status "config.js generado e index.js validado."

echo ""
echo -e "${MAGENTA}${BOLD}"
echo "======================================"
echo "          INSTALACION LISTA"
echo "======================================"
echo -e "${RESET}"

echo -e "${GREEN}Proyecto:${RESET} ${CYAN}$PROJECT_DIR${RESET}"
echo -e "${GREEN}Config:${RESET} ${CYAN}$PROJECT_DIR/config.js${RESET}"
echo -e "${GREEN}Chromium:${RESET} ${CYAN}$CHROMIUM_PATH${RESET}"
echo -e "${GREEN}Node:${RESET} $(node -v)"
echo -e "${GREEN}NPM:${RESET} $(npm -v)"
echo ""

echo -e "${YELLOW}Para arrancar el bot:${RESET}"
echo -e "${CYAN}npm start${RESET}"
echo ""

echo -e "${YELLOW}Si Chromium falla en headless, edita config.js y cambia:${RESET}"
echo -e "${CYAN}headless: true${RESET}"
echo -e "${YELLOW}por:${RESET}"
echo -e "${CYAN}headless: \"new\"${RESET}"
echo ""

echo -e "${YELLOW}Para dejarlo corriendo con tmux:${RESET}"
echo -e "${CYAN}pkg install tmux -y${RESET}"
echo -e "${CYAN}tmux new -s wa${RESET}"
echo -e "${CYAN}cd \"$PROJECT_DIR\" && npm start${RESET}"
echo ""

echo -e "${RED}${BOLD}Script hecho por Joshua Dev${RESET}"
echo -e "${MAGENTA}Neon setup complete.${RESET}"
echo ""
