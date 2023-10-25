<h1 align="center">history<a href="https://daniilshat.ru/" target="_blank"></a> 
<h3 align="center">Таблицы</h3>

  
# history.campaigns


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
|id     |     integer     |   идентификатор рекламного проекта|
 |   id_greement| integer      |  идентификатор договора|
 |   name      |  varchar(50)  | название проекта |
   | details   |  json          |детали проекта |
   | budget     | decimal(10, 2)| бюджет |
   | date_start | date          | дата начала |
   | date_end   | date          | дата планируемого окончания|
   | ch_dt      | TIMESTAMPTZ   |дата добавения в логи |
  
# history.job

| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
|  id    |       serial  |  идентификатор работы  |
|  name   |      varchar(50)  | название работы |
| hour_payment| decimal(8, 2)| почасовая оплата |
|ch_dt    |    TIMESTAMPTZ  | дата добавления в логи |

  
# history.price


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
|  id  |serial     | Идентификатор услуги   |
| name      |varchar(50)       | Название услуги     |
| min_cost |decimal(8, 2)    | Минимальная оплата     |
|ch_dt    |    TIMESTAMPTZ  | дата добавления в логи |

  
# history.promotion_materials


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
|   id         |    integer     | идентификатор рекламных материалов  |  
 |   id_agreement|   integer   |   идентификатор договора  |  
  |    types       |   varchar(50) |  тип материала |  
  |    link        |   varchar(255) | ссылка на материал |  
  |    detalis     |   varchar(255)| описание |  
|ch_dt    |    TIMESTAMPTZ  | дата добавления в логи |

# history.report


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
|   id         |    integer     | идентификатор отчета  |  
  |  id_agreement| integer| идентификатор договора|
  |  date_ending|  date  | дата фактического окончания проекта |
 |   result   |    json  |  результат |
|ch_dt    |    TIMESTAMPTZ  | дата добавления в логи |

<h3 align="center">Функции</h3>

# Удаление партиции
```
select history.deletepartitions ('job')

```
Ответ при коректном вводе
```
{"data" : null}
```
Ответ при ошибке: 
```
{"errors": [{"error": "history.deletepartitions", "detail": "Нет таблиц за определенную дату", "message": "Таблиц для удаления нет!"}]}
```

# Создание партиций
Рекламные проекты:
```
history.history_campaigns_insert()
```
Работа:
```
history.history_job_insert_trigger();
```
Услуги:
```
 history.history_price_insert();
```
Рекламные материалы:
```
history.history_promotion_materials_insert()
```
Отчеты:
```
history.history_report_insert()
```
