/*
 * tapeIoctl.c
 *
 * Description : fixed block writing
 *
 * Written by Const Olchanski 11 Apr 1992, 6 Sept 1992,
 *                            26 Apr 1993
 *
 *
*/

static const char sccsid[] = "@(#)"__FILE__"\t5.2\tCreated 7/27/97 19:51:53, \tcompiled "__DATE__;

#include <tapeIO.h>

/* Note: define DO_ALARMS is you want 'tapeIoctl.xxx()' functions
         send alarms.
	 Default is no alarms- these are very low level routines
	 and some of them are expected to fail during normal operation
	 (for example skip to EOD). The upper level functions
	 should detect and generate their own alarms.
   [Const Olchanski, 23 Jan 1994]
*/


/*
#define DO_ALARMS
*/

#ifdef DONOT_DO_ALARMS
#undef DO_ALARMS
#endif

#ifdef DO_ALARMS
#include <alarm.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <errno.h>

#ifdef sgi

#include <unistd.h>
#include <fcntl.h>

#ifdef UNDEF
/*#include <sys/sysmacros.h>*/
#include <sys/mkdev.h>
#include <sys/stat.h>
#endif

#include <sys/mtio.h>


extern int ioctl(int,int,...); /* FIXME, I did not found
				  any ioctl() prototypes
				  in *.h files
			       */

#endif

#ifdef _AIX

#include <sys/tape.h>

#define mtop     stop
#define mt_op    st_op
#define mt_count st_count

#define MTIOCTOP  STIOCTOP
#define MTREW     STREW
#define MTUNLOAD  STEJECT
#define MTWEOF    STWEOF
#define MTFSF     STFSF
#define MTBSF     STRSF
#define MTFSR     STFSR
#define MTBSR     STBSR

#endif

#ifdef DECUNIX

#include <sys/ioctl.h>
#include <sys/mtio.h>

#endif

#ifdef linux

#include <sys/mtio.h>

#endif

#if (defined(sgi)||defined(_AIX)||defined(DECUNIX)||defined(linux))

int tape_rewind(int fd)
{
  struct mtop cmd;
  int err;
  
  err = tape_flush(fd);
  if (err) return err;

  cmd.mt_op = MTREW;
  cmd.mt_count = 1;

  err = ioctl(fd, MTIOCTOP, &cmd);
  if (err<0)
    {
      fprintf(stderr,"tapeIO.rewind: ioctl(fd,MTIOCTOP,MTREW) failed: %s\n",strerror(errno));
#ifdef DO_ALARMS
      esend(ALARM_ERROR,"tapeIO.rewind: ioctl(fd,MTIOCTOP,MTREW) failed","%s\n",strerror(errno));
#endif
      return err;
    }
  return 0;
}

#else

int tape_rewind(int fd)
{
  fprintf(stderr,"tapeIO.rewind: Unsupported operation\n");
#ifdef DO_ALARMS
  esend(ALARM_WARNING,"tapeIO.rewind: Unsupported operation","");
#endif
  return -1;
}

#endif

#if (defined(sgi)||defined(_AIX)||defined(DECUNIX)||defined(linux))

int tape_unload(int fd)
{
  struct mtop cmd;
  int err;
  
  err = tape_flush(fd);
  if (err) return err;

  cmd.mt_op = MTUNLOAD;
  cmd.mt_count = 1;

  err = ioctl(fd, MTIOCTOP, &cmd);
  if (err<0)
    {
      fprintf(stderr,"tapeIO.unload: ioctl(fd,MTIOCTOP,MTUNLOAD) failed: %s\n",strerror(errno));
#ifdef DO_ALARMS
      esend(ALARM_ERROR,"tapeIO.unload: ioctl(fd,MTIOCTOP,MTUNLOAD) failed","%s\n",strerror(errno));
#endif
      return err;
    }
  return 0;
}

#else

int tape_unload(int fd)
{
  fprintf(stderr,"tapeIO.unload: Unsupported operation\n");
#ifdef DO_ALARMS
  esend(ALARM_WARNING,"tapeIO.unload: Unsupported operation","");
#endif
  return -1;
}

#endif
#if (defined(sgi)||defined(_AIX)||defined(DECUNIX)||defined(linux))

int tape_writeFM(int fd)
{
  struct mtop cmd;
  int err;
  
  err = tape_flush(fd);
  if (err) return err;

  cmd.mt_op = MTWEOF;
  cmd.mt_count = 1;

  err = ioctl(fd, MTIOCTOP, &cmd);
  if (err<0)
    {
      fprintf(stderr,"tapeIO.writeFM: ioctl(fd,MTIOCTOP,MTWEOF) failed: %s\n",strerror(errno));
#ifdef DO_ALARMS
      esend(ALARM_ERROR,"tapeIO.writeFM: ioctl(fd,MTIOCTOP,MTWEOF) failed","%s\n",strerror(errno));
#endif
      return err;
    }

  return 0;
}
#else

int tape_writeFM(int fd)
{
  fprintf(stderr,"tapeIO.writeFM: Unsupported operation\n");
#ifdef DO_ALARMS
  esend(ALARM_WARNING,"tapeIO.writeFM: Unsupported operation","");
#endif
  return -1;
}

#endif
#if (defined(sgi))

int tape_setBlockSize(int fd,unsigned long blockSize)
{
  struct mtop cmd;
  int err;

  cmd.mt_op = MTSCSI_SETFIXED;
  cmd.mt_count = (unsigned int)blockSize;

  err = ioctl(fd, MTIOCTOP, &cmd);
  if (err<0)
    {
      fprintf(stderr,"tapeIO.setBlockSize: ioctl(fd,MTIOCTOP,MTSCSI_SETFIXED) failed: %s\n",strerror(errno));
#ifdef DO_ALARMS
      esend(ALARM_ERROR,"tapeIO.setBlockSize: ioctl(fd,MTIOCTOP,MTSCSI_SETFIXED) failed","%s\n",strerror(errno));
#endif
      return err;
    }

  return 0;
}
#else

int tape_setBlockSize(int fd,unsigned long blockSize)
{
  fprintf(stderr,"tapeIO.setBlockSize: Unsupported operation\n");
#ifdef DO_ALARMS
  esend(ALARM_WARNING,"tapeIO.setBlockSize: Unsupported operation","");
#endif
  return -1;
}

#endif
#if (defined(sgi))

int tape_getState(int fd)
{
  struct mtop cmd;
  struct mtget info;
  int err;

  cmd.mt_op = MTNOP;
  cmd.mt_count = 1;

  err = ioctl(fd, MTIOCTOP, &cmd);
  if (err<0)
    {
      fprintf(stderr,"tapeIO.getState: ioctl(fd,MTIOCTOP,MTNOP) failed: %s\n",strerror(errno));
#ifdef DO_ALARMS
      esend(ALARM_ERROR,"tapeIO.getState: ioctl(fd,MTIOCTOP,MTNOP) failed","%s\n",strerror(errno));
#endif
      return err;
    }

  err = ioctl(fd, MTIOCGET, &info);
  if (err<0)
    {
      fprintf(stderr,"tapeIO.getState: ioctl(fd,MTIOCGET) failed: %s\n",strerror(errno));
#ifdef DO_ALARMS
      esend(ALARM_ERROR,"tapeIO.getState: ioctl(fd,MTIOCGET) failed","%s\n",strerror(errno));
#endif
      return -1;
    }

  return info.mt_dposn;
}
#else

int tape_getState(int fd)
{
  fprintf(stderr,"tapeIO.getState: Unsupported operation\n");
#ifdef DO_ALARMS
  esend(ALARM_WARNING,"tapeIO.getState: Unsupported operation","");
#endif
  return -1;
}

#endif
#if defined(sgi)

unsigned long tape_getPosition(int fd)
{
  struct mtget info;
  int err;
  
  err = ioctl(fd, MTIOCGET, &info);
  if (err<0)
    {
      perror("tapeIO.getPosition: ioctl(fd,MTIOCGET) failed");
#ifdef DO_ALARMS
      esend(ALARM_ERROR,"tapeIO.getPosition: ioctl(fd,MTIOCGET) failed","%s\n",strerror(errno));
#endif
      return err;
    }

  return info.mt_blkno;
}

#else

unsigned long tape_getPosition(int fd)
{
  fprintf(stderr,"tapeIO.getPosition: Unsupported operation\n");
#ifdef DO_ALARMS
  esend(ALARM_WARNING,"tapeIO.getPosition: Unsupported operation","");
#endif
  return -1;
}

#endif
#if defined(sgi)

int tape_getBlockSize1(int fd)
{
  struct mtblkinfo info;
  int ret;
  int val;

  ret = ioctl(fd, MTIOCGETBLKSIZE, &val);

  if (ret<0)
    {
      if (errno==ENOTTY) return ret;
      perror("tapeIO.getBlockSize: ioctl(fd,MTIOCGETBLKSIZE,...) failed");
#ifdef DO_ALARMS
      esend(ALARM_ERROR,"tapeIO.getBlockSize: ioctl(fd,MTIOCGETBLKSIZE) failed","%s\n",strerror(errno));
#endif
      return ret;
    }

  return val*512;
}

#else

int tape_getBlockSize1(int fd)
{
  fprintf(stderr,"tapeIO.setBlockSize1: Unsupported operation\n");
#ifdef DO_ALARMS
  esend(ALARM_WARNING,"tapeIO.setBlockSize1: Unsupported operation","");
#endif
  return -1;
}

#endif
#if defined(sgi)

int tape_getBlockSize(int fd,unsigned long*minSize,unsigned long*maxSize,unsigned long*recSize)
{
  struct mtblkinfo info;
  int err;

  err = ioctl(fd, MTIOCGETBLKINFO, &info);
  if (err<0)
    {
      if (errno==ENOTTY) return err;
      perror("tapeIO.getBlockInfo: ioctl(fd,MTIOCGETBLKINFO,...) failed");
#ifdef DO_ALARMS
      esend(ALARM_ERROR,"tapeIO.getBlockInfo: ioctl(fd,MTIOCGETBLKSIZE) failed","%s\n",strerror(errno));
#endif
      return err;
    }

  if (minSize!=NULL) *minSize = info.minblksz;
  if (maxSize!=NULL) *maxSize = info.maxblksz;
  if (recSize!=NULL) *recSize = info.recblksz;

  return info.curblksz;
}

#else

int tape_getBlockSize(int fd,unsigned long*minSize,unsigned long*maxSize,unsigned long*recSize)
{
  fprintf(stderr,"tapeIO.setBlockSize: Unsupported operation\n");
#ifdef DO_ALARMS
  esend(ALARM_WARNING,"tapeIO.setBlockSize: Unsupported operation","");
#endif
  return -1;
}

#endif
#if (defined(sgi)||defined(_AIX)||defined(DECUNIX)||defined(linux))

int tape_findFM(int fd,int count)
{
  struct mtop cmd;
  int err;
  
  err = tape_flush(fd);
  if (err) return err;

  cmd.mt_count = 0;
  cmd.mt_op = MTFSF;

  if (count > 0) cmd.mt_op = MTFSF;
  if (count < 0) cmd.mt_op = MTBSF;

  if (count > 0) cmd.mt_count = count;
  if (count < 0) cmd.mt_count = -count;

  if (cmd.mt_count == 0) return 0;

  err = ioctl(fd, MTIOCTOP, &cmd);
  if (err<0)
    {
      fprintf(stderr,"tapeIO.findFM: ioctl(fd,MTIOCTOP,MTxSF) failed: %s\n",strerror(errno));
#ifdef DO_ALARMS
      esend(ALARM_ERROR,"tapeIO.findFM: ioctl(fd,MTIOCTOP,MTxSF) failed","%s",strerror(errno));
#endif
      return err;
    }

  return 0;
}

#else

int tape_findFM(int fd,int count)
{
  fprintf(stderr,"tapeIO.findFM: Unsupported operation\n");
#ifdef DO_ALARMS
  esend(ALARM_WARNING,"tapeIO.findFM: Unsupported operation","");
#endif
  return -1;
}

#endif

#include <sys/types.h>
#include <sys/stat.h>

int tape_devType(int fd)
{
  int ret;
  struct stat statbuf;

  ret = fstat(fd,&statbuf);

#ifdef UNDEF
  fprintf(stderr,"fd %d: st_mode 0x%x, st_ino %d, st_dev %d, st_rdev %d, st_size %d, st_blksize %d, st_blocks %d\n",
	  fd,
	  statbuf.st_mode,
	  statbuf.st_ino,
	  statbuf.st_dev,
	  statbuf.st_rdev,
	  statbuf.st_size,
	  statbuf.st_blksize,
	  statbuf.st_blocks);
#endif

  if (S_ISFIFO(statbuf.st_mode)||S_ISSOCK(statbuf.st_mode))
    {
      /* fprintf(stderr,"tapeIO.devType: fd %d is a pipe.\n",fd); */
      return TAPEIO_PIPE;
    }

  if (S_ISREG(statbuf.st_mode))
    {
      /* fprintf(stderr,"tapeIO.devType: fd %d is a regular file.\n",fd); */
      return TAPEIO_STREAM;
    }

  if (S_ISCHR(statbuf.st_mode))
    {
      int isVar = 1; /* will not bother with determining
			variable versus fixed blocksize tape
			devices. Assume it is variable */

      /* ok. this is a char device. Maybe it is a tape? */

#if defined(MTCAN_CHKRDY)&&defined(MTCAPABILITY)
      {
	struct mt_capablity mtcan;
	int mtshoulddo = MTCAN_CHKRDY;
	
	ret = ioctl(fd,MTCAPABILITY,&mtcan);
	if (ret==0)
	  {
	    int isVar;
	    
	    if ((mtcan.mtcapablity & mtshoulddo) != mtshoulddo)
	      {
		fprintf(stderr,"tapeIO.devType: fd %d is tape but looks funny to me. Check tapeIO source code.\n",fd);
	      }
	    
	    isVar = 1; /* assume tape device is always variable... there is no good way to find out otherwise... */
	    
	    if (isVar)  return TAPEIO_VARIABLE;
	    else        return TAPEIO_FIXED;
	  }

	return TAPEIO_STREAM;
      }
#endif
#if defined(MTFSR)&&defined(MTIOCTOP)
      {
	struct mtop mtop;

	mtop.mt_op = MTFSR;   /* I want a No-op operation. Forward zero blocks should do. */
	mtop.mt_count = 0;
	
	ret = ioctl(fd,MTIOCTOP,&mtop);

	if (ret==0)
	  {
	    if (isVar)  return TAPEIO_VARIABLE;
	    else        return TAPEIO_FIXED;
	  }
	
	switch (errno)
	  {
	  default:
	    fprintf(stderr,"tapeIO.devType: ioctl(MTIOCTOP,...) returned %d, errno: %d, %s\n",ret,errno,strerror(errno));
	    
	    break;
#ifdef linux
	  case EINVAL:
#endif
	  case ENODEV:
	  case ENOTTY:
	    break;
	  }
      }
#endif
    }

  return TAPEIO_STREAM;
}

#ifdef UNDEF

int tape_devType(int fd)
{
  int ret;
  int isVar;

  struct mtop mtop;

  mtop.mt_op = MTFSR;   /* I want a No-op operation. Forward zero blocks should do. */
  mtop.mt_count = 0;

  ret = ioctl(fd,MTIOCTOP,&mtop);

  if (ret)
    switch (errno)
      {
      default:
	fprintf(stderr,"tapeIO.devType(AIX/DECUNIX/linux): ioctl(MTIOCTOP,...) returned %d, errno: %d, %s\n",ret,errno,strerror(errno));
	
	break;
#ifdef linux
      case EINVAL:
#endif
      case ENODEV:
      case ENOTTY:
	break;
      }

  if (ret) return TAPEIO_STREAM;

  isVar = 1; /* assume tape device is always variable... */

  if (isVar)  return TAPEIO_VARIABLE;
  else        return TAPEIO_FIXED;
}

int tape_devType(int fd)
{
  int ret;

  fprintf(stderr,"tapeIO.devType: fd %d: Do not know how to determine device type, assuming it's a STREAM.\n",fd);
#ifdef DO_ALARMS
  esend(ALARM_WARNING,"tapeIO.devType: assuming STREAM device type","");
#endif
  return TAPEIO_STREAM;
}

#endif

/* end file */
