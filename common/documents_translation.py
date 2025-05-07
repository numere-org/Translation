""" This is a testing module

This module uses deepl api to translate the documentation
"""

import os
import deepl
from deepl import DeepLException
from tqdm import tqdm


def make_directories(path):
    """
       Create directories along the given path if they do not exist.

       Params:
       path - [str]  The path containing directories to be created.

       Returns:
   """

    components = path.split(os.path.sep)
    current_path = ''
    for component in components:
        current_path = os.path.join(current_path, component)
        if not os.path.exists(current_path):
            os.makedirs(current_path)
            print(f"Directory '{current_path}' created.")
        else:
            print(f"Directory '{current_path}' already exists.")


def translate_documentation_files(path_input_files: str, path_output_files: str,
                                  target_language: str, source_lang: str, auth_key: str):
    """
    Translates each file found in path_input_files to the target_language.

    Params:
    path_input_files – [str] path where to find the input files
    path_output_files – [str] path where to find the output files
    target_language – [str] the target language to translation to
    source_lang -[str] the language to translate from
    auth_key – [str] authentication key
    Returns:

    """

    file_extension = ".nhlp"
    documentation_files = []

    # check the existence of files i the given input path
    if os.path.exists(path_input_files):
        num_files = len(os.listdir(path_input_files))
        print(f"Number of files in '{path_input_files}': {num_files}")
        # get the files in a list
        files_in_folder = os.listdir(path_input_files)
        documentation_files = [file for file in files_in_folder if file.endswith(file_extension)]
    else:
        print(f"Folder <<{path_input_files} can not be found. Please make sure the folder exists.")

    if not os.path.exists(path_output_files):
        os.makedirs(path_output_files)

    if documentation_files:
        for file in tqdm(documentation_files):
            input_file = os.path.join(path_input_files, file)
            output_file_name = input_file.replace(path_input_files, path_output_files)
            # open file
            with open(input_file, 'r', encoding='utf-8') as file_content:
                content = file_content.read()
            # translate file
            translated_content = translate_text(content, target_language, source_lang, auth_key)

            # the translation using the API is good up to 80%. For that reason we manually fix some problems
            translated_content = correct_translations(translated_content)

            # save translated file
            with open(output_file_name, 'w', encoding='utf-8') as translated_file:
                translated_file.write(translated_content)


def translate_text(content: str, target_lang: str, source_lang: str, auth_key: str):
    """
    Translates text in content to the target language using deepl API
    Params
    content - [str] text in xml format to be translated
    target_lang [str] target language
    source_lang -[str] the language to translate from
    auth_key – [str] authentication key
    return
    translated_text [str] translated text to the target language
    """

    # parameters

    translator = deepl.Translator(auth_key)
    tag_handling = "xml"
    ignore_tags = ["code", "keywords", "syntax", "&PLOTPATH&"]

    # translate content while keeping the "xml" formatting
    translated_text = translator.translate_text(content, source_lang=source_lang, target_lang=target_lang,
                                                tag_handling=tag_handling, ignore_tags=ignore_tags)
    translated_text = translated_text.text
    return translated_text


def correct_translations(content: str):
    """
    translates the documentation given by DeepL

    param
    content - [str] text to be corrected
    return
    content - [str] corrected translation
    """

    # 1) search for exclamation mark and delete the space before
    exclamation_idx = [i for i in range(len(content)) if content.startswith('!', i)]
    idx_change = 0
    for idx in exclamation_idx:
        if content[idx - idx_change - 1] == " ":
            content = content[0: idx - idx_change - 1] + content[idx - idx_change:]
            idx_change += 1

    # 2) for some reason, PLOTPATH is not translated correctly.
    content = content.replace("&amp;", "&")
    return content


def translate_to_multiple_languages(target_languages: [str], source_lang: str, auth_key: str):
    """
    Translates the documentation to multiple languages

    param
    target_languages - [list(str)]
    source_lang - [str]
    auth_key – [str] authentication key
    :return:
    """
    path_input_files = "NumeRe_Original_Docs"

    for target_lang in target_languages:
        print(f"Translating Documentation to {target_lang}")
        path_output_files = f"{target_lang.lower()}-{target_lang.capitalize()}"
        translate_documentation_files(path_input_files, path_output_files, target_lang, source_lang, auth_key)


def translate_nlng_file(source_file_name: str, target_path: str, file_name: str, source_lang: str, target_lang: str,
                        auth_key: str):
    """
    translates the nlng files

    Params:
    source_file_name – [str] name of the source file to translate (numere, main, error)
    target_path – [str] target path to save the new fle
    file_name – [str] file name to save as
    source_lang – [str] source language to translate from
    target_lang – [str] source language to translate to
    auth_key – [str] authentication key
    Returns:

    """
    make_directories(target_path)
    translated_file_path = target_path + "/" + file_name

    # check if the file exists, if that is the case, don't waste usage
    if os.path.exists(translated_file_path):
        return

    translator = deepl.Translator(auth_key)
    usage = translator.get_usage()
    usage_percent = usage.character.count / usage.character.limit
    print(f"usage percentage{100 * usage_percent} %")

    # check if usage reached the limit
    if usage_percent > 0.8:
        raise Exception("Usage reached 80%")

    with open(source_file_name, 'r', encoding='utf-8') as file_content:
        content = file_content.read()

    # if text is too long, the API throws an exception
    try:
        # translate text
        translated_text = translator.translate_text(content, source_lang=source_lang, target_lang=target_lang)
        translated_text = translated_text.text
    except DeepLException:
        # try to translate the text in two chunks
        content1 = content[0: len(content) // 2]
        content2 = content[len(content) // 2:]
        translated_text1 = translator.translate_text(content1, source_lang=source_lang, target_lang=target_lang)
        translated_text2 = translator.translate_text(content2, source_lang=source_lang, target_lang=target_lang)
        translated_text = translated_text1.text + translated_text2.text

    # write text in file
    with open(translated_file_path, 'w', encoding='utf-8') as translated_file:
        translated_file.write(translated_text)


if __name__ == "__main__":
    # initial parameters
    Source_lang = "DE"
    Target_lang = "FR"
    Auth_key = ""

    # documentation for multiple languages
    Target_langs = ["FR", "IT", "ES"]
    translate_to_multiple_languages(Target_langs, Source_lang, Auth_key)

    # ------------ error
    print("TRANSLATING ERROR FILE")
    File_name = "error.nlng"
    error_file_name = "../de-De/lang/error.nlng"
    error_path_file_translated = f"../{Target_lang.lower()}-{Target_lang.upper()}/lang"
    translate_nlng_file(error_file_name, error_path_file_translated, File_name, Source_lang, Target_lang, Auth_key)

    # ----------- main
    print("TRANSLATING MAIN FILE")
    File_name = "main.nlng"
    main_file_name = "../de-De/lang/main.nlng"
    main_path_file_translated = f"../{Target_lang.lower()}-{Target_lang.upper()}/lang"
    translate_nlng_file(main_file_name, main_path_file_translated, File_name, Source_lang, Target_lang, Auth_key)

    # ----------- numere
    print("TRANSLATING NUMERE FILE")
    File_name = "numere.nlng"
    numere_file_name = "../de-De/lang/numere.nlng"
    numere_path_file_translated = f"../{Target_lang.lower()}-{Target_lang.upper()}/lang"
    translate_nlng_file(numere_file_name, numere_path_file_translated, File_name, Source_lang, Target_lang, Auth_key)
