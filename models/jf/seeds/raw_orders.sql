MODEL (
    name jf.raw_orders,
    kind SEED (
        path '../../../seeds/jaffleshop/raw_orders.csv'
    ),
    columns (
        id INTEGER,
        user_id INTEGER,
        order_date DATE,
        status STRING
    ),
    grain [id, user_id]
);
