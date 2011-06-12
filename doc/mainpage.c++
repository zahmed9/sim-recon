// This file contains the content included on the main page of
// the Hall-D software documentaion generated by doxygen. It
// has a suffix of .c++ just to make doxygen find it.

/**
	\mainpage Hall-D Analysis Software
	
	\section intro Introduction

	This documentation was generated automatically from the source
	code using the doxygen program. The content of this page is
	taken from the file sim-recon/src/doc/mainpage.c++

	Use the links at the top to help navigate through this documentation.
	Use the search form to search the documentation.

	To view repository statistics, <A href="SVNstats">look here</A>.

	\section starting Getting Started

	The Hall-D reconstruction software is built upon the C++ <A href="http://www.jlab.org/JANA">JANA</A>
	framework. The JANA framework was designed for Hall-D but is maintained separately as an
	independent project and contains no Hall-D specific source code. The Hall-D specific reconstruction
	software based on JANA is often referred to as <i>DANA</i>.
	
	In broad terms, the JANA framework distinguishes between data classes and algorithm classes.
	Data classes generally have data members with no more than trivial methods defined. The algorithm
	classes are where the real work is done. These classes are called <i>factories</i> in JANA.
	The framework itself is repsonsible for passing pointers to the data objects between the factories
	that make them.
	
	For example, a factory that makes calorimeter cluster objects does so by using calorimeter
	hit objects as inputs. The cluster making factory requests the hit objects from the JANA framework
	whose job is to locate them and return their pointers.
	
	This design provides a loose coupling between the factory classes and the data classes. The
	factory needing a type of data object as input doesn't need direct knowledge of the factory that
	actually generates those objects. Furthermore, multiple factory classes can exist that
	implement different algorithms, but deliver the same type of data objects. Which exact algorithm
	that is used can be specified by the user at run time rather than at compile time.
	
	Below is a thumbnail of the call graph between factories implemented in DANA. Click on it to get
	a larger picture where individual factories can be clicked to jump to the corresponding 
	page. In the image, the "first" request comes at the top from the JEventProcessor object asking
	for DPhysicsEvent objects. The DPhysicsEvent algorithm requires other inputs as shown by the
	arrows. Eventually, requests lead back to data from the input file which at the classes shown
	in green trapazoids at the bottom of the graph.
	
	\htmlonly
	<center>
	<A href="jana_map.html" target="jana_map"> <IMG src="jana_map.gif" height="200"></A>
	</center>
	\endhtmlonly

	It should be noted that not all classes in the Hall-D reconstruction software show up in this
	call graph. Deprecated classes and alternate algorithms that aren't part of the default
	reconstruction as well as utility classes that aren't passed through the framework won't
	show up here. The plot itself is generated automatically by JANA using the <i>janadot</i>
	plugin and specifying only the defaults be used.
	
*/

