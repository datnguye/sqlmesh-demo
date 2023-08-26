MODEL (
    name jf.raw_payments,
    kind SEED (
        path '../../../seeds/jaffleshop/raw_payments.csv'
    ),
    columns (
        id INTEGER,
        order_id INTEGER,
        payment_method STRING,
        amount DOUBLE
    ),
    grain [id]
);
