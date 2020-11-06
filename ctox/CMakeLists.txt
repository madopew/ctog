cmake_minimum_required(VERSION 3.17)
project(ctox C)

set(CMAKE_C_STANDARD 11)

include_directories(.)

add_executable(ctox
        c_parser.tab.c
        c_parser.tab.h
        lex.yy.c)
