# Monetization

## Strategy

Freemium with content gate. N5 content is free. N4–N1 requires a paid plan.

## Pricing (Post-Validation)

| Plan | Price | Type |
|---|---|---|
| Monthly | ~$6/month | Auto-renewable subscription |
| Yearly | ~$40/year | Auto-renewable subscription |
| Lifetime | ~$80 one-time | Non-consumable IAP |

Exact prices TBD after validation.

## Free Tier

| Study Path | Free Content | Paid Content |
|---|---|---|
| JLPT | N5 | N4–N1 |
| Grade | Grade 1 | Grades 2–6, Secondary (8) |

Filtered via `min_jlpt_level` and `min_grade` on entity specs.

## MVP Phase

- Free tier content only — no payment infrastructure
- Goal: validate retention and learning flow before adding monetization

## Grandfathering

Users who signed up during the free validation phase get full access permanently. Determined by `User.created_at` — anyone created before the monetization launch date is grandfathered. No extra entity needed.

## Implementation (Later)

- Content gating via `min_jlpt_level` filtering in the lesson queue
- `UserSettings` or a new `Subscription` entity to track entitlement
- Apple StoreKit 2 + Google Play Billing
- Receipt validation server-side (Supabase Edge Function or RevenueCat)
- Restore purchases flow for device switching
