#include "displayTypes.hh"
void plotTypeInitialize(displayType *temp)
{
     temp->type = NOPLOT;
     temp->action = NOACTION;
}
void plotTypeSet(displayType set, displayType *temp)
{
     if( set.type != SAMEPLOT ) temp->type = set.type;
     temp->action = set.action;
}
