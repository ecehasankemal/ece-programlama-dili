%{
#include "y.tab.h"

// Fonksiyon deklarasyonu
int yyerror(char *s);
%}

%%
[ \t\n]                                 /* Ignore whitespace */
"%"(.|\n)*"%"                           { yylval.str = strdup(yytext); return CPP; }
"<"                                     { return OPENANGLEBRACKET; }
">"                                     { return CLOSEANGLEBRACKET; }
"("                                     { return OPENBRACKET; }
")"                                     { return CLOSEBRACKET; }
"&&"|"||"                               { yylval.str = strdup(yytext); return ANDOR; }
"="                                     { return EQUAL; }
"!"                                     { return EXCLAMATION; }
"-"                                     { return MINUS; }
"+"                                     { return PLUS; }
#ekle                                   { return INCLUDE; }
\"[^\"]*\"                              { yylval.str = strdup(yytext); return STRING; }
"yazdır"                                { return PRINTF; }
"eğer"                                  { return IF; }
"eğer değilse ve"                       { return ELSEIF; }
"değilse"                               { return ELSE; }
"ise"                                   { return IFEND; }
"işlemini döndür"                       { return RETURN; }
"iken"                                  { return WHILE; }
"tanımsız"                              { return VOID; }
"ana işlemi başlat"                     { return MAIN; }
"tam sayı türünde"                      { return INT; }
[a-z]+\.kütüphane                       { yylval.str = strdup(yytext); return LIBRARY; }
[a-zA-ZığĞüÜşŞİöÖçÇ0-9]+                { yylval.str = strdup(yytext); return VAR; }
.                                       { yylval.c = *yytext; return CHAR;}
%%

int yywrap() {
    return 1;
}
