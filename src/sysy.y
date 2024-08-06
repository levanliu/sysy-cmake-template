%code requires{
    #include <memory>
    #include <string>
}

%{
#include <iostream>
#include <memory>
#include <string>

int yylex();
void yyerror(std::unique_ptr<std::string> &ast,const char *s);

using namespace std;

%}

%parse-param {std::unique_ptr<std::string> &ast}

%union{
    std::string *str_val;
    int int_val;
}

%token INT RETURN
%token <str_val> IDENT
%token <int_val> INT_CONST

%type <str_val> FunDef FuncType Block Stmt Number

%%

CompUnit : FuncDef {
    ast = unique_ptr<string>($1);
};

FuncDef
    : FuncType IDENT '(' ')' Block {
        auto type = unique_ptr<string>($1);
        auto ident = unique_ptr<string>($2);
        auto block = unique_ptr<string>($5);
        $$ = new string(*type + " " + *ident + "()" + *block);
    };
    
FuncType
    : INT {
        $$ = new string("int");
    }

Stmt
    : RETURN Number ';' {
        auto number = unique_ptr<string>($2);
        $$  = new string ("return " + *number + ";");
    }