module MLJTime

# IMPORTS
using IndexedTables, CSVFiles, ZipFile
import MLJModelInterface: @mlj_model, fit, predict, matrix

# EXPORTS
export X_y_split, fit, predict

export load_gunpoint, TSdataset, univariate_datasets

export L1
#CONSTANTS
# the directory containing this file: (.../src/)
const MODULE_DIR = dirname(@__FILE__)
const MMI = MLJModelInterface

# Includes
include("IntervalBasedForest.jl")
include("datapath.jl")
include("measures.jl")
include("interface.jl")

end # module
