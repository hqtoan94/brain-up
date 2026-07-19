---
name: budget-planning
description: Plan next month's budget by analyzing spending patterns from VN Budget Google Sheets. Identifies outliers and asks about those; carries forward consistent spending automatically. Use when user says "plan budget", "budget next month", "monthly budget".
---

# Budget Planning

## Data Sources

- **VN 2026 Budget**: Google Sheet `1d7LMt71BPXYOKhpPWFxjCT9LzZIOe0HxscpaVCtmoQo`
- **VN 2025 Budget** (historical): Google Sheet `18K03Nuk5gv-uaI_7UOL9yWzzc0KV1hwFxyPeki2PAFk`

Use `mcp__Google_Drive__search_files` with `title contains 'budget'` or `mcp__Google_Drive__read_file_content` to pull live data.

## Confidentiality

Income is confidential. Never display or reference income amounts. Only work with outgoing categories.

## Process

1. **Pull last 3 months' actuals** from the VN 2026 Budget (yearly overview + category overview)
2. **Classify each category** into:
   - **Consistent**: amount varies less than ~20% month-to-month → carry forward the average, no question needed
   - **Outlier**: amount spiked or dropped significantly vs. the pattern → ask the user about it
   - **Seasonal/one-off**: appeared only in specific months (Tet, Travel, large gifts) → ask if it applies next month
   - **Zero baseline**: categories the user typically doesn't spend on → default to 0, don't ask unless seasonal
3. **Present the consistent items** as a block: "These are carrying forward from your pattern — [table]"
4. **Ask about outliers one at a time**:
   - "Last month [category] was [amount], which is [higher/lower] than your usual [avg]. Expecting similar next month, or back to normal?"
5. **Ask about upcoming events**:
   - "Any weddings, birthdays, or events next month?" (always ask this)
   - "Any travel planned?" (always ask this)
   - "Any large purchases or one-off expenses coming?" (always ask this)
6. **Produce the final budget table** with all categories and amounts
7. **Offer to grill** via the grill-me skill: "Want me to stress-test this plan before we finalize?"

## Output Format

```
## [Month Year] Budget Plan

### Carried Forward (consistent)
| Category | Amount (VND) |
|----------|-------------|
| ... | ... |

### Adjusted (from your answers)
| Category | Amount (VND) | Note |
|----------|-------------|------|
| ... | ... | ... |

### Total Outgoing: [sum]
```

## Rules

- Never show income
- Amounts in VND, no conversion
- Only modify current/next month — never touch historical data
- Consistent = copy, outlier = ask — keep the conversation short
