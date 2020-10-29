# ctog
<b>c</b>99 code standart <b>to</b> <b>g</b>raph scheme translator
## About
<b>ctog</b> uses GNU <b>flex</b> and <b>bison</b> to parse c code, then build an XML-AST.
## Usage
On Windows:
1. install flex and bison
2. run make_translator.exe
<b>ctog</b> uses standart input/output, so make sure you redirect it:
```
translator.exe < some_file.c > output.xml
```
# WORK IN PROGRESS...