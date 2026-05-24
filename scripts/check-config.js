const fs = require('fs');
const path = require('path');

const configPath = path.join(__dirname, '..', 'config.js');

if (!fs.existsSync(configPath)) {
    console.log('');
    console.log('Falta config.js. Para configurar rutas de Termux ejecuta:');
    console.log('chmod +x setup-wa-termux.sh');
    console.log('./setup-wa-termux.sh');
    console.log('');
}
