import os
import shutil


def delete_pycache_folders(start_dir):
    for root, dirs, files in os.walk(start_dir):
        for file in files:
            if file.endswith(".json.tmp"):
                file_path = os.path.join(root, file)
                print(f"Deleting: {file_path}")
                os.remove(file_path)
        
        for dir_name in dirs:
            if dir_name == "__pycache__":
                dir_path = os.path.join(root, dir_name)
                print(f"Deleting: {dir_path}")
                shutil.rmtree(dir_path)
        

if __name__ == "__main__":
    start_directory = "python"
    delete_pycache_folders(start_directory)
