	.386
	.model flat, stdcall  
	option casemap: none      

	include	windows.inc 
	  
	.data?                  ;��̬���ӿ��WIN32APP�ı�д������������� ��һ����                                                                               
	dwCounter	dd	?  

	.code  
	DllEntry	proc	_hInstance, _dwReason, _dwReserved		;������Ҫע�⣬�����Ƕ�̬���ӿ����ں�����
		mov     eax,TRUE							;ֻ���������ܱ�ϵͳʶ����Ȼ���������û��ʲô���ܴ��룬
		ret 										;������������DLL�Ƿ��������װ��  
     DllEntry        Endp                 
  
	_CheckCounter   proc                            ;���ܺ���1��ȷ�����ֵĴ�С��0--10֮��  
		 mov     eax,dwCounter				   ;��ʵ��������Ǹ��ڲ���������Ϊ�ڵ�����28.Def�ļ��в�û�н���д������
		 cmp     eax,0						   ;�����ֻ������DLL�ļ��ڲ�ʹ��  
		 jge     @F                                ;���ڵ�������ת  
		 xor     eax,eax 
       @@: 
		 cmp     eax,10  
		 jle     @F
           mov     eax,10                                     
       @@: 
           mov     dwCounter,eax 
		 ret
     _CheckCounter endp 
 
	_IncCounter	proc	;���ܺ���2��ʵ�ֽ���ǰ�����ּ�1���ú�����28.Def����д������������Ӧ�ó����е���  
  
       inc     dwCounter  
       call    _CheckCounter  
       ret
	    
	_IncCounter endp  
  
	_DecCounter	proc	;���ܺ���3������ǰ�����ּ�1���ú�����28.Def����д����Ҳ����Ӧ�ó����е���                                                       
  
       dec     dwCounter  
       call    _CheckCounter  
       ret  
  
	_DecCounter endp  
  
	_Mod	proc    uses ecx edx _dwNumber1, _dwNumber2	;���ܺ���4�����������������ģ��  �ú���Ҳ����Ӧ�ó����е���
                                                                                                                              
                xor     edx,edx  
                mov     eax,_dwNumber1  
                mov     ecx,_dwNumber2  
                .if     ecx  
                div    ecx  
                mov    eax,edx  
                .endif  
			 ret  
	_Mod endp  
	End     DllEntry         ;���DLL�Ľ�β 
