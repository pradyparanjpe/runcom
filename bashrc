#/usr/bin/env bash
#
# Copyright 2020 Pradyumna Paranjape
#
# This file is part of Prady_runcom.
#
# Prady_runcom is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Prady_runcom is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Prady_runcom.  If not, see <https://www.gnu.org/licenses/>.

## User-defined bashrc extensions
##	proxy settings
## PYTHONPATH
shopt -s autocd # Allows to cd by only typing name
set -o vi
bind '"jk":vi-movement-mode'
PYTHONPATH="/media/data/academic/learn_opencl/multi_organsim_localgroup_float32/GRN+GA"
export PS1="\[${GREEN}\]\u\[${NO_EFFECTS}\]@\[${BLUE}\]\h\[${WHITE}\]<\[${CYAN}\]\W\[${WHITE}\]>\[${YELLOW}\]\t\[${NO_EFFECTS}\]» ";
export PS2="\[${CYAN}\]cont...\[${WHITE}\]|\[${YELLOW}\]\t\[${NO_EFFECTS}\]» ";
export PS3="Selection: ";
export HPC="192.168.14.20";
export PC7_admin="$user@$PC7ip";
export PC5ip="192.168.11.128";
export PC7ip="192.168.11.149";
export PATH="${PATH}:${HOME}/bin/";
export PATH="${PATH}:${HOME}/bin";
export PATH="${PATH}:${HOME}/.local/bin";
export PYOPENCL_CTX='0';
export PYOPENCL_COMPILER_OUTPUT=1;
export dock="/media/data/academic/learn_opencl/multi_organsim_localgroup_float32/GRN+GA";
export LD_LIBRARY_PATH="${HOME}/.local/lib:${HOME}/.local/lib64";
export PYTHONPATH="${PYTHONPATH}:${HOME}/.local//lib64/python3.7/site-packages/";
export EXPENDLOG="${HOME}/Ledger/money/expenditure.txt"

