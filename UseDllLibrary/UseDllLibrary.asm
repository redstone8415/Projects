
 

#include <windows.h>  
#include <commctrl.h>  
#include <richedit.h>  
#include "resource.h"  
  
;Dialog resources  

LANGUAGE LANG_NEUTRAL, SUBLANG_NEUTRAL  
IDD_DIALOG1 DIALOG 0, 0, 229, 121  
STYLE DS_3DLOOK | DS_CENTER | DS_MODALFRAME | WS_CAPTION | WS_VISIBLE | WS_POPUP | WS_SYSMENU  
CAPTION "DLL����"  
FONT 8, "Ms Shell Dlg"  
{  
    LTEXT           "%", 0, 80, 91, 6, 9, SS_LEFT, WS_EX_LEFT  
    LTEXT           "0", IDC_MOD, 183, 90, 30, 13, SS_LEFT, WS_EX_STATICEDGE  
    LTEXT           "=", 0, 165, 92, 5, 9, SS_LEFT, WS_EX_LEFT  
    EDITTEXT        IDC_NUM2, 99, 90, 52, 12, ES_AUTOHSCROLL, WS_EX_LEFT  
    EDITTEXT        IDC_NUM1, 25, 90, 48, 12, ES_AUTOHSCROLL, WS_EX_LEFT  
    GROUPBOX        "ȡģ��������", 0, 16, 73, 208, 32, 0, WS_EX_STATICEDGE  
    LTEXT           "", IDC_COUNT, 31, 35, 100, 10, SS_LEFT, WS_EX_STATICEDGE  
    GROUPBOX        "DLL �ڲ�������", 0, 16, 19, 206, 34, 0, WS_EX_STATICEDGE  
    PUSHBUTTON      "����(&D)", IDC_DEC, 181, 32, 34, 14, 0, WS_EX_LEFT  
    DEFPUSHBUTTON   "����(&A)", IDC_INC, 141, 32, 34, 14, 0, WS_EX_LEFT  
}  
  
 Icon resources  
  
LANGUAGE LANG_NEUTRAL, SUBLANG_NEUTRAL  
IDI_ICON1          ICON           "icon1.ico"  


 .386  
.model flat, stdcall  
option casemap :none
  
include		windows.inc  
include		user32.inc  
includelib	user32.lib  
include		kernel32.inc   
includelib	kernel32.lib  
include		DllLibrary.inc  
includelib	DllLibrary.lib  
  
  
IDI_ICON1       equ         100  
IDD_DIALOG1     equ         101  
IDC_DEC         equ         40000  
IDC_COUNT       equ         40001  
IDC_INC         equ         40002  
IDC_NUM1        equ         40003  
IDC_NUM2        equ         40004  
IDC_MOD         equ         40005  
  
.code  
_ProcDlgMain proc uses ebx edi esi hWnd,wMsg,wParam,lParam  
	mov eax,wMsg  
	.if eax ==WM_CLOSE  
		invoke EndDialog,hWnd,NULL  
	.elseif eax == WM_COMMAND  
	mov eax,wParam  
	.if ax ==IDC_INC  
		invoke _IncCounter								;�ڴ���ؼ�����Ϣ��ʱ��ֱ�ӵ���DLL���еĺ���
		invoke SetDlgItemInt,hWnd,IDC_COUNT,eax,FALSE		;ͬ�������������ĵ���һ����
	.elseif ax == IDC_DEC  
		invoke _DecCounter  
		invoke SetDlgItemInt,hWnd,IDC_COUNT,eax,FALSE  
	.elseif ax == IDC_NUM1 || ax == IDC_NUM2  
		invoke GetDlgItemInt,hWnd,IDC_NUM1,NULL,FALSE  
		push eax  
		invoke GetDlgItemInt,hWnd,IDC_NUM2,NULL,FALSE  
		pop ecx  
		invoke _Mod,ecx,eax  
		invoke SetDlgItemInt,hWnd,IDC_MOD,eax,FALSE  
	.endif  
	.else  
	mov eax,FALSE  
	ret  
	.endif  
	mov eax,TRUE  
	ret  
_ProcDlgMain endp 
 
start:  
	invoke GetModuleHandle,NULL  
	invoke DialogBoxParam,eax,IDD_DIALOG1,NULL,offset _ProcDlgMain,NULL  
	invoke ExitProcess,NULL  
end start 
