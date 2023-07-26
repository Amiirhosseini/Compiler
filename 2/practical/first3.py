# Amirreza Hosseini 9820363
# Assignment 2 - Compiler Design Course
# Q2
# LL(1) parser

from anytree import Node, RenderTree
from anytree.dotexport import RenderTreeGraph

def extract_rules(input_grammar):
	global rules
	#make rules from input dictionary grammer
	for key in input_grammar.keys():
		temp=key+' -> '
		for rule in input_grammar[key]:
			if rule=='':
				rule='\u03B5'
			temp+=rule+' | '
		#remove last pipe
		temp=temp[:-3]
		rules.append(temp)
			

def find_next_leaf_non_terminal(node):

    # Check if any child is a non-terminal leaf
    for child in reversed(node.siblings+node.children):
        if child.name not in term_userdef and child.name != '\u03B5' and len(child.children) == 0:
            return child

    # If no child is a non-terminal leaf, move up the tree and try again
    if node.parent is not None:
        return find_next_leaf_non_terminal(node.parent)

    # If we've reached the root node and still haven't found a non-terminal leaf,
    # return None
    return None

def first(rule):
	global rules, nonterm_userdef, \
		term_userdef, diction, firsts
	# recursion base condition
	# (for terminal or epsilon)
	if len(rule) != 0 and (rule is not None):
		if rule[0] in term_userdef:
			return rule[0]
		elif rule[0] == '\u03B5':
			return '\u03B5'

	# condition for Non-Terminals
	if len(rule) != 0:
		if rule[0] in list(diction.keys()):
			# fres temporary list of result
			fres = []
			rhs_rules = diction[rule[0]]
			# call first on each rule of RHS
			# fetched (& take union)
			for itr in rhs_rules:
				indivRes = first(itr)
				if type(indivRes) is list:
					for i in indivRes:
						fres.append(i)
				else:
					fres.append(indivRes)

			# if no epsilon in result
			# - received return fres
			if '\u03B5' not in fres:
				return fres
			else:
				# apply epsilon
				# rule => f(ABC)=f(A)-{e} U f(BC)
				newList = []
				fres.remove('\u03B5')
				if len(rule) > 1:
					ansNew = first(rule[1:])
					if ansNew != None:
						if type(ansNew) is list:
							newList = fres + ansNew
						else:
							newList = fres + [ansNew]
					else:
						newList = fres
					return newList
				# if result is not already returned
				# - control reaches here
				# lastly if eplison still persists
				# - keep it in result of first
				fres.append('\u03B5')
				return fres


def follow(nt):
	global start_symbol, rules, nonterm_userdef, \
		term_userdef, diction, firsts, follows
	# for start symbol return $ (recursion base case)

	solset = set()
	if nt == start_symbol:
		# return '$'
		solset.add('$')

	# For input, check in all rules
	for curNT in diction:
		rhs = diction[curNT]
		# go for all productions of NT
		for subrule in rhs:
			if nt in subrule:
				# call for all occurrences on
				# - non-terminal in subrule
				while nt in subrule:
					index_nt = subrule.index(nt)
					subrule = subrule[index_nt + 1:]
					# empty condition - call follow on LHS
					if len(subrule) != 0:
						
						res = first(subrule)
						if '\u03B5' in res:
							newList = []
							res.remove('\u03B5')
							ansNew = follow(curNT)
							if ansNew != None:
								if type(ansNew) is list:
									newList = res + ansNew
								else:
									newList = res + [ansNew]
							else:
								newList = res
							res = newList
					else:
						
						if nt != curNT:
							res = follow(curNT)

					# add follow result in set form
					if res is not None:
						if type(res) is list:
							for g in res:
								solset.add(g)
						else:
							solset.add(res)
	return list(solset)


def computeAllFirsts():
	global rules, nonterm_userdef, \
		term_userdef, diction, firsts
	for rule in rules:
		k = rule.split("->")
		# remove un-necessary spaces
		k[0] = k[0].strip()
		k[1] = k[1].strip()
		rhs = k[1]
		multirhs = rhs.split('|')
		# remove un-necessary spaces
		for i in range(len(multirhs)):
			multirhs[i] = multirhs[i].strip()
			multirhs[i] = multirhs[i].split()
		diction[k[0]] = multirhs

	# calculate first for each rule
	# - (call first() on all RHS)
	for y in list(diction.keys()):
		t = set()
		for sub in diction.get(y):
			res = first(sub)
			if res != None:
				if type(res) is list:
					for u in res:
						t.add(u)
				else:
					t.add(res)

		# save result in 'firsts' list
		firsts[y] = t

	print("\nFirst Sets: ")
	key_list = list(firsts.keys())
	index = 0
	for gg in firsts:
		print(f"First({key_list[index]}) "
			f"=> {firsts.get(gg)}")
		index += 1


def computeAllFollows():
	global start_symbol, rules, nonterm_userdef,\
		term_userdef, diction, firsts, follows
	for NT in diction:
		solset = set()
		sol = follow(NT)
		if sol is not None:
			for g in sol:
				solset.add(g)
		follows[NT] = solset

	print("\nFollow Sets: ")
	key_list = list(follows.keys())
	index = 0
	for gg in follows:
		print(f"Follow({key_list[index]})"
			f" => {follows[gg]}")
		index += 1


# create parse table
def createParseTable():
	import copy
	global diction, firsts, follows, term_userdef

	ntlist = list(diction.keys())
	terminals = copy.deepcopy(term_userdef)
	terminals.append('$')

	# create the initial empty state of ,matrix
	mat = []
	for x in diction:
		row = []
		for y in terminals:
			row.append('')
		# of $ append one more col
		mat.append(row)

	# Classifying grammar as LL(1) or not LL(1)
	grammar_is_LL = True

	# rules implementation
	for lhs in diction:
		rhs = diction[lhs]
		for y in rhs:
			res = first(y)
			# epsilon is present,
			# - take union with follow
			if '\u03B5' in res:
				if type(res) == str:
					firstFollow = []
					fol_op = follows[lhs]
					if fol_op is str:
						firstFollow.append(fol_op)
					else:
						for u in fol_op:
							firstFollow.append(u)
					res = firstFollow
				else:
					res.remove('\u03B5')
					res = list(res) +\
						list(follows[lhs])
			# add rules to table
			ttemp = []
			if type(res) is str:
				ttemp.append(res)
				res = copy.deepcopy(ttemp)
			for c in res:
				xnt = ntlist.index(lhs)
				yt = terminals.index(c)
				if mat[xnt][yt] == '':
					mat[xnt][yt] = mat[xnt][yt] \
								+ f"{lhs}->{' '.join(y)}"
				else:
					# if rule already present
					if f"{lhs}->{y}" in mat[xnt][yt]:
						continue
					else:
						grammar_is_LL = False
						mat[xnt][yt] = mat[xnt][yt] \
									+ f",{lhs}->{' '.join(y)}"

	# final state of parse table
	print("\n\nLL(1) table:\n")
	frmt = "{:>12}" * len(terminals)
	print(frmt.format(*terminals))

	j = 0
	for y in mat:
		frmt1 = "{:>12}" * len(y)
		print(f"{ntlist[j]} {frmt1.format(*y)}")
		j += 1

	return (mat, grammar_is_LL, terminals)

def validateStringUsingStackBuffer(parsing_table, grammarll1,table_term_list, input_string,term_userdef, start_symbol, parsetree):

	print(f"\nValidate String => {input_string}\n")

	# for more than one entries
	# - in one cell of parsing table
	if grammarll1 == False:
		return f"\nInput String = " \
			f"\"{input_string}\"\n" \
			f"Grammar is not LL(1)"

	# implementing stack buffer

	stack = [start_symbol, '$']
	buffer = []

	# reverse input string store in buffer
	input_string = input_string.split()
	input_string.reverse()
	buffer = ['$'] + input_string

	print("{:>20} {:>20} {:>20}".
		format("Buffer", "Stack", "Action"))

	E = Node(start_symbol)
	Nodes = [E]
	i = 0
	while True:

		# end loop if all symbols matched
		if stack == ['$'] and buffer == ['$']:
			print("{:>20} {:>20} {:>20}"
				.format(' '.join(buffer),
						' '.join(stack),
						"Valid"))
			return "\nValid String!", E
		elif stack[0] not in term_userdef:
			flag=0
			# take font of buffer (y) and tos (x)
			x = list(diction.keys()).index(stack[0])
			y = table_term_list.index(buffer[-1])
			if parsing_table[x][y] != '':
				# format table entry received
				entry = parsing_table[x][y]
				print("{:>20} {:>20} {:>25}".
					format(' '.join(buffer),
							' '.join(stack),
							f"T[{stack[0]}][{buffer[-1]}] = {entry}"))
				lhs_rhs = entry.split("->")
				non_term=lhs_rhs[0]
				if lhs_rhs[1] == '\u03B5':
					flag=1
				lhs_rhs[1] = lhs_rhs[1].replace('\u03B5', '').strip()
				entryrhs = lhs_rhs[1].split()
				stack = entryrhs + stack[1:]
				top = entryrhs
				count = len(top)
				if flag==1:
					parsetree = Node("\u03B5", parent=Nodes[i])
					#Nodes.append(parsetree)
					next_=find_next_leaf_non_terminal(Nodes[i])
					Nodes.append(next_)
					i += 1
				# for i in every element of top
                # pop it and add it to parsetree from end
				for j in range(len(top)):
					parsetree = Node(top.pop(), parent=Nodes[i])
					Nodes.append(parsetree)
				i += count
				
			else:
				return f"\nInvalid String! No rule at " \
					f"Table[{stack[0]}][{buffer[-1]}]."
		else:
			entry = parsing_table[x][y]
			lhs_rhs = entry.split("->")
			non_term=lhs_rhs[0]
			# stack top is Terminal
			if stack[0] == buffer[-1]:
				print("{:>20} {:>20} {:>20}"
					.format(' '.join(buffer),
							' '.join(stack),
							f"Matched:{stack[0]}"))
				buffer = buffer[:-1]
				stack = stack[1:]

				next_=find_next_leaf_non_terminal(Nodes[i])
				Nodes.append(next_)
				i += 1
                    
			else:
				return "\nInvalid String! " \
					"Unmatched terminal symbols"


sample_input_string = None

#main Program

#The non-terminal symbols will consist of uppercase alphabets (A-Z) with prime (`) symbol
nonterm_userdef = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K' ,'L', 'M', 'N', 'O', 'P', 'Q',
                   'R', 'S', 'T', 'U' ,'V', 'W', 'X', 'Y', 'Z' ,'A`', 'B`', 'C`', 'D`', 'E`', 'F`', 'G`',
                   'H`', 'I`', 'J`', 'K`', 'L`', 'M`', 'N`', 'O`', 'P`', 'Q`', 'R`', 'S`', 'T`', 'U`', 'V`', 'W`', 'X`', 'Y`', 'Z`']

rules=["E -> T E'",
       "E' -> + T E' | \u03B5",
       "T -> F T'",
       "T' -> * F T' | \u03B5",
       "F -> ( E ) | id"]

#input_grammer={"E": ["TE'"], "T": ["FT'"], "F": ["(E)", "id"], "E'": ["+TE'", ""], "T'": ["*FT'", ""]}

# input_grammer={
# 'E': [' T E` '],
# 'E`': [' + T E` ', ' \u03B5 '],
# 'T': [' F T` '],
# 'T`': ['* F T` ', ' \u03B5 '],
# 'F': [' ( E ) ', ' id ']
# }

term_userdef=['id','+','*','(',')','\u03B5']
sample_input_string="id + id * id"

#rules= []
diction = {}
firsts = {}
follows = {}

#extract_rules(input_grammer)

computeAllFirsts()

start_symbol = list(diction.keys())[0]

computeAllFollows()

(parsing_table, result, tabTerm) = createParseTable()
parsetree=Node(start_symbol)
# validate string input using stack-buffer concept
if sample_input_string != None:
	validity,parsetree = validateStringUsingStackBuffer(parsing_table, result,tabTerm, sample_input_string,
											term_userdef,start_symbol,parsetree)


for pre, fill, node in RenderTree(parsetree):
	print("%s%s" % (pre, node.name))
 
from anytree.exporter import UniqueDotExporter
#save tree like format dont want loop in graph
UniqueDotExporter(parsetree, nodeattrfunc=lambda node: 'label="{}"'.format(node.name)).to_picture("parsetree.png")

