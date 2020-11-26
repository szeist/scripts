#!/usr/bin/env python

from kodijsonrpc import KodiJSONClient

VIDEO='https://video-lga3-1.xx.fbcdn.net/v/t42.26565-2/10000000_240490517076559_4945239247949251333_n.mp4?_nc_cat=103&_nc_sid=985c63&efg=eyJ2ZW5jb2RlX3RhZyI6Im9lcF9zZCJ9&_nc_ohc=k0Ip5umNUFsAX_AmHKg&_nc_ht=video-lga3-1.xx&oh=d162447f3fe5f48507eca12ea4ca4a84&oe=5E9CB6E2'

if __name__ == '__main__':
    server = KodiJSONClient('192.168.0.99', '8080', 'kodi', 'Almafa.456')
    print(server.Player.Open({"item": {"file": VIDEO}}))