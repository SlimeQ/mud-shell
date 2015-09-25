# mud-shell
A MUD based shell, rescued from [the pages of time](https://web.archive.org/web/20080509092838/http://www.xirium.com/tech/mud-shell/download/mudsh). The original hosting site, xirium.com, seems to be dead since ~2008.

Is there any reason why a shell (or command line) cannot be as tolerant or as intelligent as a text adventure game like Zork, or a MUD [Multi User Dungeon]? Is there any reason why a shell cannot work like such a game? ("Go North", etc.) Actually, no and we have the implementation to prove it. Have fun, and don't get eaten by a Grue!

- [The Idea](https://web.archive.org/web/20080509122938/http://www.xirium.com/tech/mud-shell/idea/index.html)

## Example Use

    @@@\       /@@@  Version 1.0:     @@@   o@@@@@o   @@@  (C)2001 Xirium   @@@ @@@
    @@@@\     /@@@@  BonsaiWumpus     @@@ /@@@@@@@@@\ @@@  and Dean Swift   @@@ @@@
    @@@@@\   /@@@@@                   @@@ @@@'   `@@@ @@@                   @@@ @@@
    @@@@@@\ /@@@@@@ @@@    @@@   o@@@b@@@ @@@.    @@@ @@@d@@@o     o@@@@o   @@@ @@@
    @@@\@@@V@@@/@@@ @@@    @@@ /@@@@@@@@@ \@@@o.      @@@@@@@@@\ /@@@@@@@@\ @@@ @@@
    @@@ \@@@@@/ @@@ @@@    @@@ @@@'  `@@@   *@@@@@o   @@@'  `@@@ @@@'  `@@@ @@@ @@@
    @@@  \@@@/  @@@ @@@    @@@ @@@    @@@      `*@@@\ @@@    @@@ @@@@@@@@@@ @@@ @@@
    @@@         @@@ @@@    @@@ @@@    @@@ @@@    `@@@ @@@    @@@ @@@@@@@@@@ @@@ @@@
    @@@         @@@ @@@.  ,@@@ @@@.  ,@@@ @@@.   ,@@@ @@@    @@@ @@@.       @@@ @@@
    @@@         @@@ \@@@@@@@@@ \@@@@@@@@@ \@@@@@@@@@/ @@@    @@@ \@@@@@@@@  @@@ @@@
    @@@         @@@   *@@@P@@@   *@@@P@@@   *@@@@@*   @@@    @@@   *@@@@@@  @@@ @@@
    
    You are logged in as Guest.
    
    You are in the home directory of the MUD Shell demo account. You are
    feeling curious and want to explore. You are particularly curious about
    the shimmering portal to the South. If you get lost, type "go home"
    (without the quotes) to return here.
    
    xirium@
    
    Exits: North East South West.
    
    mudsh - /home/mudsh > Go north, look and then go east
    
    This is the home of the lesser gurus and the neophytes. You see pasty
    people sleeping. Some have a keyboard pattern imprinted on one side of
    their faces. These people need to get out more.
    
    admin/  gandalf/  httpd/           mudsh/           richard/
    andre/  herve/    luser-template/  power-template/  usr/
    
    Exits: North East South West.
    
    mudsh - /lib > Go west, west again and look.
    
    You are in a junkyard. Well, you think it is a junkyard. Scrap metal
    and wood is piled conically all around you. You see crude, fearsome
    machines but you are unsure of their purpose. A stone tablet of names
    and encrypted passwords hangs from a crane. This rubble was once an
    important building.
    
    DIR_COLORS      csh.login      initlog.conf    mime.types      rpm/
    HOSTNAME        default/       inittab         motd            securetty
    X11/            exports        inputrc         mtab            security/
    adjtime         fdprm          ioctl.save      nsswitch.conf   sendmail.cf
    aliases         filesystems    isapnp.gone     pam.d/          sendmail.cw
    aliases.db      fstab          issue           passwd          sendmail.mc
    anacrontab      gettydefs      issue.net       passwd-         services
    at.deny         gpm-root.conf  issue.net0      passwd.OLD      shadow
    bashrc          group          ld.so.cache     pcmcia/         shadow-
    conf.linuxconf  group-         ld.so.conf      ppp/            shells
    conf.modules    gshadow        lilo.conf       printcap        skel/
    conf.modules~   gshadow-       localtime       profile         smrsh/
    cron.d/         gtk/           login.defs      profile.d/      sysconfig/
    cron.daily/     host.conf      logrotate.conf  protocols       sysctl.conf
    cron.fortly/    hosts          logrotate.d/    pwdb.conf       syslog.conf
    cron.hourly/    hosts.allow    mail/           rc.d/           termcap
    cron.monthly/   hosts.deny     mail.rc         redhat-release  wgetrc
    cron.weekly/    httpd/         mailcap         resolv.conf
    crontab         inetd.conf     mailcap.vga     rmt@
    csh.cshrc       info-dir       man.config      rpc
    
    Exits: North East South West.
    
    mudsh - /etc > Go /tmp look then go home.
    
    You are in a large deserted marketplace. The weather is overcast and
    you feel cold. The flagstones are uneven and newspaper soaks in a small
    puddle. Occasionally, useful information can be found here.
    
    (Empty directory)
    
    Exits: North East West.
    
    mudsh - /home/mudsh > drop all files
    
    You are not carrying anything.
    
    mudsh - /home/mudsh > !sh
    
    A wizard prevents your action.
    mudsh - /home/mudsh > kill /dev/fd0
    
    You are not strong enough to kill fd0.
    mudsh - /home/mudsh > kill zzz
    
    File zzz not found.
    mudsh - /home/mudsh > quit
    
    Experience points gained this session: 9. Experience points are earned
    by actions, but mostly by killing things.

## Installation

### Dependencies
- PERL 5

### Using Install Script
    
    $ ./install
    
This will generate a proper #! header for your system using `which perl` and install mudsh to the same directory. Then,

    $ mudsh
    
If for some reason this does not work for your system, you'll need to edit the files yourself. See ./install for instructions.

### Using mudsh as the Default Login Shell

If you want to use mudsh as a default login shell, you may need to edit /etc/shells. In summary:

    $ sudo su
    password:
    # mv ~user/download/mudsh /bin/mudsh
    # whereis perl
    perl: /usr/bin/perl5.00503 /usr/bin/perl /usr/man/man1/perl.1.gz
    # vi /bin/mudsh
    # chown bin.bin /bin/mudsh
    # chmod 755 /bin/mudsh
    # echo /bin/mudsh >> /etc/shells
    # exit
    $ /bin/mudsh

If you want to change or add descriptions, edit the source or litter .mudshrc files in your filing system. Any improvements improve the program or automate the install are welcome. Feel free to make a pull request.
