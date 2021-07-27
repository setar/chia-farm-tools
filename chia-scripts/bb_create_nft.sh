#!/bin/bash
(cd ~/chia-scripts; . ./activate)
for n in {1..999};
do
echo "  ########################## PLOT $n  #######################################"
/home/chia/bladebit/.bin/release/bladebit -n 1 -t 56 -v -f 88cbed9eb6b92d75f4073c65ca231e81f4a95057f4b9c5461997170e71adcbebe2a0eacbba2a0153ec936cfbe2f32e8f -c xch18kspvxwzth2ssyup97qc642unxe0k2fljkrkslzmvxu3zqfja88sqwzghg /home/chia/temp/

#bladebit [<OPTIONS>] [<out_dir>]
#
#<out_dir>: Output directory in which to output the plots.
#           This directory must exist.
#
#OPTIONS:
#
# -h, --help           : Shows this message and exits.
#
# -t, --threads        : Maximum number of threads to use.
#                        For best performance, use all available threads (default behavior).
#                        Values below 2 are not recommended.
#
# -n, --count          : Number of plots to create. Default = 1.
#
# -f, --farmer-key     : Farmer public key, specified in hexadecimal format.
#                        *REQUIRED*
#
# -p, --pool-key       : Pool public key, specified in hexadecimal format.
#                        Either a pool public key or a pool contract address must be specified.
#
# -c, --pool-contract  : Pool contract address, specified in hexadecimal format.
#                        Address where the pool reward will be sent to.
#                        Only used if pool public key is not specified.
#
# -w, --warm-start     : Touch all pages of buffer allocations before starting to plot.
#
# -i, --plot-id        : Specify a plot id for debugging.
#
# -v, --verbose        : Enable verbose output.
#
# -m, --no-numa        : Disable automatic NUMA aware memory binding.
#                        If you set this parameter in a NUMA system you
#                        will likely get degraded performance.

`/home/chia/chia_plots_mover.sh 2>&1 >> /home/chia/logs/plots_mover.bb.log ` &
done

