import random
import datetime
from pymongo import MongoClient

# Підключення до локальної бази MongoDB
client = MongoClient("mongodb://localhost:27017")
db = client["performance_test"]
collection = db["sales"]

# Створення списку категорій
categories = ["Electronics", "Clothing", "Books", "Home", "Sports"]

# Генерація 100 000 документів
documents = [
    {
        "customer_id": random.randint(1, 1000),
        "category": random.choice(categories),
        "amount": random.uniform(5, 500),
        "timestamp": datetime.datetime(2024, random.randint(1, 12), random.randint(1, 28))
    }
    for _ in range(100000)
]

# Вставка всіх документів одним запитом
print("Починаю вставку даних...")
collection.insert_many(documents)
print("100 000 документів успішно вставлено!")