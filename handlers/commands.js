const fs = require('fs');
const path = require('path');

function loadCommands(commandsPath) {
    const commands = new Map();
    const commandList = [];
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

        const name = command.name.toLowerCase();
        const aliases = Array.isArray(command.aliases) ? command.aliases : [];

        command.aliases = aliases.map(alias => alias.toLowerCase());
        commands.set(name, command);

        for (const alias of command.aliases) {
            commands.set(alias, command);
        }

        commandList.push(command);
    }

    commands.list = commandList;

    return commands;
}

module.exports = { loadCommands };
