#ifndef TRACECOMMON
#define TRACECOMMON
struct Points;
struct traceData;
int NumHepTrace(void);
int NumGoodTrace(void);
int getTraceData(int ihep, traceData *data);
int NumTracePoints(int ihep);
int FirstTracePoint(int ihep);
void GetTracePoint(int ihep, Points *trPoints);
char *traceMessage(int itrace);
#endif
