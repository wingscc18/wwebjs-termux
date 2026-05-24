const { handleCommand } = require('../handlers/commandRunner');

module.exports = {
    name: 'message',
    async execute(client, context, message) {
        await handleCommand(client, context, message);
    }
};
