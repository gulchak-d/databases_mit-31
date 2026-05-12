import time
from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017")
collection = client["performance_test"]["sales"]

# Початок вимірювання часу
start_time = time.time()

# Шукаємо всі записи в категорії Electronics
results = list(collection.find({"category": "Electronics"}))

# Кінець вимірювання
end_time = time.time()

print(f"Time taken without index: {end_time - start_time} seconds")