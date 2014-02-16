icassp2014_TxImpairments
====

**icassp2014_TxImpairments** is the simulation environment for
> [R. Brandt][rabr5411], [E. Björnson][emilbjo], and [M. Bengtsson][matben]. Weighted sum rate optimization for multicell MIMO systems with hardware-impaired transceivers. IEEE Conf. Acoust., Speech, and Signal Process. (ICASSP’14), 2014. Accepted.

It provides all the simulation code and scripts required to reproduce the 
figures from the paper.

## Abstract
Physical transceivers exhibit distortions from hardware impairments, of which
traces remain even after compensation and calibration. Multicell MIMO
coordinated beamforming methods that ignore these residual impairments may
suffer from severely degraded performance. In this work, we consider a general
model for the aggregate effect of the residual hardware impairments, and propose
an iterative algorithm for finding locally optimal points to a weighted sum rate
optimization problem. The importance of accounting for the residual hardware
impairments is verified by numerical simulation, and a substantial gain over
traditional time-division multiple access with impairments-aware resource
allocation is observed.

## Simulation code features

* Matlab implementation of WMMSE algorithm for hardware-impaired transceivers
* Transmitter side optimization problem is solved with [Yalmip][yalmip] and
  [Gurobi][gurobi] (faster, if available) or [Sedumi][sedumi]
* Using [Yalmip optimizer][yalmipoptimizer] for reduced overhead

## Running the simulations

1. Make sure that [Yalmip][yalmip] and [Gurobi][gurobi] or [Sedumi][sedumi] is
   installed. Note that Gurobi has free licenses available for researchers.
2. `cd` into the base directory and run `setup_environment` from within Matlab
3. `test_environment` and resolve any issues
4. `cd TxImpairments/batches`
5. `matlabpool X` where `X` is the number of cores available
6. Run any `_run` scripts to run the simulation, and the corresponding 
   `_plot_final` script to recreate the figure from the paper.

## Description of batch scripts

- convergence_batch_run
  - Runs simulations for Figure 1
- convergence_batch_plot_final
  - Recreates Figure 1, if simulation results are loaded in the workspace
- sumrateKappas_batch_run_parallel_1
  - Runs first half of the simulations for Figure 2
- sumrateKappas_batch_run_parallel_2
  - Runs second half of the simulations for Figure 2
- sumrateKappas_batch_run_merge_parallelized_files
  - Merges the two halves into one file
- sumrateKappas_batch_plot_final
  - Recreates Figure 2, if the merged simulation file is loaded in the workspace
- sumrateKappas_batch_plot_all
  - Generates auxilliary plots, not part of the paper
- sumrateSNR_batch_run
  - Runs simulations for Figure 3
- sumrateSNR_batch_plot_final
  - Recreates Figure 13 if simulation results are loaded in the workspace

The reason for splitting up the Monte Carlo realizations for Figure 2 into two
sets is that the code seems unstable when running with a large number of Monte
Carlo simulations sequentially. Some form of [thrashing][thrashing] seems to
occur. 

## Acknowledgements
This work was supported by the FP7 project [HIATUS][hiatus] (FET-Open
grant #265578). E. Björnson is funded by the International Postdoc Grant
2012-228 from The Swedish Research Council and by ERC Starting Grant 305123
MORE. We would like to extend our gratitude to Assoc. Prof.
[Johan Löfberg][johanlofberg] at Linköping Univ. for the extensive help with
shortening our Yalmip run times.

## License and referencing
This source code is licensed under the [GPLv2][gplv2] license. If you in any way
use this code for research that results in publications, please cite our
original article. The following [Bibtex][bibtex] entry can be used.
```
@article{Brandt2014accepted, 
  author = {R. Brandt and E. Björnson and M. Bengtsson}, 
  title = {Weighted Sum Rate Optimization for Multicell {MIMO} Systems with Hardware-Impaired Transceivers}, 
  journal = {IEEE Conf. Acoust., Speech, and Signal Process. (ICASSP'14)}, 
  year = 2014,
  note = {Accepted}
}
```

[rabr5411]: http://www.kth.se/profile/rabr5411
[emilbjo]: http://www.kth.se/profile/emilbjo
[matben]: http://www.kth.se/profile/matben
[yalmip]: http://users.isy.liu.se/johanl/yalmip
[gurobi]: http://www.gurobi.com/
[sedumi]: https://github.com/sqlp/sedumi
[yalmipoptimizer]: http://users.isy.liu.se/johanl/yalmip/pmwiki.php?n=Commands.Optimizer
[thrashing]: http://en.wikipedia.org/wiki/Thrashing_(computer_science)
[hiatus]: http://www.fp7-hiatus.eu/
[johanlofberg]: https://github.com/johanlofberg
[gplv2]: http://choosealicense.com/licenses/gpl-v2
[bibtex]: http://www.bibtex.org/
