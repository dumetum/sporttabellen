create or replace package "PK_TTT" as


/**
* Die drei ersten Parameter sind die Spalten aus dem interaktiven Grid.
* Die tab_id ist in der neuen Zeile in der Tabelle nicht gesetzt. Daher wird hier der Wert des Seitenelementes p3_tab_id genommen. Das ist der letzte Parameter.
* Nach der Neuanlage müssen im interaktiven Grid die id und die tab_id der neuen Zeile entsprechend gesetzt werden. Daher sind das IN OUT Parameter.
*/
procedure pr_process_ttt_tab_mann(i_id_str IN OUT varchar2, i_tab_id_str IN OUT varchar2, i_mann_id_str IN varchar2, i_p3_tab_id_str IN varchar2);

procedure pr_set_mann_id(i_mann_id IN NUMBER);

procedure pr_process_ergebnis;

function get_mannschaftsbezeichnung(i_mann_id NUMBER)
return varchar2;

/**
* Für ein Spiel aus der Tabelle ttt_spiele mit der id i_spiel_id wird die Bezeichnung der ersten bzw. zweiten beteiligten Mannschaft zurückgegeben
*/
function get_mannschaftsbezeichnung(i_spiel_id NUMBER, i_mann_nr NUMBER)
return varchar2;

end "PK_TTT";
/