import sys, collections

styleHeader = """
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title></title>
<style type="text/css">
    body {
    	color: rgb(26, 26, 26);
    	background-color: rgb(255,255,255);
    	font-family: Verdana, Tahoma, sans-serif;
    	font-size: 11px;
        width: 100%;
        overflow-y: auto;
    }



    h1 {
    	font-size: 12pt;
    	font-weight: bold;
    }

    h2 {
    	font-size: 11pt;
    	font-weight: bold;
    }

    h3 {
    	font-size: 10pt;
    	font-weight: bold;
    }

    h4 {
    	font-size: 8pt;
    	font-weight: bold;
    }





    tr {
    	background-color: rgb(224,224,224);
    }

    td {
    	padding: 0.1cm 0.2cm;
    	vertical-align: top;
    }

    /*Begin Joshua Clingo's changes*/

    a {
    	/*color: rgb(0, 0, 255);
    	background-color: rgb(255,255,255);*/
    }

    table {
    	line-height: 10pt;
    }

    /*div {
    	width: 80%;
    }*/

    .list-unstyled {
        list-style-type: none;
    }

    .list-unstyled li {
        padding-top: 10px;
        padding-bottom: 10px;
    }

    .list-header {
        font-size: 12px;
        color: rgb(0, 0, 238);
    }

    .list-header:hover {
        text-decoration: underline;
    }

    .code {
        font-family: Consolas,Menlo,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New,monospace,sans-serif;
        color:black;
        background-color:rgb(250,250,250);
        margin-top: 1em;
        margin-bottom: 1em;
        padding: 10px;
        line-height: 1.5em;
        font-size: 13px;
        overflow: auto;
    }

    .p-l-10 {
        padding-left: 10px;
    }

    .section {
        font-size: 10pt;
        margin-top: 1em;
        margin-bottom: 1em;
        margin-right: 0.5em;
        font-weight: 700;
        display: inline-block;
    }

    .cql-class, .cql-object {
        color: rgb(25, 127, 157);
    }

    .cql-function {
        color: rgb(25, 127, 157);
    }

    .cql-keyword {
        color: rgb(0, 0, 255);
        font-weight: 700;
    }

    .cql-variable, .cql-property {
        color: rgb(128, 0, 0);
    }

    .cql-interface {
        color: rgb(43, 170, 175);
    }

    .cql-literal, .cql-operator {
        color: rgb(64,64,64);
    }

    .cql-reserved {
        color: rgb(0,0,0);
    }

    .cql-string {
        color: rgb(163, 21, 21);
    }

    .cql-comment {
        color: rgb(0, 128, 0);
    }

    .treeview {
      -webkit-user-select: none;
      -moz-user-select: none;
      -ms-user-select: none;
      -o-user-select: none;
      user-select: none;
    }

    .treeview:hover input ~ label:before,
    .treeview.hover input ~ label:before {
      opacity: 1.0;
      -webkit-transition-duration: 0.5s;
      -moz-transition-duration: 0.5s;
      -ms-transition-duration: 0.5s;
      -o-transition-duration: 0.5s;
      transition-duration: 0.5s;
    }

    .treeview ul {
      -webkit-transition-duration: 1s;
      -moz-transition-duration: 1s;
      -ms-transition-duration: 1s;
      -o-transition-duration: 1s;
      transition-duration: 1s;
      list-style: none;
      padding-left: 1em;
    }
    .treeview ul li span {
      -webkit-transition-property: color;
      -moz-transition-property: color;
      -ms-transition-property: color;
      -o-transition-property: color;
      transition-property: color;
      -webkit-transition-duration: 1s;
      -moz-transition-duration: 1s;
      -ms-transition-duration: 1s;
      -o-transition-duration: 1s;
      transition-duration: 1s;
    }

    .treeview input {
      display: none;
    }
    .treeview input:checked ~ ul {
      display: none;
    }
    .treeview input ~ label {
      cursor: pointer;
    }
    .treeview input ~ label:before {
      content: '';
      width: 0;
      height: 0;
      position: absolute;
      margin-left: -1em;
      margin-top: 0.25em;
      border-width: 4px;
      border-style: solid;
      border-top-color: transparent;
      border-right-color: rgb(0, 0, 238);
      border-bottom-color: rgb(0, 0, 238);
      border-left-color: transparent;
      opacity: 0.0;
      -webkit-transition-property: opacity;
      -moz-transition-property: opacity;
      -ms-transition-property: opacity;
      -o-transition-property: opacity;
      transition-property: opacity;
      -webkit-transition-duration: 1s;
      -moz-transition-duration: 1s;
      -ms-transition-duration: 1s;
      -o-transition-duration: 1s;
      transition-duration: 1s;
    }
    .treeview input:checked ~ label:before {
      margin-left: -0.8em;
      border-width: 5px;
      border-top-color: transparent;
      border-right-color: transparent;
      border-bottom-color: transparent;
      border-left-color: rgb(0, 0, 238);
    }


    /*End Joshua Clingo's changes*/

    .h1center {
    	font-size: 12pt;
    	font-weight: bold;
    	text-align: center;
    	width: 80%;
    }

    .header_table{
    	border: 1pt inset rgb(0,0,0);
    }

    .narr_table {
    	width: 100%;
    }

    .narr_tr {
    	background-color: rgb(225,225,225);
    }

    pre {
     overflow: auto; /* Use horizontal scroller if needed; for Firefox 2, not needed in Firefox 3 */
     white-space: pre-wrap; /* css-3 */
     white-space: -moz-pre-wrap !important; /* Mozilla, since 1999 */
     white-space: -pre-wrap; /* Opera 4-6 */
     white-space: -o-pre-wrap; /* Opera 7 */
     word-wrap: break-word; /* Internet Explorer 5.5+ */
     font-family: Verdana, Tahoma, sans-serif;
     font-size: 11px;
     text-align:left;
     margin: 0px 0px 0px 0px;
     padding:0px 0px 0px 0px;
    }
    .narr_th {
    	background-color: rgb(201,201,201);
    }

    .td_label{
    	font-weight: bold;
    	color: white;
    }

    .hll { background-color: #ffffcc }
    .c { color: #408080; font-style: italic } /* Comment */
    .err { border: 1px solid #FF0000 } /* Error */
    .k { color: #008000; font-weight: bold } /* Keyword */
    .o { color: #666666 } /* Operator */
    .cm { color: #408080; font-style: italic } /* Comment.Multiline */
    .cp { color: #BC7A00 } /* Comment.Preproc */
    .c1 { color: #408080; font-style: italic } /* Comment.Single */
    .cs { color: #408080; font-style: italic } /* Comment.Special */
    .gd { color: #A00000 } /* Generic.Deleted */
    .ge { font-style: italic } /* Generic.Emph */
    .gr { color: #FF0000 } /* Generic.Error */
    .gh { color: #000080; font-weight: bold } /* Generic.Heading */
    .gi { color: #00A000 } /* Generic.Inserted */
    .go { color: #888888 } /* Generic.Output */
    .gp { color: #000080; font-weight: bold } /* Generic.Prompt */
    .gs { font-weight: bold } /* Generic.Strong */
    .gu { color: #800080; font-weight: bold } /* Generic.Subheading */
    .gt { color: #0044DD } /* Generic.Traceback */
    .kc { color: #008000; font-weight: bold } /* Keyword.Constant */
    .kd { color: #008000; font-weight: bold } /* Keyword.Declaration */
    .kn { color: #008000; font-weight: bold } /* Keyword.Namespace */
    .kp { color: #008000 } /* Keyword.Pseudo */
    .kr { color: #008000; font-weight: bold } /* Keyword.Reserved */
    .kt { color: #B00040 } /* Keyword.Type */
    .m { color: #666666 } /* Literal.Number */
    .s { color: #BA2121 } /* Literal.String */
    .na { color: #7D9029 } /* Name.Attribute */
    .nb { color: #008000 } /* Name.Builtin */
    .nc { color: #0000FF; font-weight: bold } /* Name.Class */
    .no { color: #880000 } /* Name.Constant */
    .nd { color: #AA22FF } /* Name.Decorator */
    .ni { color: #999999; font-weight: bold } /* Name.Entity */
    .ne { color: #D2413A; font-weight: bold } /* Name.Exception */
    .nf { color: #0000FF } /* Name.Function */
    .nl { color: #A0A000 } /* Name.Label */
    .nn { color: #0000FF; font-weight: bold } /* Name.Namespace */
    .nt { color: #008000; font-weight: bold } /* Name.Tag */
    .nv { color: #19177C } /* Name.Variable */
    .ow { color: #AA22FF; font-weight: bold } /* Operator.Word */
    .w { color: #bbbbbb } /* Text.Whitespace */
    .mf { color: #666666 } /* Literal.Number.Float */
    .mh { color: #666666 } /* Literal.Number.Hex */
    .mi { color: #666666 } /* Literal.Number.Integer */
    .mo { color: #666666 } /* Literal.Number.Oct */
    .sb { color: #BA2121 } /* Literal.String.Backtick */
    .sc { color: #BA2121 } /* Literal.String.Char */
    .sd { color: #BA2121; font-style: italic } /* Literal.String.Doc */
    .s2 { color: #BA2121 } /* Literal.String.Double */
    .se { color: #BB6622; font-weight: bold } /* Literal.String.Escape */
    .sh { color: #BA2121 } /* Literal.String.Heredoc */
    .si { color: #BB6688; font-weight: bold } /* Literal.String.Interpol */
    .sx { color: #008000 } /* Literal.String.Other */
    .sr { color: #BB6688 } /* Literal.String.Regex */
    .s1 { color: #BA2121 } /* Literal.String.Single */
    .ss { color: #19177C } /* Literal.String.Symbol */
    .bp { color: #008000 } /* Name.Builtin.Pseudo */
    .vc { color: #19177C } /* Name.Variable.Class */
    .vg { color: #19177C } /* Name.Variable.Global */
    .vi { color: #19177C } /* Name.Variable.Instance */
    .il { color: #666666 } /* Literal.Number.Integer.Long */

    #nn-text
    {
        text-align: center;
        text-align: center;
        color:lightgrey;
        font-size:40px;
    }
    </style>
  </head>
  <body>
    """

reserved = {
	"Add" : "cql-keyword",
	"such" : "cql-keyword",
	"that" : "cql-keyword",
	"with" : "cql-keyword",
	"without" : "cql-keyword",
	"Coalesce" : "cql-keyword",
	"collapse" : "cql-keyword",
	"define" : "cql-keyword",
	"Round" : "cql-keyword",
	"Sum" : "cql-keyword",
	"Tuple" : "cql-keyword",
	"if" : "cql-keyword",
	"between" : "cql-keyword",
	"in" : "cql-keyword",
	"and" : "cql-keyword",
	"or" : "cql-keyword",
	"of" : "cql-keyword",
	"end" : "cql-keyword",
	"start" : "cql-keyword",
	"occurs" : "cql-keyword",
	"during" : "cql-keyword",
	"from" : "cql-keyword",
	"distinct" : "cql-keyword",
	"then" : "cql-keyword",
	"else" : "cql-keyword",
	"Interval" : "cql-keyword",
	"null" : "cql-keyword",
	"return" : "cql-keyword",
	"by" : "cql-keyword",
	"not" : "cql-keyword",
	"exists" : "cql-keyword",
	"sort" : "cql-keyword",
	"Abs" : "cql-keyword",
	"where" : "cql-keyword",
	"Min" : "cql-keyword",
	"Max" : "cql-keyword",
	"First" : "cql-keyword",
	"union" : "cql-keyword",
	"intersect" : "cql-keyword",
	"overlaps" : "cql-keyword",
	"before" : "cql-keyword"
}

generics = {
	"[" : "cql-generic",
	"]" : "cql-generic",
	"{" : "cql-generic",
	"}" : "cql-generic",
	"(" : "cql-generic",
	")" : "cql-generic",
	"," : "cql-generic",
	"." : "cql-generic",
	":" : "cql-generic"
}

operators = {
	">" : "cql-operator",
	"<" : "cql-operator",
	"=" : "cql-operator",
	"+" : "cql-operator",
	"-" : "cql-operator",
	"*" : "cql-operator",
	"/" : "cql-operator"
}

timeClasses = {
	"duration" : "cql-class",
	"date" : "cql-class",
	"days" : "cql-class",
	"hours" : "cql-class",
	"AgeInYearsAt" : "cql-class",
	"MeasurementPeriod" : "cql-class"
}

interfaceList = []

classDiv = "<div class=\"p-l-10\">\n"
closeDiv = "</div>\n"
closeSpan = "</span>"

def appendInterface(interfaceName):
	switch = True
	for i in range(0, len(interfaceList)):
		if interfaceList[i] == interfaceName:
			switch = False
			break
	if switch:
		interfaceList.append(interfaceName)

def classExists (className, CQLDict):
	className.strip()
	for i in range(0, len(CQLDict)):
		if len(CQLDict[i][0]) == 0:
			continue
		# find a define block
		if CQLDict[i][0][0] == 'd':
			cqlList = []
			# the case of a class string e.g. define "Other Than Breast Feeding":
			if className[0] == "\"":
				cqlList = CQLDict[i][0].split("\"")
				if len(cqlList) > 1:
					# put the quotations back for comparison
					reconstruct = "\"" + cqlList[1] + "\""
					if (len(reconstruct) == len(className) or len(reconstruct) == len(className) -1) and reconstruct[1] == className[1]:
						return i
			else:	
				# regular class case e.g. define InitialPopulation:
				cqlList = CQLDict[i][0].split()
				if len(cqlList) > 1:				
					# append the colon on the end for comparison
					if cqlList[1] == className + ":":
						return i
	return -1

def getCodeBlock(className, CQLDict, lineNumber):
	codeBlock = {}
	codeBlock[lineNumber] = CQLDict[lineNumber]
	lineNumber += 1
	for i in range(lineNumber, len(CQLDict)):
		if len(CQLDict[i][0]) == 1 or CQLDict[i][0][0] == "d":
			break
		else:
			codeBlock[i] = CQLDict[i]
	return codeBlock

def divHeader (className):
	# <div class="treeview hover">
 #  <ul class="list-unstyled">
 #    <input type="checkbox" id="cb-numerator 1b define"checked>
 #      <label for="cb-numerator 1b define" class="list-header">
 	return "<div class=\"treeview hover\">\n\t<ul class=\"list-unstyled\">\n\t\t<input type=\"checkbox\" id=\"cb-" + className + " define\"checked>\n\t\t\
 	<label for=\"cb-" + className + " define\" class=\"list-header\">\n"

def buildSpanWithClass(className):
	return "<span class=\"" + className + "\">"

def buildSpanWithClassAndId(className, iD):
	return "<span class=\"" + className + "\" id=\"" + iD + "\">"

def linkTagWithClassAndHref(className, href):
	return "<a class=\"" + className + "\" href=\"#" + href + "\">"

def interfaceInList(interfaceName):
	for i in range(0, len(interfaceList)):
		if interfaceList[i] == interfaceName:
			return True
	return False

def buildTagFromToken(token, codeDict, defineSwitch, dotSwitch):

	tag = ""
	if token in reserved:
		tag += buildSpanWithClass(reserved[token]) + " " + token + " " + closeSpan
	elif token in timeClasses:
		tag += buildSpanWithClass(timeClasses[token]) + token + " " + closeSpan
	elif dotSwitch and token[0].isupper() or len(token) == 1:
		tag += buildSpanWithClass("cql-object") + token + closeSpan
	elif token[0].isdigit() or dotSwitch:
		tag += buildSpanWithClass("cql-literal") + token + " " + closeSpan
	elif classExists(token, codeDict) >= 0 and not defineSwitch:
		tag += linkTagWithClassAndHref("cql-interface", token) + token + " " + "</a>"
		appendInterface(token)
	elif classExists(token, codeDict) >= 0 and defineSwitch:
		tag += buildSpanWithClassAndId("cql-class", token) + token + closeSpan
	return tag


def buildTags2(codeString, codeDict):
	bracketSwitch = False
	quoteSwitch = False
	dotSwitch = False
	defineSwitch = False
	prev = 0
	curr = 0
	tag = ""
	while curr < len(codeString):
		token = ""
		if codeString[curr] == "/":
			break
		elif codeString[curr].isspace() and not quoteSwitch:		
			token = codeString[prev : curr]
			prev = curr + 1
		elif codeString[curr] in operators and not quoteSwitch:
			prev = curr + 1
			if codeString[curr+1] in operators:
				tag += buildSpanWithClass("operator") + codeString[curr] + codeString[curr+1] + " " + closeSpan
				curr += 2
				prev = curr 
			else:
				tag += buildSpanWithClass("operator") + codeString[curr] + " " + closeSpan
				prev = curr + 2
				curr += 2
			continue
		elif codeString[curr] in generics and not quoteSwitch:
			if codeString[curr] == "[":
				bracketSwitch = True
			elif codeString[curr] == "]":
				bracketSwitch == False
			elif codeString[curr] == ".":
				dotSwitch = True
			token = codeString[prev : curr]
			if len(token) > 0:
				tag += buildTagFromToken(token, codeDict, defineSwitch, dotSwitch)
			if dotSwitch: # no space after dot
				tag += buildSpanWithClass("cql-generic") + codeString[curr] + closeSpan
			else:
				tag += buildSpanWithClass("cql-generic") + codeString[curr] + " " + closeSpan
				if defineSwitch and codeString[curr] == ":":
					tag += "\n</label>\n\t\t\t<ul>\n\t\t\t\t<li>\n\t\t\t\t\t"
			prev = curr + 1
			curr += 1
			continue
		elif codeString[curr] == "\"" and not quoteSwitch:		
			quoteSwitch = True
			prev = curr
			curr += 1
			continue
		elif codeString[curr] == "\"" and quoteSwitch:
			token = codeString[prev : curr+1]
			if classExists(token, codeDict) > 0 and not defineSwitch:
				href = token.strip("\"")
				tag += linkTagWithClassAndHref("cql-interface", href) + token + " " + "</a>"	
				interfaceList.append(token)			
			elif classExists(token, codeDict) > 0 and defineSwitch:
				identifier = token.strip("\"")
				tag += buildSpanWithClassAndId("cql-class", identifier) + token + closeSpan
			else:
				tag += buildSpanWithClass("cql-property") + token + " " + closeSpan if bracketSwitch or dotSwitch else buildSpanWithClass("cql-string") + token + " " + closeSpan
			prev = curr + 1
			curr += 1
			quoteSwitch = False
			continue
		if len(token) > 0 and type(token) != None:
			if token == "define":
				defineSwitch = True
			tag += buildTagFromToken(token, codeDict, defineSwitch, dotSwitch)
			dotSwitch = False
		curr += 1
	if not defineSwitch:
		tag += "\n<br>\n"

	return tag

def htmlConstructor(codeBlock, cleanCode, interface):
	divNum = [0]
	html = ""
	className = ""

	for key in codeBlock:
		lineOfCode = codeBlock[key]	
		# analyze div counts 
		# open div case
		if divNum[-1] < lineOfCode[1]:
			html += classDiv
			divNum.append(lineOfCode[1])
		# close div case
		elif divNum[-1] > lineOfCode[1]:
			for i in range(lineOfCode[1], divNum[-1]):
				html += closeDiv
			divNum.append(lineOfCode[1])
		code = lineOfCode[0].split()

		# get the class name for div header
		if code[0] == 'define':
			# account for string class case
			if code[1][0] == "\"":
				for i in range(1, len(code)):
					if code[i][-2] == "\"":
						className += code[i].strip("\":")
						break
					className += code[i].strip("\"") + " "						
			else:
				className = code[1]

			# add the header that goes on each define block
			html += divHeader(className)

			html += buildTags2(' '.join(code) + " ", cleanCode)			
		else:
			html += buildTags2(' '.join(code) + " ", cleanCode)

	for j in range(divNum[0], divNum[-1]):
		html += closeDiv

	html += "</li>\n</ul>\n</ul>\n</div>"

	if interfaceInList(interface):
		interfaceList.remove(interface)

	if len(interfaceList) > 0:
		lineNumber = classExists(interfaceList[0], cleanCode)
		if lineNumber >= 0:
			codeBlock = getCodeBlock(interfaceList[0], cleanCode, lineNumber)
			sortedCodeBlock = collections.OrderedDict(sorted(codeBlock.items()))
			# got the requested block of code, start building the html
			html += htmlConstructor(sortedCodeBlock, cleanCode, interfaceList[0]) 

	return html

def mainDivHeader(identifier):
	return "<div class=\"treeview hover p-l-10\">\n<ul class=\"list-unstyled\">\n<input type=\"checkbox\" id=\"" + identifier + "\"checked>\n\
			<label for=\"" + identifier + "\" class=\"list-header\">\n<strong>" + identifier +"</strong>\n</label>\n<ul class=\"code\">\n<li>\n<div>\n"

def main():
	try :
		# getting dirty code with whitespace from file
		firstPass = [line for line in open(sys.argv[1])]

	except IOError :
		print "Error: cannot find file...\nTry again using a valid file name"
		sys.exit()

	# dictionary format:
	# { lineNumber: [CQL code on the line (string), divCount (int), breakCount (int)] }
	secondPass = {}
	switch = False
	i = 0
	for line in firstPass:
		# get only relevant CQL code, which is everything after the Patient context switch
		if line.rstrip() == "context Patient":
			switch = True
			continue
		if switch:
			if len(line) == 1:
				continue
			# skip any single-line comments in the code - will need to account for inline comments and block comments later
			elif line[0] == "/":
				continue
			else:
				leadingWhiteSpace = 0
				if line[0] == "\t":
					leadingWhiteSpace = len (line) - len(line.lstrip())
				else:
					leadingWhiteSpace = (len (line) - len(line.lstrip())) / 2
				secondPass[i] = [' '.join(line.strip().split()), leadingWhiteSpace]
				i += 1
	# now let's get to the real work here
	html = ""
	html += styleHeader
	# build the main div header
	html += mainDivHeader(sys.argv[3])
	# validate the class name passed in
	lineNumber = classExists(sys.argv[2], secondPass)
	if lineNumber > 0:
		codeBlock = getCodeBlock(sys.argv[2], secondPass, lineNumber)
		# got the requested block of code, start building the html
		html += htmlConstructor(codeBlock, secondPass, "")
		html += "</li>\n</ul>\n</li>\n</ul>\n</div>\n</body>\n</html>"
		output = open( "output.html", "w" )
		output.write( html )

	else:
		print "Could not find the class specified\nCheck that the class name and file name is correct and try again."

if __name__ == "__main__" :
	main()