import os
from pathlib import Path
from os.path import splitext
from subprocess import check_call


PROJ_ROOT = Path.cwd()

root = "STREAMAPI"
files = []
walk = [root]


def get_resource_files():

    # print(PROJ_ROOT)

    # proj_dirs = os.listdir(PROJ_ROOT)
    
    # print(proj_dirs)

    while walk:
        folder = walk.pop(0)+"/";
        items = os.listdir(folder) # items = folders + files
        for i in items:
            i=folder+i
            (walk if os.path.isdir(i) else files).append(i)
    print(files)

    return files


def generate_docs(files):
    for file in files:
        without_ext = splitext(file)[0]
        if ".resource" in file:
            print(file)

            lib_doc = without_ext + '.html'
            args = ['python', '-m', 'robot.libdoc', file, lib_doc]
        
        check_call(args)



if __name__ == '__main__':
    files = get_resource_files()
    generate_docs(files)
