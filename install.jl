using Pkg

Pkg.add(PackageSpec(name="IJulia", version="1.24.2"))
Pkg.add(PackageSpec(name="PyCall", version="1.96.2"))
Pkg.add(PackageSpec(name="CSV", version="0.10.11"))
Pkg.add(PackageSpec(name="DataFrames", version="1.6.1"))

Pkg.build("IJulia")
Pkg.build("PyCall")
Pkg.build("CSV")
Pkg.build("DataFrames")