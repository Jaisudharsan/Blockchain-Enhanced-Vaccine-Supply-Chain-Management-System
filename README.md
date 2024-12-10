# Blockchain-Enhanced-Vaccine-Supply-Chain-Management-System

This project implements a **Blockchain-based Regulatory and Vaccine Management System** using Solidity. It consists of three smart contracts:

1. **RegulatoryAuthority Contract**:
   - Manages company registrations with unique identifiers generated using Keccak-256 hashing.
   - Ensures companies meet specific quality, manufacturing, and compliance standards before registration.

2. **VaccineRegistration Contract**:
   - Allows registered companies to register vaccines with manufacturing and expiry dates.
   - Tracks vaccine distribution to distributors and pharmacies for transparency.

3. **Consumer Contract**:
   - Enables consumers to view detailed vaccine information, including distributor and pharmacy details.

### Key Features:
- Secure and immutable company and vaccine registration.
- Unique identifiers using Keccak-256 hashing for efficient storage.
- Transparent vaccine distribution tracking.
- Gas-optimized design for cost-efficiency.
