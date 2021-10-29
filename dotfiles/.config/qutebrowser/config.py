config.load_autoconfig(False)

config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')

config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0', 'https://accounts.google.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0', 'https://docs.google.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:71.0) Gecko/20100101 Firefox/71.0', 'https://drive.google.com/*')

config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')

config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')

config.set("colors.webpage.darkmode.enabled", True)

c.aliases = {'q': 'quit', 'w': 'session-save', 'wq': 'quit --save'}

config.bind('xt', 'config-cycle tabs.show always never')
config.bind('xb', 'config-cycle statusbar.show always never')
config.bind('xx', 'config-cycle statusbar.show always never;; config-cycle tabs.show always never')
config.bind('H', 'tab-prev')
config.bind('L', 'tab-next')
config.bind('K', 'back')
config.bind('J', 'forward')

config.bind(' z',
            'hint links spawn --detach zathura {hint-url}')

config.bind(' v',
            'hint links spawn --detach mpv --force-window yes {hint-url}')

c.url.start_pages = ['https://www.anubandha.home/']
c.url.default_page = 'http://www.anubandha.home/'

c.url.searchengines = {
    'DEFAULT': 'http://searx.anubandha.home/searx/search?q={}',
    'g': 'https://www.google.com/?q={}',
    'dg': 'https://www.duckduckgo.com/?q={}',
    'a2': 'https://alternativeto.net/browse/search?q={}',
    'dh': 'https://hub.docker.com/search?q={}&type=image',
    'pip': 'https://pypi.org/search/?q={}',
}

c.fonts.default_family = ['Fira Code Retina']
c.fonts.default_size = '20px'
c.fonts.web.size.default = 20
c.fonts.web.size.default_fixed  = 20
c.fonts.web.size.minimum = 12
c.fonts.web.size.minimum_logical = 12

c.colors.hints.bg = '#bfdfff'
c.colors.hints.fg = '#402000'
c.colors.hints.match.fg = c.colors.hints.bg

config.bind('  ', 'set-cmd-text :')
config.bind(' qr', 'restart')
config.bind(' qq', 'quit')
config.bind(' ff', 'set-cmd-text -s :open -t')
config.bind(' bd', 'tab-close')
