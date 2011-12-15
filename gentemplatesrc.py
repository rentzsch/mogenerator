#!/usr/bin/python

import argparse
import os
import re

def produce_source_files(outpath, inpaths):

    of = open(outpath, 'w')
    of.write('#include <Foundation/Foundation.h>\n')

    tmpl_names = map(os.path.basename, inpaths)
    var_names = [s.replace('.', '_') for s in tmpl_names]

    for path, name in zip(inpaths, var_names):    
        of.write('NSString * const MOBuiltin_%s = ' % name)

        # escape quotes and backlashes
        p = re.compile(r'("|\\)')
        for line in open(path):
            line = p.sub(r'\\\1', line.strip('\n'))
            of.write('@"%s\\n"\n' % line)
        of.write(';\n')

if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()
    parser.add_argument('-o', '--output')
    parser.add_argument('input', nargs='+')
    args = parser.parse_args()

    produce_source_files(args.output, args.input)
