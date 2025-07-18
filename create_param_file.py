import json
import glob
import sys
import os
from datetime import datetime

def create_param_file(file_dir: str, video_format: str = 'avi'):
    '''
    Creates json param file saved in the file_dir location for running batch inference
    example:
        python create_param_file.py 'directory/name' 'video_format'
    :param file_dir:
    :param video_format:
    :return:
    '''
    file_list = glob.glob('*.'+video_format) # get all of the video files from the directory

    now_ = datetime.now() # get current time in H-M-S
    now_ = now_.strftime("%Y%m%d-%H-%M-%S") # turn current time into string
    json_file_name = now_ + '_param_file.json' # make unique name
    param_dict = dict() # create dictionary for json file
    no_files = len(file_list)

    # check that there are actually files in the folder
    if no_files > 0:
        no_files_str = str(no_files)

        # Create param file to store video files for array analysis on computing cluster
        param_dict['count'] = no_files # store number of files - this is for batch processing
        param_dict['files'] = file_list # store file names
        json_f = open(json_file_name, 'w') # create the new json file
        json.dump(param_dict, json_f) # dumb the param dictionary
        json_f.close() # close the file

        return json_file_name, file_list
    else:
        print(f'Directory does not contain files of type: {video_format}.')

if __name__== "__main__":
    file_dir = sys.argv[1] # file directory argument
    os.chdir(file_dir) # change to file directory
    if len(sys.argv) == 2:
        create_param_file(file_dir=file_dir)
    elif len(sys.argv) >= 3:
        video_format = sys.argv[2]
        param_file, file_list = create_param_file(file_dir=file_dir, video_format=video_format)
