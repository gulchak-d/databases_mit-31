from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017")
collection = client["performance_test"]["sales"]

# Створюємо індекс
collection.create_index([("category", 1)])
print("Індекс створено")