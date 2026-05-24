const fs = require('fs');
const path = require('path');

function loadCommands(commandsPath) {
    const commands = new Map();
    const resolvedCommandsPath = path.resolve(commandsPath);

    if (!fs.existsSync(resolvedCommandsPath)) {
        return commands;
    }

    const files = fs.readdirSync(resolvedCommandsPath).filter(file => file.endsWith('.js'));

    for (const file of files) {
        const command = require(path.join(resolvedCommandsPath, file));

        if (!command.name || typeof command.execute !== 'function') {
            continue;
        }

        commands.set(command.name.toLowerCase(), command);
    }

    return commands;
}

module.exports = { loadCommands };
