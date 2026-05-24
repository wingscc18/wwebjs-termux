const fs = require('fs');
const path = require('path');

const configPath = path.join(__dirname, 'config.js');

function requireInstalled(packageName) {
    try {
        require.resolve(packageName);
    } catch (error) {
        console.error(`Falta ${packageName}. Primero instala y configura el proyecto en Termux con:`);
        console.error('chmod +x setup-wa-termux.sh');
        console.error('./setup-wa-termux.sh');
        process.exit(1);
    }
}

if (!fs.existsSync(configPath)) {
    console.error('Falta config.js. Primero configura el proyecto en Termux con:');
    console.error('chmod +x setup-wa-termux.sh');
    console.error('./setup-wa-termux.sh');
    process.exit(1);
}

requireInstalled('whatsapp-web.js');
requireInstalled('qrcode-terminal');

const qrcode = require('qrcode-terminal');
const { Client, LocalAuth } = require('whatsapp-web.js');
const config = require('./config');
const { loadCommands } = require('./handlers/commands');
const { loadEvents } = require('./handlers/events');

const sessionPath = path.isAbsolute(config.paths.session)
    ? config.paths.session
    : path.resolve(__dirname, config.paths.session);

const client = new Client({
    authStrategy: new LocalAuth({
        clientId: config.clientId,
        dataPath: sessionPath,
        rmMaxRetries: 5
    }),
    puppeteer: config.puppeteer
});

const commands = loadCommands(path.join(__dirname, 'commands'));
loadEvents(client, path.join(__dirname, 'events'), { commands, config, qrcode });

client.initialize().catch(error => {
    console.error('Error al iniciar el cliente:', error);
    process.exit(1);
});

let isShuttingDown = false;

function closeBrowserSilently() {
    const browserProcess = client.pupBrowser && client.pupBrowser.process();

    if (!browserProcess || !browserProcess.pid) {
        return;
    }

    browserProcess.kill('SIGTERM');
}

function shutdown() {
    if (isShuttingDown) {
        return;
    }

    isShuttingDown = true;
    console.log('Cliente detenido. La sesion queda guardada.');
    closeBrowserSilently();
    process.exit(0);
}

process.once('SIGINT', shutdown);
process.once('SIGTERM', shutdown);
