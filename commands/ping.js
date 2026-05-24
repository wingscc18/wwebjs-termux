module.exports = {
    name: 'ping',
    async execute(client, message) {
        await message.reply('pong');
    }
};
