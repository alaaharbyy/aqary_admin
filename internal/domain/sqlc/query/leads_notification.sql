-- name: CreateLeadNotification :one
INSERT INTO leads_notification (
    leads_id,
    agent_sms,
    agent_mail,
    agent_whatsapp,
    agent_system_notofication,
    lead_sms,
    lead_mail,
    lead_whatsapp,
    lead_system_notification,
    follow_up_email,
    closed_lost_email,
    closed_lost_sms,
    closed_lost_whatsapp,
    closed_won_email,
    closed_won_sms,
    closed_won_whatsapp
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16
) RETURNING *;

-- name: UpdateLeadNotification :one
UPDATE leads_notification
SET
    agent_sms = $2,
    agent_mail = $3,
    agent_whatsapp = $4,
    agent_system_notofication = $5,
    lead_sms = $6,
    lead_mail = $7,
    lead_whatsapp = $8,
    lead_system_notification = $9,
    follow_up_email = $10,
    closed_lost_email = $11,
    closed_lost_sms = $12,
    closed_lost_whatsapp = $13,
    closed_won_email = $14,
    closed_won_sms = $15,
    closed_won_whatsapp = $16
WHERE
    leads_id = $1
RETURNING *;


-- name: GetLeadNotificationByLeadIdLimitOne :one
SELECT *
FROM leads_notification
WHERE leads_id = $1
LIMIT 1;