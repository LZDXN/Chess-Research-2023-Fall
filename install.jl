# download and compile Pycall and Pandas to use python
import Pkg
Pkg.add("PyCall")
Pkg.add("Pandas")
# Pkg.add("DataStructures")
Pkg.add("ProgressMeter")

Pkg.build("PyCall")
Pkg.build("Pandas")
# Pkg.build("DataStructures")
Pkg.build("ProgressMeter")

