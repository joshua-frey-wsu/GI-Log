Normalization on Initial DB

1NF

- Members and Recipes relation violate 1NF. 

- Members relation contains an attribute called dietary_issues that violates 1NF because it uses an array data type which makes it not atomic.

- Recipes relation contains an attribute called ingredients that violates 1NF because it uses a JSON object data type which makes it not atomic.

- Updated DB Schema with two new relations to remove array data types in violated relations. 


2NF

Members:

    - Prime or Key Attribute: member_id, email
    - F.D. = member_id -> email, password_hash, first_name,     last_name, birth_date, created_at, updated_at
             email -> member_id, password_hash, first_name, last_name, birth_date, created_at, updated_at
    - (member_id, email)<sup>+</sup> = {member_id, email, passowrd_hash, first_name, last_name, birth_date, created_at, updated_at}
    - All non-prime attributes are fully functionally dependent on both member_id and email so this relation passes 2NF.

Members_Dietary_Issues: 

    - Prime or Key Attribute: id, user_id + dietary_issue
    - F.D. = id -> user_id, dietary_issue, created_at, updated_at
             user_id + dietary_issue -> id, created_at, updated_at
    - (id, user_id + dietary_issue)<sup>+</sup> = {id, user_id, dietary_issue, created_at, updated_at}
    - All non-prime attributes are fully functionally dependent on both id and user_id + dietary_issue so this relation passes 2NF.

All relations pass 2NF.

3NF

BCNF

4NF

5NF