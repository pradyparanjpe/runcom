#!/usr/bin/env python3
#-*- coding:utf-8; mode:python -*-
#
# Copyright 2020 Pradyumna Paranjape
#
## Check for network connectivity at the beginning
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

#imports
import requests
from argparse import ArgumentParser

class ArgumentParserError(Exception):
    exit()


class ThrowingArgumentParser(ArgumentParser):
    def error(self, message):
        raise ArgumentParserError("authentication fields blank")

try:
    parser = ThrowingArgumentParser()
    parser.add_argument("username", metavar="U", type=str,
            help="user name in plain test")
    parser.add_argument("passwordpt", metavar="P", type=str,
            help="password, unformatted, plain")
    parser.add_argument("passwordhtml", metavar="H", type=str,
            help="password, html formatted")
except ArgumentParserError:
    exit();

# Definitions
args = parser.parse_args()
username = args.username
passwordhtml = args.passwordhtml
passwordpt = args.passwordpt

PROXIES = {"http":"http://"+username+":"+passwordhtml+"@192.168.1.101:8080"}

if __name__ == "__main__":
    try:
        r = requests.get("http://www.duckduckgo.com/", proxies=PROXIES)
        exit(0)
    except (ConnectionRefusedError):
        exit(127)
