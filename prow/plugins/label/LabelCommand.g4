grammar LabelCommand;

//tokens

SLASH: '/';
LABEL: 'label';
AREA: 'area';
COMMITTEE: 'committee';
KIND: 'kind';
LANGUAGE: 'language';
PRIORITY: 'priority';
SIG: 'sig';
TRIAGE: 'triage';
WORKINGGROUP: 'wg';
REMOVELABEL: 'remove-label';
REMOVEAREA: 'remove-area';
REMOVECOMMITTEE: 'remove-committee';
REMOVEKIND: 'remove-kind';
REMOVELANGUAGE: 'remove-language';
REMOVEPRIORITY: 'remove-priority';
REMOVESIG: 'remove-sig';
REMOVETRIAGE: 'remove-triage';
REMOVEWORKINGGROUP: 'remove-wg';
NAME: [a-zA-Z0-9-]+;
NEWLINE: [\r\n];
WHITESPACE: [ \r\n\t]+ -> skip;

//rules

start : labelOperation (labelOperation)* EOF;

labelOperation
  : addLabel
  | removeLabel
  ;

addLabel
  : SLASH op=('label'|'area'|'committee'|'kind'|'language'|'priority'|'sig'|'triage'|'wg') name
  ;

removeLabel
  : SLASH op=('remove-label'|'remove-area'|'remove-committee'|'remove-kind'|'remove-language'|'remove-priority'|'remove-sig'|'remove-triage'|'remove-wg') name
  ;

name
  : NAME (NEWLINE)*
  ;
