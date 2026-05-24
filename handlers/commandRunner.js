async function handleCommand(client, context, message) {
    const prefix = context.config.prefix;

    if (!message.body || !message.body.startsWith(prefix)) {
        return;
    }

    const content = message.body.slice(prefix.length).trim();

    if (!content) {
        return;
    }

    const args = content.split(/\s+/);
    const commandName = args.shift().toLowerCase();
    const command = context.commands.get(commandName);

    if (!command) {
        return;
    }

    await command.execute(client, message, args, context);
}

module.exports = { handleCommand };
