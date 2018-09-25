pragma solidity ^0.4.25;

contract ExtendedManufactureStorage {

    struct ProductionBatch {
        uint designId;
        uint jobId;
        string machineId;
    }

    mapping(uint => ProductionBatch) batches;


    function addBatch(uint designId, uint jobId, string machineId) public returns (bool success) {
        ProductionBatch memory batchToBeSaved = ProductionBatch({designId : designId, jobId : jobId, machineId : machineId});
        batches[jobId] = batchToBeSaved;
        emit BatchAdded(jobId);
        success = true;
    }

    function getBatch(uint batchJob) public view returns (uint designId, uint jobId, string machineId) {
        ProductionBatch storage batchToBeRetrieved = batches[batchJob];
        designId = batchToBeRetrieved.designId;
        jobId = batchToBeRetrieved.jobId;
        machineId = batchToBeRetrieved.machineId;
    }

    event BatchAdded(uint jobId);
}