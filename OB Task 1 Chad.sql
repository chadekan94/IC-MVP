/****************************************/
/* Created By	: Chad Ekanayake		*/
/* Date			: 29/03/2022			*/
/*										*/
/****************************************/



/* a */

SELECT	Property.Name	AS PropertyName,
		OwnerProperty.PropertyId
FROM	OwnerProperty	INNER JOIN
		Property		ON OwnerProperty.PropertyId = Property.Id
WHERE   (OwnerProperty.OwnerId = 1426)




/* b */

SELECT	OwnerProperty.PropertyId, 
		Property.Name			AS PropertyName, 
		PropertyHomeValue.Value AS PropertyCurrentValue
FROM    OwnerProperty			INNER JOIN
		Property ON OwnerProperty.PropertyId = Property.Id INNER JOIN
		PropertyHomeValue ON Property.Id = PropertyHomeValue.PropertyId
WHERE	(OwnerProperty.OwnerId = 1426) AND (PropertyHomeValue.IsActive = 1) 





/* c */
	/* i */

SELECT	OwnerProperty.PropertyId, 
		Property.Name		AS PropertyName,  
		CASE
			WHEN TenantProperty.PaymentFrequencyId =3 THEN TenantProperty.PaymentAmount * (DATEDIFF(WW, TenantProperty.StartDate,TenantProperty.EndDate)/4)
			WHEN TenantProperty.PaymentFrequencyId =2 THEN TenantProperty.PaymentAmount * (DATEDIFF(WW, TenantProperty.StartDate,TenantProperty.EndDate)/2)
			ELSE TenantProperty.PaymentAmount * (DATEDIFF(WW, TenantProperty.StartDate,TenantProperty.EndDate)) 
		END AS SumOfPayments
FROM	OwnerProperty		INNER JOIN
        Property			ON OwnerProperty.PropertyId = Property.Id INNER JOIN
		TenantProperty		ON OwnerProperty.PropertyId = TenantProperty.PropertyId
WHERE	(OwnerProperty.OwnerId = 1426) 



	/* ii */

SELECT	TblProperty.PropertyId, 
		TblProperty.PropertyName, 
		((TblProperty.SumOfPayments/ TblProperty.PropertyValue) * 100) AS Yield
FROM 
		(
		SELECT	OwnerProperty.PropertyId, 
				Property.Name as PropertyName,  
				CASE
					WHEN TenantProperty.PaymentFrequencyId =3 THEN TenantProperty.PaymentAmount * (DATEDIFF(WW, TenantProperty.StartDate,TenantProperty.EndDate)/4)
					WHEN TenantProperty.PaymentFrequencyId =2 THEN TenantProperty.PaymentAmount * (DATEDIFF(WW, TenantProperty.StartDate,TenantProperty.EndDate)/2)
					ELSE TenantProperty.PaymentAmount * (DATEDIFF(WW, TenantProperty.StartDate,TenantProperty.EndDate)) 
				END AS SumOfPayments,
				PropertyHomeValue.Value AS PropertyValue
		FROM	OwnerProperty		INNER JOIN
				Property			ON OwnerProperty.PropertyId = Property.Id INNER JOIN
				TenantProperty		ON OwnerProperty.PropertyId = TenantProperty.PropertyId INNER JOIN
				PropertyHomeValue	ON Property.Id = PropertyHomeValue.PropertyId
		WHERE   (OwnerProperty.OwnerId = 1426) AND (PropertyHomeValue.IsActive = 1) 
		) AS TblProperty




/* d */

SELECT	Job.JobDescription AS AvailableJobs
FROM	Job INNER JOIN
		JobStatus ON Job.JobStatusId = JobStatus.Id
WHERE	(JobStatus.Id =1)



/* e */ 

SELECT	Property.Name AS PropertyName,
		CASE
			WHEN TenantProperty.IsActive = 1 THEN 
				Person.FirstName
			ELSE 
				'No Current Tenant'
			END AS FirstName,
			CASE
			WHEN TenantProperty.IsActive = 1 THEN 
				Person.LastName
			ELSE 
				'No Current Tenant'
		END AS LastName,
		TenantProperty.PaymentAmount,
		TenantPaymentFrequencies.Name AS PaymentFrequency
FROM	OwnerProperty INNER JOIN
		Property					ON OwnerProperty.PropertyId = Property.Id INNER JOIN
		TenantProperty				ON OwnerProperty.PropertyId = TenantProperty.PropertyId INNER JOIN 
		TenantPaymentFrequencies	ON TenantProperty.PaymentFrequencyId = TenantPaymentFrequencies.Id INNER JOIN 
		Person						ON TenantProperty.TenantId = Person.Id
WHERE   (OwnerProperty.OwnerId = 1426)