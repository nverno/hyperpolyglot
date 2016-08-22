#!/usr/bin/env python

"""
Create index to lookup languages from http://hyperpolyglot.org/
"""

import sys
from bs4 import BeautifulSoup

if sys.version_info[0] == 3:
    import urllib.request as urllib
    from urllib.error import HTTPError
else:
    import urllib2 as urllib
    from urllib2 import HTTPError


class IndexProcessor:
    """
    Extract index from hyperpolyglot.org
    """

    def __init__(self, url):
        self.soup = None
        try:
            html = urllib.urlopen(url).read()
            self.soup = BeautifulSoup(html)

        except HTTPError as e:
            print(e)

    # def get_menu(self):
    #     menu = self.soup.find("table")
    #     for l in menu.findAll("a"):
    #         if 'href' in l.attrs:
    #             name = l.get_text()
    #             refid = l.attrs['href'][1:]

    #             try:

    #             except:
    #                 print "Failed for %s" % name

# test
ip = IndexProcessor("http://www.hyperpolyglot.org")

if __name__ == '__main__':
    import json
    ip = IndexProcessor("http://www.hyperpolyglot.org")
    # with open("json-data.json", "w") as f:
    #     json.dump(ip.sheets, f)
