__author__ = 'janos'

import logging
import json
import os
import string


class RRFReader(object):
    """A generalized class for reading RRF files. Requires a dict which which has column
    positions, e.g., {0 : "CUI",1 : "STR"}"""
    def __init__(self, file_name, column_position, delimiter="|"):
        self.delimiter = delimiter
        self.file_name = file_name
        self.column_position = column_position

        try:
            self.fp = open(file_name, 'r')
        except IOError:
            logging.error("Cannot open '%s'", os.path.abspath(file_name))
            raise

    def __iter__(self):
        return self

    def next(self):

        try:
            line = self.fp.next()
            split_line = line.rstrip().split(self.delimiter)
            rrf_dictionary = {}
            i = 0

            for cell_value in split_line[:-1]:
                if len(cell_value) == 0:
                    cell_value = None

                rrf_dictionary[self.column_position[i]] = cell_value

                i += 1

            return rrf_dictionary

        except StopIteration:
            raise StopIteration


def read_file_layout(file_name):
    fj = open(file_name, "r")
    file_layout_json = json.load(fj)

    file_layout_json_cleaned = {}

    for file_name in file_layout_json:
        file_index_dict = {}
        for string_number in file_layout_json[file_name]:
            file_index_dict[int(string_number)] = file_layout_json[file_name][string_number]
        file_layout_json_cleaned[file_name] = file_index_dict

    return file_layout_json_cleaned


def transform_to_url(string_to_transform):

    s1 = string.join(string_to_transform.split("."),"_")
    s2 = string.join(s1.split(),"_")

    return s2



class UMLSJsonToISFSKOS(object):
    """A class for transform JSON extracted from RRF files from the UMLS into a SKOS ISF compatible format"""
    def __init__(self, json_file_name):
        self.json_file_name = json_file_name

        self.prefixes = {"skos" : "http://www.w3.org/2004/02/skos/core#",
                         "rdf" : "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
                         "arg" : "http://purl.obolibrary.org/obo/arg/",
                         "rdfs" : "http://www.w3.org/2000/01/rdf-schema#",
                         "owl" : "http://www.w3.org/2002/07/owl#",
                         "skosxl" : "http://www.w3.org/2008/05/skos-xl#"}

        self.rdf_type = self.prefixes["rdf"] + "type"
        self.see_also = self.prefixes["rdfs"] + "seeAlso"
        self.skos_concept = self.prefixes["skos"] + "concept"

        self._load_json_file()

    def _load_json_file(self):
        with open(self.json_file_name) as fj:
            self.umls_dict = json.load(fj)

    def set_base_url(self, url="http://purl.obolibrary.org/obo/arg/skos/"):
        self.base_url = url

    def set_concept_abbreviation(self, concept_abbreviation):
        self.concept_abbreviation = concept_abbreviation

    def register_transform_code_function(self, transform_code_function):
        self.transform_code_function = transform_code_function

    def write_to_out_file(self, file_name="skos_output.nt"):
        sui_dict = {} # TODO: For SUIs do not create duplicates
        with open(file_name, "w") as ft:
            for aui in self.umls_dict.keys():
                aui_dict = self.umls_dict[aui]
                code = aui_dict["CODE"]
                cui = aui_dict["CUI"]
                code_transformed = self.transform_code_function(code)
                aui_uri = self.base_url + "c_" + self.concept_abbreviation + "_" + code_transformed

                ntriples = ""
                ntriples += "<%s> <%s> <%s> .\n" % (aui_uri, self.rdf_type, self.skos_concept)

                ft.write(ntriples)


def publish_icd9cm(umls_directory="../extract/UMLSMicro2012AB/", refresh_json_file=False):
    sab = "ICD9CM"
    json_file_name = sab + "_umls.json"
    json_file_path = os.path.join(umls_directory, json_file_name)
    refresh = False
    tty_list = ["HT", "PT"]

    if os.path.exists(json_file_path):
        if refresh_json_file:
            refresh = True
    else:
        refresh = True

    if refresh:
        extract_umls_subset_to_json(umls_directory, sab, tty_list)

    icd9_isf_obj = UMLSJsonToISFSKOS(json_file_path)

    icd9_isf_obj.set_base_url(icd9_isf_obj.prefixes["arg"] + "skos/")
    icd9_isf_obj.set_concept_abbreviation(sab)
    icd9_isf_obj.register_transform_code_function(transform_to_url)
    icd9_isf_obj.write_to_out_file("../output/" + sab + "_isf_skos.nt")


def extract_umls_subset_to_json(umls_directory, SAB="ICD9CM", term_types=["HT", "PT"]):
    """Extract a source vocabulary from RRF and store as JSON"""

    print("Extracting source '%s' and term types %s" % (SAB, term_types))
    file_layout = read_file_layout("umls_file_layout.json")
    print(file_layout)

    mrconso_rrf = "MRCONSO.RRF"
    mrconso_file_layout = file_layout[mrconso_rrf]
    mrconso_rrf_file_name = os.path.join(umls_directory, mrconso_rrf)
    mrconso = RRFReader(mrconso_rrf_file_name, mrconso_file_layout)

    aui_subset = {}
    i = 0
    j = 0
    for entry in mrconso:
        sab = entry["SAB"]
        tty = entry["TTY"]
        aui = entry["AUI"]

        if sab == SAB:
            if tty in term_types:
                aui_subset[aui] = entry
                j += 1
        i += 1

    print("Extracted %s AUIs from a total of %s" % (j, i))

    mrrel_rrf  = "MRREL.RRF"
    mrrel_file_layout = file_layout[mrrel_rrf]
    mrrel_rrf_file_name = os.path.join(umls_directory, mrrel_rrf)
    mrrel = RRFReader(mrrel_rrf_file_name, mrrel_file_layout)

    k = 0
    l = 0
    for relationship in mrrel:
        sab = relationship["SAB"]
        aui = relationship["AUI1"]

        if sab == SAB:
            if aui in aui_subset:
                if "relationships" in aui_subset[aui]:
                    aui_subset[aui]["relationships"] += [relationship]
                else:
                    aui_subset[aui]["relationships"] = [relationship]
                l += 1
        k += 1

    print("Extracted %s relationships from a total of %s" % (l, k))

    mrsat_rrf  = "MRSAT.RRF"
    mrsat_file_layout = file_layout[mrsat_rrf]
    mrsat_rrf_file_name = os.path.join(umls_directory, mrsat_rrf)
    mrsat = RRFReader(mrsat_rrf_file_name, mrsat_file_layout)

    m = 0
    n = 0
    for attribute in mrsat:
        sab = attribute["SAB"]
        aui = attribute["METAUI"]

        if sab == SAB:
            if aui in aui_subset:
                if "attributes" in aui_subset[aui]:
                    aui_subset[aui]["attributes"] += [attribute]
                else:
                    aui_subset[aui]["attributes"] = [attribute]
                    n += 1
        m += 1

    print("Extracted %s attributes from a total of %s" % (n, m))

    print("Writing json file")

    sab_umls_json = os.path.join(umls_directory, SAB + "_umls" + ".json")
    with open(sab_umls_json, "w") as fw:
        json.dump(aui_subset, fw)

    return sab_umls_json


def main():
    publish_icd9cm()

if __name__ == "__main__":
    main()