/* include/config.h.  Generated from config.h.in by configure.  */
/*      Netrek Configuration file       -              by Kurt Siegl
 * 
 */

#ifndef __CONFIG_H
#define __CONFIG_H

/* 
################################################################################
	Type of code (select in configure.in)    
################################################################################
*/

/* #undef COW */
#define SERVER 1

/* #undef STABLE */

/* 
################################################################################
	All The fun defines      
################################################################################
*/

/*
   Defines
      Some possible values:
   NOTE: Only NON-system specific defines belong here
*/

/* 
   ------------------------------------------------------------
	 	Common defines
   ------------------------------------------------------------
*/


/*  	RSA 			- New RSA reserved packets stuff 		*/
/* #define RSA  		- Defined in the Makefile 			*/

				/* DEBUG   	   - Various useful debugging 
						     stuff.  No signal trap */
/* #undef DEBUG */

/* 
   ------------------------------------------------------------
	 	COW only defines
   ------------------------------------------------------------
*/
#ifdef COW

/*	NBT 			- Nick trown's macro code			*/
#define NBT

/*	MAXPLAYER		- Maximal number of players + observers	     */
/*                                REMOVED from config.h.in due to redundancy */
/*                                Look for it in ntserv/defs.h               */

/*	CORRUPTED_PACKETS 	- prevents some seg faults but verbose output	*/
#define CORRUPTED_PACKETS

/*	EXPIRE=#      		- number of days this version will work for	*/
#ifndef STABLE
#define EXPIRE 365
#endif

/*	ARMY_SLIDER   		- some sort of funky status window thing	*/
#define ARMY_SLIDER

/*	META          		- show active servers via metaserver - NBT	*/
#define META

/*	PACKET_LOG    		- log packets to stdout (for bandwith measurement) */
#define PACKET_LOG

/*	NEWMACRO 		- newmacro language				*/
#define NEWMACRO 

/*	SMARTMACRO 		- macro extension (needs NEWMACRO)		*/
#define SMARTMACRO

/*	MULTILINE_MACROS	- enables multiline macros			*/
#define MULTILINE_MACROS

/*	XTREKRC_HELP 		- Hadley's xtrekrc window (stolden by KP)	*/
#define XTREKRC_HELP

/*	TOOLS			- Various tools, like shell escape, ...		*/
#define TOOLS

/*	SOUND			- support of external sound players		*/
#define SOUND

/*      HOCKEY_LINES            - allow showing of hockey lines			*/
#define HOCKEY_LINES

/*	SMALL_SCREEN		- for 800x600 resolution screens		*/
/* #define SMALL_SCREEN */

/*	BEEPLITE		- player and planets highlighting		*/
#define BEEPLITE

/*	VSHIELD_BITMAPS		- damage dependent shields (hull)		*/
#define VSHIELD_BITMAPS
#define VARY_HULL 

/*      WARP_DEAD		- Use death detection
*/
/* #undef WARP_DEAD */

/*    RCM                     	- Receiver configurable Server messages 	*/
#define RCM

/* 	RACE_COLORS		- additional bitplane for race colors		*/
#define RACE_COLORS

/* XTRA_MESSAGE_UI  - Show message being typed on the local display */
#define  XTRA_MESSAGE_UI

#define PLIST1 
#define PLIST 
#define CONTROL_KEY
#define BRMH 
#define DOC_WIN
#define RABBIT_EARS 
#define ROTATERACE
#define FUNCTION_KEYS

/* client options */
#define IGNORE_SIGNALS_SEGV_BUS
#define NEW_DASHBOARD_2
#define MOUSE_AS_SHIFT
#define SHIFTED_MOUSE
#define TNG_FED_BITMAPS
#define MOTION_MOUSE
#define DIST_KEY_NAME
#define PHASER_STATS
#define RECORDGAME

#endif		/* COW */


/* 
   ------------------------------------------------------------
	 	SERVER only defines
   ------------------------------------------------------------
*/
#ifdef SERVER

                                /*  AUTOMOTD       - Updates your MOTD every
                                                     12 hours */
/* #undef AUTOMOTD */

                                /*  ERIKPLAGUE     - Define for Erik's
                                                     Plagueing */
#define ERIKPLAGUE

				/*  REVERSED_HOSTNAMES - Truncate the short
                                                     hostname from the end
                                                     rather than the start */
#define REVERSED_HOSTNAMES

/* #undef DNSBL_CHECK */
                                /*  DNSBL_CHECK - Check player IPs against
                                public DNS blacklists to detect open proxies
                                as well as possibly infected computers. */

#ifdef DNSBL_CHECK
/* #undef DNSBL_SHOW */
                                /*  DNSBL_SHOW - Show possible proxies to ALL
                                and in WHOIS, otherwise just log it */

#define DNSBL_PROXY_MUTE
                                /*  DNSBL_PROXY_MUTE - Automatically mute
                                hosts that are detected as possible open
                                proxies */

#define DNSBL_WARN
                                /*  DNSBL_WARN - Warn players who appear on
                                the infected host lists with a private
                                message */

/* #undef DNSBL_WARN_VERBOSE */
                                /*  DNSBL_WARN_VERBOSE - Alert all players of
                                a possibly infected host */
#endif

                                /*  INL_POP        - Use INL style planet
                                                     popping scheme */
#define INL_POP

				/* PKEY		   - shared memory key, to
						     override key specified
						     in ntserv/defs.h */
/* #undef PKEY */

				/* LTD_STATS       - Leonard/Tom/Dave extended
                                                     player statistics.  See
                                                     README.LTD for details.
                                                     THIS BREAKS PLAYERDB
                                                     COMPATIBILITY!! */

#define LTD_STATS

				/* LTD_PER_RACE    - LTD stats are normally
				                     combined regardless
				                     of which race the player
				                     is playing.  Define
				                     this to further split
				                     the stats by race.
				                     NOTE: THIS IS REQUIRED
				                     for LTD enabled INL
				                     servers. */
				/* NOTE: DO NOT USE THIS WITH PICKUP SERVERS
				   AT THIS TIME */

/* #undef LTD_PER_RACE */

				/*  ARMYTRACK	   - Generate army tracking
						     WRN messages in log */

#define ARMYTRACK

                                /*  NO_PLANET_PLAGUE -Define for plagueing
                                                     (Don't use with
                                                     ERIKPLAGUE) */
/* #undef NO_PLANET_PLAGUE */

                                /* SHOW_RSA        - Display the client type
                                                     at login */
#define SHOW_RSA

                                /* RESETGALAXY     - Reset the galaxy after
                                                     each conquer */
#define RESETGALAXY

                                /* SELF_RESET      - Galaxy will reset if the
                                                     daemon dies */
#define SELF_RESET

                                /* SHORT_THRESHOLD - For Short Packets */
/* #undef SHORT_THRESHOLD */

                                /* SURRENDER_SHORT - Cut surrender time in
                                                     half */
/* #undef SURRENDER_SHORT */

                                /* TWO_RACE        - Conquer only a 1/4 of the
                                                     galaxy for reset */
#define TWO_RACE

                                /* SENDFLAGS       - Print flags set in MOTD */
/* #undef SENDFLAGS */

				/* SENDPATCHLEVEL - Print release and
                                   patch level in MOTD */ 
#define SENDPATCHLEVEL


                                /* CHECK_ENV       - Check environment variable                                                     NTSERV_PATH for location
                                                     of system files */
/* #undef CHECK_ENV */

                                /* GPPRINT         - Print which path is being
                                                     used to find the system
                                                     files */
/* #undef GPPRINT */

                                /* ONCHECK         - support for trekon player
                                                     check */
/* #undef ONCHECK */

                                /* NBR             - Leave in for server. It
                                                     tells programs like xsg
                                                     that it is this code. */
#define NBR

                                /* NEED_EXIT       - For systems that need exit                                                     defined */
#define NEED_EXIT

				/* SB_CALVINWARP   - calvin style transwarp */
/* #undef SB_CALVINWARP */

                                /* FLAT_BONUS      - 3x bonus for killing last
                                                     army on a planet */
/* #undef FLAT_BONUS */

                                /* BASEPRACTICE    - trainingserver support */
/* #undef BASEPRACTICE */

                                /* NEWBIESERVER    - twinkserver support */
/* #undef NEWBIESERVER */

                                /* PRETSERVER      - pre-T bot  support */
#define PRETSERVER

                                /* ROBOTS_STAY_IF_PLAYERS_LEAVE   - keep pre-T mode going even
                                                     if there are no humans; this
                                                     works around a stuck Kathy
                                                     bug that should be fixed */
#define ROBOTS_STAY_IF_PLAYERS_LEAVE

                                /* STURGEON        - sturgeon mode support */
/* #undef STURGEON */

                                /* NEW_CREDIT      - give 1 planet for
                                                     destroying, two planets
                                                     for taking.  Be sure to
						     scale your player
						     database's planet counts
						     by a factor of three -
						     running newscores as
						     compiled with a -DCONVERT
						     _once_ will do this
						     scaling for you */
/* #undef NEW_CREDIT */

                                /* SBFUEL_FIX      - fix starbase re-fueling */
#define SBFUEL_FIX

                                /* NEW_ETEMP       - Wreck's etemp fix */
/* #undef NEW_ETEMP */

                                /* DOGFIGHT        - .sysdef interface
                                                   for dogfight robot */
				/* CLUE2	   - include harder clue
						     questions */
/* #undef CLUE2 */
/* #undef DOGFIGHT */

#define NODOCK          /* NODOCK allow per-slot docking priveledges */

#define NOTRANSWARP	/* NOTRANSWARP	- allow starbase to set transwarp
					  initiation restrictions */

                                /* NO_BRUTALITY    - disallow fighting between
                                                     waiting players in the
                                                     dogfighting mode */
#ifdef DOGFIGHT
#define NO_BRUTALITY
#endif

                                /* AS_CLOAK        - gives cloaked AS's more
                                                     randomness in their
                                                     apparent positions */
/* #undef AS_CLOAK */

                                /* GENO_COUNT      - keep track of a player's
                                                     winning genocides, see
						     tools/conq_vert.c for a
						     description of how to use
						     this define. */
/* #undef GENO_COUNT */

                                /* AUTO_INL        - starts up INL robot
                                                     by majority vote   */

/* WARNING: AUTO_INL as currently implemented may hose your player database
because the INL server must provide cleared stats at startup.  Enable this
only if you have no intention of retaining stats on the server for pickup */

/* #undef AUTO_INL */
                                /* AUTO_PRACTICE   - starts up PRACTICE robot
                                                     by majority vote   */
#ifdef BASEPRACTICE
#define AUTO_PRACTICE
#endif
                                /* AUTO_HOCKEY     - starts up HOCKEY robot
                                                     by majority vote   */
/* #undef AUTO_HOCKEY */
                                /* AUTO_DOGFIGHT   - starts up DOGFIGHT robot
                                                     by majority vote   */
				/* DOG_RANDOM      - somewhat random player
						     placement in arena */
#ifdef DOGFIGHT
#define AUTO_DOGFIGHT
/* #define DOG_RANDOM */
#endif

                                /* TRIPLE_PLANET_MAYHEM - enable voting
                                for the three planet cool server idea
                                by felix@coop.com */
/* #undef TRIPLE_PLANET_MAYHEM */
				/* Balance vote weightings; how important each
				t-mode stat is for calculating a player value */
#define BALANCE_BOMBING 100
#define BALANCE_PLANET  100
#define BALANCE_DEFENSE   0
#define BALANCE_OFFENSE 100
                                /* MESSAGES_ALL_TIME - allow messaging during
                                freezes like twarp, refit, and war decl. 
				required to be set for INL robot use. */
#define MESSAGES_ALL_TIME
				/* RANDOM_PRACTICE_ROBOT - Gives the practice
				robot (Hoser) the option of comming out in
				a random ship type. */
#define RANDOM_PRACTICE_ROBOT

				/* Rolling statistics - makes the player stats
				reflect the immediate playing history of each
				player, for office games using BALANCE.  Set
				slots to 20 and mask to 32767 for 18 hours. */
/* #undef ROLLING_STATS */
/* #undef ROLLING_STATS_SLOTS */
/* #undef ROLLING_STATS_MASK */

				/* NO_CHUNG_CREDIT - Avoid crediting a player
				for armies killed by their own death
				due to a plasma owned by their team.  Not a
				particularly common misuse but a few
				people asked for this, apparently just
				because of one player.
				*/
#define NO_CHUNG_CREDIT

				/* NO_BEAM_DOWN_OUT_OF_T_MODE - Prevent
				beaming down from working if t-mode is not
				active. */
/* #undef NO_BEAM_DOWN_OUT_OF_T_MODE */

				/* PLAYER_INDEX - create and maintain
				an index of the player database, to
				reduce time to log in for servers with
				large or untrimmed player databases,
				requires libgdbm, and indexes only
				characters who return to the
				server. */
#define PLAYER_INDEX

                                /* ROBOT_OBSERVER_OFFSET - force observers
                                to start in slot 'h' thereby forcing the
                                moderation bots to occupy slot 'g'. */
/* #undef ROBOT_OBSERVER_OFFSET */

				/* SB_RAPID_COOLDOWN - enables twice the
				normal rate of weapon cool down.  Useful in
				base practice mode */
/* #undef SB_RAPID_COOLDOWN */

				/* ALLOW_PRACTICE_ROBOT_SB - allows practice
				robots to be refitted into SBs */
/* #undef ALLOW_PRACTICE_ROBOT_SB */

#endif		/* SERVER */


/*
##############################################################################
       All system dependencies should be defined here 
##############################################################################
*/

#define NEED_EXIT

/* Automatic generated system dependend defines 			*/

#define HAVE_MATH_H 1
#define HAVE_STDLIB_H 1
/* #undef _ALL_SOURCES */
/* #undef HAVE_SYS_SIGNAL_H */
/* #undef BSD_SIGNALS */
/* #undef SYSV_SIGNALS */
/* #undef POSIX_SIGNALS */
/* #undef RESTARTABLE_SYSCALLS */
/* #undef NEED_MEMORY_H */
/* #undef NEED_SYS_SELECT_H */
				/* Guess we suck badly if that happens :( */
/* #undef NO_FD_SET */
#define HAVE_UNISTD_H 1
#define HAVE_SYS_TIMEB_H 1
/* #undef TM_IN_SYS_TIME */
/* #undef TIME_WITH_SYS_TIME */
#define NEED_SYS_TIME_H 1
/* #undef HAVE_SYS_PTYIO_H */
#define HAVE_SYS_FCNTL_H 1
#define HAVE_FCNTL_H 1
#define HAVE_CTYPE_H 1
#define HAVE_MACHINE_ENDIAN_H 1
#define HAVE_SYS_RESOURCE_H 1
#define HAVE_SYS_WAIT_H 1
#define HAVE_NETINET_IN_H 1
				/* Needed for Solaris 2.x */
#define HAVE_SYS_FILIO_H 1
/* #undef HAVE_GMP2_H */
/* #undef NO_U_INT */
#define SIZEOF_LONG 8
#define HAVE_USLEEP 1
#define HAVE_SETSTATE 1
#define HAVE_RANDOM 1
#define HAVE_STRFTIME 1
#define HAVE_FTIME 1
/* #undef HAVE_STRCMPI */
/* #undef HAVE_STRNCMPI */
/* #undef HAVE_NINT */
/* #undef NEED_RINT_DEC */
/* #undef RETSIGTYPE */
/* #undef pid_t */
/* #undef uid_t */
/* #undef gid_t */
/* #undef size_t */
/* #undef vfork */
#if (defined(sparc) && defined(sun))
  #define vfork fork
#endif
/* #undef NO_PATH_MAX */
/* #undef inline */

#ifdef COW
/* #undef HAVE_X11 */
/* #undef HAVE_WIN32 */
/* #undef HAVE_XPM */
/* #undef HAVE_X11_XPM_H */

/* Autodetection error with GNU win32 */
#ifdef HAVE_WIN32
#define HAVE_STRCMPI
#define HAVE_STRNCMPI
#endif

#endif

#ifdef SERVER
/* paths substituted by configure, see AC_DEFINE_UNQUOTED in configure.in */
#define LIBDIR "/Users/Shared/MacTrek/Server/lib"
#define BINDIR "/Users/Shared/MacTrek/Server/bin"
#define SYSCONFDIR "/Users/Shared/MacTrek/Server/etc"
#define LOCALSTATEDIR "/Users/Shared/MacTrek/Server/var"

/* System dependend programs */
#define UPTIME "/usr/ucb/uptime"
#define NETSTAT "/bin/true"

/*  UDP connection timeout fix for SYSV machines */
#ifdef HAVE_UNISTD_H
#define UDP_FIX
#endif
#endif

/* System dependend macros						*/

/* SYSV signal handling */
#ifdef SYSV_SIGNALS
#include <signal.h>
#define SIGNAL(x,y)   sigset(x,y)
#define PAUSE(x)      sigpause(x)
#define SIGSETMASK(x) { }
#else
#define SIGNAL(x,y)   signal(x,y)
#define PAUSE(x)      pause()
#define SIGSETMASK(x) sigsetmask(x)
#endif

#ifdef POSIX_SIGNALS
#define HANDLE_SIG(s,h)	signal(s,h)
#define setjmp(x) sigsetjmp(x,1)
#define longjmp(x,y) siglongjmp(x,y)
#else
#define HANDLE_SIG(s,h) {}
#endif

#ifdef STDC_HEADERS
#define INC_STRINGS	<string.h>
#else
#define INC_STRINGS	<strings.h>
#endif

#if (defined(HAVE_RANDOM) && defined(HAVE_SETSTATE)) || !defined(HAVE_RANDOM)
#define RANDOM()        random()
#define SRANDOM(x)      srandom(x)
#else
#define RANDOM()        rrandom()
#define SRANDOM(x)      ssrandom(x)
extern void ssrandom ();
extern long rrandom ();
#endif

#if !defined(HAVE_RANDOM)
extern void srandom ();
extern long random ();
#endif

#if (SIZEOF_LONG == 8)
#define _64BIT
#define LONG int
#define U_LONG u_int
#else
#define LONG long
#define U_LONG u_long
#endif

/*	Some Server specific programs */
#ifdef SERVER

#include <sys/types.h>
/* SYSV Types */
#ifdef NO_U_INT
#define u_char unchar
#define u_int uint
#define u_long ulong
#define u_short ushort
#endif

#ifdef HAVE_UNISTD_H
#if defined (hpux) || defined(__osf__)
#define SETPGRP()       setsid()
#else
#if defined (linux) || defined(sgi) || (defined(sparc) && defined(sun))
#define SETPGRP()       setpgrp()
#else
#define SETPGRP()       setpgrp ()
#endif
#endif
#else
#define SETPGRP()       setpgrp (0, getpid())
#endif

#ifdef _SEQUENT_
#define PERMS O_RDWR | O_NOCTTY
#else
#define PERMS O_RDWR
#endif

#if defined(HAVE_UNISTD_H) && defined(TIOCTTY)
#define IOCTL(i) \
        int zero = 0;                           \
        (void) ioctl (i, TIOCTTY, &zero);
#else
#if defined(TIOCNOTTY)
#define IOCTL(i) \
        (void) ioctl (i, TIOCNOTTY, (char *) 0);
#else
#define IOCTL(i)
#endif
#endif

#define DETACH {\
    int i;                                                      \
    if ((i = open("/dev/tty", PERMS, 0)) >=0) {                 \
        IOCTL(i)                                                \
        (void) close (i);                                       \
    }                                                           \
    SETPGRP();                                                  \
    }

#ifdef HAVE_USLEEP
#define USLEEP(x)       usleep(x)
#else
#define USLEEP(x)       microsleep(x)           /* from util.c */
#endif

#if defined (SunOS)            /*  this core dumps with SIGSEGV on a sparc-10 */
#define LONGJMP(x,y)    return;
#else
#define LONGJMP(x,y)    longjmp(x,y);
#endif

#if defined (hpux)
#define PCLOSE(x)       fclose(x)
#else
#define PCLOSE(x)       pclose(x)
#endif

#if defined (__sequent__)
#define WAIT_TYPE    union wait
#define WSTOPSIG(foo)   0
#else
#define WAIT_TYPE int
#endif

#endif		/* SERVER programs */


/*  System dependend Include files */

#ifdef SERVER
#define NULLFILE		"../null"
#else
#define NULLFILE        	"null"
#endif

#ifdef NEED_SYS_SELECT_H
#define INC_SYS_SELECT <sys/select.h>
#ifdef SERVER
/* fd_set is used in data.h of the server */
#include <sys/select.h>
#endif
#else
#define INC_SYS_SELECT NULLFILE
#endif
#define SELECT select

#ifdef HAVE_UNISTD_H
#define INC_UNISTD      <unistd.h>
#else
#define INC_UNISTD      NULLFILE
#endif

#ifdef HAVE_SYS_SIGNAL_H
#define INC_SYS_SIGNAL   <sys/signal.h>
#else
#define INC_SYS_SIGNAL   NULLFILE
#endif

#ifdef HAVE_SYS_FCNTL_H
#define INC_SYS_FCNTL   <sys/fcntl.h>
#else
#define INC_SYS_FCNTL   NULLFILE
#endif

#ifndef VMS
#ifdef HAVE_FCNTL_H
#define INC_FCNTL       <fcntl.h>
#else
#define INC_FCNTL       NULLFILE
#endif
#else
#define INC_FCNTL 	<file.h>
#endif


/* Some systems don't include <sys/time.h> in <time.h>  */
#if defined(TM_IN_SYS_TIME) || defined(NEED_SYS_TIME_H)
#define INC_SYS_TIME <sys/time.h>
#else
#define INC_SYS_TIME NULLFILE
#endif

#ifdef HAVE_SYS_PTYIO_H
#define INC_SYS_PTYIO <sys/ptyio.h>
#else
#define INC_SYS_PTYIO NULLFILE
#endif

#ifdef HAVE_CTYPE_H
#define INC_CTYPE	<ctype.h>
#else
#define INC_CTYPE 	NULLFILE
#endif

#ifdef HAVE_MACHINE_ENDIAN_H
#define INC_MACHINE_ENDIAN <machine/endian.h>
#else
#define INC_MACHINE_ENDIAN NULLFILE
#endif

#ifdef HAVE_SYS_RESOURCE_H
#define INC_SYS_RESOURCE <sys/resource.h>
#else
#define INC_SYS_RESOURCE NULLFILE
#endif

#ifdef HAVE_SYS_WAIT_H
#define INC_SYS_WAIT 	<sys/wait.h>
#else
#define INC_SYS_WAIT 	NULLFILE
#endif
 
#ifdef HAVE_NETINET_IN_H
#define INC_NETINET_IN 	<netinet/in.h>
#else
#define INC_NETINET_IN 	NULLFILE
#endif 

/* Replace outdated ftime with gettimeofday */
#if defined(HAVE_SYS_TIMEB_H) && defined(HAVE_FTIME)
#define INC_SYS_TIMEB   <sys/timeb.h>
#else
#define NOTIMEB
#define INC_SYS_TIMEB   <sys/time.h>
#endif

#ifdef HAVE_GMP2_H
#define INC_MP <gmp.h>
#define MPTYPEDEF typedef mpz_t MPTYPE; 

#define assignItom(x,i) {mpz_init(x); mpz_set_ui(x,i);}
#define madd(x, y, z) mpz_add(z, x, y)
#define msub(x, y, z) mpz_sub(z, x, y)
#define mult(x, y, z) mpz_mul(z, x, y)
#define mdiv(n, d, q, r) mpz_fdiv_qr(q, r, n, d)
#define sdiv(n, d, q, r) *r = mpz_fdiv_q_ui(q, n, d)
#define msqrt(x, y, z) mpz_sqrt(z, x, y)
#define mp_pow(x, y, z, a) mpz_powm(a, x, y, z)
#define gcd(x, y, z) mpz_gcd(z, x, y)
#define mcmp(x, y) mpz_cmp(x, y)
#define min(x) mpz_min(x)
#define mout(x) mpz_mout(x)
#define mfree(x) mpz_clear(x)
 
#else
#define MPTYPEDEF typedef MINT *MPTYPE;
#define assignItom(x,i) x= itom(i)
#define mp_pow(x, y, z, a) pow(x, y, z, a)
#define INC_MP <mp.h>
#endif

#ifdef NO_PATH_MAX
#define PATH_MAX 255
#define INC_LIMITS	NULLFILE
#else
#define INC_LIMITS	<limits.h>
#endif

#ifdef HAVE_XPM
#ifdef HAVE_X11_XPM_H
#define INC_XPM <X11/xpm.h>
#else
#define INC_XPM <xpm.h>
#endif
#else
#define INC_XPM NULLFILE
#endif

/* Unchecked machine dependencies */

#ifdef linux
#define SHMFLAG         sizeof(struct memory)
#else
#define SHMFLAG         0
#endif

#if defined(sun3)
#define INC_STDLIB 	NULLFILE
#else
#define INC_STDLIB	<stdlib.h>
#endif

#ifndef sun4
#if defined(HAVE_NINT) && defined(HAVE_MATH_H)
#define INC_MATH	<math.h>
#else
#if defined(NEED_RINT_DEC)
extern double rint(double);
#define INC_MATH        NULLFILE
#else
#define INC_MATH        <math.h>
#endif
#define  nint(x) ((int) rint(x))
#endif
#endif

#ifdef VMS
#define  R_OK  04
typedef unsigned short int ushort;
#define Sin sinetable
#define Cos cosinetable
#define strncasecmp strncmp
#include <socket.h>    /* for struct timeval */
#include "vmsutils.h"  /* for typedef fd_set & FD_ macros */
#endif

/*
   Some systems, most notably SunOS 4.1.3, don't include function definitions
   in the libraries.  This results in some warning we don't want.
   This header defines the type for all these functions.
*/

#ifdef sun4
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>

int close(int);
int connect(int, struct sockaddr *, int);
int fprintf(FILE *, const char *, ...);
int fputs(char *, FILE *);
char *memccpy(char *, char *, int, int);
int perror(char *);
int socket(int, int, int);
int sscanf(char *, char *, ...);
char *strdup(char *arg);

char _filbuf(FILE *);
int _flsbuf(unsigned char, FILE *);

#endif /* defined sun4 */

#ifdef WIN32
typedef unsigned short int ushort;
#define strncasecmp strncmp
#ifdef THREADED
#define THREAD(fn) { DWORD junk; CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)f
#define ENDTHREAD ExitThread(0);
typedef unsigned long int SEMAPHORE;
#define CREATE_SEMAPHORE(initstate) CreateEvent(NULL, 1, initstate, NULL)
#define SET_SEMAPHORE(sem) SetEvent((HANDLE)sem)
#define RESET_SEMAPHORE(sem) ResetEvent((HANDLE)sem)
#endif
#endif

#ifdef _MSC_VER
#define INC_STRINGS     <ntstring.h>
#define INC_IO     <ntio.h>
#else
#define INC_IO       NULLFILE
#endif

	/* Solaris specific stuff */

#if defined(HAVE_SYS_FILIO_H)
#define INC_SYS_FILIO <sys/filio.h>
#else
#define INC_SYS_FILIO NULLFILE
#endif

#endif  /* __CONFIG_H */
