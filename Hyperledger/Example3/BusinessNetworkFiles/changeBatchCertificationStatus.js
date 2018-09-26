/* global getFactory getAssetRegistry emit */

/**
 * Execute transaction that updates production batch status
 * @param {org.manufactureStorage.UpdateProductionBatchStatus} updateBatchTx - batch update transaction
 * @transaction
 */
async function changeBatchCertificationStatus(updateBatchTx) {
    console.log('Will change production batch status');
    const newStatus = updateBatchTx.batchStatus;
    console.log('New status', newStatus);
    let productionBatch = updateBatchTx.batch;
    productionBatch.batchStatus = newStatus;
    console.log('Updated production batch', productionBatch);
    const batchAssetsRegistry = await getAssetRegistry('org.manufactureStorage.ProductionBatch');
    console.log('Batch registry', batchAssetsRegistry);
    await batchAssetsRegistry.update(productionBatch);
    let event = getFactory().newEvent('org.manufactureStorage', 'UpdateProductionBatchEvent');
    event.batchStatus = newStatus;
    event.batch = productionBatch;
    emit(event);
}
