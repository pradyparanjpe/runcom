#!/usr/bin/env python3

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
