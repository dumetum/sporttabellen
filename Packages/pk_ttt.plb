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

procedure pr_process_ttt_tab_mann(i_id_str varchar2, i_tab_id_str varchar2, i_mann_id_str varchar2)
is
  l_row ttt_tab_mann%rowtype;
begin
  l_row.id := to_number(i_id_str);
  l_row.tab_id := to_number(i_tab_id_str);
  l_row.mann_id := to_number(i_mann_id_str);

  if v('APEX$ROW_STATUS') = 'D' then
    delete from ttt_tab_mann where id = l_row.id;
  elsif (v('APEX$ROW_STATUS') = 'U') then
    update ttt_tab_mann set tab_id = l_row.tab_id, mann_id = l_row.mann_id where id = l_row.id;
  else
    -- die id wird offensichtlich automatisch gesetzt
    insert into ttt_tab_mann (tab_id, mann_id)
    values(l_row.tab_id, l_row.mann_id);
  end if;
end pr_process_ttt_tab_mann; 


end "PK_TTT";
/