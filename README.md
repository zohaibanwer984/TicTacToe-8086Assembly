# Tic-Tac-Toe in NASM Assembly for 8086

A console-based Tic-Tac-Toe game for two players, meticulously crafted in NASM assembly tailored for the 8086 microprocessor.

## 📌 Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Running the Game](#running-the-game)
- [Code Structure](#code-structure)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)
- [About the Author](#about-the-author)

## 🎮 Features

- Classic Tic-Tac-Toe experience in the console.
- Switching gameplay between 'O' and 'X'.
- Full-fledged input validation.
- Immediate win condition checks.
- Replay option after game completion.

## 🚀 Getting Started

### Prerequisites

NASM
DOSBOX for emulation of 8086

### Running the Game

1. Compile the assembly code:

```
nasm game_x16.asm -o game_x16.com
```

2. Execute the compiled output:

```
game_x16.com
```

## 🔍 Code Structure

The game's source is segmented for clarity:

- **Data Section**: Contains game UI components, board, and various messages.
- **Code Section**: Holds the game logic, input handling, board display, and win checks.

## 🤝 Contributing

Contributions, bug reports, and feature requests are welcome! See the [issues](./issues) page if you want to contribute.

## 📜 License

This project is open-source, under the MIT License. Check out the [LICENSE](./LICENSE) file for more details.

## 👤 About the Author

**Zohaibanwer984**: A devotee of assembly and Tic-Tac-Toe!
- GitHub: [@zohaibanwer984](https://github.com/zohaibanwer984)
