const fs = require('fs');
const path = require('path');

function loadEvents(client, eventsPath, context = {}) {
    const resolvedEventsPath = path.resolve(eventsPath);

    if (!fs.existsSync(resolvedEventsPath)) {
        return;
    }

    const files = fs.readdirSync(resolvedEventsPath).filter(file => file.endsWith('.js'));

    for (const file of files) {
        const event = require(path.join(resolvedEventsPath, file));

        if (!event.name || typeof event.execute !== 'function') {
            continue;
        }

        const handler = (...args) => event.execute(client, context, ...args);

        if (event.once) {
            client.once(event.name, handler);
        } else {
            client.on(event.name, handler);
        }
    }
}

module.exports = { loadEvents };
