module.exports = {
    name: 'auth_failure',
    execute(client, context, message) {
        console.error('Error de autenticacion:', message);
    }
};
