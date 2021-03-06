.386 
.model flat,stdcall 
option casemap:none 
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD 
include windows.inc 
include user32.inc 
include kernel32.inc 
includelib user32.lib 
includelib kernel32.lib 

.const 
IDM_CREATE_THREAD equ 1 
IDM_KILL_THREAD equ 2 
IDM_EXIT equ 3 
WM_FINISH equ WM_USER+100h 
WM_KILLTHREAD equ WM_USER+200h

.data 
ClassName db "Win32ASMThreadClass",0 
AppName  db "Win32 ASM MultiThreading Example",0 
MenuName db "FirstMenu",0 
SuccessString db "The calculation is completed!",0 
KillThreadString db "The Thread is Killed!",0
Flag db 0

.data? 
hInstance HINSTANCE ? 
CommandLine LPSTR ? 
hwnd HANDLE ? 
ThreadID DWORD ?
 

.code 
start: 
    invoke GetModuleHandle, NULL 
    mov    hInstance,eax 
    invoke GetCommandLine 
    mov CommandLine,eax 
    invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT 
    invoke ExitProcess,eax 

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD 
    LOCAL wc:WNDCLASSEX 
    LOCAL msg:MSG 
    mov   wc.cbSize,SIZEOF WNDCLASSEX 
    mov   wc.style, CS_HREDRAW or CS_VREDRAW 
    mov   wc.lpfnWndProc, OFFSET WndProc 
    mov   wc.cbClsExtra,NULL 
    mov   wc.cbWndExtra,NULL 
    push  hInst 
    pop   wc.hInstance 
    mov   wc.hbrBackground,COLOR_WINDOW+1 
    mov   wc.lpszMenuName,OFFSET MenuName 
    mov   wc.lpszClassName,OFFSET ClassName 
    invoke LoadIcon,NULL,IDI_APPLICATION 
    mov   wc.hIcon,eax 
    mov   wc.hIconSm,eax 
    invoke LoadCursor,NULL,IDC_ARROW 
    mov   wc.hCursor,eax 
    invoke RegisterClassEx, addr wc 
    invoke CreateWindowEx,WS_EX_CLIENTEDGE,ADDR ClassName,ADDR AppName,\ 
           WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\ 
           CW_USEDEFAULT,300,200,NULL,NULL,\ 
           hInst,NULL 
    mov   hwnd,eax 
    invoke ShowWindow, hwnd,SW_SHOWNORMAL 
    invoke UpdateWindow, hwnd 
    .WHILE TRUE 
            invoke GetMessage, ADDR msg,NULL,0,0 
            .BREAK .IF (!eax) 
            invoke TranslateMessage, ADDR msg 
            invoke DispatchMessage, ADDR msg 
    .ENDW 
    mov     eax,msg.wParam 
    ret 
WinMain endp 

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM 
    .IF uMsg==WM_DESTROY 
        invoke PostQuitMessage,NULL 
    .ELSEIF uMsg==WM_COMMAND 
        mov eax,wParam 
        .if lParam==0 
            .if ax==IDM_CREATE_THREAD 
                mov  eax,OFFSET ThreadProc 
                invoke CreateThread,NULL,NULL,eax,\ 
                                        NULL,0,\ 
                                        ADDR ThreadID 
                invoke CloseHandle,eax 
		  .elseif ax == IDM_KILL_THREAD
			mov	Flag, 1
			.else 
                invoke DestroyWindow,hWnd 
            .endif 
        .endif 
    .ELSEIF uMsg==WM_FINISH 
        invoke MessageBox,NULL,ADDR SuccessString,ADDR AppName,MB_OK 
    .ELSEIF uMsg==WM_KILLTHREAD 
        invoke MessageBox,NULL,ADDR KillThreadString,ADDR AppName,MB_OK     
    .ELSE 
        invoke DefWindowProc,hWnd,uMsg,wParam,lParam 
        ret 
    .ENDIF 
    xor    eax,eax 
    ret 
WndProc endp 

ThreadProc PROC USES ecx Param:DWORD 
        mov  ecx,600000000
Loop1: 
        add  eax,eax 	   
	   .if(!Flag)
	   push ecx
	   mov ecx, 1000000000
 	@@:    
	   nop
	   nop
	   nop
	   nop
	   nop
	   dec ecx
	   jz @B
	   pop ecx
	   dec  ecx 
        jz   Get_out 
        jmp  Loop1 
	   .else
	   jmp Kill_out
	   .endif
Get_out: 
        invoke PostMessage,hwnd,WM_FINISH,NULL,NULL 
	   jmp End_out
Kill_out:
	   invoke PostMessage,hwnd,WM_KILLTHREAD,NULL,NULL 	   
End_out:
        ret 
ThreadProc ENDP 

end start
