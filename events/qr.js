module.exports = {
    name: 'qr',
    execute(client, context, qr) {
        console.log('');
        console.log('Escanea este QR con WhatsApp:');
        context.qrcode.generate(qr, { small: context.config.qr.small });
        console.log('\x1b[1;91m%s\x1b[0m', 'Si el QR no se ve bien, haz zoom hacia atras con dos dedos en la terminal para verlo completo.');
    }
};
