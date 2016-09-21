module Drasil.SSP.SSPModules where

import Language.Drasil
import Drasil.SSP.SSPConcepts

modules :: [ModuleChunk]
modules = [mod_hw, mod_behav, mod_ctrl, mod_inputf, mod_outputf, mod_genalg,
           mod_kinadm, mod_slipslicer, mod_slipweight, mod_mp, mod_rfem,
           mod_sps, mod_sw, mod_sds, mod_rng, mod_plot]

-- HW Hiding Module
mod_hw_desc :: ConceptChunk
mod_hw_desc = CC "hardware hiding"
  (S "Serves as a virtual hardware used by the rest of the system. This " :+:
   S "module provides the interface between the hardware and the software. " :+:
   S "So, the system can use it to display outputs or to accept inputs.")

mod_hw :: ModuleChunk
mod_hw = makeImpModule mod_hw_desc
  (S "The data structure and algorithm used to implement the virtual hardware.")
  os
  []
  []
  Nothing

-- Behaviour Hiding Module
mod_behav_desc :: ConceptChunk
mod_behav_desc = CC "behaviour hiding"
  (S "Includes programs that provide externally visible behavior of " :+:
   S "the system as specified in the software requirements specification " :+:
   S "(SRS) documents. This module serves as a communication layer between " :+:
   S "the hardware-hiding module and the software decision module. The " :+:
   S "programs in this module will need to change if there are changes " :+:
   S "in the SRS.")

mod_behav :: ModuleChunk
mod_behav = makeUnimpModule mod_behav_desc
  (S "The contents of the required behaviors.")
  Nothing


-- Control module
mod_ctrl_desc :: ConceptChunk
mod_ctrl_desc = CC "control" (S "Provides the main program.")

mod_ctrl :: ModuleChunk
mod_ctrl = makeImpModule mod_ctrl_desc
  (S "The algorithm for coordinating the running of the program.")
  program
  []
  [mod_inputf, mod_outputf, mod_genalg]
  (Just mod_behav)

-- input format module
mod_inputf_desc :: ConceptChunk
mod_inputf_desc = CC "input format"
  (S "Reads the input data from an input file, and/or " :+:
   S "prompted command line inputs. Input data includes the x,y " :+:
   S "coordinates of the slope, with a set of coordinates for each " :+:
   S "layer. For each layer it's soil properties of effective angle of " :+:
   S "friction, effective cohesion, dry unit weight, saturated unit " :+:
   S "weight, elastic modulus, and Poisson's ratio are stored in vectors " :+:
   S "of soil properties. If a piezometric surface exists in the slope " :+:
   S "it's coordinates and the unit weight of water are also included in " :+:
   S "the input. Lastly an expected range for the entrance and exit points " :+:
   S "of the critical slip surface are inputted.")

mod_inputf :: ModuleChunk
mod_inputf = makeImpModule mod_inputf_desc
  (S "The format and structure of the input data.")
  program
  []
  [mod_hw]
  (Just mod_behav)

-- output format module
mod_outputf_desc :: ConceptChunk
mod_outputf_desc = CC "output format"
  (S "Outputs the results of the calculations, including " :+:
   S "the factor of safety for the critical slip calculated by the " :+:
   S "Morgenstern Price Module and Rigid Finite Element Method Module, " :+:
   S "and a plot of the critical slip surface on the slope geometry, " :+:
   S "with the showing the element displacements as calculated by the " :+:
   S "RFEM Module.")

mod_outputf :: ModuleChunk
mod_outputf = makeImpModule mod_outputf_desc
  (S "The format and structure of the output data.")
  program
  []
  [mod_plot, mod_slipslicer, mod_mp, mod_rfem]
  (Just mod_behav)

-- gen alg module
mod_genalg_desc :: ConceptChunk
mod_genalg_desc = CC "genetic algorithm"
  (S "Searches the slope for the critical slip surface with " :+:
   S "the minimum factor of safety")

mod_genalg :: ModuleChunk
mod_genalg = makeImpModule mod_genalg_desc
  (S "Algorithm to identify the slip surface that has the " :+:
   S "minimum factor of safety, based on the inputs.")
   program
   []
   [mod_slipslicer, mod_kinadm, mod_rng, mod_slipweight, mod_mp]
   (Just mod_behav)

-- kin adm module
mod_kinadm_desc :: ConceptChunk
mod_kinadm_desc = CC "kinetic admissibility"
  (S "Some slip surfaces are physically unlikely or " :+:
   S "impossible to occur in a slip surface, such as slip surfaces " :+:
   S "containing sharp angles, or going above the slope surface. Ensures " :+:
   S "randomly generated or mutated slopes from the Genetic Algorithm " :+:
   S "Module are physically possible according to the " :+:
   S "criteria of the Kinematic Admissibility Module.")

mod_kinadm :: ModuleChunk
mod_kinadm = makeImpModule mod_kinadm_desc
  (S "Algorithm to determine if a given slip surface passes " :+:
   S "or fails a set of admissibility criteria.")
   program
   []
   []
   (Just mod_behav)

-- slip slicer module
mod_slipslicer_desc :: ConceptChunk
mod_slipslicer_desc = CC "slip slicer"
  (S "When preparing a slip surface for analysis by the " :+:
   S "Morgenstern Price Module or the RFEM Module, " :+:
   S "the x-coordinates defining the boundaries of the " :+:
   S "slices are identified and stored in a vector.")

mod_slipslicer :: ModuleChunk
mod_slipslicer = makeImpModule mod_slipslicer_desc
  (S "Algorithm to determine the coordinates of where the " :+:
   S "slip surface interslice nodes occur.")
   program
   []
   []
   (Just mod_behav)

-- slip weighting module
mod_slipweight_desc :: ConceptChunk
mod_slipweight_desc = CC "slip weighting"
  (S "Weights a set of slip surfaces generated by the " :+:
   S "Genetic Algorithm Module based on their factors of " :+:
   S "safety. A slip surface with a low factor of safety will have a high " :+:
   S "weight as it is more likely to be or to lead to generation of the " :+:
   S "critical slip surface.")

mod_slipweight :: ModuleChunk
mod_slipweight = makeImpModule mod_slipweight_desc
  (S "The weighting for each slip surface in a set of slip " :+:
   S "surfaces, based on each slip surfaces factor of safety.")
  program
  []
  []
  (Just mod_behav)

-- morg price solver module
mod_mp_desc :: ConceptChunk
mod_mp_desc = CC "morgenstern price solver"
  (S "Calculates the factor of safety of a given slip " :+:
   S "surface, through implementation of a Morgenstern Price slope " :+:
   S "stability analysis method.")

mod_mp :: ModuleChunk
mod_mp = makeImpModule mod_mp_desc
  (S "The factor of safety of a given slip surface.")
  program
  []
  [mod_sps]
  (Just mod_behav)

-- rfem solver module
mod_rfem_desc :: ConceptChunk
mod_rfem_desc = CC "RFEM solver"
  (S "Calculate the global factor of safety, local slice " :+:
   S "factors of safety, and local slice displacements of a given slip " :+:
   S "surface under given conditions, through implementation of a rigid " :+:
   S "finite element slope stability analysis method.")

mod_rfem :: ModuleChunk
mod_rfem = makeImpModule mod_rfem_desc
  (S "The algorithm to perform a Rigid Finite Element Method " :+:
   S "analysis of the slope.")
   program
   []
   [mod_sps]
   (Just mod_behav)

-- slice property sorter module
mod_sps_desc :: ConceptChunk
mod_sps_desc = CC "slice property sorter"
  (S "When performing slip analysis with the RFEM Solver " :+:
   S "Module or Morgenstern Price Module, " :+:
   S "the base and interslice surfaces of each slice " :+:
   S "in the analysis requires a soil constant. Slice Property Sorter " :+:
   S "Module identifies which soil layer the surface is in to assign " :+:
   S "properties from that soil layer, and uses a weighting scheme when " :+:
   S "the surface crosses multiple soil layers.")

mod_sps :: ModuleChunk
mod_sps = makeImpModule mod_sps_desc
  (S "Algorithm to assigns soil properties to slices based " :+:
   S "on the location of the slice with respect to the different soil layers.")
   program
   []
   []
   (Just mod_behav)

-- sfwr dec module
mod_sw_desc :: ConceptChunk
mod_sw_desc = CC "software decision"
  (S "Includes a data structure and algorithms used in the " :+:
   S "system that do not provide direct interaction with the user.")

mod_sw :: ModuleChunk
mod_sw = makeUnimpModule mod_sw_desc
  (S "The design decision based on mathematical theorems, " :+:
   S "physical facts, or programming considerations. The secrets of this " :+:
   S "module are not described in the SRS.")
   Nothing

-- sequence data structure module
mod_sds_desc :: ConceptChunk
mod_sds_desc = CC "sequence data structure"
  (S "Provides array manipulation, including building an " :+:
   S "array, accessing a specific entry, slicing an array etc.")

mod_sds :: ModuleChunk
mod_sds = makeImpModule mod_sds_desc
  (S "The data structure for a sequence data type.")
   matlab
   []
   []
   (Just mod_sw)

-- rng module
mod_rng_desc :: ConceptChunk
mod_rng_desc = CC "random number generator"
  (S "Randomly produces numbers between 0 and 1, using a " :+:
   S "chaotic function with an external seed. Used when generating slip " :+:
   S "surfaces in the Genetic Algorithm Module.")

mod_rng :: ModuleChunk
mod_rng = makeImpModule mod_rng_desc
  (S "Pseudo-random number generation algorithm.")
   matlab
   []
   []
   (Just mod_sw)

-- plotting module
mod_plot_desc :: ConceptChunk
mod_plot_desc = CC "plotting"
  (S "Provides a plot function.")

mod_plot :: ModuleChunk
mod_plot = makeImpModule mod_plot_desc
  (S "The data structures and algorithms for plotting data graphically")
   matlab
   []
   [mod_hw]
   (Just mod_sw)
