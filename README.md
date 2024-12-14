# Fischer Morrow Market Analytics


**Table of Contents**

- [Project Background](#project-background)
  
- [Data Structure and Initial Checks](#data-structure--initial-checks)
  
- [Executive Summary](#executive-summary)
  
- [Insights Into](#insights-into)
  
  - [Sales Trends](#sales-trends)
    
  - [Product Performance](#product-performance)
    
  - [Loyalty Program](#loyalty-program)
    
  - [Regional Comparisons](#regional-comparisons)
    
- [Recommendations](#recommendations)
  
- [Key Questions for Stakeholders Prior to Project Advancement](#key-questions-for-stakeholders-prior-to-project-advancement)
  
- [Assumptions and Caveats](#assumptions-and-caveats)



## Project Background

Fischer Morrow Electronics, established in 2019, is a global e-commerce company that sells popular electronic products worldwide via its website and mobile app.

The company has significant amounts of data on its sales, marketing efforts, operational efficiency, product offerings, and loyalty program that has been previously underutilized. This project thoroughly analyzes and synthesizes this data in order to uncover critical insights that will improve Fischer Morrow's commercial success.

Insights and recommendations are provided on the following key areas:

- **Sales Trends Analysis:** Evaluation of historical sales patterns, both globally and by region, focusing on **Revenue**, **Order Volume**, and **Average Order Value (AOV)**.

- **Product Level Performance:** An analysis of Fischer Morrow's various product lines, understanding their impact on sales and returns.

- **Loyalty Program Success:** An assessment of the loyalty program on customer retention and sales.

- **Regional Comparisons:** An evaluation of sales and orders by region.

---


**Interactive PowerBI Dashboard**: View/Download it [here](https://app.powerbi.com/view?r=eyJrIjoiMWI1OTYzYjAtNDZiMC00ZWRjLWFkYzAtZjUzNWZjMWJkYjFhIiwidCI6ImY5NzI3NGE2LTNlYzctNDM0ZC05MWU5LTVhY2NlMmMyMGE5MiJ9&pageName=5ca7635b3d9c51ad399d).


**Data Inspection & Quality Checks**:  [SQL script](https://github.com/faizanxmulla/Fischer-Morrow-Market-Analytics/blob/main/SQL%20scripts/1-initial-data-checks.sql)

**Data Cleaning & Preparation:** [SQL script](https://github.com/faizanxmulla/Fischer-Morrow-Market-Analytics/blob/main/SQL%20scripts/2-data-cleaning.sql)

**Business Analysis Questions**: [SQL script](https://github.com/faizanxmulla/Fischer-Morrow-Market-Analytics/blob/main/SQL%20scripts/3-business-questions.sql)

</aside>

---

## Data Structure & Initial Checks

Fischer Morrow's database structure as seen below consists of **four** tables: orders, customers, geo_lookup, and order_status, with a total row count of **108,127** records.

![image](https://github.com/user-attachments/assets/9c684e39-3be0-43f6-b2bc-061888bb43f4)

Prior to beginning the analysis, a variety of checks were conducted for quality control and familiarization with the datasets. The SQL queries utilized to inspect and perform quality checks can be found [here]().


## Executive Summary

After peaking in late 2020, the company's sales have continued to decline, with significant drops in 2022. Key performance indicators have all shown **year-over-year decreases**: order volume by **40%**, revenue by **46%**, and average order value (AOV) by **10%**. While this decline can be broadly attributed to a return to pre-pandemic normalcy, the following sections will explore additional contributing factors and highlight key opportunity areas for improvement.

![image](https://github.com/user-attachments/assets/5f53fcd7-4667-438c-9302-f7618a9a3139)


## Insights Into

### **Sales Trends**

- **The company's sales peaked in December 2020 with 4,019 orders totaling $1,251,721 monthly revenue**. This corresponds with the boom in economy-wide spending due to pandemic-induced changing consumer behavior.

- Beginning in April 2021, **revenue declined on a year-over-year basis for 21 consecutive months**. Revenue hit a company lifetime low in October 2022, with the company earning just over **$178K**. In the following months, revenue recovered slightly, following normal holiday seasonality patterns.

- Despite the downward trend, full-year 2022 remained above the pre-COVID 2019 baseline in all three key performance indicators. This is primarily due to the stronger 1Q22, which recorded revenue and order count well above the same period in 2020, **up 37% and 23% respectively.**

- Average order value saw a one-month year-over-year increase in September 2022, this can be attributed to an increased share of high-cost laptop orders.


![image](https://github.com/user-attachments/assets/0de95aae-9ff6-44e5-9577-931e9eba8008)


### **Product Performance**

- **Just three products account for 85% of the company's orders**: Gaming Monitor, Apple AirPods Headphones, and Samsung Charging Cable Pack. These products generated **$3.5M** in revenue in 2022, representing **70%** of total revenue.

- In the headphones category, Bose SoundSport Headphones have underperformed, making up less than 1% of total revenues and orders, despite being $40 cheaper than the successful AirPods.

- The accessory category's share of orders has grown steadily, **reaching 32% in 2022, up from 21% in 2020**. However, accessories contribute less than 4% of total revenue.

- The company depends heavily on Apple's continued popularity, with the brand **accounting for 47% of total revenue in 2022**. However, iPhone sales remain minimal, making up less than 1% of orders in 2022.


![image](https://github.com/user-attachments/assets/fb793768-f5c7-450c-a9f3-a8b985b155c7)


### **Loyalty Program**

- The loyalty program has grown in popularity since its implementation in 2019. Members as a share of revenue peaked in April 2022 at 62%. **On an annual basis, members have increased to 55% of revenue, up from 8% in 2019.**

- In 2022, l**oyalty members spent almost $35 more on average than non-members ($251 to $216)**. Annual order value (AOV) for members has steadily increased year-over-year, climbing 1.1% from 2021 while non-member AOV declined 18.7%.

- Non-members have historically outspent on their first orders with the company, but on **returning orders members outspent by nearly $60 in 2022.**


![image](https://github.com/user-attachments/assets/4e492991-3c49-48d9-b1b7-f4f9e76560db)


### **Regional Comparisons**

- North America grew in importance in 2022, increasing revenue share to **55%** and order share to **53%** among known region sales.

- Sales and average order value (AOV) fell across all regions in 2022. **North America remains the largest AOV with $242, 39% above Latin America, the lowest performer.**

- Europe, the Middle East, and Africa saw a significant increase in order volume share in 4Q22, climbing from **26%** to **33%** quarter-over-quarter among known region sales.


![image](https://github.com/user-attachments/assets/e5e1ea56-7012-4aea-8575-db99dcf78bdd)


## **Recommendations**

Based on the uncovered insights, the following recommendations have been provided:

- With 85% of orders and 70% of revenue coming from just three products, diversifying the product portfolio is crucial. **Expanding the accessory category with new product lines, particularly Apple charging cables, would provide upsell opportunities.**

- Despite the general sales success of Apple products, iPhone sales have been disappointingly low (1% of revenue in 2022). **Enhancing marketing efforts to previous Apple product buyers could boost sales.**

- Look to capitalize on the growing share of Samsung accessories (32% of order count in 2022) by **introducing higher-cost Samsung products in already carried product categories such as laptops and cellphones.**

- **Re-evaluate Bose SoundSport Headphones.** As the product has never made up more than 1% of annual revenue, attempt to sell through the product by implementing bundle offers and flash sales to non-Apple ecosystem loyalty members before discontinuing.

- **Continue and push forward the loyalty program.** In order to convert non-members, consider offering a one-time sign-up discount paired with increased general marketing of membership benefits and savings. Focus targeted and personalized ads to previous customers, and utilize past order data to increase marketing efforts when previously purchased products may need replacing.

- **Regional Growth Strategies**
    - **Focus on High-Performing Regions**: Continue allocating resources to North America and EMEA with regionalized marketing and product availability strategies tailored to local preferences.

    - **Target Growth in APAC and LATAM**: Leverage localized partnerships and culturally tailored promotions to capture growth potential in APAC and LATAM, stabilizing sales in these emerging markets.



## **Key Questions for Stakeholders Prior to Project Advancement**

- **`loyalty_program` in the `customers` table**

    - Is **`loyalty_program`** account-specific or tied to individual orders?

    - Can loyalty membership status vary between orders for the same user, i.e., is it a subscription or a one-time sign-up?

- **`marketing_channel` and `account_creation_method` in the `customers` table**

    - What factors contribute to their “deterministic” relationship?

    - Does **`marketing_channel`** capture the initial account creation touchpoint, or does it represent the origin of each individual purchase (which is more relevant for tracking sales)?



## **Assumptions and Caveats**

There are areas in the dataset where data quality may need further investigation. While these issues did not significantly impact the quality of this analysis, they have been retained for completeness. It is recommended to consult with the data engineering team to determine if there were any ETL errors and address these values accordingly.

- **Zero USD Price Orders:** There are 115 orders with a listed price of USD 0. The reasons for these zero-priced orders are unclear—they could be due to special promotions, giveaways, or customer service issues. The orders were retained as it represents less than 1% of the data.

- **Missing or Nonsensical Country Codes:** There are 97 orders with missing or nonsensical country codes. These entries may indicate data entry errors or issues during the data transformation process. The orders were retained as it represents less than 1% of the data.

- **Refund Records**: No refunds were recorded for 2022, which is an anomaly warranting further examination.

- **Deterministic Relationship in Data**: Each **`marketing_channel`** is uniquely linked to one **`account_creation_method`**, indicating a **“one-to-one”** mapping. This lack of variation may require attention from the data engineering team to confirm intended relationships.

<div align="center">
  <img src="https://github.com/user-attachments/assets/d45fba01-01c6-47c1-8dc0-5e62d01dd875" alt="image">
</div>


- **Loyalty Program Clarification**:

    - Ambiguity exists in the **`loyalty_program`** variable—it's unclear if it's tied to the user's account or is specific to individual orders.

    - Can a user be a loyalty member for one purchase and not another? This clarification is essential for accurately measuring program performance.


---
---

**Interactive PowerBI Dashboard**: View/Download it [here](https://app.powerbi.com/view?r=eyJrIjoiMWI1OTYzYjAtNDZiMC00ZWRjLWFkYzAtZjUzNWZjMWJkYjFhIiwidCI6ImY5NzI3NGE2LTNlYzctNDM0ZC05MWU5LTVhY2NlMmMyMGE5MiJ9&pageName=5ca7635b3d9c51ad399d).


Follow me on **LinkedIn**: [LinkedIn](www.linkedin.com/in/faizanxmulla)

