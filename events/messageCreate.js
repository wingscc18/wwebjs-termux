const { handleCommand } = require('../handlers/commandRunner');

module.exports = {
    name: 'message_create',
    async execute(client, context, message) {
        if (!context.config.commands.allowOwnMessages || !message.fromMe) {
            return;
        }

        await handleCommand(client, context, message);
    }
};
