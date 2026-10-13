-- Synthetic demo data only. No real customer information.

PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

-- Dates
INSERT OR IGNORE INTO dim_date
(date_key, full_date, day_of_month, week_of_year, month_number,
 month_name, quarter_number, year_number, financial_year, is_holiday)
VALUES
(20250101,'2025-01-01',1,1,1,'January',1,2025,'2024-25',0),
(20250115,'2025-01-15',15,3,1,'January',1,2025,'2024-25',0),
(20250201,'2025-02-01',1,5,2,'February',1,2025,'2024-25',0),
(20250215,'2025-02-15',15,7,2,'February',1,2025,'2024-25',0),
(20250301,'2025-03-01',1,9,3,'March',1,2025,'2024-25',0),
(20250315,'2025-03-15',15,11,3,'March',1,2025,'2024-25',0),
(20250401,'2025-04-01',1,14,4,'April',2,2025,'2025-26',0);

-- Product
INSERT OR IGNORE INTO dim_product
(product_key, product_id, product_name, product_family,
 product_variant, secured_status, launch_date, product_status)
VALUES
(1,'CC001','Everyday Credit Card','Credit Card',
 'Standard','Unsecured','2024-01-01','Active');

-- Customers
INSERT OR IGNORE INTO dim_customer
(customer_key, customer_id, age, gender, income, occupation,
 customer_segment, risk_grade, relationship_tenure_months,
 location, customer_since_date)
VALUES
(1,'CUST001',25,'Female',600000,'Salaried','Mass','A',24,'Delhi','2023-01-01'),
(2,'CUST002',32,'Male',900000,'Salaried','Affluent','B',36,'Noida','2022-01-01'),
(3,'CUST003',29,'Female',450000,'Self-employed','Mass','C',12,'Agra','2024-01-01');

-- Channels and geography
INSERT OR IGNORE INTO dim_channel
(channel_key, channel_name, channel_type, campaign_name)
VALUES
(1,'Website','Digital','Winter Campaign'),
(2,'Branch','Physical','Walk-in');

INSERT OR IGNORE INTO dim_geography
(geography_key, state, city, region)
VALUES
(1,'Delhi','Delhi','North'),
(2,'Uttar Pradesh','Noida','North');

-- Accounts
INSERT OR IGNORE INTO dim_account
(account_key, account_id, customer_key, product_key,
 open_date_key, closure_date_key, account_status,
 credit_limit, interest_rate, tenure_months)
VALUES
(1,'ACC001',1,1,20250101,NULL,'Active',100000,24.0,12),
(2,'ACC002',2,1,20250101,NULL,'Active',150000,22.0,12),
(3,'ACC003',3,1,20250201,NULL,'Active',50000,28.0,12);

-- Applications: one row per application
INSERT OR IGNORE INTO fact_application
(application_id, product_key, customer_key, application_date_key,
 approval_date_key, channel_key, geography_key, approval_status,
 kyc_status, turnaround_time_hours, sanction_amount, disbursement_amount)
VALUES
('APP001',1,1,20250101,20250115,1,1,'Approved','Complete',24,100000,100000),
('APP002',1,2,20250115,20250201,2,2,'Approved','Complete',48,150000,150000),
('APP003',1,3,20250201,NULL,1,2,'Pending','In Progress',NULL,NULL,NULL),
('APP004',1,1,20250215,20250301,1,1,'Rejected','Complete',72,0,0);

-- Transactions: one row per recorded transaction
INSERT OR IGNORE INTO fact_transaction
(transaction_id, account_key, transaction_date_key, channel_key,
 geography_key, transaction_type, merchant_category, amount,
 currency, transaction_status, fraud_flag)
VALUES
('TXN001',1,20250115,1,1,'Purchase','Groceries',2500,'INR','Success',0),
('TXN002',1,20250201,1,1,'Purchase','Travel',5000,'INR','Success',0),
('TXN003',2,20250215,2,2,'Purchase','Electronics',12000,'INR','Success',0),
('TXN004',2,20250301,1,2,'Purchase','Dining',1500,'INR','Failed',0),
('TXN005',3,20250315,1,2,'Purchase','Groceries',800,'INR','Success',0),
('TXN006',1,20250315,1,1,'Refund','Shopping',-1000,'INR','Success',0);

-- Account balances and risk: one account per snapshot date
INSERT OR IGNORE INTO fact_account_snapshot
(account_key, snapshot_date_key, outstanding_balance, days_past_due,
 delinquency_status, npa_flag, default_flag,
 probability_of_default, loss_given_default)
VALUES
(1,20250201,12000,0,'Current',0,0,0.01,0.30),
(2,20250201,30000,0,'Current',0,0,0.02,0.35),
(3,20250201,8000,15,'Delinquent',0,0,0.05,0.45),
(1,20250301,14000,0,'Current',0,0,0.01,0.30),
(2,20250301,32000,5,'Delinquent',0,0,0.02,0.35),
(3,20250301,9000,30,'Delinquent',0,0,0.05,0.45);

-- Financial summaries: one product per reporting date
INSERT OR IGNORE INTO fact_financial_summary
(product_key, reporting_date_key, interest_income, fee_income,
 interchange_income, processing_fee, rewards_cashback_cost,
 funding_cost, operating_cost, total_revenue, profit)
VALUES
(1,20250201,12000,3000,2000,500,1000,2500,1500,17000,11500),
(1,20250301,14500,3500,2500,600,1200,2800,1700,20500,14200);

COMMIT;
