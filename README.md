8-bit RPG
==========
Hello everyone! This my university project for the course 'Programming with Ruby' In the following days the game will be under heavy development so stay tuned.

How to run the game under Linux
----------

### You need to have [Ruby](https://www.ruby-lang.org/) installed (2.1.0 is recomended) ###

> * ``sudo apt-get install curl`` *(Ubuntu)*
> * ``\curl -sSL https://get.rvm.io | bash -s stable --ruby``
> * ``rvm install 2.1.0``

### After you've installed ruby you will need to install ``libncursesw5-dev`` ###

> **Ubuntu:** ``sudo apt-get install libncursesw5-dev`` *(This will allow ``curses`` to run with unicode characters)*

### Now install the ``curses`` gem ###

> **Ubuntu:** ``gem install curses``

### Clone this repository somewhere on your computer, open a terminal and move to the destination folder ###

> * ``cd /path/to/where/you/want/to/clone/the/repository``
> * ``git clone https://github.com/xswordsx/Ruby-RPG`` **or** [download](https://github.com/xswordsx/Ruby-RPG/archive/master.zip) the archive and extract it there
> * ``cd Ruby-RPG``

### Now run the ``ui.rb`` ###

> ``ruby ui.rb``


## Enjoy the game :) ##
