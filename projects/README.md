<h1 align="center">projects<a href="https://daniilshat.ru/" target="_blank"></a> 
<h3 align="center">Таблицы</h3>

  
# projects.campaigns


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
|id     |     integer     |   идентификатор рекламного проекта|
 |   id_greement| integer      |  идентификатор договора|
 |   name      |  varchar(50)  | название проекта |
   | details   |  json          |детали проекта |
   | budget     | decimal(10, 2)| бюджет |
   | date_start | date          | дата начала |
   | date_end   | date          | дата планируемого окончания|
   
  
# projects.promotion_materials


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
|   id         |    integer     | идентификатор рекламных материалов  |  
 |   id_agreement|   integer   |   идентификатор договора  |  
  |    types       |   varchar(50) |  тип материала |  
  |    link        |   varchar(255) | ссылка на материал |  
  |    detalis     |   varchar(255)| описание |  

# projects.report


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |
|   id         |    integer     | идентификатор отчета  |  
  |  id_agreement| integer| идентификатор договора|
  |  date_ending|  date  | дата фактического окончания проекта |
 |   result   |    json  |  результат |



#  projects.agreement


| Название столбца | Тип данных |Описание  |
| :---         |     :---:      |          ---: |


   | id   |      integer| идентификатор договора|

   | id_client | integer | идентификатор клиента |
   | date_start| date   | дата начала|
    |date_end  | date   | дата планируемого окончания|
    |text   |    json  | текст договора |

    
<h3 align="center">Функции</h3>

# Функции поиска 
```
humanresource.agreement_materials(_log_id BIGINT)
humanresource.client_materials(_client_id BIGINT)

```
# Функции добавления и ообновления данных 
```
projects.agreement_upd(_src JSONB)
projects.promotion_upd(_src JSONB)

```

# Функции удаления данных
```
delete_agreement(_agr_id integer)
```

Пример ввода: 
```
select projects.promotion_upd('
  {
  "id_agreement": 7,
  "types": "Рекламная вывеска",
  "link": "-",
  "detalis": "Ожидается оплата"
}
');
```
