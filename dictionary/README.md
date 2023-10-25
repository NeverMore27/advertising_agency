<h1 align="center">dictionary<a href="https://daniilshat.ru/" target="_blank"></a> 
<h3 align="center">Таблицы</h3>

  
# dictionary.company


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
|  company_id  |serial     | Идентификатор компании    |
| company_name      |varchar(255)       | Название компании      |

  
# dictionary.job


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
|  id  |serial     | Идентификатор работы    |
| name      |varchar(255)       | Название работы    |
|  hour_payment |decimal(8, 2)    |Почасовая оплата   |

  
# dictionary.price


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
|  id  |serial     | Идентификатор услуги   |
| name      |varchar(50)       | Название услуги     |
| min_cost |decimal(8, 2)    | Минимальная оплата     |


<h3 align="center">Функции</h3>


# Добавление работы в каталог 
```
SELECT dictionary.job_upd('
{
  "name": "Проектирование баннера",
  "hour_payment": 250
}')
```
Ответ при коректном вводе
```
{"data" : null}
```



# Добавление услуги в каталог
```
SELECT dictionary.price_upd('
{
  "name": "Проектирование баннера",
  "min_cost": 2506
}')
```
Ответ при коректном вводе
```
{"data" : null}
```
