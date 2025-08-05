# 🧪 Tests

This folder contains all test files for the Terminal of the Ancients project.

## Test Files

### Shell Scripts
- **`simple_test.sh`** - Basic functionality test (build, help command)
- **`test_game_functionality.sh`** - Tests game commands (status, reset, jump, initiate)
- **`test_game.sh`** - Comprehensive game testing
- **`test_shellout.sh`** - Tests Subprocess integration
- **`run_all_tests.sh`** - Runs all tests and provides summary

### Swift Scripts
- **`test_service_layer.swift`** - Tests the GameDataService functionality
- **`test_water_visualization.swift`** - Tests water level visualization

### Documentation
- **`SERVICE_LAYER_TEST_RESULTS.md`** - Test results and analysis

## Running Tests

### Run All Tests
```bash
cd Tests
./run_all_tests.sh
```

### Run Individual Tests
```bash
cd Tests
./simple_test.sh
./test_game_functionality.sh
./test_game.sh
./test_shellout.sh
```

### Run Swift Tests
```bash
cd Tests
swift test_service_layer.swift
swift test_water_visualization.swift
```

## Test Structure

All test scripts automatically:
1. Check they're running from the Tests directory
2. Change to the project root directory
3. Build the project if needed
4. Run their specific tests
5. Provide clear pass/fail output

## Notes

- Tests are designed to be run from the `Tests/` directory
- All scripts automatically handle directory navigation
- Tests use color-coded output for easy reading
- Failed tests provide detailed error information 