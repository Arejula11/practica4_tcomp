%{
#include "y.tab.h"
#include <stdio.h>
%}
%%
"{"	{return(OB);}
"}"	{return(CB);}
"("	{return(OP);}
")"	{return(CP);}
";" {return(PYC);}
"->" {return(FL);}
"," {return(C);}
[0-9]+	{yylval.nombre = strdup(yytext); return(NUMBER);}
[a-z]+  {return(STRING);}
\n	{return(EOL);}
[ \t]	{/* ignorar espacios */}
.


%%

