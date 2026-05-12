import redis

# Підключення до твого Docker-контейнера [cite: 56, 132]
r = redis.Redis(host='localhost', port=6379, decode_responses=True)

def run_lab_tasks():
    # Етап 1: Базові операції (Лаба 7) [cite: 11, 13]
    r.set('student', 'Dasha')
    r.incr('mycounter')
    print(f"Student: {r.get('student')}, Counter: {r.get('mycounter')}")

    # Етап 2: Транзакція (Лаба 8) [cite: 105]
    pipe = r.pipeline()
    pipe.set('test:key1', 'Hello')
    pipe.set('test:key2', 'World')
    pipe.execute()
    print("Transaction completed successfully.")

    # Етап 3: Lua-скрипт [cite: 111]
    lua_script = """
    if redis.call('exists', KEYS[1]) == 0 then 
        return redis.call('set', KEYS[1], ARGV[1]) 
    else 
        return 'exists' 
    end
    """
    result = r.eval(lua_script, 1, 'dasha_key', 'CloudDevOps')
    print(f"Lua script result: {result}")

    # Етап 4: Streams [cite: 120]
    r.xadd('mystream', {'sensor-id': '777', 'temperature': '22.5'})
    print(f"Stream entry added: {r.xrange('mystream', count=1)}")

if __name__ == "__main__":
    run_lab_tasks()
