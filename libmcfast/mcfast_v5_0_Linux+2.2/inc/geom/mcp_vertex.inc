c  Primary vertex position

      structure /beam_vertex_struct/
        real pos(3)             !Vertex position
        real sigma(3)           !Sigma of (x,y,z)
      end structure

      record /beam_vertex_struct/ beam_vertex

      common/beam_vertex1/
     *  beam_vertex
