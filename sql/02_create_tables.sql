USE MavenFlix;
GO

CREATE TABLE dbo.subscriptions (
    customer_id INT NOT NULL,
    created_date DATE NOT NULL,
    canceled_date DATE NULL,
    subscription_cost INT NOT NULL,
    subscription_interval VARCHAR(10) NOT NULL,
    was_subscription_paid VARCHAR(3) NOT NULL
);