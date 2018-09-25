pragma solidity ^0.4.25;

contract ManufactureCertificationSystem {

    enum CertificationSeal  {ToBeCertified, Certified}

    address contractOwner;

    constructor() public {
        contractOwner = msg.sender;
    }

    struct ProductionBatch {
        uint designId;
        uint jobId;
        string machineId;
        CertificationSeal certificationState;
    }

    mapping(uint => ProductionBatch) batches;
    mapping(address => bool) certificationAuthorities;
    mapping(address => bool) manufacturesRepresentatives;


    modifier onlyRepresentative() {
        require(manufacturesRepresentatives[msg.sender], "Only manufacture representative can trigger this function");
        _;
    }

    modifier onlyCertificationAuthority() {
        require(certificationAuthorities[msg.sender], "Only certification authorities can trigger this function");
        _;
    }

    modifier onlyAuthorised() {
        require(certificationAuthorities[msg.sender] || manufacturesRepresentatives[msg.sender], "Only authorised entities can trigger this function");
        _;
    }

    modifier onlyOwner() {
        require(contractOwner == msg.sender, "Only owner of the contract can trigger this function");
        _;
    }

    modifier onlyForNotCertifiedBatch(uint jobId) {
        require(batches[jobId].certificationState == CertificationSeal.ToBeCertified, "This batch is already certified");
        _;
    }

    function addManufactureRepresentative(address representativeAddress) public onlyOwner returns (bool success)
    {
        manufacturesRepresentatives[representativeAddress] = true;
        emit ManufactureRepresentativeAdded(representativeAddress);
        success = true;
    }

    function addCertificationAuthority(address authorityAddress) public onlyOwner returns (bool success)
    {
        certificationAuthorities[authorityAddress] = true;
        emit CertificationAuthorityAdded(authorityAddress);
        success = true;
    }

    function addBatch(uint designId, uint jobId, string machineId) public onlyRepresentative onlyForNotCertifiedBatch(jobId) returns (bool success)
    {
        ProductionBatch memory batchToBeSaved = ProductionBatch({designId : designId, jobId : jobId, machineId : machineId, certificationState : CertificationSeal.ToBeCertified});
        batches[jobId] = batchToBeSaved;
        emit BatchAdded(jobId);
        success = true;
    }

    function certifyBatch(uint batchJob) public onlyCertificationAuthority returns (bool success)

    {
        ProductionBatch storage batchToBeRetrieved = batches[batchJob];
        batchToBeRetrieved.certificationState = CertificationSeal.Certified;
        emit BatchCertified(batchJob);
        success = true;
    }

    function getBatch(uint batchJob) public onlyAuthorised view returns (uint designId, uint jobId, string machineId, CertificationSeal certificationState)

    {
        ProductionBatch storage batchToBeRetrieved = batches[batchJob];
        designId = batchToBeRetrieved.designId;
        jobId = batchToBeRetrieved.jobId;
        machineId = batchToBeRetrieved.machineId;
        certificationState = batchToBeRetrieved.certificationState;
    }

    event BatchAdded(uint jobId);
    event BatchCertified(uint jobId);
    event ManufactureRepresentativeAdded(address representativeAddress);
    event CertificationAuthorityAdded(address certificationAddress);

}