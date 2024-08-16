%{
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string.h>
using namespace std;

// Fonksiyon deklarasyonları
int yylex();
const char* YY_(const char* Msgid) { return Msgid; }
void yyerror(const char* s) {
    fprintf(stderr, "%s\n", s);
}

%}


%union
{
    int  num;
    char c;
    char *str;
}

%token NUMBER OPENANGLEBRACKET CLOSEANGLEBRACKET INCLUDE INT OPENBRACKET
%token CLOSEBRACKET MAIN VOID EXCLAMATION EQUAL MINUS PLUS WHILE IF IFEND PRINTF ELSEIF ELSE RETURN
%token<str> LIBRARY VAR STRING ANDOR CPP
%token<c> CHAR
%type <str> args logic logics var type

%%
    statements:
        statement
        |
        statement statements

    statement:
        CPP {
            string str = $1;
            free($1);
            cout << str.substr(1, str.length() - 2) << endl;
        }
        |
        OPENANGLEBRACKET LIBRARY CLOSEANGLEBRACKET INCLUDE {
            cout << "#include <";
            string library = string($2);
            free($2);
            if (library == "standart.kütüphane")
                cout << "stdio.h";
            else
                cout << library.substr(0, library.find(".")) << ".h";
            cout << ">" << endl;
        }
        |
        declaration
        |
        assignment
        |
        main
        |
        while
        |
        if
        |
        elseif
        |
        else
        |
        printf
        |
        return
        |
        CHAR {
            cout << $1 << endl;
        }

    printf:
        OPENBRACKET STRING CLOSEBRACKET PRINTF {
            cout << "printf(" << $2 << ")";
            free($2);
        }

    if:
        IF OPENBRACKET logics CLOSEBRACKET IFEND {
            cout << "if (" << $3 << ")" << endl;
            free($3);
        }

    elseif:
        ELSEIF OPENBRACKET logics CLOSEBRACKET IFEND {
            cout << "else if (" << $3 << ")" << endl;
            free($3);
        }

    else:
        ELSE {
            cout << "else" << endl;
        }

    return:
        OPENBRACKET var CLOSEBRACKET RETURN {
            cout << "return (" << $2 << ")";
            free($2);
        }

    while:
        OPENBRACKET logics CLOSEBRACKET WHILE {
            cout << "while (" << $2 << ")" << endl;
            free($2);
        }

    logics:
        logic {
            $$ = $1;
        }
        |
        logic ANDOR logics {
            $$ = strdup((string($1) + " " + $2 + " " + $3).c_str());
            free($1);
            free($2);
            free($3);
        }

    logic:
        var CLOSEANGLEBRACKET EQUAL var {
            $$ = strdup((string($1) + " >= " + $4).c_str());
            free($1);
            free($4);
        }
        |
        var EXCLAMATION EQUAL var {
            $$ = strdup((string($1) + " != " + $4).c_str());
            free($1);
            free($4);
        }
        |
        var OPENANGLEBRACKET EQUAL var {
            $$ = strdup((string($1) + " <= " + $4).c_str());
            free($1);
            free($4);
        }
        |
        var EQUAL EQUAL var {
            $$ = strdup((string($1) + " == " + $4).c_str());
            free($1);
            free($4);
        }
        |
        OPENBRACKET logic CLOSEBRACKET {
            $$ = strdup(('(' + string($2) + ')').c_str());
            free($2);
        }

    var:
        VAR {
            $$ = $1;
        }
        |
        OPENBRACKET var CLOSEBRACKET {
            $$ = strdup(('(' + string($2) + ')').c_str());
            free($2);
        }
        |
        OPENBRACKET type CLOSEBRACKET var {
            $$ = strdup(('(' + string($2) + ')' + $4).c_str());
            free($2);
        }

    type:
        INT {
            $$ = strdup("int");
        }

    main:
        type OPENBRACKET args CLOSEBRACKET MAIN {
            cout << $1 << " main (" << $3 << ")" << endl;
            free($1);
        }

    declaration:
        type var {
            cout << $1 << " " << $2;
            free($2);
            free($1);
        }
        |
        type var EQUAL var{
            cout << $1 << " " << $2 << " = " << $4;
            free($2);
            free($4);
            free($1);
        }

    assignment:
        var EQUAL var {
            cout << $1 << " = " << $3;
            free($1);
            free($3);
        }
        |
        var EQUAL MINUS var {
            cout << $1 << " = -" << $4;
            free($1);
            free($4);
        }
        |
        var MINUS MINUS {
            cout << $1 << "--";
            free($1);
        }
        |
        MINUS MINUS var {
            cout << "--" << $3;
            free($3);
        }
        |
        var PLUS PLUS {
            cout << $1 << "++";
            free($1);
        }
        |
        PLUS PLUS var {
            cout << "++" << $3;
            free($3);
        }

    args:
        VOID {
            $$ = (char *)"void";
        }
%%

int main() {
    yyparse();
    return 0;
}
