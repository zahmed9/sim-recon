/*======================================================================

Types out a prompt specified by the calling routine. Be careful to
copy the passed character string into a C type string.

printf would not work because the buffer would not empty without a 
newline character. This was true even when fflush was called.

======================================================================*/

#include <stdlib.h>
#include <stdio.h>

void cmd_prompt_(char *prompt, int len)
{
  int i, chr;

/* Turn off buffering and turn it on again after prompt is written*/
  if(len > 0) {
    setvbuf(stdout, NULL, _IONBF, 0);
    for (i=0; i<len; i++) {
      chr = prompt[i];
      putchar(chr);
    }
    setvbuf(stdout, NULL, _IOLBF, 0);
  }
}
