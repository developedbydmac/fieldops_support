# Contract Tests

This directory contains contract tests for FieldOps Support AI vendor integrations.

## Testing Strategy (Week 2+)

Contract tests verify that our adapters correctly interface with external vendor systems and APIs. These tests ensure that vendor integrations continue to work as expected when vendor APIs change.

### Vendor API Contracts
- **Network Equipment Vendors**
  - SNMP MIB contracts
  - REST API schemas
  - Authentication mechanisms
- **Security System Vendors**
  - Camera API contracts
  - Access control interfaces
  - Event notification formats
- **Infrastructure Providers**
  - DHCP server interfaces
  - DNS service APIs
  - Network monitoring tools

### Test Categories
1. **Schema Validation**
   - Request/response structure validation
   - Data type verification
   - Required field presence

2. **Behavior Contracts**
   - Expected response codes
   - Error handling scenarios
   - Timeout behavior

3. **Authentication Contracts**
   - Login/logout flows
   - Token refresh mechanisms
   - Session management

## Test Structure
```
contract/
├── vendors/
│   ├── cisco/
│   │   ├── test_switch_api.py
│   │   └── test_snmp_mibs.py
│   ├── axis/
│   │   ├── test_camera_api.py
│   │   └── test_event_stream.py
│   └── hikvision/
│       ├── test_camera_api.py
│       └── test_config_api.py
├── infrastructure/
│   ├── test_dhcp_contracts.py
│   └── test_dns_contracts.py
└── schemas/
    ├── camera_events.json
    ├── switch_status.json
    └── dhcp_lease.json
```

## Contract Testing Tools
- **Pact**: Consumer-driven contract testing
- **JSON Schema**: Response validation
- **OpenAPI**: API specification testing
- **WireMock**: Mock vendor services

## Test Data Management
- **Test Fixtures**: Known vendor responses
- **Mock Services**: Simulated vendor environments
- **Schema Files**: JSON/XML schemas for validation
- **Test Scenarios**: Edge cases and error conditions

## Implementation Approach
1. **Consumer Tests**: Verify our adapters send correct requests
2. **Provider Tests**: Verify vendor responses match contracts
3. **Compatibility Tests**: Test against multiple vendor API versions
4. **Breaking Change Detection**: Alert on contract violations

## Running Contract Tests
```bash
# Run all contract tests
pytest tests/contract/

# Run vendor-specific tests
pytest tests/contract/vendors/cisco/

# Generate contract documentation
pact-broker publish --consumer-app-version=$VERSION
```

## TODO
- [ ] Set up Pact consumer/provider framework
- [ ] Create vendor API mock services
- [ ] Define JSON schemas for vendor responses
- [ ] Implement camera vendor contract tests
- [ ] Add network equipment contract tests
- [ ] Set up contract test CI pipeline
- [ ] Create contract documentation generator
