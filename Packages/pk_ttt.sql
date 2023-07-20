create or replace package "PK_TTT" as

--==============================================================================
-- comments about procedure
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
    p_row_status in     varchar2 );

--==============================================================================
-- comments about function
--==============================================================================
function get_ename (
    p_empno in number )
return varchar2;

/**
* Die drei ersten Parameter sind die Spalten aus dem interaktiven Grid.
* Die tab_id ist in der neuen Zeile in der Tabelle nicht gesetzt. Daher wird hier der Wert des Seitenelementes p3_tab_id genommen. Das ist der letzte Parameter.
* Nach der Neuanlage müssen im interaktiven Grid die id und die tab_id der neuen Zeile entsprechend gesetzt werden. Daher sind das IN OUT Parameter.
*/
procedure pr_process_ttt_tab_mann(i_id_str IN OUT varchar2, i_tab_id_str IN OUT varchar2, i_mann_id_str IN varchar2, i_p3_tab_id_str IN varchar2);

end "PK_TTT";
/