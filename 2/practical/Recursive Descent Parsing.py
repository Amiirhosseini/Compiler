def find_longest_prefix(rules):
    # Find the longest common prefix among all the rules
    if not rules:
        return ''
    prefix = ''
    shortest_rule = min(rules, key=len)
    for i in range(len(shortest_rule)):
        char = shortest_rule[i]
        if all(rule[i] == char for rule in rules):
            prefix += char
        else:
            break
    return prefix

# input grammar
input_grammar = {}

# fill the input grammar as follows:
# # S → iEtS / iEtSeS / a
# input_grammar['S'] = ['iEtS', 'iEtSeS', 'a']
# # E → b
# input_grammar['E'] = ['b']

#A → aAB / aBc / aAc
input_grammar['A'] = ['aA']
input_grammar["A'"] = ['AB', 'Bc', 'Ac']

# perform the left factoring algorithm on the input grammar
for key in list(input_grammar):
    # find the longest common prefix from the alternatives
    longest_prefix = find_longest_prefix(input_grammar[key])
    # check if the prefix exists in another rule
    exists_in_other_rule = False
    for other_key in input_grammar.keys():
        if key == other_key:
            continue
        for other_rule in input_grammar[other_key]:
            if other_rule.startswith(longest_prefix):
                exists_in_other_rule = True
                break
        if exists_in_other_rule:
            break
    # shorten the prefix and try again until no conflicts exist
    while exists_in_other_rule and len(longest_prefix) > 1:
        longest_prefix = longest_prefix[:-1]
        exists_in_other_rule = False
        for other_key in input_grammar.keys():
            if key == other_key:
                continue
            for other_rule in input_grammar[other_key]:
                if other_rule.startswith(longest_prefix):
                    exists_in_other_rule = True
                    break
            if exists_in_other_rule:
                break

    # if there is a common prefix
    if len(longest_prefix) > 0:
        # create a new non-terminal symbol as ' of key
        new_key = key + "'"
        # add the new non-terminal symbol to the input grammar above the current key
        input_grammar[new_key] = []
        # for all rules
        for rule in input_grammar[key]:
            # if the rule has the longest prefix
            if rule[:len(longest_prefix)] == longest_prefix:
                # keep the rest of the rule and add only the longest prefix with the new non-terminal symbol
                input_grammar[new_key].append(rule[len(longest_prefix):])
            else:
                # otherwise, keep the rule as is
                input_grammar[key] = [r for r in input_grammar[key] if r != rule]
                input_grammar[key].append(rule)
        
        # update S rule after factoring
        input_grammar[key] = [s for s in input_grammar[key] if longest_prefix not in s]
        input_grammar[key].append(longest_prefix + new_key)
       
# show the result of the left factoring algorithm
print('The result of the left factoring algorithm:')
print(input_grammar)
