#!/usr/bin/env python3

import json
from collections import OrderedDict
from urllib.request import urlopen
from hashlib import sha256

BASE_URL = "http://wps-community.org/download/dicts"

with open("dicts-list.txt", "r") as d:
    langs = d.read().splitlines()

dicts_sources = []
for lang in langs:
    print(lang)

    zip_file_name = f"{lang}.zip"
    zip_file_url = f"{BASE_URL}/{zip_file_name}"
    zip_file = urlopen(zip_file_url)

    dicts_sources.append(OrderedDict({
        "type": "extra-data",
        "dest": "dicts",
        "filename": zip_file_name,
        "url": zip_file_url,
        "size": zip_file.length,
        "sha256": sha256(zip_file.read()).hexdigest()
    }))


with open("dicts-sources.json", "w") as sources_file:
    json.dump(dicts_sources, sources_file, indent=4)
