from collections import defaultdict

# Compute the first set of a symbol in the grammar
def compute_first_set(symbol, grammar, first_sets):
    # If the first set has already been computed, return it
    if symbol in first_sets:
        return first_sets[symbol]

    first_set = set()
    productions = grammar[symbol]
    for production in productions:
        for i, sym in enumerate(production):
            # Add the first set of the current symbol to the first set of the original symbol
            curr_set = compute_first_set(sym, grammar, first_sets)
            first_set |= curr_set
            # If epsilon is not in the first set of the current symbol, stop looking
            if 'epsilon' not in curr_set:
                break
            # If the end of the production has been reached and epsilon is in the first set of all symbols, add epsilon to the first set of the original symbol
            if i == len(production) - 1 and 'epsilon' in curr_set:
                first_set.add('epsilon')

    # Cache the computed first set for future use
    first_sets[symbol] = first_set
    return first_set

# Compute the follow set of a symbol in the grammar
def compute_follow_set(symbol, grammar, first_sets, follow_sets):
    # If the follow set has already been computed, return it
    if symbol in follow_sets:
        return follow_sets[symbol]

    follow_set = set()
    if symbol == list(grammar.keys())[0]:
        follow_set.add('$')
    for key, productions in grammar.items():
        for production in productions:
            if symbol in production:
                idx = production.index(symbol)
                # If the symbol is the last one in the production, add the follow set of the original symbol to its follow set
                if idx == len(production) - 1:
                    follow_set |= compute_follow_set(key, grammar, first_sets, follow_sets)
                else:
                    # Otherwise, add the first set of the next symbol to its follow set
                    next_sym = production[idx+1]
                    next_first_set = compute_first_set(next_sym, grammar, first_sets)
                    if 'epsilon' in next_first_set:
                        follow_set |= (next_first_set - {'epsilon'}) | compute_follow_set(key, grammar, first_sets, follow_sets)
                    else:
                        follow_set |= next_first_set

    # Cache the computed follow set for future use
    follow_sets[symbol] = follow_set
    return follow_set

# Define the input grammar
input_grammar = {
    'E': ['T', 'E`'],
    'E`': ['+T E`', ''],
    'T': ['F T`'],
    'T`': ['* F T`', ''],
    'F': ['( E )', 'id']
}

# Compute the first sets for all symbols in the grammar
first_sets = {}
for symbol in input_grammar.keys():
    compute_first_set(symbol, input_grammar, first_sets)

# Compute the follow sets for all symbols in the grammar
follow_sets = defaultdict(set)
for symbol in input_grammar.keys():
    compute_follow_set(symbol, input_grammar, first_sets, follow_sets)

# Print the first and follow sets for each symbol in the grammar
for symbol in input_grammar.keys():
    print(f"FIRST({symbol}) = {first_sets[symbol]}")
    print(f"FOLLOW({symbol}) = {follow_sets[symbol]}")
