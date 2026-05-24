module.exports = {
    name: 'help',
    aliases: ['h', 'ayuda', 'comandos'],
    description: 'Muestra la lista de comandos disponibles.',
    async execute(client, message, args, context) {
        const prefix = context.config.prefix;
        const commands = context.commands.list || [];
        const lines = commands.map(command => {
            const aliases = command.aliases && command.aliases.length
                ? command.aliases.map(alias => `${prefix}${alias}`).join(', ')
                : 'Sin alias';
            const description = command.description || 'Sin descripcion.';

            return `${prefix}${command.name}\nAlias: ${aliases}\n${description}`;
        });

        await message.reply(`Comandos disponibles:\n\n${lines.join('\n\n')}`);
    }
};
