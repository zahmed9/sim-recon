      integer db_chlen,db_varlen,db_objlen,db_entr
      parameter (db_chlen=40,db_varlen=100,db_objlen=1000,db_entr=60)
      character varname*(db_chlen), template_object*(db_chlen), 
     >     objname*(db_chlen), template_name*(db_chlen)
      character*80 chvar(db_varlen)
      double precision dvar(db_varlen)
      real rvar(db_varlen)
      integer nvars,n_templates,n_totobjs,n_entries
      integer index_object, n_instance
      common /dbin_pc/ rvar, dvar, chvar, nvars, varname, objname,
     +  template_object(db_objlen),index_object(db_objlen),n_templates,
     >     n_totobjs,
     +  template_name(db_entr), n_entries(db_entr), n_instance
*
