#!/usr/bin/env python3

import csv
import json
from collections import OrderedDict
from urllib.request import urlopen
from hashlib import sha256

BASE_URL = "http://wps-community.org/download/dicts"

with open("dicts.csv", "r") as d:
    dicts_reader = csv.DictReader(d)
    langs = [(l['language'], l['license']) for l in dicts_reader]

dicts_sources = []
for lang, license in langs:
    print(lang)

    bundle = license == 'free'

    zip_file_url = f"{BASE_URL}/{lang}.zip"
    zip_file = urlopen(zip_file_url)
    zip_file_size = zip_file.length
    zip_file_sha256 = sha256(zip_file.read()).hexdigest()

    if bundle:
        s = OrderedDict({
            "type": "archive",
            "dest": f"dicts/{lang}",
            "url": zip_file_url,
            "sha256": zip_file_sha256
        })
    else:
        s = OrderedDict({
            "type": "extra-data",
            "filename": f"{lang}.dict.zip",
            "url": zip_file_url,
            "size": zip_file_size,
            "sha256": zip_file_sha256
        })

    dicts_sources.append(s)


with open("dicts-sources.json", "w") as sources_file:
    json.dump(dicts_sources, sources_file, indent=4)
