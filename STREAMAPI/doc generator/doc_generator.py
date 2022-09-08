import fnmatch
from operator import contains
import os
from os import walk
from os.path import join, dirname, abspath, splitext
from subprocess import check_call


THIS_DIR = dirname(abspath(__file__))
print(THIS_DIR)

def get_test_files():
    matches = []
    dirs = ('STREAMAPI/tests')
    for dir_ in dirs:
        for root, _, filenames in walk(join(THIS_DIR, dir_)):
            for filename in fnmatch.filter(filenames, '[!_]*.robot'):
                matches.append(join(root, filename))
    return matches


if __name__ == '__main__':
    # print ("Generating documentation for libraries")
    # paths = get_libraries()
    # save_docs(paths)
    print ("Generating documentation for tests")
    paths = get_test_files()
    print(paths)
    # save_docs(paths)
    # print ("Generating documentation for resource files")
    # paths = get_resource_files()
    # save_docs(paths)
    print ("Documentation generated successfully.")