#if defined(c_plusplus) || defined(__cplusplus)
extern "C" {
#endif
int Mcf_ReadEvent(int stream,int *nevent);
int Mcf_ReadSpecEvent(int stream, int nevent);
int Mcf_GetEvent(int stream);
int Mcf_OpenFile(char *filename);
int Mcf_ReadGeom(int stream);
void Mcf_CloseStream(int stream);
#if defined(c_plusplus) || defined(__cplusplus)
}
#endif
