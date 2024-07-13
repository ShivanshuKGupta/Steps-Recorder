import os
import shutil


def copy_folder(src, dst):
    """
    Copies the contents of the src folder to the dst folder.

    :param src: Source folder path
    :param dst: Destination folder path
    """
    try:
        if not os.path.exists(src):
            print(f"Source folder '{src}' does not exist.")
            return

        if os.path.exists(dst):
            shutil.rmtree(dst)

        shutil.copytree(src, dst)
        print(f"Folder '{src}' successfully copied to '{dst}'.")
    except shutil.Error as e:
        print(f"Error occurred while copying folder: {e}")
    except OSError as e:
        print(f"Error: {e}")


source_folder = "python"
destination_folder = "build/windows/x64/runner/Release/python"

copy_folder(source_folder, destination_folder)

os.system("cd build/windows/x64/runner/Release && explorer .")
