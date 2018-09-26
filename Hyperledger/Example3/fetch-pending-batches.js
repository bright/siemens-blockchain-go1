const BusinessNetworkConnection = require('composer-client').BusinessNetworkConnection;

async function main() {
    const bizNetConnection = new BusinessNetworkConnection();
    const businessNetworkDefinition = await bizNetConnection.connect('admin@manufacture-certification-system');
    const pendingBatches = await bizNetConnection.query('PendingBatches');
    console.log('PendingBatches', pendingBatches);
    await bizNetConnection.disconnect();
}


main().catch((error) => {
    console.error('Failed', error)
    return process.exit(1);
});