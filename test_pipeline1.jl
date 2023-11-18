# import julia libraries
using PyCall
using Random
using ProgressMeter
# using DataStructures
# using Pandas

# import python libraries
# np = pyimport("numpy")

# if "invalid redefinition of constant chess" error pops out
# try to clear cache and restart the session
@pyimport chess
cp = pyimport("chess.pgn")

struct Pipeline
    filename::String        # Filename of the total large file
    export_path::String     # The folder of the exporting files
    seed::Int               # Seed for the randomness control
    total_games::Int        # Total number of games in the file
    games_per_cell::Int     # Number of games in each cell in the table
    round_draw_numbers::Int # Number of random indices to draw each round
    cells::Matrix{Int}      # 2D matrix to track the number of games in each cell

    function Pipeline(filename::String, export_path::String, seed::Int, total_games::Int, games_per_cell::Int, round_draw_numbers::Int)
        new(filename, export_path, seed, total_games, games_per_cell, round_draw_numbers, fill(0, 3, 3))
    end
end


function random_arr(pipeline::Pipeline, start_nth::Int, n::Int)::Vector{Int32}
    # 1-indexed
    Random.seed!(pipeline.seed)
    rand(1:pipeline.total_games, start_nth - 1)
    return rand(1:pipeline.total_games, n)
end

function write_file(filename::String, game)
    
    # Check if the file exists
    file_mode = isfile(filename) ? "a" : "w"

    # Open the file with appropriate mode
    open(filename, file_mode) do new_pgn
        # Create an exporter instance
        exporter = cp.FileExporter(new_pgn)
        
        # Use the game.accept method to write the game to the file
        game.accept(exporter)
    end
end


# helper method of check_criteria()
function time_and_elo(headers)
    time_control = get(headers, "TimeControl")
    WhiteElo = parse(Int64, get(headers, "WhiteElo"))
    BlackElo = parse(Int64, get(headers, "BlackElo"))

    return time_control, WhiteElo, BlackElo
end

function check_criteria(game)
    # criteria (will set as parameter in future)
    valid_time = ["180+0", "600+0", "1800+0"]
    elo_ranges = [(1250, 1350), (1750, 1850), (2150, Inf)]

    # time groups:
    # 0 - Invalid time group
    # 1 - Blitz: 180+0 seconds (3 minutes)
    # 2 - Rapid: 600+0 seconds (10 minutes)
    # 3 - Classical: 1800+0 seconds (30 minutes)

    time_group = 0

    # valid elo groups:
    # 0 - Invalid time group
    # 1 - Beginners: 1250-1350
    # 2 - Intermediate: 1750-1850
    # 3 - Expert: Above 2150

    elo_group = 0

    # get data from the game header
    time_control, player1_elo, player2_elo = time_and_elo(game.headers)

    for time in 1:length(valid_time)
        if (cmp(valid_time[time], time_control) == 0)
            time_group = time
        end
    end

    for elo in 1:length(elo_ranges)
        if ((elo_ranges[elo][1] < player1_elo) && (player1_elo < elo_ranges[elo][2]) && (elo_ranges[elo][1] < player2_elo) && (player2_elo < elo_ranges[elo][2]))
            elo_group = elo
        end
    end

    return time_group, elo_group
end

function game_cell_filename(criteria_result)::String
    time_group, elo_group = criteria_result

    # Mapping time groups to their string representations
    time_control = if time_group == 1
        "blitz"
    elseif time_group == 2
        "rapid"
    elseif time_group == 3
        "classical"
    end

    # Mapping ELO groups to their string representations
    elo_range = if elo_group == 1
        "beginner"
    elseif elo_group == 2
        "intermediate"
    elseif elo_group == 3
        "expert"
    end

    filename = "$(time_control)_$(elo_range).pgn"

    return filename
end


function loop_workflow(pipeline::Pipeline, cell_status::Matrix{Bool}, random_indices::Vector{Int32})::Pipeline
    # Initialize indexes
    index = 1 # current file reading process
    rand_in = 1 # the randomed arr index

    open(pipeline.filename, "r") do pgn

        # Check sizes
        seekend(pgn)
        fileSize = position(pgn)
        seekstart(pgn)
        indices_size = length(random_indices)
        
        # Initialize progress bar
        file_scaning_progress = Progress(fileSize; dt=1.0, desc="Current Round Progress...")
        fetch_arr_game_progress = Progress(indices_size; dt=1.0, desc="Selected game in array...")

        while !eof(pgn)
            game = cp.read_game(pgn)
            index += 1

            # Update file progress bar
            ProgressMeter.update!(file_scaning_progress, position(pgn))

            # in case of overflow error
            if rand_in > length(random_indices)
                continue
            end

            # check if the game is the chosen one
            if index != random_indices[rand_in]
                continue
            end

            # increment the random arr index by 1
            rand_in += 1

            # Update random arr index progress bar
            ProgressMeter.update!(fetch_arr_game_progress, rand_in)

            # Check the game's criteria to see if the game satisfies the condition
            criteria_result = check_criteria(game)

            # If the game satisfies the condition
            if all(x -> x != 0, criteria_result)
                if !cell_status[criteria_result...]
                    filename = game_cell_filename(criteria_result)
                    write_file(joinpath(pipeline.export_path, filename), game)
                    pipeline.cells[criteria_result...] += 1
                end
            end

        end

        # rand_in -= 1
    
    end
    
    # println("Total number of game in file: $index");
    # println("Index of last game read in file $(random_indices[rand_in]), the $rand_in th number of this randomed arr");
    
    return pipeline

end

function main(pipeline::Pipeline)
    # Initialize a 3x3 boolean matrix for cell status (false = open, true = closed)
    cell_status = fill(false, 3, 3)

    current_index = 1
    drawn_numbers = Set{Int32}()

    # While not all cells are closed
    while any(!cell for cell in cell_status)
        # Start a new round
        println("----------------------------—----------------------------—")
        println("Start a new round, seed drawing number from $current_index")
        println("----------------------------—----------------------------—")
        
        # Call the random_arr from 1 to the total games in the file 
        # to get 100,000 random numbers as the game index
        # also time it
        @time new_indices = unique(sort(random_arr(pipeline, current_index, pipeline.round_draw_numbers)))

        # Filter out indices that have already been drawn
        random_indices = filter(idx -> !(idx in drawn_numbers), new_indices)
        if isempty(random_indices)
            println("random indices is 0, quiting the program...")
            return
        end

        println("Finish drawing and sorting process")
        
        # Add the new indices to the drawn numbers set
        union!(drawn_numbers, random_indices)

        println("Start loop workflow...")
        # read and write games in the loop workflow and then update pipeline cells
        pipeline = loop_workflow(pipeline, cell_status, random_indices)

        # Check if each cell reaches or exceeds the condition (e.g., 3000)
        # If so, mark the cell as closed
        for i in 1:size(pipeline.cells, 1)
            for j in 1:size(pipeline.cells, 2)
                if pipeline.cells[i, j] >= pipeline.games_per_cell
                    cell_status[i, j] = true
                end
            end
        end

        # size for report
        random_indices_size = length(random_indices)
        drawn_numbers_size = length(drawn_numbers)

        println("Drew unique number $random_indices_size this round, current total drawn number size: $drawn_numbers_size")
        current_index += pipeline.round_draw_numbers
    end

    println("Work finished! I know, finally! (but it is just the first pipeline...)");
    # After all cells are closed, leave cells over-filled
    # Additional random draw logic (if needed) goes here
end


# File name of the original decompressed file
test_filename = "./test100000.pgn"

# The seed for the randomness control in this project
test_seed = 2026

# Export path
test_export_path = "./data/test_exported/"

# Total games
test_total_games = 100000

# Games per cell
test_games_per_cell = 1

# Number of random indices to draw each round
test_round_draw_numbers = 1000

# Pipeline struct
# Initialize with filename, export_path, seed, total_games, and games_per_cell, round_draw_numbers
test_pipeline = Pipeline(test_filename, test_export_path, test_seed, test_total_games, test_games_per_cell, test_round_draw_numbers)

@time main(test_pipeline)
