__author__ = 'janos'

import logging
import json
import os
import string
import codecs
import csv


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
    """Transform a string to be more URL friendly"""
    s1 = string.join(string_to_transform.split("."),"_")
    s2 = string.join(s1.split(),"_")
    return s2


class UMLSJsonToISFSKOS(object):
    """A class for transform JSON extracted from RRF files from the UMLS into a SKOS ISF compatible format"""
    def __init__(self, aui_json_file_name, sab_json_file_name="sab_umls.json"):
        self.aui_json_file_name = aui_json_file_name
        self.sab_json_file_name = sab_json_file_name

        self.prefixes = {"skos" : "http://www.w3.org/2004/02/skos/core#",
                         "rdf" : "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
                         "arg" : "http://purl.obolibrary.org/obo/arg/",
                         "rdfs" : "http://www.w3.org/2000/01/rdf-schema#",
                         "owl" : "http://www.w3.org/2002/07/owl#",
                         "skosxl" : "http://www.w3.org/2008/05/skos-xl#"}

        self.rdf_type = self.prefixes["rdf"] + "type"
        self.rdfs_see_also = self.prefixes["rdfs"] + "seeAlso"
        self.rdfs_label = self.prefixes["rdfs"] + "label"

        #SKOS URIs
        self.skos_concept = self.prefixes["skos"] + "Concept"
        self.skos_is_in_scheme = self.prefixes["skos"] + "is_in_scheme"
        self.skos_concept_scheme = self.prefixes["skos"] + "Concept_Scheme"
        self.skos_is_top_in_scheme = self.prefixes["skos"] + "is_in_top_scheme"
        self.skos_notation = self.prefixes["skos"] + "notation"
        self.skos_broader = self.prefixes["skos"] + "broader"
        self.skos_preferred_label = self.prefixes["skos"] + "preferred_label"
        self.skos_collection = self.prefixes["skos"] + "Collection"
        self.skos_has_member = self.prefixes["skos"] + "member"

        #SKOSXL
        self.skosxl_literal_form = self.prefixes["skosxl"] + "literal_form"

        self._load_json_files()
        self._generate_helper_dicts()

    def _load_json_files(self):
        with open(self.aui_json_file_name) as fj:
            self.umls_dict = json.load(fj)

        with open(self.sab_json_file_name) as fj:
            self.sab_dict = json.load(fj)

    def _generate_helper_dicts(self):
        self.cui_dict = self.dict_by_umls_cui(self.umls_dict)
        self.code_dict = self.dict_by_source_code(self.umls_dict)

    def set_broader_relationship_field(self, key="REL", value="PAR"):
        self.broader_key = key
        self.broader_value = value

    def set_schema_version_from_sab(self):
         self.concept_version_abbreviation = self.sab_dict[self.concept_abbreviation]["SVER"]

    def set_base_uri(self, uri="http://purl.obolibrary.org/obo/arg/skos/"):
        self.base_uri = uri

    def set_concept_abbreviation(self, concept_abbreviation):
        self.concept_abbreviation = concept_abbreviation

    def set_concept_version_abbreviation(self, concept_version_abbreviation):
        self.concept_version_abbreviation = concept_version_abbreviation

    def set_external_umls_base_uri(self, uri):
        self.umls_aui_base_uri = uri

    def schema_uri(self):
        return self.base_uri + "s_" + self.concept_abbreviation + "_" + self.concept_version_abbreviation

    def code_base_uri(self):
        return self.base_uri + "c_" + self.concept_abbreviation

    def literal_base_uri(self):
        return self.base_uri + "l_" + self.concept_abbreviation

    def register_transform_code_function(self, transform_code_function):
        self.transform_code_function = transform_code_function

    def code_data_type(self):
        return self.base_uri + "dt_" + self.concept_abbreviation

    def concept_uri(self,code):
        code_transformed = self.transform_code_function(code)
        return self.base_uri + "c_" + self.concept_abbreviation + "_" + code_transformed

    def umls_cui_data_type(self):
        return self.base_uri + "dt_umls_cui"

    def umls_aui_data_type(self):
        return self.base_uri + "dt_umls_aui"

    def umls_sui_uri(self, sui):
        return self.base_uri + "l_" + self.concept_abbreviation + "_" + sui

    def write_to_out_file(self, file_name="skos_output.nt"):
        sui_dict = {}  #TODO: For SUIs do not create duplicates
        with codecs.open(file_name, "w", "utf-8") as ft:

            ft.write("<%s> <%s> <%s> . \n" % (self.schema_uri(), self.rdf_type, self.skos_concept_scheme))

            for aui in self.umls_dict.keys():
                aui_dict = self.umls_dict[aui]
                code = aui_dict["CODE"]
                label = aui_dict["STR"]
                cui = aui_dict["CUI"]
                concept_uri = self.concept_uri(code)
                sui = aui_dict["SUI"]

                ntriples = ""
                ntriples += "<%s> <%s> <%s> .\n" % (concept_uri, self.rdf_type, self.skos_concept)
                ntriples += "<%s> <%s> <%s> . \n" % (concept_uri, self.skos_is_in_scheme, self.schema_uri())
                ntriples += '<%s> <%s> "%s"^^<%s> . \n' % (concept_uri, self.skos_notation,
                                                             self._escape_literal(code), self.code_data_type())
                ntriples += '<%s> <%s> "%s"@en . \n' % (concept_uri, self.skos_preferred_label,
                                                             self._escape_literal(label))
                ntriples += '<%s> <%s> "%s"^^<%s> . \n' % (concept_uri, self.skos_notation, self._escape_literal(cui),self.umls_cui_data_type())
                ntriples += '<%s> <%s> "%s"^^<%s> . \n' % (concept_uri, self.skos_notation, self._escape_literal(aui),self.umls_aui_data_type())

                ntriples += '<%s> <%s> <%s> .\n' % (concept_uri, self.rdfs_see_also, self.aui_external_uri + aui)

                sui_uri = self.umls_sui_uri(sui)
                ntriples += '<%s> <%s> <%s> . \n' % (concept_uri, self.skos_preferred_label, sui_uri)

                if sui in sui_dict:
                    pass
                else:
                    sui_dict[sui] = label
                    ntriples += "<%s> <%s> <%s> .\n" % (sui_uri, self.rdf_type, self.skosxl_literal_form)
                    ntriples += '<%s> <%s> "%s"@en .\n' % (sui_uri, self.rdfs_label, self._escape_literal(label))

                if "relationships" in aui_dict:
                    for relationship in aui_dict["relationships"]:
                        if relationship[self.broader_key] == self.broader_value:
                            if "AUI2" in relationship:
                                aui_code_to_link_to = relationship["AUI2"]
                                if aui_code_to_link_to in self.umls_dict:
                                    aui_to_link_to = self.umls_dict[aui_code_to_link_to]
                                    concept_uri_to_link_to = self.concept_uri(aui_to_link_to["CODE"])
                                    ntriples += '<%s> <%s> <%s> . \n' % (concept_uri, self.skos_broader,
                                                                         concept_uri_to_link_to)

                ft.write(ntriples)

    def _escape_literal(self, literal):
        if '"' in literal:
            literal = string.join(literal.split('"'), r'\"')
        return literal

    def set_aui_external_uri(self, uri):
        self.aui_external_uri = uri

    def dict_by_umls_cui(self, aui_dict):

        cui_dict = {}
        for aui in aui_dict:
            cui = aui_dict[aui]["CUI"]
            if cui in cui_dict:
                cui_dict[cui] += [aui]
            else:
                cui_dict[cui] = [aui]
        return cui_dict

    def dict_by_source_code(self, aui_dict):
        code_dict = {}
        for aui in aui_dict:
            code = aui_dict[aui]["CODE"]
            if code in code_dict:
                code_dict[code] += [aui]
            else:
                code_dict[code] = [aui]
        return code_dict


class UMLS2SKOSCrossVocabulary(object):
    """
        Creates mapping files in SKOS and annotations to original SKOS file based on a mapping file
    """

    def __init__(self, mapping_file, umls_skos_obj_from, umls_skos_obj_to, source_code = "S_CODE", destination_code = "Post_Code", source_cui = "S_CUI"):
        self.mapping_file = mapping_file
        self.umls_skos_obj_from = umls_skos_obj_to
        self.umls_skos_obj_to = umls_skos_obj_from

    def _load_mapping_file(self):
        with open(self.mapping_file, "r") as f:
            self.mapping_file_read = csv.DictReader(f)

        self.mapping_aui_dict = {}
        for data in self.mapping_file_read:
            aui = data["AUI"]

    def write_out_file(self):
        pass


def publish_single_source_vocabulary(umls_directory="../extract/UMLSMicro2012AB/", sab="ICD9CM",
                                     refresh_json_file=False, tty_list=["HT", "PT"],
                                     hierarchal_relationships = ("REL", "PAR")):

    relationship_type, relationship_attribute = hierarchal_relationships

    aui_json_file_name = sab + "_umls.json"
    aui_json_file_path = os.path.join(umls_directory, aui_json_file_name)
    refresh = False

    sab_json_file_name = "sab_umls.json"
    sab_json_file_path = os.path.join(umls_directory, sab_json_file_name)

    if os.path.exists(sab_json_file_path):
        if refresh_json_file:
            refresh = True
    else:
        refresh = True

    if refresh:
        extract_umls_subset_to_json(umls_directory, sab, tty_list)

    icd9_isf_obj = UMLSJsonToISFSKOS(aui_json_file_path, sab_json_file_path)

    icd9_isf_obj.set_base_uri(icd9_isf_obj.prefixes["arg"] + "skos/")
    icd9_isf_obj.set_concept_abbreviation(sab)
    icd9_isf_obj.set_schema_version_from_sab()
    icd9_isf_obj.set_aui_external_uri("http://link.informatics.stonybrook.edu/umls/AUI/")
    icd9_isf_obj.register_transform_code_function(transform_to_url)
    icd9_isf_obj.set_broader_relationship_field(relationship_type, relationship_attribute)
    icd9_isf_obj.write_to_out_file("../output/" + sab + "_isf_skos.nt")

def generate_sab_json(umls_directory):
    """Filters SAB list by "SABIN" = 'Y' and creates a dict based on the "RSAB" version"""
    file_layout = read_file_layout("umls_file_layout.json")

    mrsab_rrf = "MRSAB.RRF"
    mrsab_file_layout = file_layout[mrsab_rrf]
    mrsab_rrf_file_name = os.path.join(umls_directory, mrsab_rrf)
    mrsab = RRFReader(mrsab_rrf_file_name, mrsab_file_layout)

    i = 0
    j = 0
    sab_dict = {}
    for sab in mrsab:
        if sab["SABIN"] == "Y":
            sab_dict[sab["RSAB"]] = sab
            j += 1
        i += 1

    print("From %s SABs read in %s" % (i, j))

    json_sab_file_name = "sab_umls.json"
    json_sab_file_path = os.path.join(umls_directory, json_sab_file_name)
    with open(json_sab_file_path,"w") as fj:
        json.dump(sab_dict, fj)
    return json_sab_file_path


def extract_umls_subset_to_json(umls_directory, SAB="ICD9CM", term_types=["HT", "PT"]):
    """Extract a source vocabulary from RRF and store as JSON"""

    print("Extracting source '%s' and term types %s" % (SAB, term_types))
    file_layout = read_file_layout("umls_file_layout.json")

    generate_sab_json(umls_directory)

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


def publish_icd9cm(refresh_json_file):
    publish_single_source_vocabulary(sab="ICD9CM", refresh_json_file=refresh_json_file)


def publish_nci(refresh_json_file):
    publish_single_source_vocabulary(sab="NCI", hierarchal_relationships=("RELA", "inverse_isa"), refresh_json_file=refresh_json_file)


def main():
    #publish_icd9cm(refresh_json_file=False)
    publish_nci(refresh_json_file=False)

if __name__ == "__main__":
    main()