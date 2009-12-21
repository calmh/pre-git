#include "junle.h"

#define TAG_HEAD "TAG"

struct _MP3_TAG
{
  char Title[31];
  char Artist[31];
  char Album[31];
  char Year[5];
  char Comment[31];
  char Junle;
};

typedef struct _MP3_TAG MP3_TAG;

int read_tag ( char *file_name, MP3_TAG *tag );
void sp_cut(char *buff, int l);

/* ID TAGの読み込み */
int read_tag ( char *file_name, MP3_TAG *tag )
{
  FILE *fp;

  char TAG_BUFF[129];

  tag->Title[0]=0;
  tag->Artist[0]=0;
  tag->Album[0]=0;
  tag->Comment[0]=0;
  tag->Year[0]=0;
  tag->Junle=-1;

  fp=fopen(file_name,"r");
  if ( fp == NULL ) return ( -2 );
  fseek(fp, -128, SEEK_END);
  if(fgets(TAG_BUFF,129,fp)==NULL){
    fclose(fp);
    return ( -2 );
  }
  fclose(fp);

  if (strncmp(TAG_BUFF, TAG_HEAD, 3)!=0) return ( 0 );

  tag->Junle=TAG_BUFF[127];

  /* ID TAGの取りだし */
  strncpy ( tag->Title, &TAG_BUFF[3], 30 );
  sp_cut(tag->Title, 30);

  strncpy ( tag->Artist, &TAG_BUFF[33], 30 );
  sp_cut(tag->Artist,30);

  strncpy ( tag->Album, &TAG_BUFF[63], 30 );
  sp_cut(tag->Album,30);

  strncpy ( tag->Year, &TAG_BUFF[93], 4 );
  sp_cut(tag->Year,4);

  strncpy ( tag->Comment, &TAG_BUFF[97], 30 );
  sp_cut(tag->Comment,30);
  
  return ( 1 );
}

/* Spaceをカット */
void sp_cut(char *buff, int l)
{
  int i;

  for ( i =(l-1); i >= 0; i -- ){
    if ( *(buff+i) == 0x20 )
      *(buff+i)='\0';
    else
      break;
  }
}


