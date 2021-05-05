#!/usr/bin/env python3
# -*- coding:utf-8; mode:python -*-
#
# Copyright 2020, 2021 Pradyumna Paranjape
#
# Check for network connectivity at the beginning
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
'''
An (unsynced) secrets file should export secrets:

proxy_type,
USERNAME,
password_plain/password_html,
proxy_addr,
proxy_port

... to env.

We try to open "https://www.duckduckgo.com/" and send a proxy auth
to the server.

Proxy server generally 'remembers' that our machine was authenticated
and does not demand proxy auth again.
'''

# imports
import os
import sys
import typing
from urllib.parse import quote

from requests import get


class Proxy():
    '''
    proxy class
    '''
    def __init__(self, **kwargs) -> None:
        '''
        p_type: proxy_type: socks, http
        uname: proxy user name
        password: proxy password (url encoded)
        address: proxy address (may be ip address)
        port: proxy port

        initiate an empty proxy
        '''
        self.p_type: typing.Optional[str] = None
        self.auth: typing.Dict[str, typing.Optional[str]] = {
            'uname': None,
            'pass': None
        }
        self.target: typing.Dict[str, typing.Optional[str]] = {
            'address': None,
            'port': None
        }
        for key, val in kwargs.items():
            if key in self.auth:
                self.auth[key] = val
            elif key in self.target:
                self.target[key] = val
            else:
                raise KeyError(f"Bad keyword argument {key}")

    def __str__(self) -> str:
        '''
        string of the form
        "p_type://[USERNAME[:passwordurl]@]address[:port]/"
        '''
        if self.p_type is None:
            return ''
        if self.target['address'] is None:
            return ''
        proxy = []
        proxy.append(f"{self.p_type}://")
        if self.auth['uname'] is not None:
            proxy.append(self.auth['uname'])
            if self.auth['password'] is not None:
                proxy.append(":" + self.auth['password'])
            proxy.append("@")
        proxy.append(self.target['address'])
        if self.target['port'] is not None:
            proxy.append(":" + str(self.target['port']))
        proxy.append("/")
        return ''.join(proxy)

    def add_uname(self, uname: str, encoded: bool = False) -> None:
        '''
        uname: user name
        encoded: USERNAME is encoded?
        '''
        self.auth['uname'] = uname if encoded else quote(uname)

    def add_password(self, password: str, encoded: bool = False) -> None:
        '''
        password: proxy password
        encoded: url encoded?

        add a password
        '''
        self.auth['password'] = password if encoded else quote(password)


def build():
    '''
    build proxy dictionary from cli
    '''
    if 'http_proxy' in os.environ:
        return os.environ['http_proxy']
    # Definitions
    proxy = Proxy()
    if 'proxy_type' in os.environ:
        proxy.p_type = os.environ['proxy_type']
    else:
        print("proxy type not supplied")
        return ''
    if 'passwordplain' in os.environ:
        proxy.add_password(os.environ['passwordplain'])
    elif 'passwordhtml' in os.environ:
        proxy.add_password(os.environ['passwordhtml'], encoded=True)
    if 'USERNAME' in os.environ:
        proxy.add_uname(os.environ['USERNAME'])
    if 'proxy_addr' in os.environ:
        proxy.target['address'] = os.environ['proxy_addr']
    if 'proxy_port' in os.environ:
        proxy.target['port'] = os.environ['proxy_port']
    return {proxy.p_type: str(proxy)}


def main():
    '''
    main subroutine
    '''
    proxies = build()
    try:
        get("https://www.duckduckgo.com/", proxies=proxies)
    except ConnectionRefusedError:
        return 127
    except OSError as err:
        if 'No route to host' in str(err):
            return 0
        else:
            print(err)
            return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
