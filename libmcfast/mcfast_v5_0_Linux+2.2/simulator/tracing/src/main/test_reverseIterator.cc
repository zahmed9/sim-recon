#include <vector>

int main()
{

   vector< int > vecInt;
   for( int i=0; i<5; ++i ) {
      vecInt.push_back( i );
   }
   
   vector< int >::iterator it;
   vector< int >::reverse_iterator rit;

   cout << "Printing in normal order:" << endl;
   vector< int >::iterator itEnd = vecInt.end();
   for( it = vecInt.begin();
	it != itEnd;
	++it
      )
   {
      cout << *it << endl;
   }

   cout << "Printing in reverse order:" << endl;
   vector< int >::reverse_iterator ritEnd = vecInt.rend();
   for( rit = vecInt.rbegin();
	rit != ritEnd;
	++rit
      )
   {
      cout << *rit << endl;
   }

   it = vecInt.begin();
   ++it;
   cout << "Printing next-to-first element: " << *it << endl;

   rit = vecInt.rbegin();
   ++rit;
   cout << "Printing next-to-first reverse element: " << *rit << endl;

   vector< int >::reverse_iterator nrit( it );
   cout << "Printing new reverse iterator: " << *nrit << endl;

   rit = it+1;
   cout << "Printing assigned reverse element: " << *rit << endl;

   it = rit.base();
   cout << "Printing assigned element: " << *it << endl;


   // -------------------------------------------------------

   cout << "----------------------------" << endl;
   it = vecInt.begin();
   cout << "Printing first element: " << *it << endl;

   vector< int >::reverse_iterator newrit = it+1;
   cout << "Printing first element through reverse ctor: " << *newrit << endl;

   rit = it+1;
   cout << "Printing first element through reverse ass: " << *rit << endl;

   it = newrit.base()-1;
   cout << "Printing assigned first element: " << *it << endl;
   cout << "----------------------------" << endl;

}
