import Pkg
Pkg.add("PyCall")
Pkg.add("Pandas")
Pkg.add("ProgressMeter")
Pkg.add("CSV")
Pkg.add("DataFrames")


Pkg.build("PyCall")
Pkg.build("Pandas")
Pkg.build("ProgressMeter")
Pkg.build("CSV")
Pkg.build("DataFrames")