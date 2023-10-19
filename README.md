# Chess Data Analysis with Stockfish
This repository contains tools and scripts to download, select, and process games from Lichess using Stockfish. We aim to analyze approximately 27,000 games based on different player ELO ratings and time controls.

## Table of Contents
- [Chess Data Analysis with Stockfish](#chess-data-analysis-with-stockfish)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Setup](#setup)
    - [Ubuntu Server Setup](#ubuntu-server-setup)
    - [Environment Setup](#environment-setup)
    - [Docker Setup (TODO: Optional)](#docker-setup-todo-optional)
  - [Data Collection and Processing](#data-collection-and-processing)
  - [Expected Output (TODO)](#expected-output-todo)

## Requirements
- Ubuntu (preferably the latest version)
- Python (Version 3.x)
- Stockfish Engine
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

### Environment Setup
```bash
# Clone the repository
git clone https://github.com/LZDXN/Chess-Research-2023-Fall.git

# Navigate to the repository
cd Chess-Research-2023-Fall/

# Install required Python libraries
pip3 install -r requirements.txt

# Download and set up Stockfish
# [TODO: Add instructions for Stockfish setup]
```

### Docker Setup (TODO: Optional)
Docker can be utilized to make the setup and execution more streamlined. We'll provide Docker configurations in the future. If you're experienced with Docker, feel free to contribute!

## Data Collection and Processing
1. **Data Source**: 
   - Download the data from [Lichess September 2023 dataset](https://database.lichess.org/).
   
2. **Data Collection**: 
   - Focus on specific time controls and ELO ranges as detailed in the instructions.
   
3. **Data Processing**: 
   - Use Stockfish to evaluate each position in the selected games. 
   - Retrieve evaluations for the move played in the game and the top 5 recommended moves by Stockfish.

## Expected Output (TODO)