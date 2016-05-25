/* Scanner for COOL */

%{
#include <stdio.h>
#include "y.tab.h"
%}

%x IN_COMMENT
%option stack

%%

--.*        /* one-line comment */

"(*"        yy_push_state(IN_COMMENT);
<IN_COMMENT>{
"(*"        yy_push_state(IN_COMMENT);
"*)"        yy_pop_state();
[^*\n]+     /* eat comment in chunks */
"*"         /* eat the lone star */
\n          yylineno++;
}

[0-9]+      { return CONSTANT; }

if          { return IF; }
then        { return THEN; }
else        { return ELSE; }
fi          { return FI; }
while       { return WHILE; }
loop        { return LOOP; }
pool        { return POOL; }
let         { return LET; }
in          { return IN; }
case        { return CASE; }
of          { return OF; }
esac        { return ESAC; }
new         { return NEW; }
isvoid      { return ISVOID; }
not         { return NOT; }
true        { return TRUE; }
false       { return FALSE; }
class       { return CLASS; }
inherits    { return INHERITS; }

[a-z][[:alnum:]_]*  { return IDENTIFIER; }
[A-Z][[:alnum:]_]*  { return TYPE; }

\"(\\.|[^\\"])*\"   { return STRING; }

"{"			{ return L_BRACE; }
"}"			{ return R_BRACE; }
"+"			{ return PLUS; }
"-"			{ return MINUS; }
"*"			{ return TIMES; }
"/"			{ return DIVIDE; }
":"			{ return COLON; }
"<-"		{ return L_ARROW; }
"."			{ return DOT; }
";"			{ return SEMI; }
"~"			{ return TILDE; }
"<"			{ return LT; }
"<="		{ return LE; }
"="			{ return EQUALS; }
"("			{ return L_PAREN; }
")"			{ return R_PAREN; }
"@"			{ return AT; }

[ \t\r\n]   /* whitespaces */

.           printf("Unrecognized character: %s\n", yytext);

%%

int main(int argc, char** argv)
{
    ++argv, --argc; // skip over program name
    if (argc > 0) {
        yyin = fopen(argv[0], "r");
    } else {
        yyin = stdin;
    }

    yylex();
}
