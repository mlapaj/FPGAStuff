#!/bin/env python3

import os
import json

DIRECTORY = "./"  # Change this to the directory you want to monitor
TIMESTAMP_FILE = "build/timestamps.json"

def get_file_mod_times(directory):
    file_mod_times = {}
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".v"):
                file_path = os.path.join(root, file)
                mod_time = os.path.getmtime(file_path)
                file_mod_times[file_path] = mod_time
    return file_mod_times

def load_previous_timestamps():
    if os.path.exists(TIMESTAMP_FILE):
        with open(TIMESTAMP_FILE, "r") as f:
            return json.load(f)
    return {}

def save_timestamps(timestamps):
    if not os.path.exists('build'):
        os.makedirs('build')
    with open(TIMESTAMP_FILE, "w") as f:
        json.dump(timestamps, f)

def check_modifications():
    previous_timestamps = load_previous_timestamps()
    current_timestamps = get_file_mod_times(DIRECTORY)
    
    if previous_timestamps != current_timestamps:
        save_timestamps(current_timestamps)
        return True
    return False

if __name__ == "__main__":
    exit(0) if not check_modifications() else exit(1)

