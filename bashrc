#!/usr/bin/env bash
#-*- coding: utf-8; mode:shell-script -*-
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
[[ -f "${HOME}/.runcom/psrc" ]] && . "${HOME}/.runcom/psrc"
PATH="${PATH}:${HOME}/bin";
export PATH="${PATH}:${HOME}/.local/bin";
export PYOPENCL_CTX='0';
export PYOPENCL_COMPILER_OUTPUT=1;
export PYTHONPATH="${PYTHONPATH}:${HOME}/lib/$(python --version |cut -d "." -f1,2 |sed 's/ //' |sed 's/P/p/')/site-packages:${HOME}/lib64/$(python --version |cut -d "." -f1,2 |sed 's/ //' |sed 's/P/p/')site-packages";
export LD_LIBRARY_PATH="${HOME}/.local/lib:${HOME}/.local/lib64";
export OCL_ICD_VENDORS="/etc/OpenCL/vendors/";
# export WLR_BACKENDS="headless";
# export WLR_LIBINPUT_NO_DEVICES=1;
