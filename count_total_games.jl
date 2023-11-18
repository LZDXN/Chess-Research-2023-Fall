# import julia libraries
using PyCall
using Random
using ProgressMeter

@pyimport chess
cp = pyimport("chess.pgn")

# define a pipeline struct
struct Pipeline
    filename::String  # Filename of the total large file
    export_path::String  # The folder of the exporting files
    seed::Int  # Seed for the randomness control
    total_games::Int  # Total number of games in the file
    games_per_cell::Int  # Number of games in each cell in the table
    cells::Matrix{Int}  # 2D matrix to track the number of games in each cell

    # Constructor to initialize cells
    function Pipeline(filename::String, export_path::String, seed::Int, total_games::Int, games_per_cell::Int)
        new(filename, export_path, seed, total_games, games_per_cell, fill(0, 3, 3))
    end

end

function count_total_games(pipeline::Pipeline)::Pipeline
    count = 1
    open(pipeline.filename, "r") do pgn
        # Check file size
        seekend(pgn)
        fileSize = position(pgn)
        seekstart(pgn)

        # Initialize variable

        # Initialize progress bar
        file_scaning_progress = Progress(fileSize; dt=1.0, desc="Scanning Process...")

        while !eof(pgn)
            cp.read_game(pgn)
            count += 1
            
            # Update file progress bar
            ProgressMeter.update!(file_scaning_progress, position(pgn))

        end
    end
    pipeline.total_games = count
    println("pipeline.total_games = $(pipeline.total_games)")
    return pipeline
end

# File name of the original decompressed file
filename = "./data/lichess_db_standard_rated_2023-09.pgn"

# The seed for the randomness control in this project
seed = 2023

# Export path
export_path = "./data/exported/"

# Pipeline struct
# Initialize with filename, export_path, seed, total_games, and games_per_cell

# Count total game
pipeline = Pipeline(filename, export_path, seed, 93218629, 3000)
count_total_games(pipeline) # (filename, seed, total_games, games_per_cell)