# Unit Tests

This directory contains unit tests for FieldOps Support AI components.

## Testing Strategy (Week 2+)

### API Layer Tests
- **Authentication/Authorization**
  - Token validation
  - Role-based access control
  - Session management
- **Endpoint Tests**
  - Request/response validation
  - Error handling
  - Input sanitization
- **Business Logic**
  - Diagnostic flow logic
  - Escalation criteria
  - Data transformation

### Adapter Tests
- **Vendor Adapters**
  - Mock vendor API responses
  - Error handling and retries
  - Data mapping validation
- **Protocol Handlers**
  - SNMP query formatting
  - HTTP request building
  - Response parsing

### Database Layer Tests
- **Repository Pattern**
  - CRUD operations
  - Query optimization
  - Transaction handling
- **Data Models**
  - Validation rules
  - Serialization/deserialization
  - Relationships

## Test Structure
```
unit/
├── api/
│   ├── test_auth.py
│   ├── test_diagnostics.py
│   └── test_escalation.py
├── adapters/
│   ├── test_vendor_adapters.py
│   └── test_protocol_handlers.py
├── database/
│   ├── test_repositories.py
│   └── test_models.py
└── utils/
    ├── test_validators.py
    └── test_helpers.py
```

## Testing Tools
- **Python**: pytest, pytest-asyncio, pytest-mock
- **Coverage**: pytest-cov for coverage reporting
- **Mocking**: unittest.mock, responses
- **Database**: pytest-postgresql for test database

## Test Standards
- Minimum 80% code coverage
- All public methods must have tests
- Mock external dependencies
- Fast execution (<30s total)
- Isolated tests (no shared state)

## Running Tests
```bash
# Run all unit tests
pytest tests/unit/

# Run with coverage
pytest tests/unit/ --cov=services --cov-report=html

# Run specific test file
pytest tests/unit/api/test_diagnostics.py
```

## TODO
- [ ] Set up pytest configuration
- [ ] Create test fixtures and factories
- [ ] Implement API endpoint tests
- [ ] Add adapter unit tests
- [ ] Set up test database helpers
- [ ] Configure coverage reporting
