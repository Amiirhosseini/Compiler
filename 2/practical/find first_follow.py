class NonTerminal:
    def __init__(self, name):
        self.name = name
        self.rules = []

    def addRule(self, rule, current_rule=None):
        if current_rule is None:
            self.rules.append(rule)
        else:
            index = self.rules.index(current_rule) + 1
            self.rules.insert(index, rule)

    def setRules(self, rules):
        self.rules = rules

    def getName(self):
        return self.name

    def getRules(self):
        return self.rules


class Grammar:
    def __init__(self):
        self.nonTerminals = []
        self.first_sets = {}
        self.follow_sets = {}


    def addRule(self, rule):
        nt = None
        parse = ""

        for i in range(len(rule)):
            c = rule[i]
            if c == ' ':
                if not nt:
                    nt = NonTerminal(parse)
                    self.nonTerminals.append(nt)
                    parse = ""
                elif parse != "":
                    nt.addRule(parse)
                    parse = ""
            elif c != '|' and c != '-' and c != '>':
                parse += c
        if parse != "":
            nt.addRule(parse)

    def inputData(self, input_grammar):
        for key in input_grammar.keys():
            temp = str(key) + " -> " + str(input_grammar[key])
            # remove all of the brackets from the string
            temp = temp.replace("[", "")
            temp = temp.replace("]", "")
            # remove all of the quotation marks from the string
            temp = temp.replace("'", "")
            # convert all of the commas to pipes
            temp = temp.replace(",", " |")
            self.addRule(temp)

    def solveNonImmediateLR(self, A, B):
        nameA = A.getName()
        nameB = B.getName()

        rulesA = []
        rulesB = []
        newRulesA = []
        rulesA = A.getRules()
        rulesB = B.getRules()

        for rule in rulesA:
            if rule[0: len(nameB)] == nameB:
                for rule1 in rulesB:
                    newRulesA.append(rule1 + rule[len(nameB):])
            else:
                newRulesA.append(rule)
        A.setRules(newRulesA)

    def solveImmediateLR(self, A):
        name = A.getName()
        newName = name + "'"

        alphas = []
        betas = []
        rules = A.getRules()
        newRulesA = []
        newRulesA1 = []

        rules = A.getRules()

        # Checks if there is left recursion or not
        for rule in rules:
            if rule[0: len(name)] == name:
                alphas.append(rule[len(name):])
            else:
                betas.append(rule)

        # If no left recursion, exit
        if len(alphas) == 0:
            return

        if len(betas) == 0:
            newRulesA.append(newName)

        for beta in betas:
            newRulesA.append(beta + newName)

        for alpha in alphas:
            newRulesA1.append(alpha + newName)

        # Amends the original rule

        A.setRules(newRulesA)
        newRulesA1.append("\u03B5")

        # Adds new production rule
        newNonTerminal = NonTerminal(newName)
        newNonTerminal.setRules(newRulesA1)
        self.nonTerminals.append(newNonTerminal)

    def applyAlgorithm(self):
        size = len(self.nonTerminals)
        for i in range(size):
            for j in range(i):
                self.solveNonImmediateLR(self.nonTerminals[i], self.nonTerminals[j])
            self.solveImmediateLR(self.nonTerminals[i])
            self.eliminateLeftFactor(self.nonTerminals[i])

    def printRules(self):
        for nonTerminal in self.nonTerminals:
            nonTerminal.printRule()

    def eliminateLeftFactor(self, A):
        rules = A.getRules()
        newRules = []

        i = 0
        while i < len(rules):
            alpha = rules[i]
            commonPrefix = ""
            j = i + 1

            while j < len(rules):
                beta = rules[j]
                k = 0

                while k < min(len(alpha), len(beta)):
                    if alpha[k] != beta[k]:
                        break
                    k += 1

                if k > 0:
                    commonPrefix = alpha[:k]
                    break

                j += 1

            if len(commonPrefix) > 0:
                A1Name = A.getName() + "'"
                A1 = NonTerminal(A1Name)
                newRules.append(commonPrefix + A1Name)

                alphaPrime = alpha[len(commonPrefix):]
                if len(alphaPrime) == 0:
                    alphaPrime = "\u03B5"

                A1.addRule(alphaPrime)

                for b in range(i, j):
                    betaPrime = rules[b][len(commonPrefix):]
                    if len(betaPrime) == 0:
                        betaPrime = "\u03B5"

                    A1.addRule(betaPrime)

                self.nonTerminals.append(A1)
                i = j
            else:
                newRules.append(alpha)
                i += 1

        A.setRules(newRules)
        
    def to_dict(grammar):
        result = {}
        for nonTerminal in grammar.nonTerminals:
            name = nonTerminal.getName()
            rules = nonTerminal.getRules()
            #if rules contains epsilon, remove it and put empty string
            if '\u03B5' in rules:
                rules.remove('\u03B5')
                rules.append('')
            result[name] = rules
        # #sort keys alphabetically
        # result = dict(sorted(result.items()))
        return result
    
    def printFirstSets(self):
        for nt in self.nonTerminals:
            name = nt.getName()
            first_set = self.findFirst(name)
            print(f"FIRST({name}) = {first_set}")

    def findFirst(self, symbol):
        first_set = set()
        if symbol in self.terminals:
            first_set.add(symbol)
            return first_set
        else:
            for rule in self.grammar[symbol]:
                if rule == '':
                    first_set.add('')
                else:
                    first_set = first_set.union(self.findFirst(rule[0]))
        return first_set
    
    def terminals(self):
        terminals = set()
        for nt in self.nonTerminals:
            for rule in nt.getRules():
                for char in rule:
                    if char not in self.nonTerminals:
                        terminals.add(char)
        return terminals

input_grammar = {}
grammar = Grammar()

# test case 1
# input_grammar['E'] = ['E+T', 'T']
# input_grammar['T'] = ['T*F', 'F']
# input_grammar['F'] = ['(E)', 'id']

# test case 2
# E --> TE'
# E' --> +TE' | ε                
# T --> FT'
# T' --> *FT' | ε
# F --> id | (E)
input_grammar['E'] = ['TE']
input_grammar['E\''] = ['+TE\'', '\u03B5']
input_grammar['T'] = ['FT\'']
input_grammar['T\''] = ['*FT\'', '\u03B5']
input_grammar['F'] = ['id', '(E)']


grammar.inputData(input_grammar)

grammar.applyAlgorithm()

grammar.printFirstSets()

#result=grammar.to_dict()
# print(result)