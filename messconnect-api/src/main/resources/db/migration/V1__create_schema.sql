-- MessConnect — initial schema (PART 2)
-- Target: Supabase Postgres (Postgres 15+).
-- Migration runner: Flyway (applied at boot once the Supabase datasource is wired).
-- UUID PKs use gen_random_uuid() (built into Postgres 13+).

-- =====================================================================
-- users: Firebase-authenticated identities (customers / providers / admin)
-- =====================================================================
CREATE TABLE users (
    id            UUID DEFAULT ${uuid_gen} PRIMARY KEY,
    firebase_uid  TEXT NOT NULL UNIQUE,            -- Firebase Auth UID (auth identity)
    email         TEXT,
    phone         TEXT,
    display_name  TEXT,
    role          TEXT NOT NULL DEFAULT 'CUSTOMER'
                      CHECK (role IN ('CUSTOMER', 'PROVIDER', 'ADMIN')),
    created_at    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE INDEX idx_users_firebase_uid ON users (firebase_uid);
CREATE INDEX idx_users_email ON users (email);

-- =====================================================================
-- messes: mess / tiffin providers
-- =====================================================================
CREATE TABLE messes (
    id            UUID DEFAULT ${uuid_gen} PRIMARY KEY,
    owner_id      UUID REFERENCES users (id) ON DELETE SET NULL,
    name          TEXT NOT NULL,
    description   TEXT,
    address       TEXT,
    area          TEXT,                            -- locality / colony
    city          TEXT,
    pincode       TEXT,
    latitude      DOUBLE PRECISION,                -- for location search / maps
    longitude     DOUBLE PRECISION,
    phone         TEXT,
    image_url     TEXT,
    is_verified   BOOLEAN NOT NULL DEFAULT FALSE,
    created_at    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE INDEX idx_messes_city ON messes (city);
CREATE INDEX idx_messes_area ON messes (area);
CREATE INDEX idx_messes_owner ON messes (owner_id);
-- GiST index enables geo radius search (requires postgis; see note below).
-- CREATE INDEX idx_messes_location ON messes USING gist (ll_to_earth(latitude, longitude));

-- =====================================================================
-- menus: meal items per mess (daily / by meal type)
-- =====================================================================
CREATE TABLE menus (
    id            UUID DEFAULT ${uuid_gen} PRIMARY KEY,
    mess_id       UUID NOT NULL REFERENCES messes (id) ON DELETE CASCADE,
    meal_type     TEXT NOT NULL
                      CHECK (meal_type IN ('BREAKFAST', 'LUNCH', 'DINNER', 'SNACKS')),
    day_of_week   SMALLINT CHECK (day_of_week BETWEEN 0 AND 6),  -- 0=Sunday
    item_name     TEXT NOT NULL,
    description   TEXT,
    price         NUMERIC(10, 2) NOT NULL DEFAULT 0,
    is_veg        BOOLEAN NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE INDEX idx_menus_mess ON menus (mess_id);
CREATE INDEX idx_menus_mess_meal ON menus (mess_id, meal_type);

-- =====================================================================
-- subscriptions: a user subscribed to a mess plan
-- =====================================================================
CREATE TABLE subscriptions (
    id            UUID DEFAULT ${uuid_gen} PRIMARY KEY,
    user_id       UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    mess_id       UUID NOT NULL REFERENCES messes (id) ON DELETE CASCADE,
    plan_name     TEXT NOT NULL,
    meal_type     TEXT NOT NULL
                      CHECK (meal_type IN ('BREAKFAST', 'LUNCH', 'DINNER', 'SNACKS')),
    billing_cycle TEXT NOT NULL
                      CHECK (billing_cycle IN ('DAILY', 'WEEKLY', 'MONTHLY')),
    price         NUMERIC(10, 2) NOT NULL DEFAULT 0,
    status        TEXT NOT NULL DEFAULT 'ACTIVE'
                      CHECK (status IN ('PENDING', 'ACTIVE', 'EXPIRED', 'CANCELLED')),
    start_date    DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date      DATE,
    created_at    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE INDEX idx_subscriptions_user ON subscriptions (user_id);
CREATE INDEX idx_subscriptions_mess ON subscriptions (mess_id);
CREATE INDEX idx_subscriptions_status ON subscriptions (status);

-- =====================================================================
-- payments: simulated UPI payments for a subscription
-- =====================================================================
CREATE TABLE payments (
    id            UUID DEFAULT ${uuid_gen} PRIMARY KEY,
    subscription_id UUID NOT NULL REFERENCES subscriptions (id) ON DELETE CASCADE,
    user_id       UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    amount        NUMERIC(10, 2) NOT NULL,
    currency      TEXT NOT NULL DEFAULT 'INR',
    status        TEXT NOT NULL DEFAULT 'PENDING'
                      CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED')),
    payment_method TEXT NOT NULL DEFAULT 'UPI'
                      CHECK (payment_method IN ('UPI', 'CARD', 'WALLET')),
    upi_ref       TEXT,                            -- simulated UPI transaction ref
    created_at    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    paid_at       TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_payments_subscription ON payments (subscription_id);
CREATE INDEX idx_payments_user ON payments (user_id);

-- =====================================================================
-- reviews: verified reviews (gated to subscribed users in PART 8)
-- =====================================================================
CREATE TABLE reviews (
    id            UUID DEFAULT ${uuid_gen} PRIMARY KEY,
    mess_id       UUID NOT NULL REFERENCES messes (id) ON DELETE CASCADE,
    user_id       UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    subscription_id UUID NOT NULL REFERENCES subscriptions (id) ON DELETE CASCADE,
    rating_taste      SMALLINT NOT NULL CHECK (rating_taste BETWEEN 1 AND 5),
    rating_hygiene    SMALLINT NOT NULL CHECK (rating_hygiene BETWEEN 1 AND 5),
    rating_quality    SMALLINT NOT NULL CHECK (rating_quality BETWEEN 1 AND 5),
    rating_punctuality SMALLINT NOT NULL CHECK (rating_punctuality BETWEEN 1 AND 5),
    comment       TEXT,
    created_at    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

CREATE INDEX idx_reviews_mess ON reviews (mess_id);
CREATE INDEX idx_reviews_user ON reviews (user_id);
CREATE INDEX idx_reviews_subscription ON reviews (subscription_id);
-- One review per user per subscription (verified-reviews rule).
CREATE UNIQUE INDEX uniq_reviews_user_subscription
    ON reviews (user_id, subscription_id);
