# Chess Data Analysis with Stockfish
This repository contains tools and scripts to download, select, and process games from Lichess using Stockfish. We aim to analyze approximately 27,000 games based on different player ELO ratings and time controls.

## Table of Contents
- [Chess Data Analysis with Stockfish](#chess-data-analysis-with-stockfish)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Setup](#setup)
    - [Ubuntu Server Setup](#ubuntu-server-setup)
    - [Stockfish Setup](#stockfish-setup)
    - [Julia Environment Setup](#julia-environment-setup)
      - [1. Install Julia:](#1-install-julia)
      - [2. Install Julia Packages:](#2-install-julia-packages)
      - [3. Integrate with Python:](#3-integrate-with-python)
      - [4. Additional Julia Packages:](#4-additional-julia-packages)
      - [5. Verify Integration:](#5-verify-integration)
      - [6. Jupyter Notebook Integration (Optional):](#6-jupyter-notebook-integration-optional)
    - [Environment Setup (Python and Julia)](#environment-setup-python-and-julia)
    - [Docker Setup (TODO: Optional)](#docker-setup-todo-optional)
  - [Data Collection and Processing](#data-collection-and-processing)
  - [Expected Output (TODO)](#expected-output-todo)

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
   make -j build ARCH=x86-64-modern
   ```

   If unsure about your architecture or the right target, refer to Stockfish's [official documentation](https://github.com/official-stockfish/Stockfish) for guidance.

### Julia Environment Setup

#### 1. Install Julia:
- **Linux**:
  ```bash
  sudo apt-get update
  sudo apt-get install julia
  ```

#### 2. Install Julia Packages:
Start Julia by typing `julia` in your terminal.

```julia
using Pkg
Pkg.add("PyCall")
```

#### 3. Integrate with Python:
Set the `PYTHON` environment variable in Julia if needed:

```julia
ENV["PYTHON"] = "/path_to_desired_python"
using Pkg
Pkg.build("PyCall")
```

#### 4. Additional Julia Packages:

```julia
Pkg.add("DataFrames")
Pkg.add("Plots")
```

#### 5. Verify Integration:

```julia
using PyCall
np = pyimport("numpy")
```

#### 6. Jupyter Notebook Integration (Optional):

```julia
Pkg.add("IJulia")
```

### Environment Setup (Python and Julia)
```bash
# Clone the repository
git clone https://github.com/LZDXN/Chess-Research-2023-Fall.git

# Navigate to the repository
cd Chess-Research-2023-Fall/

# Install required Python libraries
pip3 install -r requirements.txt
```

### [Docker Setup (TODO: Optional)](./Docker.md)

## Data Collection and Processing
1. **Data Source**: 
   - Download the data from [Lichess September 2023 dataset](https://database.lichess.org/).
   
2. **Data Collection**: 
   - Focus on specific time controls and ELO ranges as detailed in the instructions.
   
3. **Data Processing**: 
   - Use Stockfish to evaluate each position in the selected games. 
   - Retrieve evaluations for the move played in the game and the top 5 recommended moves by Stockfish.

## Expected Output (TODO)
