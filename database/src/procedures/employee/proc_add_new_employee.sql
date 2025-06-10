-- Procedure to add a new employee
-- This procedure handles employee creation with validation and initialization
CREATE OR REPLACE PROCEDURE proc_add_new_employee(
    p_employee_id    IN NUMBER,      -- Employee ID
    p_first_name     IN VARCHAR2,    -- First name
    p_last_name      IN VARCHAR2,    -- Last name
    p_email          IN VARCHAR2,    -- Email
    p_phone          IN VARCHAR2,    -- Phone
    p_hire_date      IN DATE,        -- Hire date
    p_position       IN VARCHAR2,    -- Position
    p_department     IN VARCHAR2,    -- Department
    p_manager_id     IN NUMBER,      -- Manager ID
    p_store_id       IN NUMBER       -- Store ID
) AS
    v_email_count NUMBER;
    v_phone_count NUMBER;
    v_manager_exists NUMBER;
    v_store_exists NUMBER;
BEGIN
    -- Validate email uniqueness
    SELECT COUNT(*) INTO v_email_count
    FROM employees
    WHERE email = p_email;
    
    IF v_email_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20014, 'Employee email already exists');
    END IF;
    
    -- Validate phone uniqueness
    SELECT COUNT(*) INTO v_phone_count
    FROM employees
    WHERE phone = p_phone;
    
    IF v_phone_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20015, 'Employee phone number already exists');
    END IF;
    
    -- Validate manager exists if provided
    IF p_manager_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_manager_exists
        FROM employees
        WHERE employee_id = p_manager_id;
        
        IF v_manager_exists = 0 THEN
            RAISE_APPLICATION_ERROR(-20016, 'Manager ID does not exist');
        END IF;
    END IF;
    
    -- Validate store exists
    SELECT COUNT(*) INTO v_store_exists
    FROM stores
    WHERE store_id = p_store_id;
    
    IF v_store_exists = 0 THEN
        RAISE_APPLICATION_ERROR(-20017, 'Store ID does not exist');
    END IF;
    
    -- Insert new employee
    INSERT INTO employees (
        employee_id,
        first_name,
        last_name,
        email,
        phone,
        hire_date,
        position,
        department,
        manager_id,
        store_id,
        status,
        created_date
    ) VALUES (
        p_employee_id,
        p_first_name,
        p_last_name,
        p_email,
        p_phone,
        p_hire_date,
        p_position,
        p_department,
        p_manager_id,
        p_store_id,
        'ACTIVE',
        SYSDATE
    );
    
    -- Initialize employee performance metrics
    INSERT INTO employee_performance (
        employee_id,
        total_sales,
        total_transactions,
        average_transaction_value,
        customer_satisfaction_score,
        last_evaluation_date
    ) VALUES (
        p_employee_id,
        0,
        0,
        0,
        5.0,
        NULL
    );
    
    -- Initialize employee schedule
    INSERT INTO employee_schedule (
        employee_id,
        store_id,
        shift_date,
        shift_start,
        shift_end,
        break_start,
        break_end,
        status
    ) VALUES (
        p_employee_id,
        p_store_id,
        TRUNC(SYSDATE),
        TO_DATE('09:00', 'HH24:MI'),
        TO_DATE('17:00', 'HH24:MI'),
        TO_DATE('12:00', 'HH24:MI'),
        TO_DATE('13:00', 'HH24:MI'),
        'SCHEDULED'
    );
    
    COMMIT;
END proc_add_new_employee;
/ 