pragma solidity ^0.4.25;

contract ManufactureStorage {

    struct ProductionBatch {
        uint designId;
        uint jobId;
        string machineId;
    }

    ProductionBatch batch;


    constructor() public {
        batch = ProductionBatch({designId : 12321, jobId : 345, machineId : "IE23V3"});
    }

    function getBatch() public view returns (uint designId, uint jobId, string machineId) {
        designId = batch.designId;
        jobId = batch.jobId;
        machineId = batch.machineId;
    }

}