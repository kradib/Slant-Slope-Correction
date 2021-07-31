


function[binimage] = slant_slope_correct(img)
f=img;
%clear;
%f=imread('data00124.bmp');
%subplot(3,1,1);
figure,imshow(f),title('original image');
f1=f;
bin=1-im2bw(f);
skl=bwmorph(bin,'skel','inf');
%figure,imshow(skl);
[Row,column]=size(skl);
new=zeros(size(skl));
for i=1:1:Row
    for j=1:1:column
    if skl(i,j)==1
        new(i,j-1:j+1)=1;
    end
    end
end
%figure,imshow(new);
row=sum_(new,2);
row1=find(row,1,'first');
row2=find(row,1,'last');
h=row2-row1;
col=sum_(new,1);
col1=find(col,1,'first');
col2=find(col,1,'last');
w=col2-col1;
new2=ones(h,w);
new2(1:h+1,1:w+1)=new(row1:row2,col1:col2);
%figure,imshow(new2);
row=sum_(new2,2);  %take a row wise sum
avg=mean(row);
for i=1:1:length(row)
    if row(i,1)>=avg
        arr1(1,i)=row(i,1);  % if any element greater than average than it remain same
    else
        arr1(1,i)=0;           % if any element lesser than average than turn to zero
    end
end
figure,plot(row);
Max=max(arr1);                  %tke the maximum value 
   sum_=0;
   count51=0;
   for i=1:1:length(row)
       if row(i,1)<=avg
           sum_=sum_+row(i,1);      %take average of the upper of the average
           count51=count51+1;
       end
   end
       avg2=sum_/count51;         
      for i=1:1:length(row)
    if row(i,1)>=avg2                % if any element greater than average than it remain same
        arr2(1,i)=row(i,1);
    else
        arr2(1,i)=0;                   % if any element lesser than average than turn to zero
    end
end
%figure,plot(row);
Max=max(arr2);                        %tke the maximum value 
count5=find(Max==arr2,1,'first');

tempmax=max(arr2(1:count5-1));
sudo=find(arr2==tempmax,1,'first');

count31=count5;
county=0;
for x=1:count5-1
    if arr2(x)==0
        county=county+1;
    end
end
if county>0
   while arr2(count5)~=0
       count5=count5-1;          %from the left of maximum value every element will be cheaked untill there is no zero
   end
else
    count5=sudo;
end
count11=count5;
county=0;
tempmax2=max(arr2(count31+1:length(arr2)));
sudo2=find(arr2==tempmax2,1,'last');
for x=count31+1:length(arr2)
    if arr2(x)==0
        county=county+1;
    end
end
if county>0
    while arr2(count31)~=0
        count31=count31+1;
        if count31>length(arr2)
            count31=count31-1;
        end
    end
else  count31=sudo2;                                             %from the right of maximum value every element is cheaked untill there is  no zero occure
end
count21=count31;
width=count21-count11;
% for i=1:1:h-width
%    x=zeros(size(new2));
%    x(i:i+width,:)=new2(i:i+width,:);
%    y=sum(x,2);
%    z(i)=sum(y,1);
% 
% end
mycount=0;
for i=1:h-width-1
    
        for k=i:i+width
            for l=1:w
                if new2(k,l)==1
                    mycount=mycount+1;
                end
            end
        end
        c(i)=mycount;
        mycount=0;
end
Max=max(c);
new3=zeros(width,w);
temp=find(Max==c,1,'first');
% new3(1:width,w)=new2(temp:temp+width-1,w);
m=1;
for i=temp:temp+width
    n=1;
    for j=1:w
        
        new3(m,n)=new2(i,j);
        n=n+1;
    end
    m=m+1;
end

%figure,imshow(new3);
new4=1-im2bw(new3);
[a,c,d,e,fo]=BestFitLine1(new4);
%figure,plot(d,fo);
Min=min(d);
ycount=0;
for i=1:1:length(d)
    if d(i,1)==Min
        ycount=i;
        break;
    end
end
Max=max(d);
y1count=0;
for i=1:1:length(d)
    if d(i,1)==Max
        y1count=i;
        break;
    end
end
a=fo(y1count)-fo(ycount);
bh2=a/Max;
h=atand(bh2);
%I=imread('eng1.bmp');


%I=mat2gray(I);
%J=imrotate255(I,-2);

%figure, imshow(I, []);
theta=h;

%figure,imshow(f1);

rotateImg = imrotate(f1,theta,'crop'); % rotate by 45 or 315 degrees
%figure, imshow(rotateImg);
%subplot(1,2,1)
%imshow(rotateImg, [min(min(rotateImg(:))) max(max(rotateImg(:)))]);
newrotateImg = rotateImg;
newrotateImg(newrotateImg == 0) = 255; % make all 0 pixels to 255..
%deSlopedImg=newrotateImg;
%subplot(3,1,2)
%imshow(newrotateImg, [min(min(newrotateImg(:))) max(max(newrotateImg(:)))]);title('slop correct');
%figure,imshow(newrotateImg);

%% 1. read the image,turning it into gray image

img1=newrotateImg;
A=img1;
A=rgb2gray(A);
temp=1;
temp1=1;
%% 2.shearing images from 10 to 70 anticlockwise and calcuting column sum and storing there maximums and calculating vertical projection intensity
for theta=10:10:70
    count=1;
    theta = theta/100; 
    T = maketform('affine', [1 0 0; theta 1 0; 0 0 1]);
    white = 255;
    R = makeresampler({'cubic','nearest'},'fill');
    B = imtransform(A,T,R,'FillValues',white); 
    binImg=im2bw(B);
    binImg=~binImg;
    [row,col]=size(binImg);
    v=0;
    for i=1:col
        for j=1:row
            v=binImg(j,i)+v;
            csum1(temp,i)=v;
        end
        v=0;
    end
     maxcsum1(temp1)=max(csum1(temp,:));
        for u=1:col
            if csum1(temp,u)==maxcsum1(temp1);
                count=count+1;    
            end
        end
        maxcount1(temp1)=count-1;
    temp=temp+1;
    temp1=temp1+1;    
end
maxmax1=max(maxcount1);
maxmaxcsum1=max(maxcsum1);
%% 3.again shearing the image from 10 to 70 in clockwise directions
A=img1;
A=rgb2gray(A);
temp=1;
temp1=1;
for theta=-10:-10:-70
    count=1;
    theta = theta/100; %0.25;  % if theta=25 degree
    T = maketform('affine', [1 0 0; theta 1 0; 0 0 1]);
    white = 255;
    R = makeresampler({'cubic','nearest'},'fill');
    B = imtransform(A,T,R,'FillValues',white); 
    binImg=im2bw(B);
    binImg=~binImg;
    [row,col]=size(binImg);
    v=0;
    for i=1:col
        for j=1:row
            v=binImg(j,i)+v;
            csum2(temp,i)=v;
        end
        v=0;
    end
     maxcsum2(temp1)=max(csum2(temp,:));
        for u=1:col
            if csum2(temp,u)==maxcsum2(temp1);
                count=count+1;  
            end
        end
        maxcount2(temp1)=count-1;
    temp=temp+1;
    temp1=temp1+1;
end
maxmax2=max(maxcount2);
maxmaxcsum2=max(maxcsum2);
%% slant correction algorithm
%%if we get a the maximum column sum,then that detects the slant angle,,if maximum sums are equal(most of the cases) we go for the intensity extraction and that gives the slant angle 
if maxmaxcsum1>=maxmaxcsum2
    if numel(find(maxcsum1==maxmaxcsum1))==1
        slant=find(maxcsum1==maxmaxcsum1)/10;
    else
        findmax1=find(maxcsum1==maxmaxcsum1);
        len1=length(findmax1);
        star=maxcount1(findmax1(1));
        for l=1:len1
            if maxcount1(findmax1(l))>=star
                star=maxcount1(findmax1(l));
            end
        end
        nofind=(find(maxcount1==star));
        l1=length(nofind);
         for l=1:len1
             for k=1:l1
                 if nofind(k)==findmax1(l)
                    slant=findmax1(l)/10;
                 end
             end
         end
         %slant=v1;
    end
else
    if numel(find(maxcsum2==maxmaxcsum2))==1
        slant=-find(maxcsum2==maxmaxcsum2)/10;
    else
         findmax2=find(maxcsum2==maxmaxcsum2);
        len2=length(findmax2);
        star=maxcount2(findmax2(1));
        for l=1:len2
            if maxcount2(findmax2(l))>=star
                star=maxcount2(findmax2(l));
            end
        end
        nofind=find(maxcount2==star);
        l1=length(nofind);
        for l=1:len2
            for k=1:l1
                if nofind(k)==findmax2(l)
                  slant=-(findmax2(l))/10;
                end
            end
         end
       %slant=v2;
    end
end
theta=slant;
T=maketform('affine',[1 0 0;theta 1 0;0 0 1]);
white=255;
R=makeresampler({'cubic','nearest'},'fill');
B=imtransform(A,T,R,'Fillvalues',white);
f=B;
A=f;
%%now we get the partialy slant corrected image and then we apply the same
%%algorithm for 10 degree shearing both clockwise and anticlockwise and
%%extract the slant angle
temp2=1;
temp3=1;
for theta=1:9
    count=1;
    theta = theta/100; 
    T = maketform('affine', [1 0 0; theta 1 0; 0 0 1]);
    white = 255;
    R = makeresampler({'cubic','nearest'},'fill');
    B = imtransform(A,T,R,'FillValues',white); 
    binImg=im2bw(B);
    binImg=~binImg;
    [row,col]=size(binImg);
    v=0;
    for i=1:col
        for j=1:row
            v=binImg(j,i)+v;
            csum3(temp2,i)=v;
        end
        v=0;
    end
     maxcsum3(temp3)=max(csum3(temp2,:));
        for u=1:col
            if csum3(temp2,u)==maxcsum3(temp3);
                count=count+1;    
            end
        end
        maxcount3(temp3)=count-1;
    temp2=temp2+1;
    temp3=temp3+1;    
end
maxmax3=max(maxcount3);
maxmaxcsum3=max(maxcsum3);
A=f;
temp2=1;
temp3=1;
for theta=-1:-1:-9
    count=1;
    theta = theta/100; 
    T = maketform('affine', [1 0 0; theta 1 0; 0 0 1]);
    white = 255;
    R = makeresampler({'cubic','nearest'},'fill');
    B = imtransform(A,T,R,'FillValues',white); 
    binImg=im2bw(B);
    binImg=~binImg;
    [row,col]=size(binImg);
    v=0;
    for i=1:col
        for j=1:row
            v=binImg(j,i)+v;
            csum4(temp2,i)=v;
        end
        v=0;
    end
     maxcsum4(temp3)=max(csum4(temp2,:));
        for u=1:col
            if csum4(temp2,u)==maxcsum4(temp3);
                count=count+1;
            end
        end
        maxcount4(temp3)=count-1;
    temp2=temp2+1;
    temp3=temp3+1;
end
maxmax4=max(maxcount4);
maxmaxcsum4=max(maxcsum4);
if maxmaxcsum3>maxmaxcsum4
    if numel(find(maxcsum3==maxmaxcsum3))==1
        slant1=find(maxcsum3==maxmaxcsum3)/100;
    else
        findmax3=find(maxcsum3==maxmaxcsum3);
        len3=length(findmax3);
        star=maxcount3(findmax3(1));
        for l=1:len3
            if maxcount3(findmax3(l))>=star
                star=maxcount3(findmax3(l));
            end
        end
        slant1=max(find(maxcount3==maxmax3)/100);
    end
elseif maxmaxcsum3==maxmaxcsum4
    u1=numel(find(maxcsum3==maxmaxcsum3));
    u2=numel(find(maxcsum4==maxmaxcsum4));
    if u1>u2
        slant1=find(maxcount3==max(maxcount3))/100;
    else
        slant1=-find(maxcount4==max(maxcount4))/100;
    end
    
else
    if numel(find(maxcsum4==maxmaxcsum4))==1
        slant1=-find(maxcsum4==maxmaxcsum4)/100;
    else
        findmax4=find(maxcsum4==maxmaxcsum4);
        len4=length(findmax4);
        star=maxcount4(findmax4(1));
        for l=1:len4
            if maxcount4(findmax4(l))>=star
                star=maxcount4(findmax4(l));
            end
        end
        slant1=-max(find(maxcount4==maxmax4)/100);
    end
end
%%now total slant angle is the sum of both slant angle derived before
%%we now shear the image to get the slant corrected image
slantangle=slant(1)+slant1(1);
last1=slantangle;
%vangle=slantangle;

if   last1==0.01 
     vangle=0;
elseif last1==0.02
     vangle=0;
elseif last1==0.03
    vangle=0;
else
    vangle=slantangle;
end
A=img1;
A=rgb2gray(A);
theta=vangle;
T=maketform('affine',[1 0 0;theta 1 0;0 0 1]);
%h1=figure;imshow(A);title('original Image');
white=255;
R=makeresampler({'cubic','nearest'},'fill');
B=imtransform(A,T,R,'Fillvalues',white);
binimage=B;
%subplot(3,1,3);
%imshow(B);title('allcorrect');
end


