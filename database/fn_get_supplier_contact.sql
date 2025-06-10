-- Function to get supplier contact info
-- Returns the contact name and email for a supplier as a string
CREATE OR REPLACE FUNCTION fn_get_supplier_contact(
    p_supplier_id IN NUMBER   -- Supplier ID
) RETURN VARCHAR2 IS
    v_contact_info VARCHAR2(400); -- Variable to hold the contact info
BEGIN
    -- Select the contact name and email from suppliers
    SELECT contact_name || ' (' || email || ')' INTO v_contact_info
    FROM suppliers
    WHERE supplier_id = p_supplier_id;
    -- Return the contact info
    RETURN v_contact_info;
EXCEPTION
    -- If no record found, return NULL
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END fn_get_supplier_contact;
/ 