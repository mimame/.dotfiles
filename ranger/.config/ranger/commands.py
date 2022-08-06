# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import (absolute_import, division, print_function)

# You can import any python module as needed.
import os
from os.path import join, expanduser, lexists
from os import makedirs
import re
import subprocess

from collections import deque

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command
from ranger.ext.get_executables import get_executables


# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":my_edit<ENTER>" in ranger!
class my_edit(Command):
    # The so-called doc-string of the class will be visible in the built-in
    # help that is accessible by typing "?c" inside ranger.
    """:my_edit <filename>

    A sample command for demonstration purposes that opens a file in an editor.
    """

    # The execute method is called when you run this command in ranger.
    def execute(self):
        # self.arg(1) is the first (space-separated) argument to the function.
        # This way you can write ":my_edit somefilename<ENTER>".
        if self.arg(1):
            # self.rest(1) contains self.arg(1) and everything that follows
            target_filename = self.rest(1)
        else:
            # self.fm is a ranger.core.filemanager.FileManager object and gives
            # you access to internals of ranger.
            # self.fm.thisfile is a ranger.container.file.File object and is a
            # reference to the currently selected file.
            target_filename = self.fm.thisfile.path

        # This is a generic function to print text in ranger.
        self.fm.notify("Let's edit the file " + target_filename + "!")

        # Using bad=True in fm.notify allows you to print error messages:
        if not os.path.exists(target_filename):
            self.fm.notify("The given file does not exist!", bad=True)
            return

        # This executes a function from ranger.core.actions, a module with a
        # variety of subroutines that can help you construct commands.
        # Check out the source, or run "pydoc ranger.core.actions" for a list.
        self.fm.edit_file(target_filename)

    # The tab method is called when you press tab, and should return a list of
    # suggestions that the user will tab through.
    # tabnum is 1 for <TAB> and -1 for <S-TAB> by default
    def tab(self, tabnum):
        # This is a generic tab-completion function that iterates through the
        # content of the current directory.
        return self._tab_directory_content()

class mc(Command):
    """
    :mc <dirname>

    Creates a directory with the name <dirname> and enters it.
    """

    def execute(self):

        dirname = join(self.fm.thisdir.path, expanduser(self.rest(1)))
        if not lexists(dirname):
            makedirs(dirname)

            match = re.search('^/|^~[^/]*/', dirname)
            if match:
                self.fm.cd(match.group(0))
                dirname = dirname[match.end(0):]

            for m in re.finditer('[^/]+', dirname):
                s = m.group(0)
                if s == '..' or (s.startswith('.') and not self.fm.settings['show_hidden']):
                    self.fm.cd(s)
                else:
                    ## We force ranger to load content before calling `scout`.
                    self.fm.thisdir.load_content(schedule=False)
                    self.fm.execute_console('scout -ae ^{}$'.format(s))
        else:
            self.fm.notify("file/directory exists!", bad=True)

class fd_fzf(Command):
    """
    :fd_fzf <query>
    Executes "fd_fzf <query>"

    See https://github.com/sharkdp/fd
    """

    def execute(self):
        if 'fdfind' in get_executables():
            fd = 'fdfind'
        elif 'fd' in get_executables():
            fd = 'fd'
        else:
            self.fm.notify("Couldn't find fd in the PATH.", bad=True)
            return

        if 'fzf' not in get_executables():
            self.fm.notify('Could not find fzf in the PATH.', bad=True)
            return

        if self.arg(1):
            target = self.arg(1)
        else:
            self.fm.notify(":fd_fzf needs a query.", bad=True)
            return

        command = f'{fd} {target} | fzf --no-multi --exit-0 --select-1'
        fd = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, _ = fd.communicate()

        if fd.returncode == 0:
            selected = os.path.abspath(stdout.strip())
            print(f"SELECTED: {selected}")

            if selected == "":
               self.fm.notify('No results found.')
               return

            if os.path.isdir(selected):
               self.fm.cd(selected)
            else:
               self.fm.select_file(selected)
        else:
               self.fm.notify('No results found.')

class rg_fzf(Command):
    """
    :rg_fzf <query>
    Executes "rg_fzf <query>"

    See https://github.com/sharkdp/fd
    """

    def execute(self):
        if 'rg' in get_executables():
            rg = 'rg'
        else:
            self.fm.notify("Couldn't find rg in the PATH.", bad=True)
            return

        if 'fzf' not in get_executables():
            self.fm.notify('Could not find fzf in the PATH.', bad=True)
            return

        if self.arg(1):
            target = self.arg(1)
        else:
            self.fm.notify(":rg_fzf needs a query.", bad=True)
            return

        command = f'{rg} --smart-case --no-heading --with-filename --hidden --ignore-file ~/.config/fd/ignore {target} | fzf --no-multi --exit-0 --select-1'
        rg = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, _ = rg.communicate()

        if rg.returncode == 0:
            selected = os.path.abspath(stdout.strip())
            print(f"SELECTED: {selected}")

            if selected == "":
               self.fm.notify('No results found.')
               return
            else:
               self.fm.edit_file(selected.split(":")[0])
        else:
               self.fm.notify('No results found.')
