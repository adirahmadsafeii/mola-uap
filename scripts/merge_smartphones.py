import json
import sys
import os

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

def merge_smartphones():
    # Read existing smartphones
    with open('assets/data/smartphones.json', 'r', encoding='utf-8') as f:
        existing_data = json.load(f)
    
    # List of files to merge
    files_to_merge = [
        'assets/data/new_smartphones.json',
        'assets/data/more_smartphones.json',
        'assets/data/remaining_smartphones.json',
        'assets/data/final_smartphones.json',
        'assets/data/extra_2jutaan.json'
    ]
    
    all_new_phones = []
    for file_path in files_to_merge:
        if os.path.exists(file_path):
            with open(file_path, 'r', encoding='utf-8') as f:
                phones = json.load(f)
                all_new_phones.extend(phones)
                print(f"Loaded {len(phones)} phones from {file_path}")
    
    # Get existing IDs to avoid duplicates
    existing_ids = {phone['id'] for phone in existing_data['smartphones']}
    
    # Add new phones that don't exist
    added_count = 0
    for phone in all_new_phones:
        if phone['id'] not in existing_ids:
            existing_data['smartphones'].append(phone)
            existing_ids.add(phone['id'])
            added_count += 1
            print(f"Added: {phone['name']}")
        else:
            print(f"Skipped (already exists): {phone['name']}")
    
    # Write back to file
    with open('assets/data/smartphones.json', 'w', encoding='utf-8') as f:
        json.dump(existing_data, f, indent=2, ensure_ascii=False)
    
    print(f"\nSuccessfully added {added_count} new smartphones!")
    print(f"Total smartphones: {len(existing_data['smartphones'])}")

if __name__ == '__main__':
    merge_smartphones()

