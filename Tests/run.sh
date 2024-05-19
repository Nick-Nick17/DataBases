#!/bin/bash

python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

pytest -v test.py
# python3 test.py