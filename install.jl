import Pkg
Pkg.add("PyCall")
Pkg.add("Pandas")
Pkg.add("ProgressMeter")

Pkg.build("PyCall")
Pkg.build("Pandas")
Pkg.build("ProgressMeter")

