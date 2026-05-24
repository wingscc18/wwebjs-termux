module.exports = {
    name: 'qr',
    execute(client, context, qr) {
        console.log('');
        console.log('Escanea este QR con WhatsApp:');
        context.qrcode.generate(qr, { small: context.config.qr.small });
    }
};
