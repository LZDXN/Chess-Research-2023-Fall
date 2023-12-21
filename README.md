# Chess Data Analysis with Stockfish
This repository contains tools and scripts to download, select, and process games from Lichess using Stockfish. We aim to analyze approximately 27,000 games based on different player ELO ratings and time controls.

## Table of Contents
- [Chess Data Analysis with Stockfish](#chess-data-analysis-with-stockfish)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Setup](#setup)
    - [Ubuntu Server Setup](#ubuntu-server-setup)
    - [Stockfish Setup](#stockfish-setup)
    - [Environment Setup](#environment-setup)
      - [1. Install Julia:](#1-install-julia)
      - [2. Install Julia and Python Packages:](#2-install-julia-and-python-packages)
  - [Data Collection and Processing](#data-collection-and-processing)
- [Expected Output](#expected-output)

## Requirements
- Ubuntu (preferably the latest version)
- Python (Version 3.x)
- Stockfish Engine
- Julia and the `PyCall` package
- Internet connection for downloading games from Lichess

## Setup

### Ubuntu Server Setup
```bash
# Update and upgrade packages
sudo apt-get update
sudo apt-get upgrade

# Install necessary tools
sudo apt-get install python3 python3-pip
```

### Stockfish Setup

1. **Clone the Stockfish Repository**:
```bash
git clone https://github.com/official-stockfish/Stockfish.git
```

2. **Navigate to the Stockfish Source Directory**:
```bash
cd Stockfish/src
```

3. **Compile Stockfish**:
For most modern CPUs on 64-bit systems:
```bash
make -j profile-build ARCH=x86-64-avx2
```

If unsure about your architecture or the right target, refer to Stockfish's [official documentation](https://github.com/official-stockfish/Stockfish) for guidance.

### Environment Setup

#### 1. Install Julia:
- **Linux**:
```bash
sudo apt-get update
wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.4-linux-x86_64.tar.gz
tar zxvf julia-1.9.4-linux-x86_64.tar.gz
export PATH="$PATH:/path/to/<Julia directory>/bin"
```

#### 2. Install Julia and Python Packages:
```bash
# Clone the repository
git clone https://github.com/LZDXN/Chess-Research-2023-Fall.git

# Navigate to the repository
cd Chess-Research-2023-Fall/

# Install required Julia libraries
julia install.jl

# Install required Python libraries
pip3 install -r requirements.txt
```

## Data Collection and Processing
1. **Data Source**: 
   - Download the data from [Lichess September 2023 dataset](https://database.lichess.org/).
2. **Data Collection**: 
   - Focus on specific time controls and ELO ranges as detailed in the instructions.
3. **Data Processing**: 
   - Use Stockfish to evaluate each position in the selected games. 
   - Retrieve evaluations for the move played in the game and the top 5 recommended moves by Stockfish.

# Expected Output
![](./documents/Pipeline_one.md)