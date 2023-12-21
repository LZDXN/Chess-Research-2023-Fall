import Pkg
Pkg.add("PyCall")
Pkg.add("Pandas")
Pkg.add("CSV")
Pkg.add("DataFrames")

Pkg.build("PyCall")
Pkg.build("Pandas")
Pkg.build("CSV")
Pkg.build("DataFrames")