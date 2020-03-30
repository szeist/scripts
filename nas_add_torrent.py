#!/usr/bin/env pipenv-shebang

import sys
import magic
from subprocess import Popen, PIPE
from synology_api.filestation import FileStation
import config

def _upload_torrent_file(file, password):
    file_station = FileStation(config.nas['ip'], config.nas['port'], config.nas['user'], password)
    result = file_station.upload_file(config.nas['torrent_files_dir'], file)
    file_station.logout()
    return result

def _get_nas_password():
    p = Popen(['bw', '--raw', 'get', 'password', config.nas['bw_secret_id']], stdout=PIPE)
    p.wait()
    return p.stdout.read().decode('utf-8')

def _validate_file(file):
    mime = magic.Magic(mime=True)
    actual_type = mime.from_file(file)
    if actual_type != 'application/x-bittorrent':
        raise ValueError(f'{file} is not a bittorrent file.')

if __name__ == '__main__':
    file = sys.argv[1]
    _validate_file(file)
    nas_pass = _get_nas_password()
    result = _upload_torrent_file(file, nas_pass)
    print(result)
