      FUNCTION between(x,x1,x2) ! between: x between {x1,x2}
      implicit none                    
      LOGICAL between                                                           
      REAL x,x1,x2 
                                                                   
      between = x.GT.x1 .AND. x.LT.x2                                           
     >         .OR.                                                             
     >          x.LT.x1 .AND. x.GT.x2
                                                
      RETURN                                                                    
      END                                                                       

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:26  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:02  garren
c add rcs log line
c
