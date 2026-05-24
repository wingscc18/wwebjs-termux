module.exports = {
    name: 'ping',
    aliases: ['p'],
    description: 'Responde pong para probar que el bot esta activo.',
    async execute(client, message) {
        await message.reply('pong');
    }
};
