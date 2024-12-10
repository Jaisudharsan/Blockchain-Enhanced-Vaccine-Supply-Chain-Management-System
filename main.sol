// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract RegulatoryAuthority {
    struct Company {
        bool registered;
        bytes20 uniqueAddress;
    }

    mapping(string => Company) private companies;

    function registerCompany(
        string calldata name,
        uint8 qc,
        uint8 mf,
        uint8 rc
    ) external returns (string memory) {
        require(qc > 5, "Low quality control");
        
        Company storage company = companies[name];
        if (company.registered) {
            return string(abi.encodePacked(name, " already registered"));
        }

        bytes20 uniqueAddress = bytes20(keccak256(abi.encodePacked(name, (qc + mf + rc) / 3)));
        companies[name] = Company(true, uniqueAddress);

        return string(abi.encodePacked(name, " registered"));
    }

    function getCompanyInfo(string calldata name) external view returns (bool, bytes20) {
        Company storage company = companies[name];
        return (company.registered, company.uniqueAddress);
    }
}

contract VaccineRegistration {
    RegulatoryAuthority private regulatoryAuthority;

    struct Vaccine {
        string manufacturingDate;
        string expiryDate;
        string distributor;
        string pharmacy;
        bool registered;
    }

    mapping(string => Vaccine) private vaccines;

    constructor(address regulatoryAuthorityAddress) {
        regulatoryAuthority = RegulatoryAuthority(regulatoryAuthorityAddress);
    }

    function registerVaccine(
        string calldata company,
        string calldata vaccine,
        uint8 standard,
        string calldata manufacturingDate,
        string calldata expiryDate
    ) external returns (string memory) {
        require(standard > 5, "Low standard");

        (bool isRegistered, ) = regulatoryAuthority.getCompanyInfo(company);
        require(isRegistered, "Company not registered");

        vaccines[vaccine] = Vaccine(manufacturingDate, expiryDate, "", "", true);
        return string(abi.encodePacked(vaccine, " registered"));
    }

    function distributeVaccine(
        string calldata vaccine,
        string calldata distributor,
        string calldata pharmacy
    ) external {
        require(vaccines[vaccine].registered, "Not registered");

        Vaccine storage v = vaccines[vaccine];
        v.distributor = distributor;
        v.pharmacy = pharmacy;
    }

    function getVaccineInfo(string calldata vaccine)
        external view
        returns (
            string memory manufacturingDate,
            string memory expiryDate,
            string memory distributor,
            string memory pharmacy
        ) {
        require(vaccines[vaccine].registered, "Not registered");

        Vaccine storage v = vaccines[vaccine];
        return (v.manufacturingDate, v.expiryDate, v.distributor, v.pharmacy);
    }
}

contract Consumer {
    VaccineRegistration private vaccineRegistration;

    constructor(address vaccineRegistrationAddress) {
        vaccineRegistration = VaccineRegistration(vaccineRegistrationAddress);
    }

    function getVaccineDetails(string calldata vaccine)
        external view
        returns (
            string memory manufacturingDate,
            string memory expiryDate,
            string memory distributor,
            string memory pharmacy
        ) {
        return vaccineRegistration.getVaccineInfo(vaccine);
    }
}