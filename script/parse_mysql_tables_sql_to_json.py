__author__ = 'janos'

import re
import json
import pprint

def main():

    regex_ct = re.compile(r"^CREATE TABLE (.+) \(")
    regex_end_table = re.compile(r"^\) CHARACTER SET utf8;")

    state = "SCAN"
    files_layout_dict = {}
    with open("mysql_tables.sql") as f:

        for line in f:

            if state == "READ":
                if regex_end_table.match(line):
                    state = "SCAN"
                else:
                    split_line = line.split()
                    column_name = split_line[0]
                    files_layout_dict[rrf_file_name][str(i)] = column_name
                    i += 1
            elif state == "SCAN":
                result_ct = regex_ct.match(line)
                if result_ct:
                    rrf_file_name = result_ct.groups()[0] + ".RRF"
                    files_layout_dict[rrf_file_name] = {}

                    state = "READ"
                    i = 0

        pprint.pprint(files_layout_dict)

        with open("umls_file_layout.json", "w") as fw:
            json.dump(files_layout_dict, fw)

if __name__ == "__main__":
    main()
