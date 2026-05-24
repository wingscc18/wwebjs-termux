async function handleCommand(client, context, message) {
    const prefix = context.config.prefix;

    if (!message.body || !message.body.startsWith(prefix)) {
        return;
    }

    const args = message.body.slice(prefix.length).trim().split(/\s+/);
    const commandName = args.shift().toLowerCase();
    const command = context.commands.get(commandName);

    if (!command) {
        return;
    }

    await command.execute(client, message, args, context);
}

module.exports = { handleCommand };
