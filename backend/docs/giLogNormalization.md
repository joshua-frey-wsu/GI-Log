Normalization on Initial DB

1NF

- Members and Recipes relation violate 1NF. 

- Members relation contains an attribute called dietary_issues that violates 1NF because it uses an array data type which makes it not atomic.

- Recipes relation contains an attribute called ingredients that violates 1NF because it uses a JSON object data type which makes it not atomic.

- Updated DB Schema with two new relations to remove array data types in violated relations. 


2NF

3NF

BCNF

4NF

5NF