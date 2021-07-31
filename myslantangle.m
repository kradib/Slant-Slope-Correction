%% 1. read the image,turning it into gray image

img1=imread('data00987.bmp');
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
A=img1;
A=rgb2gray(A);
theta=slantangle;
T=maketform('affine',[1 0 0;theta 1 0;0 0 1]);
h1=figure;imshow(A);title('original Image');
white=255;
R=makeresampler({'cubic','nearest'},'fill');
B=imtransform(A,T,R,'Fillvalues',white);
h2=figure;imshow(B);
title('slantcorrect');
