%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE* yyin;
extern int yylex();
extern int yyerror(const char *msg);

typedef union {
    int num;
    char* str;
} SymValue;

SymValue sym[26];

%}

%union {
    int num;
    char* str;
}

%token <num> NUM
%token <str> IDENTIFIER STRING_LITERAL TAPU_INT TAPU_STRING
%token EQ SEMICOLON COMMA PRINT OPEN_PAREN CLOSE_PAREN OPEN_BRACE CLOSE_BRACE PLUS MINUS TIMES DIVIDE GOKULDHAM BAPUJI_SAHMAT BAPUJI_ASAHMAT
%token EQUAL NE LT LE GT GE

%type <num> if_else_statement condition expression

%%

program: block
       ;

block: GOKULDHAM OPEN_BRACE statement_list CLOSE_BRACE
       ;

statement_list: statement
              | statement_list statement
              ;

statement: declaration
         | print_statement
         | if_else_statement
         ;

declaration: TAPU_INT IDENTIFIER EQ NUM SEMICOLON { sym[((char*)$2)[0] - 'a'].num = $4; }
           | TAPU_STRING IDENTIFIER EQ STRING_LITERAL SEMICOLON { sym[((char*)$2)[0] - 'a'].str = strdup($4); }
           | TAPU_INT IDENTIFIER EQ IDENTIFIER PLUS IDENTIFIER SEMICOLON { sym[((char*)$2)[0] - 'a'].num = sym[((char*)$4)[0] - 'a'].num + sym[((char*)$6)[0] - 'a'].num; }
           | TAPU_INT IDENTIFIER EQ IDENTIFIER MINUS IDENTIFIER SEMICOLON { sym[((char*)$2)[0] - 'a'].num = sym[((char*)$4)[0] - 'a'].num - sym[((char*)$6)[0] - 'a'].num; }
           | TAPU_INT IDENTIFIER EQ IDENTIFIER TIMES IDENTIFIER SEMICOLON { sym[((char*)$2)[0] - 'a'].num = sym[((char*)$4)[0] - 'a'].num * sym[((char*)$6)[0] - 'a'].num; }
           | TAPU_INT IDENTIFIER EQ IDENTIFIER DIVIDE IDENTIFIER SEMICOLON { 
                 if ($6 != 0) sym[((char*)$2)[0] - 'a'].num = sym[((char*)$4)[0] - 'a'].num / sym[((char*)$6)[0] - 'a'].num; 
                 else { 
                     yyerror("Division by zero\n"); 
                     exit(1); 
                 } 
             }
           ;

print_statement: PRINT OPEN_PAREN TAPU_INT COMMA IDENTIFIER CLOSE_PAREN SEMICOLON {
                 if (sym[((char*)$5)[0] - 'a'].num)
                     printf("the value of %s is %d\n",$5,sym[((char*)$5)[0] - 'a'].num);
                 else
                     printf("NULL\n");
               }
               | PRINT OPEN_PAREN TAPU_STRING COMMA IDENTIFIER CLOSE_PAREN SEMICOLON {
                 if (sym[((char*)$5)[0] - 'a'].str)
                     printf("the value of %s is %s\n",$5,sym[((char*)$5)[0] - 'a'].str);
                 else
                     printf("NULL\n");
               }
               | PRINT OPEN_PAREN TAPU_INT COMMA IDENTIFIER PLUS IDENTIFIER CLOSE_PAREN SEMICOLON {
                 printf("sum is %d\n", sym[((char*)$5)[0] - 'a'].num + sym[((char*)$7)[0] - 'a'].num);
               }
               | PRINT OPEN_PAREN TAPU_INT COMMA IDENTIFIER MINUS IDENTIFIER CLOSE_PAREN SEMICOLON {
                 printf("subtraction is %d\n", sym[((char*)$5)[0] - 'a'].num - sym[((char*)$7)[0] - 'a'].num);
               }
               | PRINT OPEN_PAREN TAPU_INT COMMA IDENTIFIER TIMES IDENTIFIER CLOSE_PAREN SEMICOLON {
                 printf("multiplication is %d\n", sym[((char*)$5)[0] - 'a'].num * sym[((char*)$7)[0] - 'a'].num);
               }
               | PRINT OPEN_PAREN TAPU_INT COMMA IDENTIFIER DIVIDE IDENTIFIER CLOSE_PAREN SEMICOLON {
                 if (sym[((char*)$7)[0] - 'a'].num != 0)
                     printf("devision is  %d\n", sym[((char*)$5)[0] - 'a'].num / sym[((char*)$7)[0] - 'a'].num);
                 else
                     printf("Division by zero\n");
               }
               ;

if_else_statement: BAPUJI_SAHMAT OPEN_PAREN condition CLOSE_PAREN OPEN_BRACE statement_list CLOSE_BRACE BAPUJI_ASAHMAT OPEN_BRACE statement_list CLOSE_BRACE {
                    if ($3) {
                       // $6;
                    } else {
                       // $10;
                    }
                }
                ;

condition: expression EQUAL expression { $$ = ($1 == $3); }
          | expression NE expression { $$ = ($1 != $3); }
          | expression LT expression { $$ = ($1 < $3); }
          | expression LE expression { $$ = ($1 <= $3); }
          | expression GT expression { $$ = ($1 > $3); }
          | expression GE expression { $$ = ($1 >= $3); }
          ;


expression: IDENTIFIER { $$ = sym[((char*)$1)[0] - 'a'].num; }
          | NUM { $$ = $1; }
          ;

%%

int yyerror(const char *msg) {
    fprintf(stderr, "Error: %s\n", msg);
    return 0;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Error opening file");
        return 1;
    }

    yyparse();

    fclose(yyin);

    return 0;
}
