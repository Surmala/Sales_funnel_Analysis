# Sales_funnel_Analysis
 SQL-based e-commerce funnel analysis to identify drop-offs, source performance, conversion timing, and revenue opportunities.

## 1.Sales Funnel Stages:
| Stage | Funnel_Step | Users |
|-------|-------------|-------|
| 1 | View | 4268 |
| 2 | Cart | 1332 |
| 3 | Checkout | 951 |
| 4 | Payment | 768 |
| 5 | Purchase | 708 |


The funnel shows how users progress through each purchase stage. As users move forward, the count decreases, indicating drop-off at each stage.
### KEY INSIGHT:
Largest drop_off occurs between View and cart stage.

## 2.CONVERSION RATES THROUGH THE FUNNEL:
| Funnel Transition  |       Users | Conversion Rate | Insight                                                                  |
| ------------------ | ----------: | --------------: | ------------------------------------------------------------------------ |
| View → Cart        | 4268 → 1332 |             31% | Lowest conversion stage; many users view products but do not add to cart |
| Cart → Checkout    |  1332 → 951 |             71% | Good progression after cart addition                                     |
| Checkout → Payment |   951 → 768 |             81% | Most users continue once checkout starts                                 |
| Payment → Purchase |   768 → 708 |             92% | Highest conversion stage; very low drop-off                              |
| Overall Funnel     |  4268 → 708 |             17% | Final purchase conversion from total views                               |

### KEY INSIGHT:
View → Cart has the lowest conversion rate, so further analysis is needed to identify whether users are dropping due to product mismatch, missing information, or poor add-to-cart visibility.

## 3.FUNNEL BY SOURCE:
| Source   | Views | Carts | Purchases | View → Cart | View → Purchase | Cart → Purchase | Insight                                   |
| -------- | ----: | ----: | --------: | ----------: | --------------: | --------------: | ----------------------------------------- |
| Organic  |  1750 |   576 |       300 |         33% |             17% |             52% | Stable performance, moderate conversion   |
| Paid Ads |   820 |   305 |       173 |         37% |             21% |             57% | Best performing paid source               |
| Email    |   445 |   280 |       151 |         63% |             34% |             54% | Highest quality traffic                   |
| Social   |  1253 |   171 |        84 |         14% |              7% |             49% | Weakest source, major drop at first stage |

### KEY INSIGHT:
Social media generates high traffic (1253 views) but shows the lowest conversion efficiency, with only 14% of users reaching cart and 7% completing purchases.
Email generates fewer visits (445 views) but delivers the highest purchase conversion (34%), indicating stronger user intent and better targeting.

## 4.TIME TO CONVERSION ANALYSIS:
Journey Time Insight
| Metric | Value |
|---|---:|
| Converted Users | 708 |
| Average View → Cart Time | 11.19 minutes |
| Average Cart → Purchase Time | 13.36 minutes |
| Average Total Journey Time | 24.55 minutes |

### KEY INSIGHT:
Although funnel completion is successful for converted users, the average 24.55-minute journey indicates moderate decision time before final purchase, with checkout contributing slightly more delay than initial product selection.

## 5.REVENUE FUNNEL ANALYSIS:
| Metric              |    Value |
| ------------------- | -------: |
| Total Visitors      |     4268 |
| Total Buyers        |      708 |
| Total Orders        |      708 |
| Total Revenue       | 76037.93 |
| Average Order Value |   107.40 |
| Revenue per Buyer   |   107.40 |
| Revenue per Visitor |    17.82 |

### KEY INSIGHT:
Out of 4268 visitors, 708 completed purchases, generating total revenue of 76037.93, with an average order value of 107.40 per buyer.

## Final Recommendations
### Optimize Social Media for Quality, Not Just Volume
Social media contributes a large share of traffic but shows the lowest conversion efficiency, indicating weak purchase intent.
Action: Shift campaigns toward retargeting, lead capture, and email acquisition.

### Scale High-Performing Email Marketing
Email delivers the highest conversion efficiency despite lower traffic volume.
Action: Expand retention campaigns, personalized offers, and remarketing efforts.
