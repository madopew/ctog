#presettings----------------------------------------

ifeq ($(OS), Windows_NT)
	PROGRAM := ctox.exe
	CLEAN_CMD := del
else
	PROGRAM := ctox
	CLEAN_CMD := rm -f
endif

PARSER_NAME := c_parser
PARSER_EXT := tab
LEXER_NAME := c_lexer
LEXER_EXT := lex

PARSER := $(PARSER_NAME).$(PARSER_EXT)
LEXER := $(LEXER_NAME).$(LEXER_EXT)
OUTPUT := ctox.output.xml

#presettings----------------------------------------

$(PROGRAM): $(LEXER).c $(PARSER).c $(PARSER).h
	gcc -o $(PROGRAM) -O3 $(LEXER).c $(PARSER).c

$(LEXER).c: $(LEXER_NAME).l $(PARSER).h
	flex -o$(LEXER).c $(LEXER_NAME).l

$(PARSER).c $(PARSER).h: $(PARSER_NAME).y
	bison -d $(PARSER_NAME).y


.PHONY: clean
clean: 
	$(CLEAN_CMD) $(PROGRAM) $(PROGRAM).exe $(LEXER).c $(PARSER).c $(PARSER).h $(OUTPUT)
