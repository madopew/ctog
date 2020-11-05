# ctog
<b>c</b>11 code standart <b>to</b> <b>g</b>raph scheme translator
## About
<b>ctog</b> is a project that consists of two sub-projects:
1. <b>ctox</b>
2. <b>xtog</b>

<b>ctox</b> uses GNU <b>flex</b> and <b>bison</b> to parse c code, then builds an XML-AST;
<br/>
<br/>
After building the tree <b>xtog</b> - Java-program, parses the tree and generates 
graph scheme in a .svg format.
## Usage
On Windows:

- install flex and bison; 
- run make_translator.exe; <br/>
<b>ctog</b> uses standart input/output, so make sure you redirect it:
```
$ ctox.exe < some_file.c > output.xml
```
- run xtog.jar...
# WORK IN PROGRESS...