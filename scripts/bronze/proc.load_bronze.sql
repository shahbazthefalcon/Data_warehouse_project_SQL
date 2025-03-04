


USE [DataWarehouse]
GO
/****** Object:  StoredProcedure [bronze].[local_bronze]    Script Date: 04/03/2025 10:11:40 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER   Procedure [bronze].[local_bronze] AS 
BEGIN
	DECLARE @Start_time DATETIME, @end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		print '===================================================================================================================='
		print 'Loading the Bronze layer '
		print'====================================================================================================================='

		print '--------------------------------------------------------------------------------------------------------------------'
		print 'LADING CRM TABLES'
		print '--------------------------------------------------------------------------------------------------------------------'

		set @Start_time = GETDATE();
		print '>> TRUNCATING the TABLE: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info
		
		print '>> INSERTING DATA INTO the TABLE: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM
		"C:\Users\shahb\Downloads\Compressed\DATAWAREHOUSE PROJET\DATA\sql-data-warehouse-project\datasets\source_crm\cust_info.csv"

		with (
		FIRSTROW=2,
		FIELDTERMINATOR =',',
		TABLOCK

		)
		set @end_time = GETDATE();
		print '>> LOAD DURATION: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+ 'seconds';
		print'-----------------------'
		
		set @Start_time = GETDATE();
		print '>> TRUNCATING the TABLE: bronze.prd_info'
		TRUNCATE TABLE bronze.prd_info

		print '>> INSERTING DATA INTO the TABLE: bronze.prd_info'
	
		BULK INSERT bronze.prd_info
		FROM
		"C:\Users\shahb\Downloads\Compressed\DATAWAREHOUSE PROJET\DATA\sql-data-warehouse-project\datasets\source_crm\prd_info.csv"

		with (
		FIRSTROW=2,
		FIELDTERMINATOR =',',
		TABLOCK

		)
		set @end_time = GETDATE();
		print '>> LOAD DURATION bronze.prd_info: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+ 'seconds';
		print'-----------------------'
		set @Start_time = GETDATE();
		print '>> TRUNCATING the TABLE:  bronze.sales_details'
		TRUNCATE TABLE bronze.sales_details
		print '>> INSERTING DATA INTO the TABLE: bronze.sales_details'

		BULK INSERT bronze.sales_details
		FROM
		"C:\Users\shahb\Downloads\Compressed\DATAWAREHOUSE PROJET\DATA\sql-data-warehouse-project\datasets\source_crm\sales_details.csv"

		with (
		FIRSTROW=2,
		FIELDTERMINATOR =',',
		TABLOCK

		)
		set @end_time = GETDATE();
		print '>> LOAD DURATION bronze.sales_details: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR)+ 'seconds';
		
		set @batch_end_time = GETDATE();
		
		print'======================================================'
		print'Loading Bronze Layer is Completed'
		print '>> BATCH LOAD DURATION: ' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR)+ 'seconds';
		print'======================================================'
		

		print '--------------------------------------------------------------------------------------------------------------------'
		print 'LADING ERP TABLES'
		print '--------------------------------------------------------------------------------------------------------------------'

		print '>> TRUNCATING the TABLE: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12
		print '>> ISERTDATA DATA INTO TABLE: bronze.erp_cust_az12'
	
		BULK INSERT bronze.erp_cust_az12
		FROM
		"C:\Users\shahb\Downloads\Compressed\DATAWAREHOUSE PROJET\DATA\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv"

		with (
		FIRSTROW=2,
		FIELDTERMINATOR =',',
		TABLOCK

		)

		print '>> TRUNCATING the TABLE: bronze.erp_location_a101'
		TRUNCATE TABLE bronze.erp_location_a101
		print '>> ISERTDATA DATA INTO TABLE: bronze.erp_location_a101'
		BULK INSERT bronze.erp_location_a101
		FROM
		"C:\Users\shahb\Downloads\Compressed\DATAWAREHOUSE PROJET\DATA\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv"

		with (
		FIRSTROW=2,
		FIELDTERMINATOR =',',
		TABLOCK

		)


		print '>> TRUNCATING the TABLE: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
		print '>> ISERTDATA DATA INTO TABLE: bronze.erp_px_cat_g1v2'

		BULK INSERT bronze.erp_px_cat_g1v2
		FROM
		"C:\Users\shahb\Downloads\Compressed\DATAWAREHOUSE PROJET\DATA\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv"
		with (
		FIRSTROW=2,
		FIELDTERMINATOR =',',
		TABLOCK

		)
	END TRY
	BEGIN CATCH
	print '==================================================================================='
	print 'Eror Occured during Loading Bronze Layer'
	print 'Eror Message'+ ERROR_MESSAGE();
	print 'Eror Number' + cast(Error_number()AS NVARCHAR);
	print 'Eror Number' + cast(Error_state() AS NVARCHAR);
	print '==================================================================================='
	END CATCH
END
