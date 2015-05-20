# README

This folder contains a python script that looks up unique user IPs. It queries all unique IP addresses from a mongodb collection and looks up their country-level location. It then stores each unique IP in a flat table in a SQLite database. 

The script does not yet filter for unique IPs *per user*. However, you can do this afterwards.

Please keep in mind that Coursera counts IP-adresses as [*personally identifiable information* (PII)](https://partner.coursera.help/hc/en-us/articles/203574479-Data-and-Privacy). As such, this is potentially 'dangerous data' in the sense that it poses a risk of identification for your learners. 