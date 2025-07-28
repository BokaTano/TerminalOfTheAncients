# 🛠️ Development Guide

## Quick Start

### Using the Build Script

Instead of manually running `swift build` and then the executable, use the convenient build script:

```bash
# Build and run the game
./build_and_run.sh

# Build and run with specific flags
./build_and_run.sh --initiate
./build_and_run.sh --reset
./build_and_run.sh --status

# Build and run with custom arguments
./build_and_run.sh --help
```

### Benefits

- **One Command**: Build and run in a single command
- **Error Handling**: Automatically exits if build fails
- **Helpful Tips**: Shows usage hints
- **Consistent**: Always builds before running

## New Features

### ShellOut Integration

The game now includes a new puzzle that demonstrates ShellOut usage:

**Puzzle 6: The Shell Script Ritual**
- Teaches shell script execution from Swift
- Uses the [ShellOut](https://github.com/JohnSundell/ShellOut) library
- Validates that the build script can be executed
- Introduces automation concepts

### How It Works

The puzzle uses ShellOut to:
1. Execute the `build_and_run.sh` script
2. Verify the script runs successfully
3. Accept "automation" as the correct answer

This demonstrates how Swift can interact with shell commands and scripts.

## Development Workflow

1. **Make Changes**: Edit Swift files
2. **Test**: Run `./build_and_run.sh --status` to check current state
3. **Play**: Run `./build_and_run.sh` to play the game
4. **Reset**: Use `./build_and_run.sh --reset` to start fresh

## Dependencies

The project now includes:
- **ShellOut**: For shell command execution
- **ArgumentParser**: For CLI argument handling
- **Rainbow**: For colored terminal output
- **SwiftData**: For progress persistence

## Puzzle Structure

The game now has 7 puzzles:
1. The Sigil Compiler
2. Welcome Ritual
3. The Echo Chamber
4. The File of Truth
5. The JSON Codex
6. **The Shell Script Ritual** (NEW)
7. The Vault Gate

## Tips for Development

- Use `./build_and_run.sh --initiate` to skip the first puzzle during testing
- The build script automatically handles permissions for shell scripts
- All puzzle files are created automatically when the game starts
- Progress is saved using SwiftData for persistence 