# Сбор данных для модели PD-12 ЦАЛ

Проект не содержит данных, служит для сохранения исходных текстов программы

## Установка

```bash
git clone [Title](https://github.com/astashenko/FeatureEngineeringPD.git)
```
---
## Использование

Проект создан для сбора и тестирования данных модели PD-12 ЦАЛ

- Исходные тексты программ находятся в папке **src**
  
- Директория **src/data** предназначена для создания .plk файлов, инициализации функций доступа к данным

- Описание сформированных данных reports/report_of_testing_data.md

- Порядок тестирования сформированных данных src/testing/plan_of_test.md
  

#### Порядок сбора данных для тестирования модели PD-12

у всех файлов, если не указано иначе, корневой каталог *src/*

1. Чтение данных 

```bash  
src/data/create_pickle.ipynb
``` 

2. Подготовка данных target_class

```bash  
src/preprocessing/processing_target.ipynb
``` 

3. Формирование и запись вспомогательной таблицы pre_contracts: "все договоры ИНН на день принятия решения"

```bash  
src/preprocessing/contracts_of_inn.ipynb
``` 

4. Расчет фичи okved  - ОКВЭД

```bash  
src/features/11okved.ipynb
``` 

5. Определение списка договоров на каждую дату decision_date и ИНН контрагента

```bash  
src/features/12contracts.ipynb
``` 

6. Расчет параметра OVERDUE_FLG наличия просрочки по договору на определенную дату

```bash  
src/features/13contract_ovd.ipynb
``` 

7. Расчет показателя max_leas_ovd_pay_dt - дата последней оплаченной просроченной задолженности по лизинговым платежам

```bash  
src/features/14leas_ovd_pay_dt.ipynb
``` 

8. Объединение всех фичей в одну таблицу 

```bash  
src/features/21features_combine.ipynb
``` 



####  Назначение отдельных веток:
*main* - стабильная версия

*develop* - для разработки

*preprod* - ветка перед merge в main
