create or replace package body "PK_TTT" as

--==============================================================================
-- Public API, see specification
--==============================================================================
procedure process_emp_data (
    p_empno      in out number,
    p_ename      in     varchar2,
    p_job        in     varchar2,
    p_mgr        in     number,
    p_hiredate   in     date,
    p_sal        in     number,
    p_comm       in     number,
    p_deptno     in     number,
    p_row_status in     varchar2 )
is
begin
    apex_debug.enter(
        'process_emp_data' ,
        'p_empno'          , p_empno,
        'p_empno'          , p_empno,
        'p_job'            , p_job,
        'p_mgr'            , p_mgr,
        'p_hiredate'       , p_hiredate,
        'p_sal'            , p_sal,
        'p_comm'           , p_comm,
        'p_deptno'         , p_deptno,
        'p_row_status'     , p_row_status );

    -- enter the procedure code here

end process_emp_data;

--==============================================================================
-- Public API, see specification
--==============================================================================
function get_ename (
    p_empno in number )
return varchar2
is
    l_ename varchar2(255);
begin
    apex_debug.enter(
        'get_ename' ,
        'p_empno'   , p_empno );

    -- enter the function code here
    /*
    select ename
      into l_ename
      from emp
     where empno = p_empno;
    */
    return l_ename;
exception
    when no_data_found then
        apex_debug.warn(
            p_message => 'Employee not found. p_empno %s, sqlerrm %s',
            p0        => p_empno,
            p1        => sqlerrm );
        raise;
end get_ename;

--
-- Verarbeite alle Ergebnisse einer Tabelle, d.h. berechne alle Punkte neu.
-- Beinhaltet nicht die Sortierung (oder doch?)
--
procedure verarbeite_ergebnisse(i_tab_id IN NUMBER)
is
begin
  null;
end;


--
-- Sortierung einer Tabelle, d.h. Berechnung und Setzen des Rangs
--
procedure sortiere_tabelle(i_tab_id IN NUMBER)
is
begin
  -- ZU TUN: Man könnte die Zeilen der Tabelle in eine interne Tabelle schreiben und diese sortieren. Und dann den Rang entsprechend updaten.
  -- Vielleicht geht es auch anders.
  null;
end;

--
-- Seitenbearbeitungsprozess für die Eingabe von Mannschaften zu einer Tabelle
--
procedure pr_process_ttt_tab_mann(i_id_str IN OUT varchar2, i_tab_id_str IN OUT varchar2, i_mann_id_str IN varchar2, i_p3_tab_id_str IN varchar2)
is
  l_row ttt_tab_mann%rowtype;
  l_new_id NUMBER;
  l_anzahl NUMBER;
  l_mannschaft_mehrfach_zugeordnet EXCEPTION;
  l_mannschaft_bez VARCHAR2(43);
begin
  l_row.id := to_number(i_id_str);
  l_row.tab_id := to_number(i_p3_tab_id_str);
  l_row.mann_id := to_number(i_mann_id_str);

  if v('APEX$ROW_STATUS') = 'D' then
    delete from ttt_spiele where tab_id = l_row.tab_id and (mann_id_1 = l_row.mann_id or mann_id_2 = l_row.mann_id);
    delete from ttt_tabellenzeilen where tab_id = l_row.tab_id and mann_id = l_row.mann_id;
    delete from ttt_tab_mann where id = l_row.id;
    verarbeite_ergebnisse(l_row.tab_id);
    sortiere_tabelle(l_row.tab_id);
  elsif (v('APEX$ROW_STATUS') = 'U') then
    -- Das kann nicht passieren, da ein Zeilenupdate verboten ist.
    update ttt_tab_mann set tab_id = l_row.tab_id, mann_id = l_row.mann_id where id = l_row.id;
  else
    insert into ttt_tabellenzeilen (tab_id, mann_id, rang, anz_spiele, anz_siege, anz_unentschieden, anz_niederlagen, einzelpunkte_plus, einzelpunkte_minus, gesamtpunkte_plus, gesamtpunkte_minus)
    values (l_row.tab_id, l_row.mann_id, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    sortiere_tabelle(l_row.tab_id);

    -- die id wird offensichtlich automatisch gesetzt
    insert into ttt_tab_mann (tab_id, mann_id)
    values(l_row.tab_id, l_row.mann_id)
    returning id into l_new_id;

    -- Rückgabe der entsprechenden Werte für die Oberfläche
    i_id_str := to_char(l_new_id);
    i_tab_id_str := i_p3_tab_id_str;
  end if;

  -- Check, ob die gewählte Mannschaft mehrfach zugeordnet wurde. Evtl. auch einer anderen Tabelle (was durch die Oberfläche aber auch geprüft wird)
  -- Professionellerweise müßte man hier eine Check-Methode schreiben.
  -- Für den Prototypen reicht es so.
  select count(*) into l_anzahl from ttt_tab_mann where mann_id = l_row.mann_id;
  if l_anzahl > 1 then
    select verein || ' ' || nr into l_mannschaft_bez from ttt_mannschaften where id = l_row.mann_id;
    --raise l_mannschaft_mehrfach_zugeordnet;
    APEX_ERROR.add_error('Mannschaft ' || l_mannschaft_bez || ' mehrfach zugeordnet!', 'Mannschaft mehrfach zugeordnet!', APEX_ERROR.c_inline_in_notification);
  end if;

end pr_process_ttt_tab_mann; 

procedure pr_set_mann_id(i_mann_id IN NUMBER)
is
begin
  apex_util.set_session_state('P3_MANN_ID', i_mann_id);
  pk_chh.pr_write_log ('pr_set_mann_id: i_mann_id' || i_mann_id || ', P3_MANN_ID: ' || apex_util.get_session_state('P3_MANN_ID'));
end;

procedure pr_process_ergebnis
is
  l_request constant varchar2(10)  :=  V('REQUEST');
  l_id constant number := apex_session_state.get_number('P6_ID');
  l_new_id number;
  l_tab_id constant number := apex_session_state.get_number('P6_TAB_ID');
  l_mann_id_1 constant number := apex_session_state.get_number('P6_MANN_ID_1');
  l_mann_id_2 constant number := apex_session_state.get_number('P6_MANN_ID_2');
  l_punkte_mann_1 constant number := apex_session_state.get_number('P6_PUNKTE_MANN_1');
  l_punkte_mann_2 constant number := apex_session_state.get_number('P6_PUNKTE_MANN_2');
begin
  -- pk_chh.pr_write_log('pr_process_ergebnis: , request: ' || l_request || ', id: ' || l_id ||  ', tab_id: ' || l_tab_id || ', mann_id_1: ' || l_mann_id_1  || ', mann_id_2: ' || l_mann_id_2 || ', punkte_mann_1: ' || l_punkte_mann_1  || ', punkte_mann_2: ' || l_punkte_mann_2);
  APEX_DEBUG_MESSAGE.LOG_MESSAGE(p_message => 'pr_process_ergebnis: , request: ' || l_request || ', id: ' || l_id ||  ', tab_id: ' || l_tab_id || ', mann_id_1: ' || l_mann_id_1  || ', mann_id_2: ' || l_mann_id_2 || ', punkte_mann_1: ' || l_punkte_mann_1  || ', punkte_mann_2: ' || l_punkte_mann_2, p_level => 4);

  if l_request = 'CREATE'  then
    insert into ttt_spiele (tab_id, mann_id_1, mann_id_2, punkte_mann_1, punkte_mann_2)
    values(l_tab_id, l_mann_id_1, l_mann_id_2, l_punkte_mann_1, l_punkte_mann_2)
    returning id into l_new_id;   

    apex_session_state.set_value('P6_ID', l_new_id);
  elsif l_request = 'DELETE' then
    delete from ttt_spiele where id = l_id;
  else
    update ttt_spiele
    set mann_id_1 = l_mann_id_1, mann_id_2 = l_mann_id_2, punkte_mann_1 = l_punkte_mann_1, punkte_mann_2 = l_punkte_mann_2
    where id = l_id;
  end if;

end;

end "PK_TTT";
/