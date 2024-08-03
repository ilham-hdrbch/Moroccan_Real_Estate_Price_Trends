# Moroccan Real Estate Price Trends Dashboard

## Problem Statement

The Moroccan real estate market is complex and lacks a centralized platform for analyzing price trends. This project addresses this issue by developing a dashboard that enables users to explore house prices based on location (city, district), property characteristics (size, number of rooms), and property type.

### Steps followed 
#### 1. Data Collection

I collected data using web scraping techniques from two real estate websites:
Maskan.ma
Mubawab.ma
The following details were extracted:
Location (city and district)
Price of the house
Area of the house (in square meters)
Number of rooms
####2. Data Storage and Preparation
I stored the collected data in SQL Server across three tables:
House: Contains information about each house listing.
Localisation: Contains details about the location of each house.
Web: Contains metadata about the web scraping process.
In SQL Server, I performed data cleaning and preparation, including:
Removing duplicates
Handling null values
Standardizing unit measurements
####3. Data Visualization in Power BI
Using Power BI, I visualized the cleaned and processed data through an interactive dashboard. I created a new column to categorize houses into luxury, mid-range, and economy based on their prices. The dashboard includes various visualizations that enable users to explore and compare house prices based on area, number of rooms, and location. It also allows users to compare house prices across different cities and between the two websites, Maskan.ma and Mubawab.ma. These visualizations provide a comprehensive view of the Moroccan real estate market, offering valuable insights for potential buyers and investors.
