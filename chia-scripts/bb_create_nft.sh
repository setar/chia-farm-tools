#!/bin/bash
. ~/chia-scripts/activate
for n in {1..999};
do
echo "  ########################## PLOT $n  #######################################"
$HOME/bladebit/.bin/release/bladebit -n 1 -t $CHIA_THREADS -v -f $CHIA_FPK -c $CHIA_NFT $CHIA_TEMP/

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

`$HOME/chia-scripts/chia_plots_mover.sh 2>&1 >> $HOME/logs/plots_mover.bb.log ` &
done

