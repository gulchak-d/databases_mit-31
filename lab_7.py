import redis

# Підключення до Redis у Docker
r = redis.Redis(host='localhost', port=6379, decode_responses=True)

# 1. Робота з лічильником
r.incr('lab_counter')
print(f"Counter value: {r.get('lab_counter')}")

# 2. Робота зі списком задач
r.lpush('tasks', 'Complete Lab 7')
print(f"Current tasks: {r.lrange('tasks', 0, -1)}")

# 3. Публікація повідомлення
r.publish('lab_channel', 'Redis is working!')
print("Message published to lab_channel")