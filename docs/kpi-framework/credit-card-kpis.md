# Credit Card Product Health — KPI Framework

## 1. Purpose

This document defines the initial KPIs for monitoring Credit Card product health.

It follows the top-down approach:

Business Question → KPI → Required Data → Logical Model → OLAP Layer → Analytical View → Power BI

The KPI definitions are provisional. They are based on the business data blueprint and must be validated against the actual warehouse schema and business rules before implementation.

## 2. KPI Categories

The initial framework covers five areas:

1. Acquisition
2. Customer
3. Usage
4. Financial
5. Risk

## 3. Acquisition KPIs

### 3.1 Total Applications

- **Business question:** How many credit card applications were received during a period?
- **Required fields:** Application ID, Product ID, Application Date.
- **Calculation:** Count of distinct eligible Application IDs for the selected period and product.
- **Dimensions:** Date, channel, campaign, geography, customer segment, where available.
- **Data group:** Application / Origination; Product; Time; Channel / Geography.
- **Open questions:** Are multiple records allowed for one application? Which application statuses should be included? Confirm the date field used for reporting.

### 3.2 Approval Rate

- **Business question:** What proportion of decided applications were approved?
- **Required fields:** Application ID, Product ID, Application Date, Approval Status.
- **Calculation:** Approved applications ÷ eligible decided applications × 100.
- **Dimensions:** Date, channel, campaign, geography, customer segment, where available.
- **Data group:** Application / Origination; Product; Time; Channel / Geography.
- **Open questions:** Define which statuses count as approved, rejected, pending, withdrawn, or incomplete. Pending applications should not automatically be treated as rejected. Confirm the denominator with the business owner.

### 3.3 Cards Issued

- **Business question:** How many credit cards were actually issued during a period?
- **Required fields:** Not yet confirmed. The blueprint includes Application ID, Approval Status, Account ID, and Account Open Date, but does not explicitly identify a card issuance event or issuance date.
- **Calculation:** To be defined after the source of card issuance is identified.
- **Dimensions:** Date, channel, campaign, geography, customer segment, where available.
- **Data group:** To be confirmed.
- **Open questions:** Is card issuance recorded in a dedicated card table, an account table, or another source? What event and date define issuance?
- **Important:** Approval and account opening must not be assumed to mean card issuance without confirmation.

### 3.4 Average Application Turnaround Time

- **Business question:** How long does an application take to process?
- **Required fields:** Application ID, Turnaround Time, Product ID, Application Date.
- **Calculation:** Average Turnaround Time over eligible applications.
- **Dimensions:** Date, channel, campaign, geography, where available.
- **Data group:** Application / Origination; Product; Time; Channel / Geography.
- **Open questions:** Confirm the unit of time, start and end events, treatment of incomplete applications, and whether the source already calculates turnaround time.

## 4. Customer KPIs

### 4.1 Total Customers

- **Business question:** How many distinct customers are in the defined Credit Card reporting population?
- **Required fields:** Customer ID and a confirmed relationship between customers and Credit Card accounts or products.
- **Calculation:** Count of distinct Customer IDs in the agreed reporting population.
- **Dimensions:** Customer segment, risk grade, geography, occupation, and customer status, where available.
- **Data group:** Customer; Account / Portfolio; Product; Time.
- **Open questions:** Define the reporting population and whether the KPI represents all eligible customers or only customers currently holding a Credit Card.

### 4.2 New Customers

- **Business question:** How many new customers entered the defined Credit Card customer population during a period?
- **Required fields:** Customer ID, Existing/New Customer, relevant date, and a confirmed Credit Card relationship.
- **Calculation:** Count of distinct customers classified as new within the agreed population and period.
- **Dimensions:** Date, customer segment, geography, channel, where available.
- **Data group:** Customer; Account / Portfolio; Application / Origination; Time.
- **Open questions:** Confirm whether "new" means new to the bank or new to the Credit Card product. Confirm the date that determines when a customer is counted as new.

### 4.3 Customer Segment Distribution

- **Business question:** How is the Credit Card customer population distributed across customer segments?
- **Required fields:** Customer ID, Customer Segment, and a confirmed Credit Card relationship.
- **Calculation:** Count of distinct customers in each segment. Segment percentage = customers in segment ÷ total customers in the defined population × 100.
- **Dimensions:** Customer segment, date, geography, risk grade, where available.
- **Data group:** Customer; Account / Portfolio; Product; Time.
- **Open questions:** Define the reporting population and treatment of missing or changing customer segment values.

## 5. Usage KPIs

### 5.1 Active Cards

- **Business question:** How many Credit Cards qualify as active during the reporting period?
- **Required fields:** Account ID, Product ID, Account Status, relevant dates, and card-level identifiers or activity data if available.
- **Calculation:** Count of distinct cards or eligible accounts satisfying an agreed active-card rule.
- **Dimensions:** Date, customer segment, channel, geography, where available.
- **Data group:** Account / Portfolio; Transaction / Usage; Product; Time.
- **Open questions:** Define "active." Does it mean an open account, a card with at least one purchase within a defined period, or another business rule? Confirm whether Account ID uniquely identifies a card.

### 5.2 Transaction Count

- **Business question:** How many Credit Card transactions occurred during a period?
- **Required fields:** Transaction ID, Account ID, Transaction Date, Product relationship.
- **Calculation:** Count of eligible distinct Transaction IDs during the period.
- **Dimensions:** Date, transaction type, merchant category, channel, geography, where available.
- **Data group:** Transaction / Usage; Account / Portfolio; Product; Time.
- **Open questions:** Define eligible transactions and treatment of reversals, refunds, duplicates, and failed transactions.

### 5.3 Transaction Value

- **Business question:** What is the total value of Credit Card transactions during a period?
- **Required fields:** Transaction ID, Account ID, Transaction Date, Amount, Currency, Product relationship.
- **Calculation:** Sum of eligible transaction amounts after applying the agreed currency and transaction-type rules.
- **Dimensions:** Date, transaction type, merchant category, channel, geography, currency, where available.
- **Data group:** Transaction / Usage; Account / Portfolio; Product; Time.
- **Open questions:** Confirm whether amounts are stored in a common reporting currency. Define treatment of refunds, reversals, and cross-currency transactions.

### 5.4 Average Transaction Value

- **Business question:** What is the average value of an eligible transaction?
- **Required fields:** Transaction ID, Amount, Currency, Transaction Date, Product relationship.
- **Calculation:** Eligible transaction value ÷ eligible transaction count.
- **Dimensions:** Date, transaction type, merchant category, channel, geography, where available.
- **Data group:** Transaction / Usage; Account / Portfolio; Product; Time.
- **Open questions:** Use the same transaction eligibility and currency rules as Transaction Value.

### 5.5 Transaction Failure Rate

- **Business question:** What percentage of attempted transactions fail?
- **Required fields:** Transaction ID and transaction outcome/status.
- **Calculation:** Failed eligible attempts ÷ all eligible attempts × 100.
- **Dimensions:** Date, channel, transaction type, geography, where available.
- **Data group:** Transaction / Usage; Time; Channel / Geography.
- **Open questions:** The current blueprint does not explicitly list a transaction status or outcome field. Confirm whether this data exists before including the KPI in implementation.

## 6. Financial KPIs

### 6.1 Outstanding Balance

- **Business question:** What is the total outstanding Credit Card balance at a point in time?
- **Required fields:** Account ID, Product ID, Outstanding Balance, and a reporting/as-of date.
- **Calculation:** Sum of eligible outstanding balances as of the selected reporting date.
- **Dimensions:** Date, customer segment, geography, risk grade, where available.
- **Data group:** Account / Portfolio; Product; Customer; Time.
- **Open questions:** Confirm the balance definition, reporting currency, treatment of closed accounts, and availability of historical snapshots.

### 6.2 Interest Income

- **Business question:** How much interest income was generated during a period?
- **Required fields:** Interest Income, Product ID or a reliable relationship to the Credit Card product, and reporting date.
- **Calculation:** Sum of eligible interest income for the selected period.
- **Dimensions:** Date, product variant, customer segment, geography, where available.
- **Data group:** Revenue / Cost; Product; Time; Customer.
- **Open questions:** Identify the source grain, date field, reporting currency, and accounting definition.

### 6.3 Fee Income

- **Business question:** How much fee income was generated during a period?
- **Required fields:** Fee Income, Product ID or a reliable product relationship, and reporting date.
- **Calculation:** Sum of eligible fee income for the selected period.
- **Dimensions:** Date, product variant, customer segment, geography, where available.
- **Data group:** Revenue / Cost; Product; Time; Customer.
- **Open questions:** Confirm which fee types are included and whether fee income is already aggregated.

### 6.4 Total Revenue

- **Business question:** What is the total revenue attributable to the Credit Card product during a period?
- **Required fields:** Total Revenue, Product ID or a reliable product relationship, and reporting date.
- **Calculation:** Sum of Total Revenue at its documented source grain, if it is an additive measure.
- **Dimensions:** Date, product variant, customer segment, geography, where available.
- **Data group:** Revenue / Cost; Product; Time; Customer.
- **Open questions:** Confirm the business definition of Total Revenue and whether it already includes interest, fee, and interchange income. Avoid double-counting components.

### 6.5 Profit

- **Business question:** What profit is attributable to the Credit Card product during a period?
- **Required fields:** Profit, Product ID or a reliable product relationship, and reporting date.
- **Calculation:** Sum of Profit only if the source definition and grain support additive aggregation.
- **Dimensions:** Date, product variant, customer segment, geography, where available.
- **Data group:** Revenue / Cost; Product; Time; Customer.
- **Open questions:** Confirm the profit formula, included costs, allocation method, reporting currency, and source grain.

## 7. Risk KPIs

### 7.1 Delinquency Rate

- **Business question:** What proportion of the defined Credit Card portfolio is delinquent?
- **Required fields:** Account ID, DPD, Delinquency Status, Product relationship, reporting date, and a suitable portfolio denominator.
- **Calculation:** To be finalized after the business defines delinquency and the denominator. Possible measures include delinquent accounts ÷ eligible accounts or delinquent balance ÷ total outstanding balance.
- **Dimensions:** Date, DPD band, customer segment, risk grade, geography, where available.
- **Data group:** Risk / Collections; Account / Portfolio; Customer; Product; Time.
- **Open questions:** Confirm the DPD threshold, denominator, treatment of closed accounts, and whether the KPI is account-based or balance-based.

### 7.2 NPA Rate

- **Business question:** What proportion of the defined Credit Card portfolio is classified as NPA?
- **Required fields:** Account ID, NPA Flag, Product relationship, reporting date, and a suitable portfolio denominator.
- **Calculation:** To be finalized. Possible measures include NPA accounts ÷ eligible accounts or NPA balance ÷ total outstanding balance.
- **Dimensions:** Date, customer segment, risk grade, geography, where available.
- **Data group:** Risk / Collections; Account / Portfolio; Customer; Product; Time.
- **Open questions:** Confirm the applicable NPA definition, denominator, and whether account-level or balance-level reporting is required.

### 7.3 Default Rate

- **Business question:** What proportion of the defined portfolio enters default during a period?
- **Required fields:** Account ID, Default Date, Product relationship, and the required eligible population.
- **Calculation:** To be defined after the business specifies the default event, reporting cohort, and denominator.
- **Dimensions:** Date, customer segment, risk grade, geography, where available.
- **Data group:** Risk / Collections; Account / Portfolio; Customer; Product; Time.
- **Open questions:** Confirm the default definition, event date, cohort basis, and whether the requested measure is a period rate or a point-in-time rate.

### 7.4 Credit Loss

- **Business question:** What credit loss is attributed to the Credit Card portfolio during a period?
- **Required fields:** Credit Loss, Product relationship, and reporting date.
- **Calculation:** Sum of Credit Loss at the documented source grain, if the measure is additive.
- **Dimensions:** Date, customer segment, risk grade, geography, where available.
- **Data group:** Risk / Collections; Revenue / Cost if applicable; Product; Time; Customer.
- **Open questions:** Confirm the definition of Credit Loss, its relationship to provisioning and recovery, and whether it is a flow or balance measure.

### 7.5 Recovery Rate

- **Business question:** How much of the relevant credit loss or overdue amount is recovered?
- **Required fields:** Recovery Amount and an agreed denominator, potentially Credit Loss or an eligible overdue/default amount.
- **Calculation:** To be defined after the business confirms the denominator and measurement period.
- **Dimensions:** Date, customer segment, risk grade, geography, where available.
- **Data group:** Risk / Collections; Account / Portfolio; Customer; Product; Time.
- **Open questions:** Confirm the recovery-rate definition, cohort, timing, and denominator. Do not assume that Recovery Amount ÷ Credit Loss is the approved formula.

## 8. Common Reporting Dimensions

Potential dimensions from the blueprint include:

- **Time:** Date, week, month, quarter, year, financial year.
- **Product:** Product ID, Product Name, Product Family, Product Variant.
- **Customer:** Customer Segment, Risk Grade, Existing/New Customer.
- **Channel:** Channel, Campaign, Branch, Digital, Partner/DSA, Call Center, where applicable.
- **Geography:** State, City, Region.
- **Transaction:** Transaction Type, Merchant Category, Currency, where applicable.
- **Risk:** DPD, Delinquency Status, NPA Flag.

These are candidate dimensions. Each KPI should only expose dimensions supported by a valid relationship and the actual source data.

## 9. Validation Rules Before Implementation

Before creating SQL views or Power BI measures:

1. Confirm the actual warehouse tables, columns, data types, and grain.
2. Confirm primary keys, foreign keys, and join paths.
3. Define reporting dates and historical snapshot availability.
4. Confirm business definitions, filters, denominators, and exclusions.
5. Check missing values, duplicates, status values, and currency consistency.
6. Validate KPI results with a business owner or trusted reference report.
7. Document any unavailable fields instead of inventing replacements.

## 10. Initial Open Questions

1. Where is card issuance recorded, and what date defines a card as issued?
2. Does "new customer" mean new to the bank or new to the Credit Card product?
3. What qualifies a card as active?
4. Which application statuses are included in the Approval Rate denominator?
5. Is transaction outcome/status available for calculating Transaction Failure Rate?
6. What definitions and denominators should be used for Delinquency Rate, NPA Rate, Default Rate, and Recovery Rate?
7. Which warehouse tables and columns are actually available for this product?
8. Which BI tool connection and data access have been provided?

## 11. Status

- Acquisition KPIs: Initial definitions documented; business validation pending.
- Customer KPIs: Initial definitions documented; population rules pending.
- Usage KPIs: Initial definitions documented; field availability and business rules pending.
- Financial KPIs: Initial definitions documented; source grain and accounting definitions pending.
- Risk KPIs: Initial definitions documented; definitions and denominators pending.
- Physical data model: Not yet finalized.
- OLAP layer and analytical views: Not yet implemented.
- Power BI dashboard: Not yet implemented.
