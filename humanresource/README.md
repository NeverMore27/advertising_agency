<h1 align="center">humanresource<a href="https://daniilshat.ru/" target="_blank"></a> 
<h3 align="center">Таблицы</h3>

  
# humanresource.client


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
   | client_id |   BIGINT    |  идентификатор клиента|
   | name |        VARCHAR(255)  | имя клиента|
   | phone_number| VARCHAR(11) |  номер телефона клиента|
  |  company_id |  integer    | идентификатор компании|
   | ch_employee |integer    | идентификатор сотрудника, добавившего клиента|
  

  
# humanresource.employee


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
    |employee_id  |   BIGINT    |  идентификатор сотрудника|
   | name        |    VARCHAR(255)   | имя сотрудника|
   | phone_number  |  VARCHAR(11)    | номер телефона сотрудника |
   | payment_detalis | varchar(255)   | платежная информация |

<h3 align="center">Функции</h3>


# Функции вставки: 
```
humanresource.clientupd(_src JSONB, _ch_employee INTEGER)
humanresource.employeesupd(_src JSONB)
```
Ответ при коректном вводе
```
{"data" : null}
```
Ответ при ошибке: 

```
{"errors": [{"error": "humanresource.client_ins.phone_exists", "detail": "phone = 8900663636", "message": "Такой номер телефона уже зарегитрирован!"}]}
```

```
{"errors": [{"error": "humanresource.client_ins.ch_employee", "detail": "code = 112313123", "message": "Неверный код сотрудника"}]}
```
# Пример ввода


```
select humanresource.clientupd ('{
      "client_id": 2222,
      "client_name": "Лира",
      "phone": "8900663636",
      "company_id": 32,
      "ch_employee": 11}', 22)

```


# Функции получения данных:
```
humanresource.get_employee_job(_emp_id BIGINT)
humanresource.get_employee_project(_emp_id BIGINT DEFAULT NULL)
humanresource.get_project_client(_client_id BIGINT)
```

# Функции удаления данных
```
humanresource.delete_employee(_employee_id integer)

```
