      structure /geom_struct/
        integer		type		! type of volume
        integer 	id_number	! Identifies item to users
        integer         iname		! name, to refer to an element or medium
        integer 	id_parent	! The parent id number
        integer 	num_child	! The number of children
        integer 	children	! Position of first child
        real 	        xpos		! The x position of the object (center)
        real       	ypos		! The y position
        real            zpos		! The z position
        real            rotation(3)	! The rotation matrix
        real            color(3)      	! RGB values defining color 
        real            transparency	! Transparency
        integer 	visibility	! If flag set to 0, graphics not drawn
      end structure
