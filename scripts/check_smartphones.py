import json

with open('assets/data/smartphones.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

print(f"Total smartphones: {len(data['smartphones'])}")
print()

# Count by brand
brands = {}
for phone in data['smartphones']:
    brand = phone['brand']
    brands[brand] = brands.get(brand, 0) + 1

print("Brands:")
for brand, count in sorted(brands.items()):
    print(f"  {brand}: {count}")
print()

# Count by category
categories = {}
for phone in data['smartphones']:
    for cat in phone.get('categories', []):
        categories[cat] = categories.get(cat, 0) + 1

print("Categories:")
for cat, count in sorted(categories.items()):
    print(f"  {cat}: {count}")
print()

# Count by price range
price_ranges = {
    "2 Jutaan": 0,
    "3 Jutaan": 0,
    "4 Jutaan": 0
}

for phone in data['smartphones']:
    price = phone['price']
    if price <= 2000000:
        price_ranges["2 Jutaan"] += 1
    elif price <= 3000000:
        price_ranges["3 Jutaan"] += 1
    elif price <= 4000000:
        price_ranges["4 Jutaan"] += 1

print("Price Ranges:")
for range_name, count in price_ranges.items():
    print(f"  {range_name}: {count}")

