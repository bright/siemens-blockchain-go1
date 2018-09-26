/* global getFactory getAssetRegistry emit */

/**
 * Execute transaction that updates production batch status
 * @param {org.manufactureStorage.UpdateProductionBatchStatus} updateBatchTx - batch update transaction
 * @transaction
 */
async function changeBatchCertificationStatus(updateProductionBatchStatus) {
    const newStatus = updateProductionBatchStatus.newBatchStatus;
    const batch = updateProductionBatchStatus.batch;
    batch.batchStatus = newStatus;

    const registry = await getAssetRegistry('org.manufactureStorage.ProductionBatch');
    await registry.update(batch);

    const event = getFactory().newEvent('org.manufactureStorage', 'UpdateProductionBatchEvent');
    event.batchStatus = newStatus;
    event.batch = batch;
    emit(event);
}
