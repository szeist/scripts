#!/usr/bin/env pipenv-shebang

import sys
import magic
from subprocess import Popen, PIPE
from synology_api.filestation import FileStation
from synology_api.downloadstation import DownloadStation
import config

def _upload_torrent_file(file, password):
    file_station = FileStation(config.nas['ip'], config.nas['port'], config.nas['user'], password)
    result = file_station.upload_file(config.nas['torrent_files_dir'], file)
    file_station.logout()
    return result

def _get_downloads(password):
    download_station = DownloadStation(config.nas['ip'], config.nas['port'], config.nas['user'], password)
    result = _parse_downloads(download_station.tasks_list())
    download_station.logout()
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

def _parse_downloads(downloadstation_response):
    return [_parse_task(task) for task in downloadstation_response['data']['tasks']]

def _parse_task(task):
    return {
        'title': task['title'],
        'status': task['status'],
        'downloaded_percent': _get_download_percent(task),
        'remaining_sec': _get_remaining_time(task)
    }

def _get_download_percent(task):
    if task['additional']['transfer']['size_downloaded'] == 0:
        return 0
    return round((task['additional']['transfer']['size_downloaded'] / task['size']) * 100)

def _get_remaining_time(task):
    if task['additional']['transfer']['speed_download'] == 0:
        return 0
    remaining = task['size'] - task['additional']['transfer']['size_downloaded']
    return remaining // task['additional']['transfer']['speed_download']

def _format_time(seconds):
    hours = seconds // 3600
    seconds %= 3600
    minutes = seconds // 60
    seconds %= 60
    return f'{hours}:{minutes}:{seconds}'


if __name__ == '__main__':
    command = sys.argv[1]
    if command == 'torrent':
        subcommand = sys.argv[2]
        if subcommand == 'add':
            file = sys.argv[3]
            _validate_file(file)
            nas_pass = _get_nas_password()
            result = _upload_torrent_file(file, nas_pass)
            print(result)
        elif subcommand == 'list':
            nas_pass = _get_nas_password()
            for download in _get_downloads(nas_pass):
                remaining_time = _format_time(download['remaining_sec'])
                print(f"[{download['status']}]\t{download['title']}\t({download['downloaded_percent']}%)\t{remaining_time}")
        else:
            print(f'Unknown subcommand: {subcommand}')
    else:
        print(f'Unknown command: {command}')

