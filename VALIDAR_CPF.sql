create or replace FUNCTION validar_cpf(p_cpf IN CHAR) RETURN NUMBER IS
  m_total  NUMBER := 0;
  m_digito NUMBER := 0;
  p_cpf2 Varchar2(11);
  l_first_digit Varchar2(1);
  l_count NUMBER;
BEGIN
--Limpa a String para retirar pontos e hifen
  p_cpf2 := replace(replace(p_cpf,'.',''),'-','');

--Percorre a string e compara todos os dígitos com o primeiro dígito
  l_first_digit := SUBSTR (p_cpf2, 1, 1);
  FOR i IN 2..11 LOOP    
    IF SUBSTR (p_cpf2, i, 1) != l_first_digit THEN
      EXIT;
    END IF;
    l_count := i;
  END LOOP;

--Se todos os caracteres forem iguais ou o número de caracteres da string for diferente de 11, retorna 0
  IF LENGTH(p_cpf2) <> 11 or l_count = '11'
    then      
    return 0;
  end if;  

/*
Validação do primeiro dígito
*/
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

-- Validação do segundo dígito
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
/
