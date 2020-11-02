#!/usr/bin/env python3
# -*- coding:utf-8; mode:python -*-
#
# Copyright 2020 Pradyumna Paranjape
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
username,
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
from sys import exit as sysexit
from os import environ
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
        self.p_type: str = None
        self.auth = {'uname': None, 'pass': None}
        self.target = {'address': None, 'port': None}
        for key, val in kwargs.items():
            if key in self.auth:
                self.auth[key] = val
            elif key in self.target:
                self.target[key] = val
            else:
                raise KeyError(f"Bad keyword argument {key}")

    def __str__(self) -> None:
        '''
        string of the form
        "p_type://[username[:passwordurl]@]address[:port]/"
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
        encoded: username is encoded?
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
    if 'http_proxy' in environ:
        return environ['http_proxy']
    # Definitions
    proxy = Proxy()
    if 'proxy_type' in environ:
        proxy.p_type = environ['proxy_type']
    else:
        print("proxy type not supplied")
        return ''
    if 'passwordplain' in environ:
        proxy.add_password(environ['passwordplain'])
    elif 'passwordhtml' in environ:
        proxy.add_password(environ['passwordhtml'], encoded=True)
    if 'username' in environ:
        proxy.add_uname(environ['username'])
    if 'proxy_addr' in environ:
        proxy.target['address'] = environ['proxy_addr']
    if 'proxy_port' in environ:
        proxy.target['port'] = int(environ['proxy_port'])
    return {proxy.p_type: str(proxy)}


def main():
    '''
    main subroutine
    '''
    proxies = build()
    try:
        get("https://www.duckduckgo.com/", proxies=proxies)
    except ConnectionRefusedError:
        sysexit(127)
    except OSError as err:
        if 'No route to host' in str(err):
            sysexit(0)
        else:
            print(err)
            sysexit(1)
    sysexit(0)


if __name__ == "__main__":
    main()
