<h1 align="center">whsync<a href="https://daniilshat.ru/" target="_blank"></a> 
<h3 align="center">Таблицы</h3>

  
# whsync.clientsync


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
| log_id |      BIGSERIAL   | идентификатор логов |
   | client_id |   BIGINT    |  идентификатор клиента|
   | name |        VARCHAR(255)  | имя клиента|
   | phone_number| VARCHAR(11) |  номер телефона клиента|
  |  company_id |  integer    | идентификатор компании|
   | ch_employee |integer    | идентификатор сотрудника, добавившего клиента|
   | sync_dt   |   TIMESTAMP WITH TIME ZONE| дата синхронизации|

  
# whsync.employeessync


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |

   | log_id    |      BIGSERIAL  | идентификатор логов |
    |employee_id  |   BIGINT    |  идентификатор сотрудника|
   | name        |    VARCHAR(255)   | имя сотрудника|
   | phone_number  |  VARCHAR(11)    | номер телефона сотрудника |
   | payment_detalis | varchar(255)   | платежная информация |
   | sync_dt      |   TIMESTAMP WITH TIME ZONE| дата синхронизации |

<h3 align="center">Функции</h3>


# Функции экспорта: 
```
whsync.clientsyncexport(_log_id BIGINT)
whsync.employeessyncexport(_log_id BIGINT)
```
# Функции импорта:
```
whsync.clientsyncimport(_src JSONB)
whsync.employeessyncimport(_src JSONB)
```
Ответ при коректном вводе
```
{"data" : null}
```

# Пример ввода


```
SELECT whsync.clientsyncimport(
  '[
    {
      "client_id": 2222,
      "client_name": "Барри",
      "phone": "8900663636",
      "company_id": 29,
      "ch_employee": 11
    },
    {
      "client_id": 221,
      "client_name": "Карри",
      "phone": "220-01",
      "company_id": 29,
      "ch_employee": 11
    }
  ]'::jsonb
);
```
