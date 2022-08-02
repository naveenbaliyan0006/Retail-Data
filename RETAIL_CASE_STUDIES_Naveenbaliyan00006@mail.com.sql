--CREATE DATABASE CASE_STUDY_RETAIL

  

USE CASE_STUDY_RETAIL ;

 /************************************************************************************************************************************************	
  -- **********ROUGH WORK************

 exec sp_columns transactions     exec sp_columns Customer      exec sp_columns prod_cat_info 

 exec sp_help transactions         exec sp_help Customer                 exec sp_help prod_cat_info 

  select * from [dbo].[Customer];       select * from [dbo].[Transactions];       select * from [dbo].[prod_cat_info]; 
  
  ALTER TABLE  [dbo].[Transactions]
  ALTER COLUMN QTY NUMERIC  
  
update transactions set tran_date  = convert(date ,transactions.tran_date , 105)
--**************************************************************************************************************************/

--q1

select 'CUSTOMER' AS TABLE_NAME, COUNT(*) AS  CUST_COUNT from [dbo].[Customer]
UNION
select'PROD_CAT_INFO' ,COUNT(*) AS PROD_CAT_COUNT from [dbo].[prod_cat_info]
UNION
select 'TRANSACTIONS', COUNT(*) AS TRANS_COUNT from [dbo].[Transactions] ;

--**************************************************************************************************************************
-- Q2 
		
 SELECT 'RETURN' AS TRANSACTIONS_TYPE ,COUNT(*) AS COUNT_ FROM [dbo].[Transactions]
  WHERE QTY < 0 ;
--**************************************************************************************************************************

--Q3 

update transactions set tran_date  = convert(date ,transactions.tran_date , 105)

 alter table [Transactions] 

 alter column tran_date date


 -- ************************************************************************************************************************************************
 --Q4 
      
	  SELECT   CUST_ID , TRAN_DATE, (SELECT DATEDIFF(DAY,GETDATE() , TRAN_DATE )) AS NO_OF_DAY,
	   (SELECT DATEDIFF(MONTH,GETDATE() , TRAN_DATE )) AS NO_OF_MONTH  ,
	    (SELECT DATEDIFF(YEAR,GETDATE() , TRAN_DATE )) AS NO_OF_YEAR  
		  FROM TRANSACTIONS ;

 -- ************************************************************************************************************************************************

 -- Q5

 SELECT prod_cat,prod_subcat FROM [dbo].[prod_cat_info]
  WHERE PROD_SUBCAT = 'DIY' ;

 
 --************************************************************************************************************************************************
 --************************************************************************************************************************************************	
  --Q1 

  SELECT TOP 1  STORE_TYPE, COUNT(STORE_TYPE) AS COUNT_CHANNEL  FROM [dbo].[Transactions]
  GROUP BY STORE_TYPE 
  ORDER BY COUNT_CHANNEL DESC ;

--**************************************************************************************************************************
 --Q2 
  
  SELECT GENDER , COUNT(GENDER) AS COUNT_OF_M_F FROM [dbo].[Customer]
  GROUP BY GENDER ;  

             --OR   

  SELECT GENDER , COUNT(GENDER) AS COUNT_OF_M_F FROM [dbo].[Customer]
  WHERE GENDER IN ('M','F')
  GROUP BY GENDER ;

--**************************************************************************************************************************
  --Q3 

  SELECT city_code, COUNT(CITY_CODE) AS COUNT_CITY_NO  FROM   CUSTOMER
  INNER JOIN    TRANSACTIONS 
  ON            CUSTOMER.customer_Id =  TRANSACTIONS.CUST_ID
  GROUP BY      city_code
  ORDER BY      COUNT_CITY_NO DESC ;

--**************************************************************************************************************************
--Q4 

  SELECT PROD_CAT , PROD_SUBCAT FROM [dbo].[prod_cat_info]
  WHERE PROD_CAT = 'BOOKS' ;

   -- OR
                     
  SELECT PROD_CAT , COUNT (PROD_SUBCAT) AS SUB_CAT_COUNT FROM [dbo].[prod_cat_info]
  WHERE PROD_CAT = 'BOOKS'
  GROUP BY PROD_CAT  ;


 --************************************************************************************************************************** 
  --Q5 

  ALTER TABLE  [dbo].[Transactions]
  ALTER COLUMN QTY NUMERIC 

  SELECT TOP 1  PROD_CAT_CODE , PROD_SUBCAT_CODE , SUM(QTY) AS QTY_SUM FROM [dbo].[Transactions]
  GROUP BY PROD_CAT_CODE , PROD_SUBCAT_CODE 
  order by QTY_SUM DESC ;

--**************************************************************************************************************************
  
  --Q6
   
  ALTER TABLE [dbo].[Transactions]
  ALTER COLUMN TOTAL_AMT NUMERIC
  
 ( SELECT  prod_cat,SUM(total_amt) AS REVENUE  FROM Transactions  
  INNER JOIN  PROD_CAT_INFO
  ON          TRANSACTIONS.PROD_CAT_CODE = PROD_CAT_INFO. PROD_CAT_CODE AND   TRANSACTIONS.PROD_SUBCAT_CODE = PROD_CAT_INFO . PROD_SUB_CAT_CODE 
  WHERE       PROD_CAT IN ('ELECTRONICS' , 'BOOKS')
  GROUP BY    PROD_CAT  )

  UNION 

  (  SELECT 'TOTAL_REVENUE' , SUM(REVENUE) FROM 
  (SELECT  prod_cat,SUM(total_amt) AS REVENUE  FROM Transactions  
  INNER JOIN   PROD_CAT_INFO
  ON          TRANSACTIONS.PROD_CAT_CODE = PROD_CAT_INFO. PROD_CAT_CODE AND  TRANSACTIONS.PROD_SUBCAT_CODE = PROD_CAT_INFO . PROD_SUB_CAT_CODE 
  WHERE      PROD_CAT IN ('ELECTRONICS' , 'BOOKS')
  GROUP BY   PROD_CAT) AS NEW_TBL  )


  --*******************************************************************************************************************
  -- NEED TO ASK IF I NEED TO ADD NEGATIVE ALSO IN NET REVENUE ??????
  /*
   CASE 
        WHEN TOTAL_AMT >=0 THEN SUM(TOTAL_AMT)
		END
		AS REVENUE_AMT
  */
--**************************************************************************************************************************
  --Q7

  SELECT CUST_ID ,COUNT(CUST_ID) AS CUST_COUNT FROM  ( SELECT CUST_ID , QTY , TOTAL_AMT FROM Transactions  WHERE QTY >=0  )    AS NEW_TBL
  GROUP BY CUST_ID 
  HAVING COUNT(CUST_ID) >10 ;

--**************************************************************************************************************************

  --(  SELECT CUST_ID ,COUNT(CUST_ID) AS CUSTOMER_COUNT, QTY FROM Transactions  HAVING (QTY >=0) AND (COUNT(CUST_ID) >10 ) ) 

--**************************************************************************************************************************

  --Q8

  ALTER TABLE [dbo].[Transactions]
  ALTER COLUMN   PROD_CAT_CODE   NUMERIC 

  (  SELECT STORE_TYPE,PROD_CAT,SUM( TOTAL_AMT) AS REVENUE  FROM TRANSACTIONS 
   INNER JOIN  PROD_CAT_INFO 
  ON             TRANSACTIONS.PROD_CAT_CODE = PROD_CAT_INFO.PROD_CAT_CODE  AND   TRANSACTIONS.PROD_SUBCAT_CODE = PROD_CAT_INFO.PROD_SUB_CAT_CODE
  WHERE        ( PROD_CAT IN ('ELECTRONICS' , 'CLOTHING' )) AND (STORE_TYPE = 'FLAGSHIP STORE')
  GROUP BY     STORE_TYPE,PROD_CAT    )

  UNION 

  SELECT '_','TOTAL REVENUE' ,SUM(REVENUE) AS REVENUE  FROM 
(
   SELECT STORE_TYPE,PROD_CAT,SUM( TOTAL_AMT) AS REVENUE  FROM TRANSACTIONS 
   INNER JOIN   PROD_CAT_INFO 
  ON             TRANSACTIONS.PROD_CAT_CODE = PROD_CAT_INFO.PROD_CAT_CODE  AND   TRANSACTIONS.PROD_SUBCAT_CODE = PROD_CAT_INFO.PROD_SUB_CAT_CODE
  WHERE        ( PROD_CAT IN ('ELECTRONICS' , 'CLOTHING' )) AND (STORE_TYPE = 'FLAGSHIP STORE')
  GROUP BY      STORE_TYPE,PROD_CAT  ) AS NEW_TBL
  
   
 -- *******************************************************************************************************************
 
   --Q9 

  SELECT GENDER,prod_cat,prod_subcat ,SUM(TOTAL_AMT) AS TOTAL_REVENUE       FROM 
 ( SELECT CUSTOMER_ID , GENDER, CUST_ID , PROD_SUBCAT_CODE , PROD_CAT_CODE , TOTAL_AMT  FROM    CUSTOMER 
  INNER JOIN    TRANSACTIONS 
	ON          CUSTOMER.CUSTOMER_ID  =  TRANSACTIONS.CUST_ID )  AS COMB_TBL
  INNER JOIN    PROD_CAT_INFO
    ON          COMB_TBL . PROD_CAT_CODE = PROD_CAT_INFO. PROD_CAT_CODE  AND  COMB_TBL. PROD_SUBCAT_CODE = PROD_CAT_INFO . PROD_SUB_CAT_CODE
    WHERE       PROD_CAT = 'ELECTRONICS' AND  GENDER = 'M'
  GROUP BY      GENDER,prod_cat,prod_subcat
  ORDER BY      PROD_SUBCAT
		

 -- *******************************************************************************************************************
 
--Q10

    SELECT TOP 5   prod_subcat, (SUM(Qty)*100 / (SELECT SUM(QTY) FROM TRANSACTIONS )) AS QTY_PERCENT, 
	               (SUM(total_amt)* 100 / (SELECT SUM(TOTAL_AMT) FROM TRANSACTIONS )) AS SALE_PERCENT ,
				    SUM(TOTAL_AMT) AS TOTAL_SALES FROM TRANSACTIONS 
	INNER JOIN     PROD_CAT_INFO
	ON             TRANSACTIONS.PROD_CAT_CODE = PROD_CAT_INFO.PROD_CAT_CODE   AND    TRANSACTIONS.PROD_SUBCAT_CODE = PROD_CAT_INFO.PROD_SUB_CAT_CODE
	GROUP BY       PROD_SUBCAT
	ORDER  BY     SUM(TOTAL_AMT) DESC 

 -- *******************************************************************************************************************	
 
--Q11   

/*
 exec sp_help Customer 

  UPDATE CUSTOMER SET DOB = CONVERT (DATE ,DOB ,105)

 alter table customer 
 alter column dob date   */


   SELECT SUM(TOTAL_AMT) AS NET_TTL_REVENUE  FROM ( select * from (select *, (select datediff(YEAR,dob,getdate() )) as no_yrs from customer) as new_tbl 
             where NO_YRS BETWEEN 25 AND 35   )  AS NEW_CUS_TBL 
   INNER JOIN    (   SELECT * FROM TRANSACTIONS  WHERE TRAN_DATE >= DATEADD(DAY , -30, (SELECT MAX(TRAN_DATE) FROM TRANSACTIONS )) )  AS NEW_TRAN_TBL
	ON           NEW_CUS_TBL.CUSTOMER_ID  =  NEW_TRAN_TBL.CUST_ID  
	
 -- *******************************************************************************************************************

--Q12 


SELECT TOP 1 prod_cat, FILTER_SUM_RET    FROM  PROD_CAT_INFO
INNER JOIN   (  SELECT  cust_id, tran_date, prod_subcat_code, prod_cat_code, total_amt ,  SUM(TOTAL_AMT) AS FILTER_SUM_RET     FROM TRANSACTIONS  
 WHERE       TRAN_DATE >= DATEADD(MONTH,-3 , (SELECT MAX(TRAN_DATE) FROM TRANSACTIONS))
 GROUP BY    cust_id, tran_date, prod_subcat_code, prod_cat_code, Qty, total_amt ) AS NEW_RETURN_TBL
 ON           PROD_CAT_INFO.PROD_CAT_CODE  = NEW_RETURN_TBL.PROD_CAT_CODE   AND   PROD_CAT_INFO.PROD_SUB_CAT_CODE = NEW_RETURN_TBL.PROD_SUBCAT_CODE 
 WHERE       FILTER_SUM_RET >=0
 GROUP BY    PROD_CAT,FILTER_SUM_RET
 ORDER BY    FILTER_SUM_RET DESC ;


 -- *******************************************************************************************************************

--Q13

    SELECT TOP 1  Store_type ,SUM(Qty) AS QTY_SUM, SUM(TOTAL_AMT)AS SALE_AMT    FROM TRANSACTIONS 
	GROUP BY  Store_type 
	HAVING SUM(TOTAL_AMT) >=0
	ORDER BY STORE_TYPE


 -- *******************************************************************************************************************

--Q14 

	SELECT  prod_cat,AVG_REVENUE FROM  PROD_CAT_INFO
	INNER JOIN  (  SELECT prod_cat_code, AVG(total_amt) AS AVG_REVENUE FROM TRANSACTIONS  GROUP BY PROD_CAT_CODE ) AS X
      ON        PROD_CAT_INFO.prod_cat_code = X.prod_cat_code
	 WHERE      AVG_REVENUE > (SELECT AVG(TOTAL_AMT) FROM TRANSACTIONS )
	 GROUP BY   prod_cat,  AVG_REVENUE ;
	 
 -- *******************************************************************************************************************
--Q15 

    SELECT  TOP 5  prod_cat, prod_subcat ,  SUM(Qty) AS QTY_SUM_ , AVG (total_amt) AS AVG_OF_SUBCAT, SUM(TOTAL_AMT) AS TOTAL_REVENUE   FROM   TRANSACTIONS 
	INNER JOIN     PROD_CAT_INFO
	ON             TRANSACTIONS.PROD_CAT_CODE = PROD_CAT_INFO.PROD_CAT_CODE   AND  TRANSACTIONS.PROD_SUBCAT_CODE = PROD_CAT_INFO.PROD_SUB_CAT_CODE
    GROUP BY       prod_cat, prod_subcat
    ORDER BY       SUM(QTY) DESC , PROD_CAT  ;

 -- *******************************************************************************************************************
































