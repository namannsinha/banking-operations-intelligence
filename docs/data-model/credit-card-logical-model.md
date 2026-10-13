# Credit Card Logical Data Model

## 1. Purpose

Define the logical entities and candidate relationships required for Credit Card Product Health analytics.

This is a conceptual model based on the business data blueprint. It is not a confirmed physical warehouse schema.

## 2. Design Principles

- Follow the business KPIs and their data requirements.
- Identify the grain of each entity before designing analytical tables.
- Separate descriptive entities from measurable business events.
- Record unknown keys and relationships rather than inventing them.
- Validate all proposed relationships against the actual warehouse schema.

## 3. Candidate Entities

### 3.1 Product

Purpose: Describe the banking product and its variants.

Candidate identifier: Product ID.

Attributes include Product Name, Product Family, Product Variant, Secured/Unsecured, Interest Rate, Fees, Credit Limit, Tenure, Launch Date, and Status.

Supports: Product filtering and Credit Card product health reporting.

### 3.2 Customer

Purpose: Describe customers and their segments.

Candidate identifier: Customer ID.

Attributes include Age, Gender, Income, Occupation, Customer Segment, Risk Grade, Relationship Tenure, Location, and Existing/New Customer.

Supports: Customer counts, new-customer analysis, and segment distribution.

### 3.3 Application / Origination

Purpose: Represent credit applications and their processing outcomes.

Candidate identifier: Application ID.

Candidate relationships: Product ID and Customer ID, subject to source confirmation.

Attributes include Application Date, Channel, Campaign, KYC Status, Approval Status, Approval Date, Sanction Amount, Disbursement Amount, and Turnaround Time.

Supports: Application volume, approval rate, and application turnaround time.

### 3.4 Account / Portfolio

Purpose: Represent Credit Card accounts and their portfolio state.

Candidate identifier: Account ID.

Candidate relationships: Customer ID and Product ID.

Attributes include Open Date, Outstanding Balance, Credit Limit, EMI, Interest Rate, Tenure, Account Status, Closure Date, and Prepayment.

Supports: Portfolio population, outstanding balance, and relationships to transaction and risk data.

### 3.5 Transaction / Usage

Purpose: Represent transaction activity.

Candidate identifier: Transaction ID.

Candidate relationship: Account ID.

Attributes include Transaction Date, Amount, Transaction Type, Merchant Category, Channel, Location, Currency, and Fraud Flag.

Supports: Transaction count, transaction value, and average transaction value.

Transaction outcome/status is not explicitly listed in the blueprint and must be verified before calculating transaction failure rate.

### 3.6 Revenue / Cost

Purpose: Represent financial measures attributable to the product or portfolio.

Measures include Interest Income, Fee Income, Interchange Income, Processing Fee, Rewards/Cashback Cost, Funding Cost, Operating Cost, Total Revenue, and Profit.

Candidate relationships: Product and Time, with further dimensions depending on source availability.

The unique identifier, source grain, reporting date, and aggregation rules are not yet known.

### 3.7 Risk / Collections

Purpose: Represent credit-risk and collection measures.

Attributes include DPD, Delinquency Status, NPA Flag, Default Date, Recovery Amount, Provisioning Amount, PD, LGD, Credit Loss, and Recovery Rate.

Candidate relationship: Account ID, subject to confirmation.

The reporting grain and historical snapshot mechanism must be established before defining risk rates.

### 3.8 Channel / Geography

Purpose: Support reporting by acquisition channel and geography.

Attributes include Branch, Digital, Partner/DSA, Call Center, Campaign, State, City, Region, Dealer, and Relationship Manager.

The blueprint does not confirm dedicated identifiers for all these attributes. Do not assume that Channel is a separate physical table.

### 3.9 Time

Purpose: Support consistent reporting over time.

Attributes include Date, Day, Week, Month, Quarter, Year, Financial Year, Holiday Flag, and Seasonality.

A dedicated date dimension is a candidate for the analytical layer. Its implementation depends on the warehouse and BI design.

## 4. Candidate Relationships

| Parent entity | Child entity | Candidate relationship | Validation required |
|---|---|---|---|
| Product | Application | One product to many applications | Confirm Product ID and relationship |
| Customer | Application | One customer to many applications | Confirm Customer ID is available on applications |
| Product | Account | One product to many accounts | Confirm Product ID on accounts |
| Customer | Account | One customer to many accounts | Confirm Customer ID on accounts |
| Account | Transaction | One account to many transactions | Confirm Account ID and transaction grain |
| Account | Risk / Collections | Potentially one account to many dated risk records | Confirm grain and historical snapshots |
| Product / Time | Revenue / Cost | Reporting association | Confirm product attribution and financial grain |

These are candidate relationships, not verified foreign-key constraints.

## 5. Important Grain Questions

Before creating an OLAP layer, establish:

1. Is each application record one application, or can an application have multiple rows?
2. Does Account ID identify a Credit Card account, a physical card, or another banking object?
3. Is transaction data one row per transaction, and how are reversals and refunds represented?
4. Are outstanding balances available as historical snapshots or only current values?
5. Are revenue and cost measures recorded per transaction, account, product, or reporting period?
6. Are risk measures recorded per account and date, or only as current account attributes?
7. Can one customer hold multiple products and accounts?
8. Is there an explicit card issuance event and date?

## 6. Relationship and Modeling Rules

- Never join tables only because their columns have similar names.
- Validate key uniqueness and referential integrity before using a key in a join.
- Identify one-to-many and many-to-many relationships explicitly.
- Avoid joining multiple fact-like datasets directly if doing so duplicates financial amounts or counts.
- Preserve reporting dates and source grain for balances, revenue, and risk metrics.
- Use a consistent reporting currency where financial aggregation requires it.
- Document missing fields and unresolved business definitions.

## 7. Next Step

Validate this logical model against the data dictionary and the actual warehouse schema.

Only after confirming available tables, keys, relationships, grain, and historical data should the physical OLAP design and analytical SQL views be finalized.

## 8. Status

- Logical entities: Proposed.
- Relationships: Candidate only.
- Keys and foreign keys: Not yet verified.
- Source tables and column types: Not yet verified.
- Physical model: Not implemented.
- OLAP layer and analytical views: Not implemented.
