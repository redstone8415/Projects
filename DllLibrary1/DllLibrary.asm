	.386
	.model flat, stdcall  
	option casemap: none      

	include	windows.inc 
	  
	.data?                  ;动态链接库和WIN32APP的编写很像，这里基本都 是一样的                                                                               
	dwCounter	dd	?  

	.code  
	DllEntry	proc	_hInstance, _dwReason, _dwReserved		;这里需要注意，这里是动态链接库的入口函数，
		mov     eax,TRUE							;只有这样才能被系统识别，虽然这个函数并没有什么功能代码，
		ret 										;但是它决定了DLL是否可以正常装入  
     DllEntry        Endp                 
  
	_CheckCounter   proc                            ;功能函数1，确保数字的大小在0--10之间  
		 mov     eax,dwCounter				   ;其实这个函数是个内部函数，因为在导出表28.Def文件中并没有将它写出来，
		 cmp     eax,0						   ;因此它只能用在DLL文件内部使用  
		 jge     @F                                ;大于等于则跳转  
		 xor     eax,eax 
       @@: 
		 cmp     eax,10  
		 jle     @F
           mov     eax,10                                     
       @@: 
           mov     dwCounter,eax 
		 ret
     _CheckCounter endp 
 
	_IncCounter	proc	;功能函数2，实现将当前的数字加1，该函数在28.Def中已写出，后来会在应用程序中调用  
  
       inc     dwCounter  
       call    _CheckCounter  
       ret
	    
	_IncCounter endp  
  
	_DecCounter	proc	;功能函数3，将当前的数字减1，该函数在28.Def中已写出，也会在应用程序中调用                                                       
  
       dec     dwCounter  
       call    _CheckCounter  
       ret  
  
	_DecCounter endp  
  
	_Mod	proc    uses ecx edx _dwNumber1, _dwNumber2	;功能函数4，求输入的两个数的模，  该函数也会在应用程序中调用
                                                                                                                              
                xor     edx,edx  
                mov     eax,_dwNumber1  
                mov     ecx,_dwNumber2  
                .if     ecx  
                div    ecx  
                mov    eax,edx  
                .endif  
			 ret  
	_Mod endp  
	End     DllEntry         ;最后DLL的结尾 
