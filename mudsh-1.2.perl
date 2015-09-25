#MUD Shell
#(C)2001 Dean "Gandalf" Swift and Xirium
#
#20010209 Gandalf: idea taken from comments on SlashDot.Org
#20010210 Gandalf: start
#20010211 Gandalf: save
#20010212 Gandalf: save test
#20010213 Gandalf: save
#20010214 Gandalf: save test
#20010218 Gandalf: save
#20010302 Gandalf: save fix spacing, add comments
# Examine command contributed by Ron Broberg
# Stat command fixed by Bernard Yap
#20010307 Gandalf: start themes

#This subroutine, &disp, formats text to 72 columns.
#This is done by using a ruler, $width, to copy the first 72 characters from $in to $line.
#The last space is located and surplus from the next character is returned by prepending it to $in.
#There are exceptions for strings containing "\n", although these are not tested.
#Very long words have undefined results and hyphenation is not implemented.

sub disp
 {
 $width="."x72;
 $in=shift;
 if($in ne "")
  {
  print("\n");
  }
 while(length($in)>length($width))
  {
  $in=~s/^($width)//s;
  $line=$1;
  if($line=~/\n/s)
   {
   $line=~s/^(.*)\n(.*)$/$1/s;
   $in=$2.$in;
   }
  else
   {
   $line=~s/^(.*) (.*)$/$1/s;
   $in=$2.$in;
   }
  print("$line\n");
  }
 print("$in\n");
 $disp_flag=1;
 }

#For non null input, &disp, outputs a blank line before any other output.
#&disp can be called multiple times, so, to ensure single blank lines between uses of &disp and to ensure a blank after the final use, a flag, $disp_flag is set.
#&disp_space only outputs a blank line if &disp has been called then the flag is cleared.

sub disp_space
 {
 if($disp_flag==1)
  {
  print "\n";
  $disp_flag=0;
  }
 }

sub inv_add
 {
 }

sub inv_sub
 {
 }

#-Message	inv-empty	You are carrying nothing and you have no weapons.

sub inv_disp
 {
 &disp($message{"inv-empty"});
 }

#read configuration file specified as only parameter.
#currently collected configuration information is stored in @alias, @des and @message.
#aliases are not case sensitive, descriptions and messages are case sensitive.

sub conf_read
 {
 $temp0=shift;
 if(-r $temp0)
  {
  open(FILE,$temp0);
  while(defined($line=<FILE>))
   {
   $line=~s/^\#\-//;
   $line=~s/[\n\r]*$//;
   if($line!~/^\#/)
    {
    ($temp0,$temp1,$temp2)=split(/[ \t]+/,$line,3);
    $temp0=~tr/[a-z]/[A-Z]/;
    if($temp0 eq "ALIAS")
     {
     $temp1=~tr/[a-z]/[A-Z]/;
     $temp2=~tr/[a-z]/[A-Z]/;
     $alias{$temp1}=$temp2;
     }
    elsif($temp0 eq "DESCRIBE")
     {
     $temp2=~s/\\n/\n/g;
     $temp2=~s/\\\\/\\/g;
     $des{$temp1}=$temp2;
     }
    elsif($temp0 eq "MESSAGE")
     {
     $message{$temp1}=$temp2;
     }
    else
     {
     #should output error here
     }
    }
   }
  close(FILE);
  }
 }

#The following comments form part of the default theme.
#The comments are stored in @des when the prog reads itself as configuration.
#Directives in this format can be added to separate "theme" configuration files.
#In theme files, directives must not be preceded with "#-".
#This is for upward compatibility.

#-Describe	/	You are in a desert. A tumbleweed passes. You see a signpost but the words are obscure and abbreviated. Footprints indicate that the gurus have passed here many times before. If you stay here long enough, you will grow a beard.
#-Describe	/dev	You are in the vast engine room of an alien spacecraft. Or it might be a holographic projection room. There are many exotic instruments, gauges, blinking lights and a sign in another language. Do not touch!
#-Describe	/etc	You are in a junkyard. Well, you think it is a junkyard. Scrap metal and wood is piled conically all around you. You see crude, fearsome machines but you are unsure of their purpose. A stone tablet of names and encrypted passwords hangs from a crane. This rubble was once an important building.
#-Describe	/bin	You are in the reference section of an old library. It is extremely dusty and hard to read the book titles. You can tell that this was once a place of profound discovery in golden era. You feel that this place may be useful in an emergency.
#-Describe	/tmp	You are in a large deserted marketplace. The weather is overcast and you feel cold. The flagstones are uneven and newspaper soaks in a small puddle. Occasionally, useful information can be found here.
#-Describe	/usr	You are in a tall, sparkling glass building. The building is curved and clear except for the light green turrets. A flying car passes.
#-Describe	/usr/local	You are in a modern town.
#-Describe	/var	You are in the lobby of a hotel.
#-Describe	/var/spool	You are in the lounge of a hotel. You hear tasteful music playing quietly. Low comfy seating is arranged around palm trees and ferns. Soft lighting shines from the white ceiling. You would feel uneasy staying here too long.
#-Describe	/root	You see a vast cavern with no quota limit. There might be treasure here but it is too dark to see. The walls by the entrance are scorched. A wise old dragon lives here. The dragon is subtle and quick to anger. Should you be here?
#-Describe	/proc	You are in an office. You see many cubicles and hear a humming noise from the nearby supercomputer. Or maybe the hum is the air conditioning.
#-Describe	/opt	You see a newly created cavern. Two gurus are arguing over the usefulness of this new area. Bugs and bloatware have already infested the area. You see some vendorware in the distance.");
#-Describe	/opt/xirium	You are not sure why this room is here. A bell rings as you open the glass door. You see an arrangement of scrolls and a quaint photocopier, which is free to use. There is a generic desk with a generic sign that says "tech@xirium.com". You see an assortment of gadgets, some unfinished. Finally, you see some bones. A wumpus has eaten the shopkeeper.
#-Describe	/boot	You are in a cave. This place was the beginning of civilisation.
#-Describe	/site	You are in a trendy suburb. Residential and commercial properties are intermixed.");

#&describe checks for a description previously read from a theme.
#If none is found, an attempt is made to read ".mudshrc" in the current directory.
#If this is not the case, one of the defaults is tried.
#Descriptions in the theme take precedence.
#This is followed by descriptions in the filing system, although for some directories, such as /proc and /tmp , this is not practical.

#-Message	directory-empty	(Empty Directory)
#-Message	exits	Exits
#-Message	direction-north	North
#-Message	direction-east	East
#-Message	direction-south	South
#-Message	direction-west	West
#-Message	direction-up	Up
#-Message	direction-home	Home
#-Message	direction-none	(None)

sub describe
 {
 if(defined($des{$cwd}))
  {
  #use description from theme
  &disp($des{$cwd});
  }
 elsif(-r ".mudshrc")
  {
  #print description found in .mudshrc in current directory
  local($/);
  open(FILE,".mudshrc");
  $buffer=<FILE>;
  $buffer=~s/\n\r/\n/gm;
  $buffer=~s/\r\n/\n/gm;
  $buffer=~s/\r/\n/gm;
  $buffer=~s/\n$//gm;
  &disp($buffer);
  close(FILE);
  }
 else
  {
  #use default
  if(($cwd eq "/usr/local/bin")||($cwd eq "/usr/bin"))
   {
   &disp("You are in a modern factory. Many of the machines form a single automated production line. Occasionally, a machine makes a loud noise, but there is no pattern.");
   }
  elsif(($cwd eq "/usr/local/lib")||($cwd eq "/usr/lib"))
   {
   &disp("You are in workshop. You see many interesting tools. Some are general purpose and some are for highly specialised uses.");
   }
  elsif(($cwd eq "/usr/local/man")||($cwd eq "/usr/man"))
   {
   &disp("You are standing by an information kiosk. The kiosk has a curved front and is painted in white, dark green and purple. It is quite gaudy. You see many leaflets on exotic subjects. The leaflets are written in a strange, terse language, but are extensively cross referenced. No one is present, but you see a sign that says \"Please take a leaflet or five\".");
   }
  elsif(($cwd eq "/var/spool/mail")||($cwd eq "/var/mail"))
   {
   &disp("You are in an oak panel room with plush carpet. You see pigeon holes for people's mail. You are curious and want to read. There are tubes to deliver mail and tubes to send mail. A mangle sits in the corner.");
   }
  elsif(($cwd eq "/usr/tmp")||($cwd eq "/var/tmp"))
   {
   &disp("You squeeze past a tall metal gate with a notice that reads \"Property left here at owners risk\". You see a concrete yard with a large bin. People don't come here any more, not since the machines replaced the workers.");
   }
  elsif($cwd=~/\/lost\+found$/)
   {
   &disp("You are in a lost property office.");
   }
  elsif($cwd eq "/mnt")
   {
   &disp("You are at an airport.");
   }
  elsif($cwd=~/\/mnt\/[^\/]+$/)
   {
   &disp("You are in an airplane.");
   }
  elsif(($cwd eq "/home")||($cwd=~/^\/[^\/]*\/home$/))
   {
   &disp("This is the home of the lesser gurus and the neophytes. You see pasty people sleeping. Some have a keyboard pattern imprinted on one side of their faces. These people need to get out more.");
   }
  elsif($cwd=~/\/home[^\/]*\/gandalf/)
   {
   &disp("You are in a disorganised room.");
   }
  elsif(($cwd eq "/www")||($cwd eq "/home/httpd/html"))
   {
   &disp("You are in the centre of a vast printing room. Loud machines surround you and they are producing thousands of informative magazines every minute. The noise is deafening.");
   }
  elsif((($cwd=~/^\/www\//)&&($cwd=~/\/cgi-bin$/))||($cwd eq "/home/httpd/cgi-bin"))
   {
   &disp("You are standing in a custom printing room. The most bizarrely designed machines are brought from miles around to work in this room. Steam prevents you seeing clearly.");
   }
  elsif(($cwd eq "/www-log")||($cwd eq "/home/httpd/logs")||($cwd eq "/usr/local/apache/logs"))
   {
   &disp("You are in the accounting room of the printers. Open ledgers can be found on elf size wooden desks. You wish the elves would write more clearly and spend less time getting drunk.");
   }
  elsif($cwd=~/^\/site\/[^\/]+\/www$/)
   {
   &disp("You are in a small office.");
   }
  }
 print "\n";
 $temp0=`ls -CF`;
 if($temp0 eq "")
  {
  $temp0=$message{"directory-empty"}."\n";
  }
 print $temp0;
 $temp0="";
 if($dir_n ne "")
  {
  $temp0.=" ".$message{"direction-north"};
  }
 if($dir_e ne "")
  {
  $temp0.=" ".$message{"direction-east"};
  }
 if($dir_s ne "")
  {
  $temp0.=" ".$message{"direction-south"};
  }
 if($dir_w ne "")
  {
  $temp0.=" ".$message{"direction-west"};
  }
 if($temp0 eq "")
  {
  $temp0=" ".$message{"direction-none"};
  }
 &disp($message{"exits"}.":$temp0.");
 }

#&scout identifies target directories for navigation.
#(Replace this bit to *really* confuse your users.)
#If not in root directory, you can go North.
#If not in root directory, obtain the names of the items in the parent directory in alphabetical order.
#For all of the readable directories found in the parent directory, create a window of three items.
#Terminate loop if current directory is middle element of window.
#First and last elements of window are East and West.
#Obtain the names of the items in the current directory in alphabetical order.
#The first readable directory is South.
#A null string indicates that an exit is not available.
#(This algorithm will change so that North and South are consistant and Up works how North currently does.)

sub scout
 {
 $dir_w="";
 $dir_e="";
 $dir_s="";
 if($cwd eq "/")
  {
  $dir_n="";
  }
 else
  {
  $dir_n="..";
  #scout West and East: search for sibling directories here
  @temp0=glob("../*");
  $temp1=$cwd;
  $temp1=~s/.*\///;
  $temp1=~s/([^0-9A-Za-z])/\\$1/g;
  $flag=0;
  $x=0;
  for($x=0;($x<@temp0)&&($flag==0);$x++)
   {
   if(((((stat($temp0[$x]))[2])&040000)!=0)&&(-r $temp0[$x]))
    {
    if($temp0[$x]=~/$temp1$/)
     {
     $flag=1;
     }
    else
     {
     $dir_w=$temp0[$x];
     }
    }
   }
  for(;($x<@temp0)&&($dir_e eq "");$x++)
   {
   if(((((stat($temp0[$x]))[2])&040000)!=0)&&(-r $temp0[$x]))
    {
    $dir_e=$temp0[$x];
    }
   }
  }
 #scout South: search for first child directory here
 @temp0=glob("*");
 for($x=0;($x<@temp0)&&($dir_s eq "");$x++)
  {
  if(((((stat($temp0[$x]))[2])&040000)!=0)&&(-r $temp0[$x]))
   {
   $dir_s=$temp0[$x];
   }
  }
 }

#Attempt to change directory.
#This routine reports an error to output if directory change is not possible.

#-Message	cd-cannot	You cannot go in that direction.
#-Message	cd-deny	A force field is blocking you. Your face is squashed and it tingles.
#-Message	cd-unknown	This exit does not exist. You feel confused.

sub cd
 {
 $dir=shift;
 if($dir eq "")
  {
  &disp($message{"cd-cannot"});
  }
 else
  {
  if(chdir($dir))
   {
   $cwd=`pwd`;
   $cwd=~s/\n//;
   &scout();
   $xp++;
   }
  else
   {
   if(-e $dir)
    {
    &disp($message{"cd-deny"});
    }
   else
    {
    &disp($message{"cd-unknown"});
    }
   }
  }
 return(1);
 }

#&go maps directions to directory names found by &scout before calling &cd.
#Not sure if use of glob here has a bug.

sub go
 {
 if(($c eq "NORTH")||($c eq "N")||($c eq "UP")||($c eq ".."))
  {
  return(&cd($dir_n));
  }
 elsif(($c eq "WEST")||($c eq "W"))
  {
  return(&cd($dir_w));
  }
 elsif(($c eq "EAST")||($c eq "E"))
  {
  return(&cd($dir_e));
  }
 elsif(($c eq "SOUTH")||($c eq "S"))
  {
  return(&cd($dir_s));
  }
 elsif(($c eq "HOME")||($c eq "H"))
  {
  $temp=glob("~");
  return(&cd($temp));
  }
 return(0);
 }

#Array of words is passed to &parse.
#Words are decoded from the beginning and discarded as they are interpreted.
#$c should always be capitalised, with trailing punctuation removed, which speeds and simplifies decode.
#(Ensuring the consistancy of $c when the array is shifted should be the action of a subroutine.)
#Some commands grab the whole line, others allow further commands to be appended.
#Glue words, such as "and" are ignored but unknown words halt decode, possibly after partial decode.

#-Message	direction-ambiguous	This direction is ambiguous.
#-Message	directory-ambiguous	This directory is ambiguous.
#-Message	demo-move	This is the demo version of MUDShell. You cannot move files.
#-Message	demo-read	This is the demo version of MUDShell. You cannot view files.
#-Message	demo-edit	This is the demo version of MUDShell. You cannot edit files.

sub parse
 {
 *command=shift;
 while(@command)
  {
  $c=$command[0];
  $c=~tr/[a-z]/[A-Z]/;
  $c=~s/([0-9A-Z])[^0-9A-Z]$/$1/;
  if(defined($alias{$c}))
   {
   $c=$alias{$c};
   }
  if(($c eq "HELP")||($c eq "H")||($c eq "?")||($c eq "MAN"))
   {
   &disp("MUDShell Help\n\nAvailable commands are: GO direction, CD directory, LOOK, EXAMINE object, INVENTORY or INV, TAKE objects, DROP objects, TALK, SHOUT, WHISPER, EMOTE gesture, READ files or VIEW files, EDIT files or OPEN files, KILL files, STAT, EXIT. Warning: KILL may remove files permanantly.");
   if($exec_flag==1)
    {
    $temp="currently enabled";
    }
   else
    {
    $temp="not available from this login shell";
    }
   &disp("Prefix an explanation mark (\"!\") to execute proper shell commands. (This feature is $temp.)");
   shift(@command);
   }
  elsif($c eq "GO")
   {
   shift(@command);
   $c=$command[0];
   $c=~tr/[a-z]/[A-Z]/;
   $c=~s/([0-9A-Z])[^0-9A-Z]$/$1/;
   if(!&go())
    {
    @temp=glob($command[0]);
    if(@temp>1)
     {
     &disp($message{"direction-ambiguous"});
     }
    else
     {
     &cd($temp[0]);
     }
    }
   shift(@command);
   }
  elsif(&go())
   {
   shift(@command);
   }
  elsif($c eq "CD")
   {
   shift(@command);
   @temp=glob($command[0]);
   if(@temp>1)
    {
    &disp($message{"directory-ambiguous"});
    }
   else
    {
    &cd($temp[0]);
    }
   shift(@command);
   }
  elsif($c eq "LOOK")
   {
   &describe();
   $xp++;
   shift(@command);
   }
  elsif($c eq "INV")
   {
   &inv_disp();
   $xp++;
   shift(@command);
   }
  elsif($c eq "TAKE")
   {
   &disp($message{"demo-move"});
   return(1);
   }
  elsif($c eq "DROP")
   {
   &disp("You are not carrying anything.");
   return(1);
   }
  elsif(($c eq "TALK")||($c eq "SAY")||($c eq "SHOUT"))
   {
   shift(@command);
   write(join(@command," "));
   return(1);
   }
  elsif($c eq "EMOTE")
   {
   shift(@command);
   write("Guest ".join(@command," "));
   return(1);
   }
  elsif($c eq "WHISPER")
   {
   &disp("Other users are not logged in.");
   return(1);
   }
  elsif($c eq "EXAMINE") {
    shift(@command);
    while($command[0] ne "") {
      if($command[0]!~/^and$/i) {
        $temp=$command[0];
        $temp=~s/^.*\/([^\/]*)$/$1/;
        if("$temp" eq "") {
          &disp("No such object");
        } elsif(!-e $temp) {
          &disp("Object $temp not found here.");
        } else {
          $examfile=`file $temp`;
          $examfile=~s/^.*: //;
          chomp($examfile);
          &disp("$temp is a $examfile");
          $xp++;
        }
      }
    shift(@command);
    }
  }
  elsif($c eq "READ")
   {
   &disp($message{"demo-read"});
   return(1);
   }
  elsif($c eq "EDIT")
   {
   &disp($message{"demo-edit"});
   return(1);
   }
  elsif($c eq "KILL")
   {
   shift(@command);
   mkdir("~/Trash",0600); #fix this
   while($command[0] ne "")
    {
    if($command[0]!~/^and$/i)
     {
     $temp=$command[0];
     $temp=~s/^.*\/([^\/]*)$/$1/;
     if(!-e $command[0])
      {
      &disp("File $temp not found.");
      }
     else
      {
      $len=(stat($temp))[7];
      if(rename($command[0],"~/Trash/$temp")) #fix this
       {
       &disp("You killed $temp.");
       $xp+=$len;
       }
      else
       {
       &disp("You are not strong enough to kill $temp.");
       }
      }
     }
    shift(@command);
    }
   }
  elsif($c eq "STAT")
   {
   &disp("You have $xp experience points.");
   shift(@command);
   }
  elsif($c eq "EXIT")
   {
   return(0);
   }
  elsif($c=~/^\#/)
   {
   #shell comment
   return(1);
   }
  elsif(($c ne "AND")&&($c ne "THEN")&&($c ne "THE")&&($c ne "OF")&&($c ne "AGAIN"))
   {
   print("Eh?\n");
   return(1);
   }
  else
   {
   shift(@command);
   $c=$command[0];
   $c=~tr/[a-z]/[A-Z]/;
   $c=~s/([0-9A-Z])[^0-9A-Z]$/$1/;
   if(defined($alias{$c}))
    {
    $c=$alias{$c};
    }
   }
  }
 return(1);
 }

#Aliases are defined here.
#These aliases are added to @alias when the program reads itself as configuration.
#Aliases are substituted before commands are interpreted.
#Currently, you can only substitute one word for another.

#-Alias	g	go
#-Alias	l	look
#-Alias	ls	look
#-Alias	inventory	inv
#-Alias	i	inv
#-Alias	exam	examine
#-Alias	ex	examine
#-Alias	open	edit
#-Alias	view	read
#-Alias	more	read
#-Alias	less	read
#-Alias	stats	stat
#-Alias	quit	exit
#-Alias	qui	exit
#-Alias	qu	exit
#-Alias	q	exit
#-Alias	logout	exit
#-Alias	logoff	exit

#Main program is here.
#Display banner, check for login shell, check safeguard then enter decode loop.
#Lines are checked for shell escapes before being sent to the parser.
#If an exit command is encountered, &parse returns an exit value.
#Accumulated experience points are displayed before termination.

print("\@\@\@\\       /\@\@\@  Version 1.2:     \@\@\@   o\@\@\@\@\@o   \@\@\@  (C)2001 Xirium   \@\@\@ \@\@\@\n");
print("\@\@\@\@\\     /\@\@\@\@  PointyStick      \@\@\@ /\@\@\@\@\@\@\@\@\@\\ \@\@\@  and Dean Swift   \@\@\@ \@\@\@\n");
print("\@\@\@\@\@\\   /\@\@\@\@\@                   \@\@\@ \@\@\@'   `\@\@\@ \@\@\@                   \@\@\@ \@\@\@\n");
print("\@\@\@\@\@\@\\ /\@\@\@\@\@\@ \@\@\@    \@\@\@   o\@\@\@b\@\@\@ \@\@\@.    \@\@\@ \@\@\@d\@\@\@o     o\@\@\@\@o   \@\@\@ \@\@\@\n");
print("\@\@\@\\\@\@\@V\@\@\@/\@\@\@ \@\@\@    \@\@\@ /\@\@\@\@\@\@\@\@\@ \\\@\@\@o.      \@\@\@\@\@\@\@\@\@\\ /\@\@\@\@\@\@\@\@\\ \@\@\@ \@\@\@\n");
print("\@\@\@ \\\@\@\@\@\@/ \@\@\@ \@\@\@    \@\@\@ \@\@\@'  `\@\@\@   *\@\@\@\@\@o   \@\@\@'  `\@\@\@ \@\@\@'  `\@\@\@ \@\@\@ \@\@\@\n");
print("\@\@\@  \\\@\@\@/  \@\@\@ \@\@\@    \@\@\@ \@\@\@    \@\@\@      `*\@\@\@\\ \@\@\@    \@\@\@ \@\@\@\@\@\@\@\@\@\@ \@\@\@ \@\@\@\n");
print("\@\@\@         \@\@\@ \@\@\@    \@\@\@ \@\@\@    \@\@\@ \@\@\@    `\@\@\@ \@\@\@    \@\@\@ \@\@\@\@\@\@\@\@\@\@ \@\@\@ \@\@\@\n");
print("\@\@\@         \@\@\@ \@\@\@.  ,\@\@\@ \@\@\@.  ,\@\@\@ \@\@\@.   ,\@\@\@ \@\@\@    \@\@\@ \@\@\@.       \@\@\@ \@\@\@\n");
print("\@\@\@         \@\@\@ \\\@\@\@\@\@\@\@\@\@ \\\@\@\@\@\@\@\@\@\@ \\\@\@\@\@\@\@\@\@\@/ \@\@\@    \@\@\@ \\\@\@\@\@\@\@\@\@  \@\@\@ \@\@\@\n");
print("\@\@\@         \@\@\@   *\@\@\@P\@\@\@   *\@\@\@P\@\@\@   *\@\@\@\@\@*   \@\@\@    \@\@\@   *\@\@\@\@\@\@  \@\@\@ \@\@\@\n");
&disp("You are logged in as Guest.");
if($0!~/^\-/)
 {
 #this is not a login shell therefore allows external commands to be run
 $exec_flag=1;
 }
@temp=`ps`;
if(scalar(@temp)<=3)
 {
 #there are too few tasks for this not to be a login shell
 $exec_flag=0;
 }
&conf_read($0); #reads self for configuration
&conf_read("/etc/mudshrc");
&conf_read("/opt/xirium/mudsh/conf");
&conf_read(glob("~/.mudshrc"));
$xp=0;
$cwd=`pwd`;
$cwd=~s/\n//;
&scout();
&describe();
$continue=1;
while($continue)
 {
 &disp_space();
 print("mudsh - $cwd > ");
 $buffer=<>;
 $buffer=~s/[\n\r]*$//g;
 $buffer=~s/\t/ /g;
 $buffer=~s/ +/ /g;
 $buffer=~s/^ //;
 $buffer=~s/ $//;
 if($buffer=~/^!/)
  {
  if($exec_flag!=1)
   {
   &disp("A wizard prevents your action.");
   }
  else
   {
   $buffer=~s/^!//;
   system($buffer);
   }
  }
 else
  {
  @line=split(/ /,$buffer);
  $continue=&parse(\@line);
  }
 }
&disp("Experience points gained this session: $xp. Experience points are earned by actions, but mostly by killing things.");
