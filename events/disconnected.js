module.exports = {
    name: 'disconnected',
    execute(client, context, reason) {
        console.log('Cliente desconectado:', reason);
    }
};
