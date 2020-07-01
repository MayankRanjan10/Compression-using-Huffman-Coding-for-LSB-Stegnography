clear all;
close all
clc;
%ENCRYPTING
inpu = imread('mario.png'); %Image used to store our secret message
inpu=rgb2gray(inpu) ;%Convert it into Black and White
message= input('Enter: '); %Enter the secret message to be encrypted
s=unique(message);% To remove repeated characters
l=length(s);
%To calculate the probability of occurence of each character
for i=1:l
 count=0;
 for j=1:(length(message))
 if s(i)==message(j)
 count=count+1;
 end
 p(i)=count/(length(message));%Probability of occurence of ith character
 end
end
symbols=[];
for i=1:l
 symbols(i)=s(i);
end
dict = huffmandict(symbols,p);%creating huffman dictionary
comp = huffmanenco(message,dict);%Encoding the characters using the dictionary created
bin_message = comp(:);
N = length(bin_message);
bin_num_message=bin_message;
output = inpu;
%LSB Steganography
height = size(inpu, 1);
width = size(inpu, 2);
embed_counter = 1;
%Traversing through each pixel of the image
for i = 1 : height % Number of rows in the matrix of the image
 for j = 1 : width % Number of coloums in the matrix of the image
 if(embed_counter <= N)
 LSB = mod(double(inpu(i, j)), 2);%Getting the least significant bit of a given pixel
 temp = double(xor(LSB, bin_num_message(embed_counter)));%Change the bit if and
only if it is not same as that of encoded character
 output(i, j) = inpu(i, j)-temp; %Updating the pixel after modiying its least significant
bit.
 embed_counter = embed_counter+1; %Next encoded bit
 end
 end
end
imwrite(inpu, 'C:\Users\Mayank\Downloads\Vit downloads\SEM-6\ECE4007-Information Theory and Coding\14490 - RAMYA S - SENSE-F2-TF2\ITC Project.jpg');
imwrite(output, 'C:\Users\Mayank\Downloads\Vit downloads\SEM-6\ECE4007-Information Theory and Coding\14490 - RAMYA S - SENSE-F2-TF2\ITC Project.jpg');
peak= psnr(output,inpu); %To calculate the peak signal to noise ratio of the new encrypted
image with respect to the original image
%DECRYPTING
in=output;
height = size(in, 1);
width = size(in, 2);
embed_counter = 1;
ii=1;
%Getting the least significant bit of every pixel of the new encrypted
%image
for i = 1 : height
 for j = 1 : width
 if(embed_counter <= N)
 LSB(ii) = mod(double(in(i, j)), 2);
 ii=ii+1;
 embed_counter = embed_counter+1;
 end
 end
end
dcr=huffmandeco(LSB,dict); %Decoding the secret message using the Huffman dictionary
created during encrypting
msg=char(dcr); %Retrieving the secret message