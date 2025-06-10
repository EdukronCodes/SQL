-- Procedure to update customer loyalty points
-- This procedure handles loyalty point updates with validation and history tracking
CREATE OR REPLACE PROCEDURE proc_update_loyalty_points(
    p_customer_id IN NUMBER,    -- Customer ID
    p_points      IN NUMBER,    -- Points to add/subtract
    p_reason      IN VARCHAR2,  -- Reason for update
    p_user_id     IN NUMBER     -- User performing the update
) AS
    v_old_points NUMBER;
    v_new_points NUMBER;
BEGIN
    -- Get current points
    SELECT loyalty_points
    INTO v_old_points
    FROM customers
    WHERE customer_id = p_customer_id;
    
    -- Calculate new points
    v_new_points := v_old_points + p_points;
    
    -- Validate new points
    IF v_new_points < 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Points cannot be negative');
    END IF;
    
    -- Update points
    UPDATE customers
    SET loyalty_points = v_new_points
    WHERE customer_id = p_customer_id;
    
    -- Log points history
    INSERT INTO loyalty_points_history (
        history_id,
        customer_id,
        old_points,
        new_points,
        points_change,
        change_date,
        change_reason,
        user_id
    ) VALUES (
        loyalty_history_seq.NEXTVAL,
        p_customer_id,
        v_old_points,
        v_new_points,
        p_points,
        SYSDATE,
        p_reason,
        p_user_id
    );
    
    -- Check for loyalty tier changes
    INSERT INTO loyalty_tier_changes (
        change_id,
        customer_id,
        old_tier,
        new_tier,
        change_date
    )
    SELECT 
        loyalty_tier_seq.NEXTVAL,
        p_customer_id,
        CASE 
            WHEN v_old_points < 1000 THEN 'BRONZE'
            WHEN v_old_points < 5000 THEN 'SILVER'
            ELSE 'GOLD'
        END,
        CASE 
            WHEN v_new_points < 1000 THEN 'BRONZE'
            WHEN v_new_points < 5000 THEN 'SILVER'
            ELSE 'GOLD'
        END,
        SYSDATE
    WHERE 
        CASE 
            WHEN v_old_points < 1000 THEN 'BRONZE'
            WHEN v_old_points < 5000 THEN 'SILVER'
            ELSE 'GOLD'
        END !=
        CASE 
            WHEN v_new_points < 1000 THEN 'BRONZE'
            WHEN v_new_points < 5000 THEN 'SILVER'
            ELSE 'GOLD'
        END;
    
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20011, 'Customer not found');
END proc_update_loyalty_points;
/ 