-- BRAIN: Credit Card Analytics Prototype
-- Purpose: Synthetic-data development only.
-- This is a proposed analytical model, not the bank's confirmed schema.

PRAGMA foreign_keys = ON;

-- =========================
-- DIMENSIONS
-- =========================

CREATE TABLE IF NOT EXISTS dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date TEXT NOT NULL UNIQUE,
    day_of_month INTEGER,
    week_of_year INTEGER,
    month_number INTEGER,
    month_name TEXT,
    quarter_number INTEGER,
    year_number INTEGER,
    financial_year TEXT,
    is_holiday INTEGER DEFAULT 0
        CHECK (is_holiday IN (0, 1))
);

CREATE TABLE IF NOT EXISTS dim_product (
    product_key INTEGER PRIMARY KEY,
    product_id TEXT NOT NULL UNIQUE,
    product_name TEXT NOT NULL,
    product_family TEXT,
    product_variant TEXT,
    secured_status TEXT,
    launch_date TEXT,
    product_status TEXT
);

CREATE TABLE IF NOT EXISTS dim_customer (
    customer_key INTEGER PRIMARY KEY,
    customer_id TEXT NOT NULL UNIQUE,
    age INTEGER,
    gender TEXT,
    income REAL,
    occupation TEXT,
    customer_segment TEXT,
    risk_grade TEXT,
    relationship_tenure_months INTEGER,
    location TEXT,
    customer_since_date TEXT
);

CREATE TABLE IF NOT EXISTS dim_channel (
    channel_key INTEGER PRIMARY KEY,
    channel_name TEXT NOT NULL,
    channel_type TEXT,
    campaign_name TEXT,
    UNIQUE (channel_name, channel_type, campaign_name)
);

CREATE TABLE IF NOT EXISTS dim_geography (
    geography_key INTEGER PRIMARY KEY,
    state TEXT,
    city TEXT,
    region TEXT,
    UNIQUE (state, city, region)
);

CREATE TABLE IF NOT EXISTS dim_account (
    account_key INTEGER PRIMARY KEY,
    account_id TEXT NOT NULL UNIQUE,
    customer_key INTEGER NOT NULL,
    product_key INTEGER NOT NULL,
    open_date_key INTEGER,
    closure_date_key INTEGER,
    account_status TEXT,
    credit_limit REAL,
    interest_rate REAL,
    tenure_months INTEGER,

    FOREIGN KEY (customer_key)
        REFERENCES dim_customer(customer_key),
    FOREIGN KEY (product_key)
        REFERENCES dim_product(product_key),
    FOREIGN KEY (open_date_key)
        REFERENCES dim_date(date_key),
    FOREIGN KEY (closure_date_key)
        REFERENCES dim_date(date_key)
);

-- =========================
-- FACT TABLES
-- =========================

-- Grain: one row per application.
CREATE TABLE IF NOT EXISTS fact_application (
    application_id TEXT PRIMARY KEY,
    product_key INTEGER NOT NULL,
    customer_key INTEGER,
    application_date_key INTEGER NOT NULL,
    approval_date_key INTEGER,
    channel_key INTEGER,
    geography_key INTEGER,
    approval_status TEXT,
    kyc_status TEXT,
    turnaround_time_hours REAL,
    sanction_amount REAL,
    disbursement_amount REAL,

    FOREIGN KEY (product_key)
        REFERENCES dim_product(product_key),
    FOREIGN KEY (customer_key)
        REFERENCES dim_customer(customer_key),
    FOREIGN KEY (application_date_key)
        REFERENCES dim_date(date_key),
    FOREIGN KEY (approval_date_key)
        REFERENCES dim_date(date_key),
    FOREIGN KEY (channel_key)
        REFERENCES dim_channel(channel_key),
    FOREIGN KEY (geography_key)
        REFERENCES dim_geography(geography_key)
);

-- Grain: one row per recorded transaction.
-- transaction_status is a prototype field that must be
-- verified against the real source before production use.
CREATE TABLE IF NOT EXISTS fact_transaction (
    transaction_id TEXT PRIMARY KEY,
    account_key INTEGER NOT NULL,
    transaction_date_key INTEGER NOT NULL,
    channel_key INTEGER,
    geography_key INTEGER,
    transaction_type TEXT,
    merchant_category TEXT,
    amount REAL NOT NULL,
    currency TEXT NOT NULL,
    transaction_status TEXT,
    fraud_flag INTEGER DEFAULT 0
        CHECK (fraud_flag IN (0, 1)),

    FOREIGN KEY (account_key)
        REFERENCES dim_account(account_key),
    FOREIGN KEY (transaction_date_key)
        REFERENCES dim_date(date_key),
    FOREIGN KEY (channel_key)
        REFERENCES dim_channel(channel_key),
    FOREIGN KEY (geography_key)
        REFERENCES dim_geography(geography_key)
);

-- Grain: one account per snapshot date.
CREATE TABLE IF NOT EXISTS fact_account_snapshot (
    account_key INTEGER NOT NULL,
    snapshot_date_key INTEGER NOT NULL,
    outstanding_balance REAL,
    days_past_due INTEGER,
    delinquency_status TEXT,
    npa_flag INTEGER
        CHECK (npa_flag IN (0, 1) OR npa_flag IS NULL),
    default_flag INTEGER
        CHECK (default_flag IN (0, 1) OR default_flag IS NULL),
    probability_of_default REAL,
    loss_given_default REAL,

    PRIMARY KEY (account_key, snapshot_date_key),

    FOREIGN KEY (account_key)
        REFERENCES dim_account(account_key),
    FOREIGN KEY (snapshot_date_key)
        REFERENCES dim_date(date_key)
);

-- Grain: one product per reporting date.
-- Use a consistent reporting period, such as month-end.
CREATE TABLE IF NOT EXISTS fact_financial_summary (
    product_key INTEGER NOT NULL,
    reporting_date_key INTEGER NOT NULL,
    interest_income REAL DEFAULT 0,
    fee_income REAL DEFAULT 0,
    interchange_income REAL DEFAULT 0,
    processing_fee REAL DEFAULT 0,
    rewards_cashback_cost REAL DEFAULT 0,
    funding_cost REAL DEFAULT 0,
    operating_cost REAL DEFAULT 0,
    total_revenue REAL,
    profit REAL,

    PRIMARY KEY (product_key, reporting_date_key),

    FOREIGN KEY (product_key)
        REFERENCES dim_product(product_key),
    FOREIGN KEY (reporting_date_key)
        REFERENCES dim_date(date_key)
);

-- =========================
-- INDEXES
-- =========================

CREATE INDEX IF NOT EXISTS idx_application_date
    ON fact_application(application_date_key);

CREATE INDEX IF NOT EXISTS idx_transaction_date
    ON fact_transaction(transaction_date_key);

CREATE INDEX IF NOT EXISTS idx_transaction_account
    ON fact_transaction(account_key);

CREATE INDEX IF NOT EXISTS idx_snapshot_date
    ON fact_account_snapshot(snapshot_date_key);

CREATE INDEX IF NOT EXISTS idx_account_customer
    ON dim_account(customer_key);

CREATE INDEX IF NOT EXISTS idx_account_product
    ON dim_account(product_key);
