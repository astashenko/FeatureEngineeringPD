# Результат тестирования данных 

## 26.09.2023

#### Тестирование фичи contract_cnt Количество договоров с рассчитанными фичой в витрине ЦАЛ

значения contract_cnt не совпадают у 12 строк из 51692

#### Тестирование списка договоров, которые будут учитываться при расчете фичей 

Проверка успешно прошла
значения не совпадают у 11 строк из 51691 
связано с тем, что Отбор строк по дате лизинга в ЦАЛ производится после того как дата лизинга агрегирована на самое первое приложение, получается, что если у первого приложения не было передачи в лизинг, а у повторного есть, то невозможно определить что есть лизинг. Это необходимо править в витрине ЦАЛ

#### Тестирование фичи contract_ovd_cnt - количество просроченных договоров на дату принятия решения с рассчитанной фичой в витрине ЦАЛ 

Проверка прошла успешно. 
значения 'OVERDUE_FLG' не совпадают у 304 строк из 139464. Причем во всех случаях в ЦАЛ витрине был установлен флаг 'OVERDUE_FLG'=1, когда сейчас он 'OVERDUE_FLG'=0. В большинстве случаев, это были договоры с PLAN_PAY_DT_ORIG = 2023-07-04, платежи могли прийти в систему ЦАЛ позже, поэтому мы строили на OVD.PLAN_PAY_DT_ORIG < CONTRS.DECISION_DATE - 1, то еть меньше  2023-07-04. так что такие разногласия допустимы. Тем более что мы строим на последней версии данных, так что сторно не учитывается. поэтому 100% совпадения не будет


#### Тестирование фичи dsnc_ovd_pay_days "Количество дней с последней оплаченной просрочки" с рассчитанными фичой в витрине ЦАЛ 

Проверка прошла успешно. 
значения не совпадают у 45 строк из 84443. 1с подтверждает данные посчитанные здесь а не витрине ЦАЛ

#### Тестирование всех агрегированных фичей с рассчитанными фичами в витрине ЦАЛ

Проверка прошла успешно. 

contract_cnt значения не совпадают у 12 строк из 51692
contract_ovd_cnt значения не совпадают у 244 строк из 51692
dsnc_ovd_pay_days значения не совпадают у 30 строк из 51692

#### Ручная проверка рабочего варианта сформированный таблицы отдельных случаев по данным 1с

Проверка прошла успешно

#### Проверка состава и характеристик итогового варианта таблицы 

Проверка прошла успешно

___________

## 05.10.2023

#### Тестирование списка договоров, которые будут учитываться при расчете фичей 

Проверка успешно прошла
значения не совпадают у 9 строк из 59042
связано с тем, что Отбор строк по дате лизинга в ЦАЛ производится после того как дата лизинга агрегирована на самое первое приложение, получается, что если у первого приложения не было передачи в лизинг, а у повторного есть, то невозможно определить что есть лизинг. Это необходимо править в витрине ЦАЛ


#### Тестирование параметра OVERDUE_FLG наличия просрочки по договору на определенную дату

Проверка прошла успешно. 
значения не совпадают у 230 строк из 153662. Причем во всех случаях в ЦАЛ витрине был установлен флаг 'OVERDUE_FLG'=1, когда сейчас он 'OVERDUE_FLG'=0. такие разногласия допустимы. Тем более что мы строим на последней версии данных, так что сторно не учитывается. поэтому 100% совпадения не будет


#### Тестирование показателя max_leas_ovd_pay_dt - дата последней оплаченной просроченной задолженности по лизинговым платежам с ЦАЛ

Проверка прошла успешно. 
значения совпадают во всех 99205 строках

#### Тестирование всех фичей с рассчитанными фичами в витрине ЦАЛ 

Проверка прошла успешно. 

contract_cnt значения не совпадают у 9 строк из 59042
contract_ovd_cnt значения не совпадают у 178 строк из 59042
dsnc_ovd_pay_days значения не совпадают у 23 строк из 59042

#### Ручная проверка рабочего варианта сформированный таблицы отдельных случаев по данным 1с

Проверка прошла успешно

#### Проверка состава и характеристик итогового варианта таблицы 

Проверка прошла успешно

### Тестирование данных по выборочно выгруженным из 1с 
1. Тестирование количество договоров за 6 месяцев
   
   Проверка по столбцам ctr_count_6m и ctr_count_6m_csv - значения не совпадают у 1 строк из 51504
различие из-за того,что в договоре , не было даты лизинга, а по договору она есть, после цессии, и если брать условие ата лизинга по договору, то он посчитался. более правильно в наших фичах

1. Тестирование параметра OVERDUE_FLG наличия просрочки по договору на определенную дату по 1с
   
значения совпадают во всех 128 строках

1. Тестирование параметра max_leas_ovd_pay_dt - дата последней оплаченной просроченной задолженности по лизинговым платежам на определенную дату по 1с

значения совпадают во всех 147 строках

___________

## 06.10.2023

### Проведена проверка contract_cnt с записями в DM.BEHAVIOR_MODEL_DAILY 

Проверялись сделки, при условии Дата принятия решения по сделке позднее 2020-10-19, даты появления первой записи в таблице DM.BEHAVIOR_MODEL_DAILY_HIST. 

Проверялось 20896 сделок

1. смотрим просто по последней записи в DM.BEHAVIOR_MODEL_DAILY

Все, у кого у нас имеются контракты, есть на сегодняшний день записи в DM.BEHAVIOR_MODEL_DAILY

Проверка пройдена успешно

1. смотрим по записи DM.BEHAVIOR_MODEL_DAILY_HIST на дату DECISION_DATE
значения не совпадают у 805 строк из 20896

| ИНН контрагента | Дата принятия решения по сделке | CLIENT_KEY | contract_cnt > 0 | Есть в BEH |
| --------------- | ------------------------------- | ---------- | ---------------- | ---------- |
| ***    | 16.11.2020                      | 160706     | False            | True       |


#### Анализ различий:

1.	Когда has_contracts==False, contract_cnt == 0, а в   BEH на дату принятия решения есть записи

**Пример 1:**

| ИНН контрагента | Дата принятия решения по сделке | CLIENT_KEY | contract_cnt > 0 | Есть в BEH |
| --------------- | ------------------------------- | ---------- | ---------------- | ---------- |
| ***     | 2020-11-16                      | 160706     | False            | True       |

До 2020-11-16 договоров по данным 1с не было, в beh запись уже была, что не верно, но указано CLIENT_ACTIVE_PAYER_COUNT_M = 0, то есть, запись есть, но платежей в прошлом не было, возможно так нужно читать эту таблицу

| SNAPSHOT_DT | CLIENT_KEY | ACCOUNTID                            | CLIENT_ACTIVE_PAYER_COUNT_M | CLIENT_AGE_DAYS |
| ----------- | ---------- | ------------------------------------ | --------------------------- | --------------- |
| 2020-11-15  | 160706     | 068E95FB-4C1E-E511-8FC1-2C768A556E81 | 0                           |                 |	 

**Примеры, которые объясняются почему contract_cnt == 0 при повторных клиентах.** 

У всех договоры были более 5 лет назад:

ИНН контрагента = '*** ' CLIENT_KEY = 37401  2021-05-19 был договор более 5 назад АЛ 38820/01-15 БШК от 09.04.2015, поэтому contract_cnt == 0

ИНН контрагента ***  договор до АЛ 1143/01-13 от 26.02.2013  

ИНН контрагента ***  договор до АЛ 26897/01-14 от 18.09.2014  

ИНН контрагента ***  договор до АЛ 1254/02-13 НЖГ от 12.03.2013  

ИНН контрагента ***  договор до АЛ 29317/01-14 ЕКБ от 28.10.2014  

ИНН контрагента ***  договор до АЛ 437/02-13 от 15.02.2013 

2.	Пример, когда has_contracts==True, contract_cnt > 0, а в   BEH на дату принятия решения нет

**Пример 1**:

ИНН контрагента = ***  CLIENT_KEY = 178209 первая запись появилась на следующий день, после принятия решения 


| ИНН контрагента | Дата принятия решения по сделке | CLIENT_KEY | contract_cnt > 0 | Есть в BEH |
| --------------- | ------------------------------- | ---------- | ---------------- | ---------- |
| ***       | 2021-09-09                      | 178209     | True             | False      |


в базе BEH первая запись появилась на следующий день после принятия решения 

| SNAPSHOT_DT | CLIENT_KEY | ACCOUNTID                            | CLIENT_ACTIVE_PAYER_COUNT_M | CLIENT_AGE_DAYS |
| ----------- | ---------- | ------------------------------------ | --------------------------- | --------------- |
| 2021-09-10  | 178209     | 6BEAFA2F-0DAB-EA11-80FD-02BF0A010246 | 6                           |                 |
|             |            |                                      |                             |                 |
 
**Пример 2:**

ИНН контрагента = ***  CLIENT_KEY = 175988 (Дата принятия решения по сделке = 2021-03-02) первая оплата была 21.12.2020, так что в beh должен был быть, но 04.03.21 появился на следующий день после принятия решения

| ИНН контрагента | Дата принятия решения по сделке | CLIENT_KEY | contract_cnt > 0 | Есть в BEH |
| --------------- | ------------------------------- | ---------- | ---------------- | ---------- |
| 345300*** 6655      | 2021-03-02                      | 175988,00  | True             | False      |

в базе BEH первая запись появилась на следующий день после принятия решения

| SNAPSHOT_DT | CLIENT_KEY | ACCOUNTID                            | CLIENT_ACTIVE_PAYER_COUNT_M | CLIENT_AGE_DAYS |
| ----------- | ---------- | ------------------------------------ | --------------------------- | --------------- |
| 2021-03-04  | 175988     | 9CA304BF-FC48-EB11-8103-02BF0A010246 | 3                           |                 |

**Вывод**: ошибок в расчете фичей по данным BEH не выявлено
