grammar Bil;

bil : progdecl? function+ EOF;
function : sub 
         paramTypes*
         (stmt)* 
         endsub ;

/* First line is always this */
progdecl: addr ':' 'program';
/* Beginning of sub */
sub : addr ':' 'sub' functionName '(' param? (',' param)* ')';
/* Listing the parameter types */
paramTypes : addr ':' param '::' inout nat '=' var ;
/* Statement */
stmt : addr ':' 
       (assign|call|jmp|cjmp)?
     ;
/* Calling with noreturn (probably) means exiting a function */
endsub : addr ':' 'call' (('@' functionName)|var) 'with' 'noreturn';

call : 'call' (('@' functionName)|var) 'with' returnaddr ;

assign : var ':=' exp ;
exp : exp bop exp                                       #expBop
    | literal                                           #expLiteral
    | '(' exp ')'                                       #expBracket
    | uop exp                                           #expUop
    | var                                               #expVar
    | exp 'with' '[' exp ',' ENDIAN ']:' nat '<-' exp   #expStore
    | CAST ':' nat '[' exp ']'                          #expCast
    | exp '[' exp ',' ENDIAN ']:' nat                   #expLoad
    | 'extract' ':' nat ':' nat '[' exp ']'             #expExtract
    ;
cjmp : 'when' var 'goto' '%' addr ;
jmp : 'goto' (('%' addr)|('@' var));

var : ID ;
functionName : ID ;
param : ID ;
bop : PLUS | MINUS | TIMES | DIVIDE | MODULO | LSL | LSR | ASR | BAND | BOR | BXOR | EQ | NEQ | LT | LE ;
uop : NOT ;
inout : 'in out' | 'in' | 'out' ;
returnaddr : 'noreturn' | 'return' '%' addr ;
literal : NUMBER ;
nat : (NAT | NUMBER) ;
addr : NUMBER ;

CAST : ('pad' | 'extend' | 'high' | 'low') ;
NAT : ('u32' | 'u64') ;
ENDIAN : ('el' | 'be');
ID : (ALPHA|'_'|'#') (ALPHA | NUMBER | '_')* ;
NUMBER : HEX | DECIMAL;
DECIMAL : [0-9]+ ;
HEX : '0x'? ([0-9]|[a-f]|[A-F])+ ;
ALPHA : ([A-Z]|[a-z])+ ;
NEWLINE : '\r'? '\n' -> skip;
WHITESPACE : ' '+ -> skip;
COMMENT : '//' ~[\r\n]* -> skip;
PLUS : '+' ;
MINUS : '-' ;
TIMES : '*' ;
DIVIDE : '/' ;
MODULO : '%' ; 
LSL : '<<' ; // Inferred
LSR : '>>' ; // Inferred
ASR : '>>>' ; // Inferred
BAND : '&' ;
BOR : '|' ;
BXOR : 'xor' ; 
EQ : '=' ;
NEQ : '<>' ;
LT : '<' ;
LE : '<=' ;
NOT : '~' ;

