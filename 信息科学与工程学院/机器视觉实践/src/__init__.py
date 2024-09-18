import logging
import os

debug = os.environ.get("DEBUG") or os.environ.get("debug") or False

logging.basicConfig(level=logging.INFO if not debug else logging.DEBUG)
