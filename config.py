import os

nas = {
    'ip': os.environ['NAS_IP'],
    'port': os.environ['NAS_PORT'],
    'user': os.environ['NAS_USER'],
    'torrent_files_dir': os.environ['NAS_TORRENT_FILE_DIR'],
    'bw_secret_id': os.environ['NAS_BW_SECRET_ID']
}