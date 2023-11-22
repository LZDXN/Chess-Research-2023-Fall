using Pkg
Pkg.add(PackageSpec(name="IJulia", version="1.24.2"))
Pkg.add(PackageSpec(name="ProgressMeter", version="1.9.0"))
Pkg.add(PackageSpec(name="PyCall", version="1.96.2"))

Pkg.build("IJulia")
Pkg.build("ProgressMeter")
Pkg.build("PyCall")