 %????????? ??????????? ??????? ????????? ??????? 

%??? ????????? ???????? ??????????? ?????????? ???????? ? ???????
%????????? ??????? ???????????? ??????????
%???, ???????????????, ??????-?????????????,?????????????????
% ? ???????????? ????????? ?????????? ????????
%????????????? ??????????? ????????????? ? ???????? ?????????? 
%????????? ????????? ? ????????? ???????? ???????????? ??????????,
%???????????? ??????????, ????? ??????? ???????? (????? ???????????),
%????? ??????? ????? (????? ???????????)
%????? ?????? ????????? ??? 1024 ?????????? - 1 ???. 20 ???.
tic

kt=1024; % ?????????? ????????
shum=0.3 ;%???
kp=5.12;%?????????? ???????? ???????

clc;%??????? Command Window
i=1:kt;
for i4=1:2048 %?????????? ?????????
%1. ????????? ?????????? ???????
 %????????? ??????? ???????
  y(i)=0;
 
%????????? ??????????? ? ?????? ????
  noise=randn(1024);
  %noise=wgn(kt,1,0);

  %????????? ?????????? ???????
  w(i)=exp(-20*((i-kt/2)/kt).^2);
  y(i)=cos(2*pi*kp*i/kt).*w(i);
  y(i)=y(i)+shum*noise(i); 

%i=1:kt; %??????????? ?????????? ??????? ?? ????????? ???????

%2. ?????????????? ?????????????? (???)
bpfy=fft(y,kt);%???
bpf=bpfy.*conj(bpfy)/kt;%???

%?????????? ????. ????. ??????? ??? ??? ??????? Y
[C,kpbpf]=max(bpf);
% for i=1:kt %????? ?????????? ????????, ??????????????? ????????? ???
%     if (bpf(i)==C)          
%         kpbpf=(i-1);         
%         break
%     end
% end
kp_bpf=kpbpf-1;
%3. ???????? ???????? ? ???????????????
kp1=kpbpf-1;
    search_area=0.7/kp;%????????? ??????? ??????  ???????. kp_bpf  
for i3=1:3 %??????? ?????????? ????????    
shagkor=kp1*search_area/3;%??? ??????
        k=0;
  for j=kp1-kp1*search_area:shagkor:kp1+kp1*search_area %???? ??? ???????? 6 ???????? ? ??????????? ????????????? 
            %???????? ?????????? ????????, ???????????? ? ??????? ???.           
            k=k+1;
            xkor(k)=j;
            kor(k)=0;
            for i=1:kt           
                x(i)=0;    
            end
%?????????? ???????? ????????? ???????? 
%??? ????????????? ????????? ???????? ????????????? ????? - ?????? sign
        %for i=1:kt                                                
        x(i)=cos(2*pi*j*i/kt).*w(i);
        %end    
%?????????? ??????? ???????? ?????????? ? ????????? ????????
            x_sr=mean(x);
            y_sr=mean(y);
            x_sko=0;
            y_sko=0;
%?????????? ??? ? ????. ?????????? ?????????? ? ????????? ????????
            %for i=1:kt
                x_sko=sum((x(i)-x_sr).*(x(i)-x_sr));
                y_sko=sum((y(i)-y_sr).*(y(i)-y_sr));
                kor(k)=sum((x(i)-x_sr).*(y(i)-y_sr));

              %  kor(k)=kor(k)+abs(x(i)+y(i)); %???????? ???????? - ???????? ????? ??????? abs(x(i)+y(i)
            %end             
            kor(k)=kor(k)/(sqrt(x_sko*y_sko));%???????? ???????? - ???????? ??????? ????????????? ??????????
            % kor(k)=kor(k)%???????? ???????? - ???????? ??????? ????????????? ??????????             
            
  end %????? ????? ???????? ???????? ? ?????????? ??????? ????. ????.(??? )
 
  %??????-???????????? ? ?????????????????
        xx=1:k;
        xi=1:0.1:k;         
        yint=interp1(xx,kor,xi,'spline');% ??????-????????????? ???? ??????????               
        r1=kor;
        %%apr=csaps(xx,r1);
        apr=spaps(xkor,kor,0.000001);%%%%%%%%%%%%%%%

%?????????? ??????????? ???????? ?????????? ???????? ???????
        cmax=max(yint); %?????????? ????????? ????. ????.        
        for i=1:round((k-1)/0.1+1)
            if (yint(i)==cmax)     
                kp_int=kp1-kp1*search_area+(i-1)*shagkor/10; %?????????? ???????? ??????? ?? ??? ??????? ????. ????.
            end           
        end
        kp1=kp_int;%????????? ??????????? ?????????? ????????
        search_area=search_area/2;%?????????? ??????? ??????
     end  %????? ????? ?? ?????????? ????????      
     kp2(i4)=kp_int;
end  %????? ????? ????.?????????  
  MO1=mean(kp2)
  SKO1=std(kp2)
  SKO_persent=SKO1/kp*100
  hist(kp2,7); %?????????? ???????? ???????????
  
  i=1:kt; %??????????? ?????????? ??????? ?? ????????? ???????
% figure
% plot(i,y);
% axis tight;
% title('Time domain')
% xlabel('Sample number')
timeElapsed = toc

pause;
close all;
clear;
