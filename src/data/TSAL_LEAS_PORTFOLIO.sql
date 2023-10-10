  DEFINE P_REPORT_DT = "to_date('2023.09.14', 'YYYY.MM.DD')";

  select
                                     &P_REPORT_DT,
                                     DWH.CONTRACTS.CONTRACT_KEY,
                                     DWH.CONTRACTS.CONTRACT_NUM,
                                     DWH.LEASING_CONTRACTS_APPLS.CONTRACT_APP_KEY,
                                     DWH.LEASING_CONTRACTS_APPLS.PRESENTATION,
                                     DWH.LEASING_CONTRACTS_APPLS.CONTRACT_NUM,
                                     DWH.CONTRACTS.OPEN_DT,
                                     DWH.CONTRACTS.CLOSE_DT,
                                     DWH.LEASING_CONTRACTS.AUTO_FLG,
                                     nvl(DWH.ACCOUNT.NEW_INN,DWH.CLIENTS.INN),
                                     DWH.NEW_CONTRACT.NEW_CONTRACTID,
                                     TRANS.lease_date,
                                     DWH.NEW_LEASOBJECT.NEW_NUM1C,
                                     DWH.NEW_LEASOBJECT.NEW_CARTYPENAME,
                                     DWH.NEW_LEASOBJECT.NEW_CARTYPE,
                                     sysdate,
                                     DWH.CLIENTS.CLIENT_KEY

FROM DWH.CONTRACTS
INNER JOIN DWH.LEASING_CONTRACTS ON  DWH.LEASING_CONTRACTS.CONTRACT_KEY = DWH.CONTRACTS.CONTRACT_KEY
                                 AND DWH.LEASING_CONTRACTS.VALID_TO_DTTM = to_date('01.01.2400','dd.mm.yyyy')
                                 and NVL(DWH.LEASING_CONTRACTS.AUTO_FLG,0) = 1
INNER JOIN DWH.LEASING_CONTRACTS_APPLS ON  DWH.LEASING_CONTRACTS_APPLS.CONTRACT_KEY = DWH.CONTRACTS.CONTRACT_KEY
                                       AND DWH.LEASING_CONTRACTS_APPLS.VALID_TO_DTTM = to_date('01.01.2400','dd.mm.yyyy')
                                       AND NVL(DWH.LEASING_CONTRACTS_APPLS.DELETIONMARK, 0) !=1
INNER JOIN (SELECT distinct TT.ACT_DT as lease_date, T.CONTRACT_KEY, T.CONTRACT_APP_KEY, T.CONTRACT_NUM
            FROM (SELECT CONTR.CONTRACT_NUM,
                         CONTR.CONTRACT_KEY,
                         LST.CONTRACT_APP_KEY,
                         LST.TRANSMIT_SUBJECT_CD,
                         LST.SNAPSHOT_DT,
                         LST.ACT_DT,
                         FIRST_VALUE (LST.TRANSMIT_SUBJECT_CD) over (partition by CONTR.CONTRACT_NUM order by LST.SNAPSHOT_DT) as TRANSMIT_SUBJECT_CD_1,
                         FIRST_VALUE (LST.CONTRACT_APP_KEY) over (partition by CONTR.CONTRACT_NUM order by LST.SNAPSHOT_DT) as CONTRACT_APP_KEY_1
                  FROM DWH.LEASING_SUBJECT_TRANSMIT LST
                  INNER JOIN (SELECT CONTR.CONTRACT_NUM,
                                     CONTR.CONTRACT_KEY,
                                     LCA.CONTRACT_APP_KEY
                              FROM DWH.CONTRACTS CONTR
                              INNER JOIN DWH.LEASING_CONTRACTS LC ON LC.CONTRACT_KEY = CONTR.CONTRACT_KEY
                                                                  AND LC.VALID_TO_DTTM = TO_DATE ('01.01.2400', 'DD.MM.YYYY')
                                                                  AND NVL(LC.AUTO_FLG,0) = 1
                              INNER JOIN DWH.LEASING_CONTRACTS_APPLS LCA ON LCA.CONTRACT_KEY = CONTR.CONTRACT_KEY
                                                                         AND LCA.VALID_TO_DTTM = TO_DATE ('01.01.2400', 'DD.MM.YYYY')
                                                                         AND NVL(LCA.DELETIONMARK, 0) !=1
                              WHERE CONTR.VALID_TO_DTTM = TO_DATE ('01.01.2400', 'DD.MM.YYYY')
                              AND NVL(CONTR.DELETE_FLG, 0) !=1) CONTR ON CONTR.CONTRACT_APP_KEY = LST.CONTRACT_APP_KEY
                  WHERE LST.VALID_TO_DTTM = TO_DATE ('01.01.2400', 'DD.MM.YYYY')
                  AND LST.ACT_DT IS NOT NULL AND LST.ACT_DT > TO_DATE ('01.01.0001', 'DD.MM.YYYY')
                  AND LST.ACT_NUM IS NOT NULL
                  AND LST.CONTRACT_APP_KEY IS NOT NULL) T,
                  (SELECT LST.CONTRACT_APP_KEY,
                          LST.TRANSMIT_SUBJECT_CD,
                          LST.SNAPSHOT_DT,
                          FIRST_VALUE (LST.ACT_DT) over (partition by LST.CONTRACT_APP_KEY, LST.TRANSMIT_SUBJECT_CD order by LST.SNAPSHOT_DT DESC) as act_dt
                  FROM DWH.LEASING_SUBJECT_TRANSMIT LST
                  WHERE LST.VALID_TO_DTTM = TO_DATE ('01.01.2400', 'DD.MM.YYYY')
                  AND LST.ACT_DT IS NOT NULL AND LST.ACT_DT > TO_DATE ('01.01.0001', 'DD.MM.YYYY')
                  AND LST.ACT_NUM IS NOT NULL
                  AND LST.CONTRACT_APP_KEY IS NOT NULL) TT
                  WHERE TT.TRANSMIT_SUBJECT_CD = T.TRANSMIT_SUBJECT_CD_1
                    AND TT.CONTRACT_APP_KEY = T.CONTRACT_APP_KEY_1
                    AND T.TRANSMIT_SUBJECT_CD = T.TRANSMIT_SUBJECT_CD_1
                    AND T.CONTRACT_APP_KEY = T.CONTRACT_APP_KEY_1) TRANS ON TRANS.CONTRACT_NUM = DWH.CONTRACTS.CONTRACT_NUM

LEFT JOIN DWH.CLIENTS ON  DWH.CLIENTS.CLIENT_KEY = DWH.CONTRACTS.CLIENT_KEY
                      AND DWH.CLIENTS.VALID_TO_DTTM  = TO_DATE ('01.01.2400', 'DD.MM.YYYY')

LEFT JOIN (SELECT CLIENT_CD, CRM_CLIENT_CD
           FROM (SELECT CLIENT_CD, CRM_CLIENT_CD, CREATION_DT,
                        ROW_NUMBER () OVER (PARTITION BY CLIENT_CD ORDER BY CREATION_DT desc) RN
                 FROM (SELECT CLIENT_CD, CRM_CLIENT_CD, CREATION_DT
                       FROM DWH.CRM_CLIENTS
                       WHERE VALID_TO_DTTM  = TO_DATE ('01.01.2400', 'DD.MM.YYYY')
                       AND CLIENT_CD IS NOT NULL))
           WHERE RN = 1 ) CRM_CLIENTS ON CRM_CLIENTS.CLIENT_CD = DWH.CLIENTS.CLIENT_CD

LEFT JOIN DWH.ACCOUNT ON  DWH.ACCOUNT.ACCOUNTID = UPPER(CRM_CLIENTS.CRM_CLIENT_CD)
                      AND DWH.ACCOUNT.VALID_TO_DTTM = TO_DATE ('01.01.2400', 'DD.MM.YYYY')

LEFT JOIN DWH.NEW_CONTRACT ON
                            DWH.NEW_CONTRACT.NEW_CONTRACTID = UPPER(DWH.LEASING_CONTRACTS.CRM_CONTRACT_CD)
                           AND DWH.NEW_CONTRACT.VALID_TO_DTTM = TO_DATE ('01.01.2400', 'DD.MM.YYYY')

LEFT JOIN DWH.NEW_LEASOBJECT ON  DWH.NEW_LEASOBJECT.NEW_LEASOBJECTID = DWH.NEW_CONTRACT.NEW_LEASOBJECT
                             AND DWH.NEW_LEASOBJECT.VALID_TO_DTTM = TO_DATE ('01.01.2400', 'DD.MM.YYYY')

WHERE DWH.CONTRACTS.VALID_TO_DTTM = to_date('01.01.2400','dd.mm.yyyy')
AND NVL(DWH.CONTRACTS.DELETE_FLG, 0) !=1
AND TRANS.lease_date IS NOT NULL
