# Аналітика продажів (OLAP) з PostgreSQL та Excel

Цей проєкт демонструє створення схеми бази даних "зірка" у PostgreSQL для подальшого аналізу даних за допомогою зведених таблиць в Excel.

## Запуск бази даних через Docker
```powershell
docker run --name postgres-olap -e POSTGRES_PASSWORD=mysecretpassword -e POSTGRES_DB=olap_lab -d -p 5433:5432 postgres
