
upcase(char *inp_string) {

      int i, count ;

      count = strlen(inp_string) ;

      for (i=0; i<count; i++) {
       if (*inp_string >= 'a' && *inp_string <= 'z') 
        *inp_string = *inp_string + 'A' - 'a' ;
       *inp_string = *inp_string++ ;
      } 

      return ;
}
