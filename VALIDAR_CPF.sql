create or replace FUNCTION validar_cpf(p_cpf IN CHAR) RETURN NUMBER IS
  m_total  NUMBER := 0;
  m_digito NUMBER := 0;
  p_cpf2 Varchar2(11);
BEGIN
  p_cpf2 := replace(replace(p_cpf,'.',''),'-','');
  IF LENGTH(p_cpf2) <> 11 or         
    p_cpf2 = '00000000000' or         
    p_cpf2 = '11111111111' or         
    p_cpf2 = '22222222222' or        
    p_cpf2 = '33333333333' or        
    p_cpf2 = '44444444444' or        
    p_cpf2 = '55555555555' or      
    p_cpf2 = '66666666666' or      
    p_cpf2 = '77777777777' or       
    p_cpf2 = '88888888888' or    
    p_cpf2 = '99999999999' 
    then      
    return 0;
    end if;       
  FOR i IN 1 .. 9 LOOP
    m_total := m_total + substr(p_cpf2, i, 1) * (11 - i);
  END LOOP;
  m_digito := 11 - MOD(m_total, 11);
  IF m_digito > 9 THEN
    m_digito := 0;
  END IF;
  IF m_digito != substr(p_cpf2, 10, 1) THEN
    RETURN 0;
  END IF;
  m_digito := 0;
  m_total  := 0;
  FOR i IN 1 .. 10 LOOP
    m_total := m_total + substr(p_cpf2, i, 1) * (12 - i);
  END LOOP;
  m_digito := 11 - MOD(m_total, 11);
  IF m_digito > 9 THEN
    m_digito := 0;
  END IF;
  IF m_digito != substr(p_cpf2, 11, 1) THEN
    RETURN 0;
  END IF;
  RETURN 1;
EXCEPTION 
  WHEN OTHERS THEN 
    RETURN 0;
END;
